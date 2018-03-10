import SwiftRewriterLib
import Utils
import SwiftAST

/// Applies passes to simplify known Foundation methods
public class FoundationExpressionPass: SyntaxNodeRewriterPass {
    var transformers: [StaticConstructorTransformer] = []
    var enumMappings: [String: () -> Expression] = [:]
    
    public required init() {
        super.init()
        makeInitializerTransformers()
        makeEnumTransformers()
    }
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let new = convertIsEqualToString(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        if let new = convertStringWithFormat(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        if let new = convertAddObjectsFromArray(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        if let new = convertClassCall(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        if let new = convertDataStructureInit(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        if let new = convertRespondsToSelector(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        if let new = applyTransformers(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        
        return super.visitPostfix(exp)
    }
    
    public override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        if let new = convertNSPrefixedTypeName(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        if let new = convertEnumIdentifier(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        
        return super.visitIdentifier(exp)
    }
    
    func applyTransformers(_ exp: PostfixExpression) -> Expression? {
        for transformer in transformers {
            if let result = transformer.attemptApply(on: exp) {
                return result
            }
        }
        
        return nil
    }
    
    /// Converts [<lhs> respondsToSelector:<selector>] -> <lhs>.responds(to: <selector>)
    func convertRespondsToSelector(_ exp: PostfixExpression) -> Expression? {
        guard let postfix = exp.exp.asPostfix, let fc = exp.functionCall else {
            return nil
        }
        guard postfix.member?.name == "respondsToSelector" else {
            return nil
        }
        guard fc.arguments.count == 1 else {
            return nil
        }
        
        exp.op = .functionCall(arguments: [
            FunctionArgument.labeled("to", fc.arguments[0].expression)
        ])
        
        if postfix.op.hasOptionalAccess {
            postfix.op = .member("responds")
            postfix.op.hasOptionalAccess = true
            exp.resolvedType = .optional(.bool)
        } else {
            postfix.op = .member("responds")
            exp.resolvedType = .bool
        }
        
        return exp
    }
    
    /// Converts [<lhs> isEqualToString:<rhs>] -> <lhs> == <rhs>
    func convertIsEqualToString(_ exp: PostfixExpression) -> Expression? {
        guard let postfix = exp.exp.asPostfix, postfix.member?.name == "isEqualToString",
            let args = exp.functionCall?.arguments, args.count == 1 && !args.hasLabeledArguments() else {
            return nil
        }
        
        let res = postfix.exp.binary(op: .equals, rhs: args[0].expression)
        
        res.resolvedType = .bool
        
        return res
    }
    
    /// Converts [NSString stringWithFormat:@"format", <...>] -> String(format: "format", <...>)
    func convertStringWithFormat(_ exp: PostfixExpression) -> Expression? {
        guard let postfix = exp.exp.asPostfix else {
            return nil
        }
        
        guard postfix.exp.asIdentifier?.identifier == "NSString",
            postfix.op.asMember?.name == "stringWithFormat",
            let args = exp.functionCall?.arguments, args.count > 0 else {
            return nil
        }
        
        let newArgs: [FunctionArgument] = [
            .labeled("format", args[0].expression),
        ] + args.dropFirst()
        
        exp.exp = .identifier("String")
        exp.op = .functionCall(arguments: newArgs)
        
        exp.resolvedType = .string
        
        return exp
    }
    
    /// Converts [<array> addObjectsFromArray:<exp>] -> <array>.addObjects(from: <exp>)
    func convertAddObjectsFromArray(_ exp: PostfixExpression) -> Expression? {
        guard let postfix = exp.exp.asPostfix, postfix.member?.name == "addObjectsFromArray",
            let args = exp.functionCall?.arguments, args.count == 1 else {
            return nil
        }
        
        exp.op = .functionCall(arguments: [
            .labeled("from", args[0].expression)
        ])
        
        exp.exp = .postfix(postfix.exp, .member("addObjects"))
        exp.resolvedType = .void
        
        if postfix.op.hasOptionalAccess {
            exp.exp.asPostfix?.member?.hasOptionalAccess = true
            exp.resolvedType = .optional(.void)
        }
        
        return exp
    }
    
    /// Converts [Type class] and [expression class] expressions
    func convertClassCall(_ exp: PostfixExpression) -> Expression? {
        guard let args = exp.functionCall?.arguments, args.count == 0 else {
            return nil
        }
        guard let classMember = exp.exp.asPostfix, classMember.member?.name == "class" else {
            return nil
        }
        
        // Use resolved expression type, if available
        if case .metatype? = classMember.exp.resolvedType {
            let exp = Expression.postfix(classMember.exp, .member("self"))
            exp.resolvedType = classMember.exp.resolvedType
            
            return exp
        } else if !classMember.exp.isErrorTyped && classMember.exp.resolvedType != nil {
            return Expression.postfix(.identifier("type"),
                                      .functionCall(arguments: [
                                        .labeled("of", classMember.exp)
                                        ]))
        }
        
        // Deduce using identifier or expression capitalization
        switch classMember.exp {
        case let ident as IdentifierExpression where ident.identifier.startsUppercased:
            return Expression.postfix(classMember.exp, .member("self"))
        default:
            return Expression.postfix(.identifier("type"),
                                      .functionCall(arguments: [
                                        .labeled("of", classMember.exp)
                                        ]))
        }
    }
    
    /// Converts [NSArray array], [NSDictionary dictionary], etc. constructs
    func convertDataStructureInit(_ exp: PostfixExpression) -> Expression? {
        guard let args = exp.functionCall?.arguments, args.count == 0 else {
            return nil
        }
        guard let initMember = exp.exp.asPostfix, let typeName = initMember.exp.asIdentifier?.identifier else {
            return nil
        }
        guard let initName = initMember.member?.name else {
            return nil
        }
        
        switch (typeName, initName) {
        case ("NSArray", "array"),
             ("NSMutableArray", "array"),
             ("NSDictionary", "dictionary"),
             ("NSMutableDictionary", "dictionary"),
             ("NSSet", "set"),
             ("NSMutableSet", "set"),
             ("NSDate", "date"),
             ("NSMutableString", "string"):
            let res = Expression.identifier(typeName).call()
            res.resolvedType = .typeName(typeName)
            
            return res
        default:
            return nil
        }
    }
    
    /// Converts NSDate -> Date, NSTimeZone -> TimeZone, etc.
    func convertNSPrefixedTypeName(_ exp: IdentifierExpression) -> Expression? {
        let ident = exp.identifier
        guard ident.hasPrefix("NS") && ident.count > 2 else {
            return nil
        }
        guard isIdentifierUsedInTypeNameContext(exp) else {
            return nil
        }
        // Make sure we don't convert local/globals that some reason have an NS-
        // prefix.
        guard exp.definition?.local == nil && exp.definition?.global == nil else {
            return nil
        }
        // Can only convert known instance types
        guard self.context.typeSystem.isClassInstanceType(exp.identifier) else {
            return nil
        }
        
        let context = TypeConstructionContext(typeSystem: self.context.typeSystem)
        let mapper = DefaultTypeMapper(context: context)
        
        let newType =
            mapper.swiftType(forObjcType: .pointer(.struct(ident)),
                             context: .alwaysNonnull)
        
        let typeName = mapper.typeNameString(for: newType)
        
        if exp.identifier == typeName {
            return nil
        }
        
        exp.identifier = typeName
        exp.resolvedType = .metatype(for: .typeName(typeName))
        
        return exp
    }
    
    func convertEnumIdentifier(_ identifier: IdentifierExpression) -> Expression? {
        if let mapped = enumMappings[identifier.identifier] {
            return mapped()
        }
        
        return nil
    }
    
    /// Returns `true` if a given identifier is contained in a possibly type name
    /// usage context.
    /// Non type contexts include prefix/unary/binary operations, and as the lhs
    /// on an assignment expression.
    private func isIdentifierUsedInTypeNameContext(_ exp: IdentifierExpression) -> Bool {
        if exp.parent is PrefixExpression || exp.parent is UnaryExpression {
            return false
        }
        if let binary = exp.parent as? BinaryExpression, binary.lhs === exp {
            return false
        }
        if let assignment = exp.parent as? AssignmentExpression, assignment.lhs === exp {
            return false
        }
        
        return true
    }
}

// MARK: - Transformations

extension FoundationExpressionPass {
    func makeInitializerTransformers() {
        func make(typeName: String, property: String, convertInto: @autoclosure @escaping () -> Expression,
                  andTypeAs type: SwiftType? = nil) {
            let transformer
                = StaticConstructorTransformer(
                    typeName: typeName,
                    kind: .property(property),
                    conversion: {
                        let exp = convertInto()
                        exp.resolvedType = type
                        return exp
                    })
            
            transformers.append(transformer)
        }
        
        func make(typeName: String, method: String, convertInto: @autoclosure @escaping () -> Expression,
                  andCallWithArguments args: [FunctionInvocationTransformer.ArgumentStrategy],
                  andTypeAs type: SwiftType? = nil) {
            let transformer
                = StaticConstructorTransformer(
                    typeName: typeName,
                    kind: .method(method, args),
                    conversion: {
                        let exp = convertInto()
                        exp.resolvedType = type
                        return exp
                    })
            
            transformers.append(transformer)
        }
        
        // MARK: NSTimeZone
        
        make(typeName: "NSTimeZone", property: "localTimeZone",
             convertInto: Expression.identifier("TimeZone").dot("autoupdatingCurrent"),
             andTypeAs: .typeName("TimeZone"))
        
        make(typeName: "NSTimeZone", property: "defaultTimeZone",
             convertInto: Expression.identifier("TimeZone").dot("current"),
             andTypeAs: .typeName("TimeZone"))
        
        make(typeName: "NSTimeZone", property: "systemTimeZone",
             convertInto: Expression.identifier("TimeZone").dot("current"),
             andTypeAs: .typeName("TimeZone"))
        
        // MARK: NSLocale
        
        make(typeName: "NSLocale", method: "localeWithLocaleIdentifier",
             convertInto: Expression.identifier("Locale"),
             andCallWithArguments: [.labeled("identifier", .asIs)],
             andTypeAs: .typeName("Locale"))
        
        make(typeName: "NSLocale", property: "currentLocale",
             convertInto: Expression.identifier("Locale").dot("current"),
             andTypeAs: .typeName("Locale"))
        
        make(typeName: "NSLocale", property: "systemLocale",
             convertInto: Expression.identifier("Locale").dot("current"),
             andTypeAs: .typeName("Locale"))
        
        make(typeName: "NSLocale", property: "autoupdatingCurrentLocale",
             convertInto: Expression.identifier("Locale").dot("autoupdatingCurrent"),
             andTypeAs: .typeName("Locale"))
        
        // MARK: NSNotificationCenter
        make(typeName: "NSNotificationCenter", property: "defaultCenter",
             convertInto: Expression.identifier("NotificationCenter").dot("default"),
             andTypeAs: .typeName("NotificationCenter"))
    }
    
    func makeEnumTransformers() {
        enumMappings["NSCalendarUnitEra"] = {
            Expression.identifier("Calendar").dot("Component").dot("era")
        }
        enumMappings["NSCalendarUnitYear"] = {
            Expression.identifier("Calendar").dot("Component").dot("year")
        }
        enumMappings["NSCalendarUnitMonth"] = {
            Expression.identifier("Calendar").dot("Component").dot("month")
        }
        enumMappings["NSCalendarUnitDay"] = {
            Expression.identifier("Calendar").dot("Component").dot("day")
        }
        enumMappings["NSCalendarUnitHour"] = {
            Expression.identifier("Calendar").dot("Component").dot("hour")
        }
        enumMappings["NSCalendarUnitMinute"] = {
            Expression.identifier("Calendar").dot("Component").dot("minute")
        }
        enumMappings["NSCalendarUnitSecond"] = {
            Expression.identifier("Calendar").dot("Component").dot("second")
        }
        enumMappings["NSCalendarUnitWeekday"] = {
            Expression.identifier("Calendar").dot("Component").dot("weekday")
        }
        enumMappings["NSCalendarUnitWeekdayOrdinal"] = {
            Expression.identifier("Calendar").dot("Component").dot("weekdayOrdinal")
        }
        enumMappings["NSCalendarUnitQuarter"] = {
            Expression.identifier("Calendar").dot("Component").dot("quarter")
        }
        enumMappings["NSCalendarUnitWeekOfMonth"] = {
            Expression.identifier("Calendar").dot("Component").dot("weekOfMonth")
        }
        enumMappings["NSCalendarUnitWeekOfYear"] = {
            Expression.identifier("Calendar").dot("Component").dot("weekOfYear")
        }
        enumMappings["NSCalendarUnitYearForWeekOfYear"] = {
            Expression.identifier("Calendar").dot("Component").dot("weekOfYear")
        }
        enumMappings["NSCalendarUnitYearForWeekOfYear"] = {
            Expression.identifier("Calendar").dot("Component").dot("yearForWeekOfYear")
        }
        enumMappings["NSCalendarUnitNanosecond"] = {
            Expression.identifier("Calendar").dot("Component").dot("nanosecond")
        }
        enumMappings["NSCalendarUnitCalendar"] = {
            Expression.identifier("Calendar").dot("Component").dot("calendar")
        }
        enumMappings["NSCalendarUnitTimeZone"] = {
            Expression.identifier("Calendar").dot("Component").dot("timeZone")
        }
    }
}
