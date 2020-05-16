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
        
        type = KnownTypeBuilder(typeName: name)
        type = type?.settingKind(.class)
        
        collectMembers(in: node.members)
        
        return .skipChildren
    }
    
    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.identifier.text
        
        type = KnownTypeBuilder(typeName: name)
        type = type?.settingKind(.protocol)
        
        collectMembers(in: node.members)
        
        return .skipChildren
    }
    
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.identifier.text
        
        type = KnownTypeBuilder(typeName: name)
        type = type?.settingKind(.struct)
        
        collectMembers(in: node.members)
        
        return .skipChildren
    }
    
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.identifier.text
        
        type = KnownTypeBuilder(typeName: name)
        type = type?.settingKind(.enum)
        
        collectMembers(in: node.members)
        
        return .skipChildren
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
        let modifiers = self.modifiers(in: node.modifiers)
        let ownership = modifiers.first?.ownership ?? .strong
        let isStatic = modifiers.contains(.static)
        
        for binding in node.bindings {
            guard let typeAnnotation = binding.typeAnnotation else {
                continue
            }
            guard let identifier = self.identifier(inPattern: binding.pattern) else {
                continue
            }
            
            let storage = ValueStorage(type: typeAnnotation.type.asSwiftType,
                                       ownership: ownership,
                                       isConstant: isConstant)
            
            typeBuilder = typeBuilder.property(named: identifier, storage: storage, isStatic: isStatic)
        }
        
        return .skipChildren
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let modifiers = self.modifiers(in: node.modifiers)
        
        let returnType = node.signature.output?.returnType.asSwiftType ?? .void
        let parameters = parameterSignatures(in: node.signature.input.parameterList)
        
        let signature = FunctionSignature(name: node.identifier.text,
                                          parameters: parameters,
                                          returnType: returnType,
                                          isStatic: modifiers.contains(.static),
                                          isMutating: modifiers.contains(.mutating))
        
        typeBuilder = typeBuilder.method(withSignature: signature)
        
        return .skipChildren
    }
    
    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        let modifiers = self.modifiers(in: node.modifiers)
        
        let isConvenience = modifiers.contains(.convenience)
        let isFailable = node.optionalMark != nil
        let parameters = parameterSignatures(in: node.parameters.parameterList)
        
        typeBuilder = typeBuilder.constructor(withParameters: parameters,
                                              isFailable: isFailable,
                                              isConvenience: isConvenience)
        
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
        return .skipChildren
    }
    
    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }
    
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }
    
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }
    
    func parameterSignatures(in parameterList: FunctionParameterListSyntax) -> [ParameterSignature] {
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
    
    func identifier(inPattern pattern: PatternSyntax) -> String? {
        if let ident = pattern.as(IdentifierPatternSyntax.self) {
            return ident.identifier.text
        }
        
        return nil
    }
    
    func modifiers(in modifierList: ModifierListSyntax?) -> [Modifier] {
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
    
    enum Modifier: String {
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
}

private extension TypeSyntax {
    var asSwiftType: SwiftType {
        return try! SwiftTypeParser.parse(from: description.trimmingWhitespaces())
    }
}
