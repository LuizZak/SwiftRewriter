import Utils
import SwiftAST
import Commons
import TypeSystem

/// Applies passes to simplify known Foundation methods
public class FoundationExpressionPass: BaseExpressionPass {
    
    public required init(context: ASTRewriterPassContext) {
        super.init(context: context)
        
        makeFunctionTransformers()
        makeEnumTransformers()
    }
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let new = convertIsEqualToString(exp, op: .equals) {
            notifyChange()
            
            return visitExpression(new)
        }
        if let new = convertStringWithFormat(exp) {
            notifyChange()
            
            return visitExpression(new)
        }
        if let new = convertAddObjectsFromArray(exp) {
            notifyChange()
            
            return visitExpression(new)
        }
        if let new = convertClassCall(exp) {
            notifyChange()
            
            return visitExpression(new)
        }
        if let new = convertDataStructureInit(exp) {
            notifyChange()
            
            return visitExpression(new)
        }
        if let new = convertRespondsToSelector(exp) {
            notifyChange()
            
            return visitExpression(new)
        }
        
        return super.visitPostfix(exp)
    }
    
    public override func visitUnary(_ exp: UnaryExpression) -> Expression {
        // Handle negated ![<exp> isEqualToString:<exps>] by creating an inequality
        // test early here instead of allowing awkward !(<string> == <string>)
        // expressions to form
        // TODO: This can be generalized in ASTSimplifier later for all expression
        // types by simplifying !(<exp1> == <exp2>) constructs.
        if exp.op == .negate, let postfix = exp.exp.asPostfix {
            if let new = convertIsEqualToString(postfix, op: .unequals) {
                notifyChange()
                
                return visitExpression(new)
            }
        }
        
        return super.visitUnary(exp)
    }
    
    public override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        if let new = convertNSPrefixedTypeName(exp) {
            notifyChange()
            
            return visitExpression(new)
        }
        
        return super.visitIdentifier(exp)
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
        
        if postfix.op.optionalAccessKind != .none {
            let accessKind = postfix.op.optionalAccessKind
            postfix.op = .member("responds")
            postfix.op.optionalAccessKind = accessKind
            exp.resolvedType = .optional(.bool)
        } else {
            postfix.op = .member("responds")
            exp.resolvedType = .bool
        }
        
        return exp
    }
    
    /// Converts [<lhs> isEqualToString:<rhs>] -> <lhs> <operator> <rhs> (where
    /// <operator> is usually '==' (equality). see usages above in visitPostfix
    /// and visitUnary)
    func convertIsEqualToString(_ exp: PostfixExpression, op: SwiftOperator) -> Expression? {
        guard let postfix = exp.exp.asPostfix, postfix.member?.name == "isEqualToString",
            let args = exp.functionCall?.arguments, args.count == 1 && !args.hasLabeledArguments() else {
            return nil
        }
        
        let res = postfix.exp.copy().binary(op: op, rhs: args[0].expression.copy())
        
        res.resolvedType = .bool
        
        return res
    }
    
    /// Converts [NSString stringWithFormat:@"format", <...>] -> String(format: "format", <...>)
    func convertStringWithFormat(_ exp: PostfixExpression) -> Expression? {
        guard let postfix = exp.exp.asPostfix else {
            return nil
        }
        
        guard let typename = postfix.exp.asIdentifier?.identifier else {
            return nil
        }
        
        guard (typename == "NSString" || typename == "NSMutableString")
            && postfix.op.asMember?.name == "stringWithFormat",
            let args = exp.functionCall?.copy().arguments, !args.isEmpty else {
            return nil
        }
        
        let newArgs: [FunctionArgument] = [
            .labeled("format", args[0].expression)
        ] + args.dropFirst()
        
        let newExp = exp.copy()
        
        newExp.exp = .identifier(typename == "NSMutableString" ? "NSMutableString" : "String")
        newExp.op = .functionCall(arguments: newArgs)
        
        newExp.resolvedType = .string
        
        return newExp
    }
    
    /// Converts [<array> addObjectsFromArray:<exp>] -> <array>.addObjects(from: <exp>)
    func convertAddObjectsFromArray(_ exp: PostfixExpression) -> Expression? {
        guard let postfix = exp.exp.asPostfix, postfix.member?.name == "addObjectsFromArray",
            let args = exp.functionCall?.arguments, args.count == 1 else {
            return nil
        }
        
        let newExp = exp.copy()
        
        newExp.op = .functionCall(arguments: [
            .labeled("from", args[0].expression.copy())
        ])
        
        newExp.exp = .postfix(postfix.exp.copy(), .member("addObjects"))
        newExp.resolvedType = .void
        
        let postfixOptional = postfix.op.optionalAccessKind
        if postfixOptional != .none {
            newExp.exp.asPostfix?.member?.optionalAccessKind = postfixOptional
            
            newExp.resolvedType = .optional(.void)
        }
        
        return newExp
    }
    
    /// Converts [Type class] and [<expression> class] expressions
    func convertClassCall(_ exp: PostfixExpression) -> Expression? {
        guard let args = exp.functionCall?.arguments, args.isEmpty else {
            return nil
        }
        guard let classMember = exp.exp.asPostfix, classMember.member?.name == "class" else {
            return nil
        }
        
        // Use resolved expression type, if available
        if case .metatype? = classMember.exp.resolvedType {
            let exp = classMember.exp.copy().dot("self")
            exp.resolvedType = classMember.exp.resolvedType
            
            return exp
        } else if !classMember.exp.isErrorTyped && classMember.exp.resolvedType != nil {
            return .postfix(
                .identifier("type"),
                .functionCall(arguments: [
                    .labeled("of", classMember.exp.copy())
                ])
            )
        }
        
        // Deduce using identifier or expression capitalization
        switch classMember.exp {
        case let ident as IdentifierExpression where ident.identifier.startsUppercased:
            return .postfix(classMember.exp.copy(), .member("self"))
        default:
            return .postfix(
                .identifier("type"),
                .functionCall(arguments: [
                    .labeled("of", classMember.exp.copy())
                ])
            )
        }
    }
    
    /// Converts [NSArray array], [NSDictionary dictionary], etc. constructs
    func convertDataStructureInit(_ exp: PostfixExpression) -> Expression? {
        guard let args = exp.functionCall?.arguments, args.isEmpty else {
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
        guard !(exp.definition is LocalCodeDefinition) && !(exp.definition is GlobalCodeDefinition) else {
            return nil
        }
        // Can only convert known instance types
        guard typeSystem.isClassInstanceType(exp.identifier) else {
            return nil
        }
        
        let mapper = DefaultTypeMapper(typeSystem: typeSystem)
        
        let newType = mapper.swiftType(
            forObjcType: .pointer(.typeName(ident)),
            context: .alwaysNonnull
        )
        
        let typeName = mapper.typeNameString(for: newType)
        
        if exp.identifier == typeName {
            return nil
        }
        
        exp.identifier = typeName
        exp.resolvedType = .metatype(for: .typeName(typeName))
        
        return exp
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
    func makeFunctionTransformers() {
        makeInitializerTransformers()
    }
    
    func makeInitializerTransformers() {
        // MARK: NSTimeZone
        
        makeInit(typeName: "NSTimeZone",
                 property: "localTimeZone",
                 convertInto: .identifier("TimeZone").dot("autoupdatingCurrent"),
                 andTypeAs: .typeName("TimeZone"))
        
        makeInit(typeName: "NSTimeZone",
                 property: "defaultTimeZone",
                 convertInto: .identifier("TimeZone").dot("current"),
                 andTypeAs: .typeName("TimeZone"))
        
        makeInit(typeName: "NSTimeZone",
                 property: "systemTimeZone",
                 convertInto: .identifier("TimeZone").dot("current"),
                 andTypeAs: .typeName("TimeZone"))
        
        // MARK: NSLocale
        
        makeInit(typeName: "NSLocale",
                 method: "localeWithLocaleIdentifier",
                 convertInto: .identifier("Locale"),
                 andCallWithArguments: [.labeled("identifier")],
                 andTypeAs: .typeName("Locale"))
        
        makeInit(typeName: "NSLocale",
                 property: "currentLocale",
                 convertInto: .identifier("Locale").dot("current"),
                 andTypeAs: .typeName("Locale"))
        
        makeInit(typeName: "NSLocale",
                 property: "systemLocale",
                 convertInto: .identifier("Locale").dot("current"),
                 andTypeAs: .typeName("Locale"))
        
        makeInit(typeName: "NSLocale",
                 property: "autoupdatingCurrentLocale",
                 convertInto: .identifier("Locale").dot("autoupdatingCurrent"),
                 andTypeAs: .typeName("Locale"))
        
        // MARK: NSNotificationCenter
        makeInit(typeName: "NSNotificationCenter",
                 property: "defaultCenter",
                 convertInto: .identifier("NotificationCenter").dot("default"),
                 andTypeAs: .typeName("NotificationCenter"))
    }
    
    func makeEnumTransformers() {
        makeCalendarUnitTransformers()
        makeCalendarIdentifierTransformers()
        
        enumMappings["NSOrderedAscending"] = {
            .identifier("ComparisonResult").dot("orderedAscending")
        }
        enumMappings["NSOrderedDescending"] = {
            .identifier("ComparisonResult").dot("orderedDescending")
        }
        enumMappings["NSOrderedSame"] = {
            .identifier("ComparisonResult").dot("orderedSame")
        }
    }
    
    func makeCalendarIdentifierTransformers() {
        enumMappings["NSCalendarIdentifierGregorian"] = {
            .identifier("Calendar").dot("Identifier").dot("gregorian")
        }
        enumMappings["NSCalendarIdentifierBuddhist"] = {
            .identifier("Calendar").dot("Identifier").dot("buddhist")
        }
        enumMappings["NSCalendarIdentifierChinese"] = {
            .identifier("Calendar").dot("Identifier").dot("chinese")
        }
        enumMappings["NSCalendarIdentifierCoptic"] = {
            .identifier("Calendar").dot("Identifier").dot("coptic")
        }
        enumMappings["NSCalendarIdentifierEthiopicAmeteMihret"] = {
            .identifier("Calendar").dot("Identifier").dot("ethiopicAmeteMihret")
        }
        enumMappings["NSCalendarIdentifierEthiopicAmeteAlem"] = {
            .identifier("Calendar").dot("Identifier").dot("ethiopicAmeteAlem")
        }
        enumMappings["NSCalendarIdentifierHebrew"] = {
            .identifier("Calendar").dot("Identifier").dot("hebrew")
        }
        enumMappings["NSCalendarIdentifierISO8601"] = {
            .identifier("Calendar").dot("Identifier").dot("ISO8601")
        }
        enumMappings["NSCalendarIdentifierIndian"] = {
            .identifier("Calendar").dot("Identifier").dot("indian")
        }
        enumMappings["NSCalendarIdentifierIslamic"] = {
            .identifier("Calendar").dot("Identifier").dot("islamic")
        }
        enumMappings["NSCalendarIdentifierIslamicCivil"] = {
            .identifier("Calendar").dot("Identifier").dot("islamicCivil")
        }
        enumMappings["NSCalendarIdentifierJapanese"] = {
            .identifier("Calendar").dot("Identifier").dot("japanese")
        }
        enumMappings["NSCalendarIdentifierPersian"] = {
            .identifier("Calendar").dot("Identifier").dot("persian")
        }
        enumMappings["NSCalendarIdentifierRepublicOfChina"] = {
            .identifier("Calendar").dot("Identifier").dot("republicOfChina")
        }
        enumMappings["NSCalendarIdentifierIslamicTabular"] = {
            .identifier("Calendar").dot("Identifier").dot("islamicTabular")
        }
        enumMappings["NSCalendarIdentifierIslamicUmmAlQura"] = {
            .identifier("Calendar").dot("Identifier").dot("islamicUmmAlQura")
        }
    }
    
    func makeCalendarUnitTransformers() {
        enumMappings["NSCalendarUnitEra"] = {
            .identifier("Calendar").dot("Component").dot("era")
        }
        enumMappings["NSCalendarUnitYear"] = {
            .identifier("Calendar").dot("Component").dot("year")
        }
        enumMappings["NSCalendarUnitMonth"] = {
            .identifier("Calendar").dot("Component").dot("month")
        }
        enumMappings["NSCalendarUnitDay"] = {
            .identifier("Calendar").dot("Component").dot("day")
        }
        enumMappings["NSCalendarUnitHour"] = {
            .identifier("Calendar").dot("Component").dot("hour")
        }
        enumMappings["NSCalendarUnitMinute"] = {
            .identifier("Calendar").dot("Component").dot("minute")
        }
        enumMappings["NSCalendarUnitSecond"] = {
            .identifier("Calendar").dot("Component").dot("second")
        }
        enumMappings["NSCalendarUnitWeekday"] = {
            .identifier("Calendar").dot("Component").dot("weekday")
        }
        enumMappings["NSCalendarUnitWeekdayOrdinal"] = {
            .identifier("Calendar").dot("Component").dot("weekdayOrdinal")
        }
        enumMappings["NSCalendarUnitQuarter"] = {
            .identifier("Calendar").dot("Component").dot("quarter")
        }
        enumMappings["NSCalendarUnitWeekOfMonth"] = {
            .identifier("Calendar").dot("Component").dot("weekOfMonth")
        }
        enumMappings["NSCalendarUnitWeekOfYear"] = {
            .identifier("Calendar").dot("Component").dot("weekOfYear")
        }
        enumMappings["NSCalendarUnitYearForWeekOfYear"] = {
            .identifier("Calendar").dot("Component").dot("weekOfYear")
        }
        enumMappings["NSCalendarUnitYearForWeekOfYear"] = {
            .identifier("Calendar").dot("Component").dot("yearForWeekOfYear")
        }
        enumMappings["NSCalendarUnitNanosecond"] = {
            .identifier("Calendar").dot("Component").dot("nanosecond")
        }
        enumMappings["NSCalendarUnitCalendar"] = {
            .identifier("Calendar").dot("Component").dot("calendar")
        }
        enumMappings["NSCalendarUnitTimeZone"] = {
            .identifier("Calendar").dot("Component").dot("timeZone")
        }
    }
}
