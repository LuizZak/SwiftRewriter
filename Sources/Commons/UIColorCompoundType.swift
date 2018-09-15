import SwiftAST
import SwiftRewriterLib

public enum UIColorCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let string = typeString()
        
        do {
            let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: string)
            let type = try incomplete.toCompoundedKnownType()
            
            return type
        } catch {
            fatalError(
                "Found error while parsing UIColor class interface: \(error)"
            )
        }
    }
    
    static func typeString() -> String {
        let type = """
            class UIColor: NSObject, NSSecureCoding, NSCopying {
                @_swiftrewriter(renameFrom: blackColor)
                @_swiftrewriter(mapFrom: blackColor())
                static var black: UIColor { get }
                
                @_swiftrewriter(renameFrom: darkGrayColor)
                @_swiftrewriter(mapFrom: darkGrayColor())
                static var darkGray: UIColor { get }
                
                @_swiftrewriter(renameFrom: lightGrayColor)
                @_swiftrewriter(mapFrom: lightGrayColor())
                static var lightGray: UIColor { get }
                
                @_swiftrewriter(renameFrom: whiteColor)
                @_swiftrewriter(mapFrom: whiteColor())
                static var white: UIColor { get }
                
                @_swiftrewriter(renameFrom: grayColor)
                @_swiftrewriter(mapFrom: grayColor())
                static var gray: UIColor { get }
                
                @_swiftrewriter(renameFrom: redColor)
                @_swiftrewriter(mapFrom: redColor())
                static var red: UIColor { get }
                
                @_swiftrewriter(renameFrom: greenColor)
                @_swiftrewriter(mapFrom: greenColor())
                static var green: UIColor { get }
                
                @_swiftrewriter(renameFrom: blueColor)
                @_swiftrewriter(mapFrom: blueColor())
                static var blue: UIColor { get }
                
                @_swiftrewriter(renameFrom: cyanColor)
                @_swiftrewriter(mapFrom: cyanColor())
                static var cyan: UIColor { get }
                
                @_swiftrewriter(renameFrom: yellowColor)
                @_swiftrewriter(mapFrom: yellowColor())
                static var yellow: UIColor { get }
                
                @_swiftrewriter(renameFrom: magentaColor)
                @_swiftrewriter(mapFrom: magentaColor())
                static var magenta: UIColor { get }
                
                @_swiftrewriter(renameFrom: orangeColor)
                @_swiftrewriter(mapFrom: orangeColor())
                static var orange: UIColor { get }
                
                @_swiftrewriter(renameFrom: purpleColor)
                @_swiftrewriter(mapFrom: purpleColor())
                static var purple: UIColor { get }
                
                @_swiftrewriter(renameFrom: brownColor)
                @_swiftrewriter(mapFrom: brownColor())
                static var brown: UIColor { get }
                
                @_swiftrewriter(renameFrom: clearColor)
                @_swiftrewriter(mapFrom: clearColor())
                static var clear: UIColor { get }
                
                @_swiftrewriter(renameFrom: lightTextColor)
                @_swiftrewriter(mapFrom: lightTextColor())
                static var lightText: UIColor { get }
                
                @_swiftrewriter(renameFrom: darkTextColor)
                @_swiftrewriter(mapFrom: darkTextColor())
                static var darkText: UIColor { get }
                
                @_swiftrewriter(renameFrom: groupTableViewBackgroundColor)
                @_swiftrewriter(mapFrom: groupTableViewBackgroundColor())
                static var groupTableViewBackground: UIColor { get }
                
                @_swiftrewriter(renameFrom: viewFlipsideBackgroundColor)
                @_swiftrewriter(mapFrom: viewFlipsideBackgroundColor())
                static var viewFlipsideBackground: UIColor { get }
                
                @_swiftrewriter(renameFrom: scrollViewTexturedBackgroundColor)
                @_swiftrewriter(mapFrom: scrollViewTexturedBackgroundColor())
                static var scrollViewTexturedBackground: UIColor { get }
                
                @_swiftrewriter(renameFrom: underPageBackgroundColor)
                @_swiftrewriter(mapFrom: underPageBackgroundColor())
                static var underPageBackground: UIColor { get }
                
                @_swiftrewriter(renameFrom: CGColor)
                var cgColor: CGColor { get }
                
                @_swiftrewriter(renameFrom: CIColor)
                var ciColor: CGColor { get }
                
                
                @_swiftrewriter(mapFrom: colorWithAlphaComponent(_:))
                func withAlphaComponent(_ alpha: CGFloat) -> UIColor
            }
            """
        
        return type
    }
}

private extension KnownTypeBuilder {
    
