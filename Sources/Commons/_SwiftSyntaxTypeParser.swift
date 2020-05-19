import KnownType
import SwiftAST
import SwiftSyntax

public class _SwiftSyntaxTypeParser {
    var types: [IncompleteKnownType] = []
    let source: String
    
    public init(source: String) {
        self.source = source
    }
    
    public func parseTypes() -> [IncompleteKnownType] {
        types.removeAll()
        
        do {
            let syntax = try SyntaxParser.parse(source: source)
            
            for item in syntax.statements {
                parseType(in: item)
            }
        } catch {
            
        }
        
        return types
    }
    
    private func parseType(in item: CodeBlockItemSyntax) {
        let visitor = _SwiftSyntaxTypeParserVisitor()
        visitor.walk(item)
        
        if let type = visitor.type {
            let incompleteType = IncompleteKnownType(typeBuilder: type)
            types.append(incompleteType)
        }
    }
}

private class _SwiftSyntaxTypeParserVisitor: SyntaxVisitor {
    var type: KnownTypeBuilder?
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.identifier.text
        
        if type == nil {
            type = KnownTypeBuilder(typeName: name)
        }
        type = type?.settingKind(.class)
        type = type?.settingAttributes(attributes(in: node.attributes))
        
        collectConformances(in: node.inheritanceClause)
        collectMembers(in: node.members)
        
        return .skipChildren
    }
    
    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.identifier.text
        
        if type == nil {
            type = KnownTypeBuilder(typeName: name)
        }
        type = type?.settingUseSwiftSignatureMatching(true)
        type = type?.settingKind(.protocol)
        type = type?.settingAttributes(attributes(in: node.attributes))
        
        collectConformances(in: node.inheritanceClause)
        collectMembers(in: node.members)
        
        return .skipChildren
    }
    
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.identifier.text
        
        if type == nil {
            type = KnownTypeBuilder(typeName: name)
        }
        type = type?.settingUseSwiftSignatureMatching(true)
        type = type?.settingKind(.struct)
        type = type?.settingAttributes(attributes(in: node.attributes))
        
        collectConformances(in: node.inheritanceClause)
        collectMembers(in: node.members)
        
        return .skipChildren
    }
    
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.identifier.text
        
        if type == nil {
            type = KnownTypeBuilder(typeName: name)
        }
        type = type?.settingUseSwiftSignatureMatching(true)
        type = type?.settingKind(.enum)
        type = type?.settingAttributes(attributes(in: node.attributes))
        
        if let rawValue = node.inheritanceClause?.inheritedTypeCollection.first {
            type = type?.settingEnumRawValue(type: rawValue.typeName.asSwiftType)
        }
        
        collectConformances(in: node.inheritanceClause)
        collectMembers(in: node.members)
        
        return .skipChildren
    }
    
    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard let name = node.extendedType.asSwiftType.typeName else {
            return .skipChildren
        }
        
        if type == nil {
            type = KnownTypeBuilder(typeName: name)
        }
        type = type?.settingUseSwiftSignatureMatching(true)
        type = type?.settingKind(.extension)
        type = type?.settingAttributes(attributes(in: node.attributes))
        
        collectConformances(in: node.inheritanceClause)
        collectMembers(in: node.members)
        
        return .skipChildren
    }
    
    private func collectConformances(in inheritanceClause: TypeInheritanceClauseSyntax?) {
        guard let inheritanceClause = inheritanceClause else {
            return
        }
        
        for inheritance in inheritanceClause.inheritedTypeCollection {
            type = type?.protocolConformance(protocolName: inheritance.typeName.withoutTrivia().description)
        }
    }
    
    private func collectMembers(in decl: MemberDeclBlockSyntax) {
        guard let type = type else {
            return
        }
        
        let visitor = _SwiftSyntaxMemberVisitor(typeBuilder: type)
        visitor.walk(decl)
        
        self.type = visitor.typeBuilder
    }
}