    func staticColorProperty(named name: String, transformations: TransformationsSink) -> KnownTypeBuilder {
        return
            property(named: name, type: "UIColor", isStatic: true, accessor: .getter)
            ._createPropertyRename(from: "\(name)Color", in: transformations)
            ._createPropertyFromMethods(getterName: "\(name)Color", setterName: nil, in: transformations)
    }
    
}

extension KnownTypeBuilder {
    func _createConstructorMapping(fromStaticMethod signature: FunctionSignature,
                                   in transformations: TransformationsSink) -> KnownTypeBuilder {
        
        guard let constructor = lastConstructor else {
            assertionFailure("Must be called after a call to `.constructor`")
            return self
        }
        
        let transformer = ValueTransformer<PostfixExpression, Expression> { $0 }
            .validate { exp in
                exp.asPostfix?
                    .functionCall?
                    .identifierWith(methodName: signature.name)
                        == signature.asIdentifier
            }
            .decompose()
            .transformIndex(index: 0, transformer: ValueTransformer()
                .removingMemberAccess()
                .validate(matcher: ValueMatcher()
                    .isTyped(.metatype(for: .typeName(typeName)),
                             ignoringNullability: true)
                )
            )
            .asFunctionCall(labels: constructor.parameters.argumentLabels())
            .typed(.typeName(typeName))
        
        transformations.addValueTransformer(transformer)
        
        let attributeParams =
            SwiftClassInterfaceParser
                .SwiftRewriterAttribute
                .Content
                .mapFrom(signature)
        
        let attribute =
            KnownAttribute(name: SwiftClassInterfaceParser.SwiftRewriterAttribute.name,
                           parameters: attributeParams.asString)
        
        return attributingLatestConstructor(attribute: attribute)
    }
    
    func _createConstructorMapping(fromParameters parameters: [ParameterSignature],
                                   in transformations: TransformationsSink) -> KnownTypeBuilder {
        
        guard let constructor = lastConstructor else {
            assertionFailure("Must be called after a call to `.constructor`")
            return self
        }
        
        transformations.addInitTransform(from: parameters,
                                         to: constructor.parameters)
        
        let parameterNames = parameters.map { $0.label }
        
        let attributeParams: SwiftClassInterfaceParser.SwiftRewriterAttribute.Content
            = .mapFromIdentifier(FunctionIdentifier(name: "init",
                                                    parameterNames: parameterNames))
        
        let attribute =
            KnownAttribute(name: SwiftClassInterfaceParser.SwiftRewriterAttribute.name,
                           parameters: attributeParams.asString)
        
        return attributingLatestConstructor(attribute: attribute)
    }
    
    func _createPropertyRename(from old: String, in transformations: TransformationsSink) -> KnownTypeBuilder {
        guard let property = lastProperty else {
            assertionFailure("Must be called after a call to `.property`")
            return self
        }
        
        transformations.addPropertyRenaming(old: old, new: property.name)
        
        let attributeParams =
            SwiftClassInterfaceParser.SwiftRewriterAttribute.Content.renameFrom(old).asString
        
        let attribute =
            KnownAttribute(name: SwiftClassInterfaceParser.SwiftRewriterAttribute.name,
                           parameters: attributeParams)
        
        return attributingLatestProperty(attribute: attribute)
    }
    
    func _createPropertyFromMethods(getterName: String,
                                    setterName: String?,
                                    in transformations: TransformationsSink) -> KnownTypeBuilder {
        
        guard let property = lastProperty else {
            assertionFailure("Must be called after a call to `.property`")
            return self
        }
        
        transformations
            .addPropertyFromMethods(property: property.name,
                                    getter: getterName,
                                    setter: setterName,
                                    propertyType: property.storage.type,
                                    isStatic: property.isStatic)
        
        var attributes: [KnownAttribute] = []
        
        let attributeParams: SwiftClassInterfaceParser.SwiftRewriterAttribute.Content
            = .mapFromIdentifier(FunctionIdentifier(name: getterName, parameterNames: []))
        
        let attribute =
            KnownAttribute(name: SwiftClassInterfaceParser.SwiftRewriterAttribute.name,
                           parameters: attributeParams.asString)
        attributes.append(attribute)
        
        if let setterName = setterName {
            let attributeParams: SwiftClassInterfaceParser.SwiftRewriterAttribute.Content
                = .mapFromIdentifier(FunctionIdentifier(name: setterName, parameterNames: [nil]))
            
            let attribute =
                KnownAttribute(name: SwiftClassInterfaceParser.SwiftRewriterAttribute.name,
                               parameters: attributeParams.asString)
            
            attributes.append(attribute)
        }
        
        return attributes.reduce(self) { $0.attributingLatestProperty(attribute: $1) }
    }
}