private class _SwiftSyntaxMemberVisitor: SyntaxVisitor {
    var typeBuilder: KnownTypeBuilder
    
    init(typeBuilder: KnownTypeBuilder) {
        self.typeBuilder = typeBuilder
    }
    
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        let isConstant = node.letOrVarKeyword.text == "let"
        let modifierList = modifiers(in: node.modifiers)
        let attributeList = attributes(in: node.attributes)
        let ownership = modifierList.first?.ownership ?? .strong
        let isStatic = modifierList.contains(.static)
        
        for binding in node.bindings {
            guard let typeAnnotation = binding.typeAnnotation else {
                continue
            }
            guard let ident = identifier(inPattern: binding.pattern) else {
                continue
            }
            let accessors = accessor(in: binding.accessor)
            
            let storage = ValueStorage(type: typeAnnotation.type.asSwiftType,
                                       ownership: ownership,
                                       isConstant: isConstant)
            
            typeBuilder = typeBuilder.property(named: ident,
                                               storage: storage,
                                               isStatic: isStatic,
                                               accessor: accessors.propertyAccessor,
                                               attributes: attributeList)
        }
        
        return .skipChildren
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let modifierList = modifiers(in: node.modifiers)
        
        let returnType = node.signature.output?.returnType.asSwiftType ?? .void
        let parameters = parameterSignatures(in: node.signature.input.parameterList)
        let attributeList = attributes(in: node.attributes)
        
        let signature = FunctionSignature(name: node.identifier.text,
                                          parameters: parameters,
                                          returnType: returnType,
                                          isStatic: modifierList.contains(.static),
                                          isMutating: modifierList.contains(.mutating))
        
        typeBuilder = typeBuilder.method(withSignature: signature,
                                         attributes: attributeList)
        
        return .skipChildren
    }
    
    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        let modifierList = modifiers(in: node.modifiers)
        
        let isConvenience = modifierList.contains(.convenience)
        let isFailable = node.optionalMark != nil
        let parameters = parameterSignatures(in: node.parameters.parameterList)
        let attributeList = attributes(in: node.attributes)
        
        typeBuilder = typeBuilder.constructor(withParameters: parameters,
                                              attributes: attributeList,
                                              isFailable: isFailable,
                                              isConvenience: isConvenience)
        
        return .skipChildren
    }
    
    override func visit(_ node: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        let modifierList = modifiers(in: node.modifiers)
        let attributeList = attributes(in: node.attributes)
        let accessors = accessor(in: node.accessor)
        
        let parameterList = parameterSignatures(in: node.indices.parameterList)
        let returnType = node.result.returnType.asSwiftType
        
        typeBuilder = typeBuilder.subscription(
            parameters: parameterList,
            returnType: returnType,
            isStatic: modifierList.contains(.static),
            isConstant: accessors == .get,
            attributes: attributeList,
            semantics: [],
            annotations: [])
        
        return .skipChildren
    }
    
    override func visit(_ node: EnumCaseElementSyntax) -> SyntaxVisitorContinueKind {
        let name = node.identifier.text
        let initialValue: Expression?
        // TODO: Support different raw values; we specifically detect '0' here
        // because it has special semantic value as the default case in Objective-C
        // enum declarations
        if node.rawValue?.value.description == "0" {
            initialValue = .constant(0)
        } else {
            initialValue = nil
        }
        typeBuilder = typeBuilder.enumCase(named: name, rawValue: initialValue, semantics: [])
        
        return .skipChildren
    }
    
    // Ignore nested type definitions
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        typeBuilder = typeBuilder.nestedType(named: node.identifier.text) { builder in
            let visitor = _SwiftSyntaxTypeParserVisitor()
            visitor.type = builder
            visitor.walk(node)
            return visitor.type!
        }
        
        return .skipChildren
    }
    
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        typeBuilder = typeBuilder.nestedType(named: node.identifier.text) { builder in
            let visitor = _SwiftSyntaxTypeParserVisitor()
            visitor.type = builder
            visitor.walk(node)
            return visitor.type!
        }
        
        return .skipChildren
    }
    
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        typeBuilder = typeBuilder.nestedType(named: node.identifier.text) { builder in
            let visitor = _SwiftSyntaxTypeParserVisitor()
            visitor.type = builder
            visitor.walk(node)
            return visitor.type!
        }
        
        return .skipChildren
    }
}

private extension TypeSyntax {
    var asSwiftType: SwiftType {
        return try! SwiftTypeParser.parse(from: description.trimmingWhitespaces())
    }
}

private func accessor(in accessor: Syntax?) -> Accessor {
    guard let accessor = accessor else {
        return .getSet
    }
    
    if let accessor = accessor.as(AccessorBlockSyntax.self) {
        var result = Accessor.get
        
        for acc in accessor.accessors {
            if acc.accessorKind.text == "set" {
                result = .getSet
                break
            }
        }
        
        return result
    }
    
    return .get
}

private func attributes(in attributeList: AttributeListSyntax?) -> [KnownAttribute] {
    return attributeList?.compactMap { node -> KnownAttribute? in
        if let attribute = node.as(AttributeSyntax.self) {
            let params = attribute.argument?.withoutTrivia().description
            
            return KnownAttribute(name: attribute.attributeName.text,
                                  parameters: params)
        }
        if let attribute = node.as(CustomAttributeSyntax.self) {
            let params = attribute.argumentList?.withoutTrivia().description
            
            return KnownAttribute(name: attribute.attributeName.withoutTrivia().description,
                                  parameters: params)
        }
        
        return nil
    } ?? []
}

private func parameterSignatures(in parameterList: FunctionParameterListSyntax) -> [ParameterSignature] {
    return parameterList.compactMap { parameterSyntax -> ParameterSignature? in
        guard let type = parameterSyntax.type?.asSwiftType else {
            return nil
        }
        
        let hasDefaultValue = parameterSyntax.defaultArgument != nil
        
        var label: String?
        var name: String = ""
        
        if let firstName = parameterSyntax.firstName, firstName.text == "_" {
            label = nil
            name = parameterSyntax.secondName?.text ?? "_"
        } else if let firstName = parameterSyntax.firstName, parameterSyntax.secondName == nil {
            label = firstName.text
            name = firstName.text
        } else if let firstName = parameterSyntax.firstName,
            let secondName = parameterSyntax.secondName {
            label = firstName.text
            name = secondName.text
        }
        
        return ParameterSignature(label: label,
                                  name: name,
                                  type: type,
                                  hasDefaultValue: hasDefaultValue)
    }
}

private func identifier(inPattern pattern: PatternSyntax) -> String? {
    if let ident = pattern.as(IdentifierPatternSyntax.self) {
        return ident.identifier.text
    }
    
    return nil
}

private func modifiers(in modifierList: ModifierListSyntax?) -> [Modifier] {
    guard let modifierList = modifierList else {
        return []
    }
    
    var modifiers: [Modifier] = []
    
    for modifierSyntax in modifierList {
        if let mod = Modifier(rawValue: modifierSyntax.name.text) {
            modifiers.append(mod)
        }
    }
    
    return modifiers
}

private enum Accessor {
    case get
    case getSet
    
    var propertyAccessor: KnownPropertyAccessor {
        switch self {
        case .get:
            return .getter
        case .getSet:
            return .getterAndSetter
        }
    }
}

private enum Modifier: String {
    case strong
    case weak
    case unownedSafe = "unowned(safe)"
    case unownedUnsafe = "unowned(unsafe)"
    case mutating
    case `static`
    case convenience
    
    var ownership: Ownership? {
        switch self {
        case .strong:
            return .strong
        case .weak:
            return .weak
        case .unownedSafe:
            return .unownedSafe
        case .unownedUnsafe:
            return .unownedUnsafe
        default:
            return nil
        }
    }
}
