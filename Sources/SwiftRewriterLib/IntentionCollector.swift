import GrammarModels
import ObjcParser
import SwiftAST

public protocol IntentionCollectorDelegate: class {
    func isNodeInNonnullContext(_ node: ASTNode) -> Bool
    func reportForLazyParsing(intention: Intention)
    func reportForLazyResolving(intention: Intention)
    func typeMapper(for intentionCollector: IntentionCollector) -> TypeMapper
    func typeParser(for intentionCollector: IntentionCollector) -> TypeParsing
}

/// Represents a local context for constructing types with.
public class IntentionBuildingContext {
    var contexts: [Intention] = []
    var inNonnullContext: Bool = false
    var ivarAccessLevel: AccessLevel = .private
    
    public init() {
        
    }
    
    public func pushContext(_ intention: Intention) {
        contexts.append(intention)
    }
    
    /// Returns the latest context on the contexts stack that matches a given type.
    ///
    /// Searches from top-to-bottom, so the last context `T` that was pushed is
    /// returned first.
    public func findContext<T: Intention>(ofType type: T.Type = T.self) -> T? {
        return contexts.reversed().first { $0 is T } as? T
    }
    
    /// Returns the topmost context on the contexts stack casted to a specific type.
    ///
    /// If the topmost context is not T, nil is returned instead.
    public func currentContext<T: Intention>(as type: T.Type = T.self) -> T? {
        return contexts.last as? T
    }
    
    public func popContext() {
        contexts.removeLast()
    }
}

/// Traverses a provided AST node, and produces intentions that are recorded by
/// pushing and popping them as contexts on a delegate's context object.
public class IntentionCollector {
    public weak var delegate: IntentionCollectorDelegate?
    
    var context: IntentionBuildingContext
    
    public init(delegate: IntentionCollectorDelegate, context: IntentionBuildingContext) {
        self.delegate = delegate
        self.context = context
    }
    
    public func collectIntentions(_ node: ASTNode) {
        startNodeVisit(node)
    }
    
    private func startNodeVisit(_ node: ASTNode) {
        let visitor = AnyASTVisitor()
        let traverser = ASTTraverser(node: node, visitor: visitor)
        
        visitor.onEnterClosure = { node in
            self.context.inNonnullContext
                = self.delegate?.isNodeInNonnullContext(node) ?? false
            
            switch node {
            case let n as ObjcClassInterface:
                self.enterObjcClassInterfaceNode(n)
            case let n as ObjcClassCategoryInterface:
                self.enterObjcClassCategoryNode(n)
            case let n as ObjcClassImplementation:
                self.enterObjcClassImplementationNode(n)
            case let n as ObjcClassCategoryImplementation:
                self.enterObjcClassCategoryImplementationNode(n)
            case let n as ObjcStructDeclaration:
                self.enterStructDeclarationNode(n)
            case let n as ProtocolDeclaration:
                self.enterProtocolDeclarationNode(n)
            case let n as IVarsList:
                self.enterObjcClassIVarsListNode(n)
            case let n as ObjcEnumDeclaration:
                self.enterObjcEnumDeclarationNode(n)
            case let n as FunctionDefinition:
                self.enterFunctionDefinitionNode(n)
            default:
                return
            }
        }
        
        visitor.visitClosure = { node in
            switch node {
            case let n as TypedefNode:
                self.visitTypedefNode(n)
                
            case let n as KeywordNode:
                self.visitKeywordNode(n)
                
            case let n as MethodDefinition:
                self.visitObjcClassMethodNode(n)
                
            case let n as PropertyDefinition:
                self.visitPropertyDefinitionNode(n)
                
            case let n as PropertySynthesizeItem:
                self.visitPropertySynthesizeItemNode(n)
                
            case let n as ProtocolReferenceList:
                self.visitObjcClassProtocolReferenceListNode(n)
                
            case let n as SuperclassName:
                self.visitObjcClassSuperclassName(n)
                
            case let n as ObjcStructField:
                self.visitStructFieldNode(n)
                
            case let n as IVarDeclaration:
                self.visitObjcClassIVarDeclarationNode(n)
                
            case let n as VariableDeclaration:
                self.visitVariableDeclarationNode(n)
                
            case let n as ObjcEnumCase:
                self.visitObjcEnumCaseNode(n)
                
            case let n as Identifier
                where n.name == "NS_ASSUME_NONNULL_BEGIN":
                self.context.inNonnullContext = true
                
            case let n as Identifier
                where n.name == "NS_ASSUME_NONNULL_END":
                self.context.inNonnullContext = false
            default:
                return
            }
        }
        
        visitor.onExitClosure = { node in
            switch node {
            case let n as ObjcClassInterface:
                self.exitObjcClassInterfaceNode(n)
            case let n as ObjcClassCategoryInterface:
                self.exitObjcClassCategoryNode(n)
            case let n as ObjcClassImplementation:
                self.exitObjcClassImplementationNode(n)
            case let n as ObjcClassCategoryImplementation:
                self.exitObjcClassCategoryImplementationNode(n)
            case let n as ObjcStructDeclaration:
                self.exitStructDeclarationNode(n)
            case let n as ProtocolDeclaration:
                self.exitProtocolDeclarationNode(n)
            case let n as ObjcEnumDeclaration:
                self.exitObjcEnumDeclarationNode(n)
            case let n as FunctionDefinition:
                self.exitFunctionDefinitionNode(n)
            default:
                return
            }
        }
        
        traverser.traverse()
    }
    
    private func visitKeywordNode(_ node: KeywordNode) {
        switch node.keyword {
        case .atPrivate:
            context.ivarAccessLevel = .private
        case .atPublic:
            context.ivarAccessLevel = .public
        case .atPackage:
            context.ivarAccessLevel = .internal
        case .atProtected:
            context.ivarAccessLevel = .internal
        default:
            break
        }
    }
    
    // MARK: - Typedef
    
    private func visitTypedefNode(_ node: TypedefNode) {
        guard let ctx = context.findContext(ofType: FileGenerationIntention.self) else {
            return
        }
        guard let type = node.type else {
            return
        }
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent =
            TypealiasIntention(originalObjcType: type.type, fromType: .void,
                               named: name)
        recordSourceHistory(intention: intent, node: node)
        intent.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
        
        ctx.addTypealias(intent)
        
        delegate?.reportForLazyResolving(intention: intent)
    }
    
    // MARK: - Global Variable
    
    private func visitVariableDeclarationNode(_ node: VariableDeclaration) {
        guard let ctx = context.findContext(ofType: FileGenerationIntention.self) else {
            return
        }
        
        guard let name = node.identifier, let type = node.type else {
            return
        }
        
        let swiftType = SwiftType.anyObject
        let ownership = evaluateOwnershipPrefix(inType: type.type)
        let isConstant = InternalSwiftWriter._isConstant(fromType: type.type)
        
        let storage =
            ValueStorage(type: swiftType, ownership: ownership, isConstant: isConstant)
        
        let intent = GlobalVariableGenerationIntention(name: name.name, storage: storage, source: node)
        intent.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
        recordSourceHistory(intention: intent, node: node)
        
        if let initialExpression = node.initialExpression {
            let initialExpr =
                GlobalVariableInitialValueIntention(expression: .constant(0),
                                                    source: initialExpression)
            
            delegate?.reportForLazyParsing(intention: initialExpr)
            
            intent.initialValueExpr = initialExpr
        }
        
        ctx.addGlobalVariable(intent)
        
        delegate?.reportForLazyResolving(intention: intent)
    }
    
    // MARK: - ObjcClassInterface
    private func enterObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent = ClassGenerationIntention(typeName: name, source: node)
        recordSourceHistory(intention: intent, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }
    
    private func exitObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        if node.identifier?.name != nil {
            context.popContext() // ClassGenerationIntention
        }
    }
    
    // MARK: - ObjcClassCategory
    private func enterObjcClassCategoryNode(_ node: ObjcClassCategoryInterface) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent = ClassExtensionGenerationIntention(typeName: name, source: node)
        delegate?.reportForLazyResolving(intention: intent)
        intent.categoryName = node.categoryName?.name
        recordSourceHistory(intention: intent, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }
    
    private func exitObjcClassCategoryNode(_ node: ObjcClassCategoryInterface) {
        if node.identifier?.name != nil {
            context.popContext() // ClassExtensionGenerationIntention
        }
    }
    
    // MARK: - ObjcClassImplementation
    private func enterObjcClassImplementationNode(_ node: ObjcClassImplementation) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent = ClassGenerationIntention(typeName: name, source: node)
        recordSourceHistory(intention: intent, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }
    
    private func exitObjcClassImplementationNode(_ node: ObjcClassImplementation) {
        context.popContext() // ClassGenerationIntention
    }
    
    // MARK: - ObjcClassCategoryImplementation
    private func enterObjcClassCategoryImplementationNode(_ node: ObjcClassCategoryImplementation) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent = ClassExtensionGenerationIntention(typeName: name, source: node)
        delegate?.reportForLazyResolving(intention: intent)
        intent.categoryName = node.categoryName?.name
        recordSourceHistory(intention: intent, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }
    
    private func exitObjcClassCategoryImplementationNode(_ node: ObjcClassCategoryImplementation) {
        context.popContext() // ClassExtensionGenerationIntention
    }
    
    // MARK: - ProtocolDeclaration
    private func enterProtocolDeclarationNode(_ node: ProtocolDeclaration) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent = ProtocolGenerationIntention(typeName: name, source: node)
        recordSourceHistory(intention: intent, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addProtocol(intent)
        
        context.pushContext(intent)
    }
    
    private func exitProtocolDeclarationNode(_ node: ProtocolDeclaration) {
        if node.identifier?.name != nil {
            context.popContext() // ProtocolGenerationIntention
        }
    }
    
    // MARK: - Property definition
    private func visitPropertyDefinitionNode(_ node: PropertyDefinition) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }
        
        let swiftType: SwiftType = .anyObject
        
        var ownership: Ownership = .strong
        if let type = node.type?.type {
            ownership = evaluateOwnershipPrefix(inType: type, property: node)
        }
        
        let attributes =
            node.attributesList?
                .attributes.map { attr -> PropertyAttribute in
                    switch attr.attribute {
                    case .getter(let getter):
                        return PropertyAttribute.getterName(getter)
                    case .setter(let setter):
                        return PropertyAttribute.setterName(setter)
                    case .keyword(let keyword):
                        return PropertyAttribute.attribute(keyword)
                    }
                } ?? []
        
        let storage =
            ValueStorage(type: swiftType, ownership: ownership, isConstant: false)
        
        // Protocol property
        if context.findContext(ofType: ProtocolGenerationIntention.self) != nil {
            let prop =
                ProtocolPropertyGenerationIntention(name: node.identifier?.name ?? "",
                                                    storage: storage,
                                                    attributes: attributes,
                                                    source: node)
            prop.isOptional = node.isOptionalProperty
            prop.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
            recordSourceHistory(intention: prop, node: node)
            
            ctx.addProperty(prop)
            
            delegate?.reportForLazyResolving(intention: prop)
        } else {
            let prop = PropertyGenerationIntention(name: node.identifier?.name ?? "",
                                                   storage: storage,
                                                   attributes: attributes,
                                                   source: node)
            prop.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
            recordSourceHistory(intention: prop, node: node)
            
            ctx.addProperty(prop)
            
            delegate?.reportForLazyResolving(intention: prop)
        }
    }
    
    // MARK: - Property Implementation
    private func visitPropertySynthesizeItemNode(_ node: PropertySynthesizeItem) {
        guard let ctx = context.findContext(ofType: BaseClassIntention.self) else {
            return
        }
        
        guard let propertyName = node.propertyName else {
            return
        }
        
        let ivarName = node.instanceVarName?.name ?? propertyName.name
        
        let intent =
            PropertySynthesizationIntention(
                propertyName: propertyName.name, ivarName: ivarName, isExplicit: true)
        
        recordSourceHistory(intention: intent, node: node)
        
        ctx.addSynthesization(intent)
    }
    
    // MARK: - Method Declaration
    private func visitObjcClassMethodNode(_ node: MethodDefinition) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }
        
        let localMapper = DefaultTypeMapper(typeSystem: DefaultTypeSystem.defaultTypeSystem)
        
        let signGen = SwiftMethodSignatureGen(typeMapper: localMapper,
                                              inNonnullContext: context.inNonnullContext)
        let sign = signGen.generateDefinitionSignature(from: node)
        
        let method: MethodGenerationIntention
        
        if context.findContext(ofType: ProtocolGenerationIntention.self) != nil {
            let protMethod = ProtocolMethodGenerationIntention(signature: sign, source: node)
            protMethod.isOptional = node.isOptionalMethod
            recordSourceHistory(intention: protMethod, node: node)
            
            method = protMethod
        } else {
            method = MethodGenerationIntention(signature: sign, source: node)
        }
        
        method.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
        
        recordSourceHistory(intention: method, node: node)
        
        if let body = node.body {
            let methodBodyIntention = FunctionBodyIntention(body: [], source: body)
            recordSourceHistory(intention: methodBodyIntention, node: body)
            
            delegate?.reportForLazyParsing(intention: methodBodyIntention)
            method.functionBody = methodBodyIntention
        }
        
        ctx.addMethod(method)
        
        delegate?.reportForLazyResolving(intention: method)
    }
    
    private func visitObjcClassSuperclassName(_ node: SuperclassName) {
        guard let ctx = context.findContext(ofType: ClassGenerationIntention.self) else {
            return
        }
        
        ctx.superclassName = node.name
    }
    
    private func visitObjcClassProtocolReferenceListNode(_ node: ProtocolReferenceList) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }
        
        for protNode in node.protocols {
            // In Swift, 'NSObject' protocol is written as 'NSObjectProtocol'
            let protName = protNode.name == "NSObject" ? "NSObjectProtocol" : protNode.name
            
            let intent = ProtocolInheritanceIntention(protocolName: protName, source: protNode)
            recordSourceHistory(intention: intent, node: node)
            
            ctx.addProtocol(intent)
        }
    }
    
    // MARK: - IVar Section
    private func enterObjcClassIVarsListNode(_ node: IVarsList) {
        context.ivarAccessLevel = .private
    }
    
    private func visitObjcClassIVarDeclarationNode(_ node: IVarDeclaration) {
        guard let classCtx = context.findContext(ofType: BaseClassIntention.self) else {
            return
        }
        
        let access = context.ivarAccessLevel
        
        let swiftType: SwiftType = .anyObject
        var ownership = Ownership.strong
        var isConstant = false
        if let type = node.type?.type {
            ownership = evaluateOwnershipPrefix(inType: type)
            isConstant = InternalSwiftWriter._isConstant(fromType: type)
        }
        
        let storage = ValueStorage(type: swiftType, ownership: ownership, isConstant: isConstant)
        let ivar =
            InstanceVariableGenerationIntention(name: node.identifier?.name ?? "",
                                                storage: storage,
                                                accessLevel: access,
                                                source: node)
        ivar.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
        recordSourceHistory(intention: ivar, node: node)
        
        classCtx.addInstanceVariable(ivar)
        
        delegate?.reportForLazyResolving(intention: ivar)
    }
    
    // MARK: - Enum Declaration
    private func enterObjcEnumDeclarationNode(_ node: ObjcEnumDeclaration) {
        guard let identifier = node.identifier else {
            return
        }
        
        let enumIntention =
            EnumGenerationIntention(typeName: identifier.name,
                                    rawValueType: .anyObject,
                                    source: node)
        enumIntention.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
        recordSourceHistory(intention: enumIntention, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(enumIntention)
        
        context.pushContext(enumIntention)
        
        delegate?.reportForLazyResolving(intention: enumIntention)
    }
    
    private func visitObjcEnumCaseNode(_ node: ObjcEnumCase) {
        guard let ctx = context.currentContext(as: EnumGenerationIntention.self) else {
            return
        }
        guard let identifier = node.identifier?.name else {
            return
        }
        
        let enumCase =
            EnumCaseGenerationIntention(name: identifier, expression: nil,
                                        accessLevel: .internal, source: node)
        recordSourceHistory(intention: enumCase, node: node)
        
        delegate?.reportForLazyParsing(intention: enumCase)
        
        ctx.addCase(enumCase)
    }
    
    private func exitObjcEnumDeclarationNode(_ node: ObjcEnumDeclaration) {
        guard node.identifier != nil && node.type != nil else {
            return
        }
        
        context.popContext() // EnumGenerationIntention
    }
    
    // MARK: - Function Definition
    private func enterFunctionDefinitionNode(_ node: FunctionDefinition) {
        guard node.identifier != nil else {
            return
        }
        
        guard let mapper = delegate?.typeMapper(for: self) else {
            return
        }
        
        let gen = SwiftMethodSignatureGen(typeMapper: mapper,
                                          inNonnullContext: context.inNonnullContext,
                                          instanceTypeAlias: nil)
        let signature = gen.generateDefinitionSignature(from: node)
        
        let globalFunc = GlobalFunctionGenerationIntention(signature: signature, source: node)
        recordSourceHistory(intention: globalFunc, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addGlobalFunction(globalFunc)
        
        context.pushContext(globalFunc)
        
        if let body = node.methodBody {
            let methodBodyIntention = FunctionBodyIntention(body: [], source: body)
            recordSourceHistory(intention: methodBodyIntention, node: body)
            
            delegate?.reportForLazyParsing(intention: methodBodyIntention)
            globalFunc.functionBody = methodBodyIntention
        }
        
        delegate?.reportForLazyResolving(intention: globalFunc)
    }
    
    private func exitFunctionDefinitionNode(_ node: FunctionDefinition) {
        guard node.identifier != nil else {
            return
        }
        
        context.popContext() // GlobalFunctionGenerationIntention
    }
    
    // MARK: - Struct declaration
    private func enterStructDeclarationNode(_ node: ObjcStructDeclaration) {
        var nodeIdentifiers: [Identifier] = []
        if let identifier = node.identifier {
            nodeIdentifiers = [identifier]
        }
        if let parentNode = node.parent as? TypedefNode {
            nodeIdentifiers.append(contentsOf: parentNode.childrenMatching(type: Identifier.self))
        }
        
        guard let identifier = nodeIdentifiers.first else {
            return
        }
        
        let fileIntent = context.findContext(ofType: FileGenerationIntention.self)
        
        let structIntent = StructGenerationIntention(typeName: identifier.name, source: node)
        recordSourceHistory(intention: structIntent, node: node)
        
        fileIntent?.addType(structIntent)
        
        context.pushContext(structIntent)
        
        // Remaining identifiers are used as typealiases
        for identifier in nodeIdentifiers.dropFirst() {
            let alias = TypealiasIntention(originalObjcType: .struct(structIntent.typeName),
                                           fromType: .void, named: identifier.name)
            alias.inNonnullContext = delegate?.isNodeInNonnullContext(identifier) ?? false
            recordSourceHistory(intention: alias, node: identifier)
            
            fileIntent?.addTypealias(alias)
            
            delegate?.reportForLazyResolving(intention: alias)
        }
    }
    
    private func visitStructFieldNode(_ node: ObjcStructField) {
        guard let ctx = context.currentContext(as: StructGenerationIntention.self) else {
            return
        }
        guard let identifier = node.identifier else {
            return
        }
        
        let storage = ValueStorage(type: .void, ownership: .strong, isConstant: false)
        let ivar = InstanceVariableGenerationIntention(
            name: identifier.name,
            storage: storage,
            source: node)
        recordSourceHistory(intention: ivar, node: node)
        ctx.addInstanceVariable(ivar)
        
        delegate?.reportForLazyResolving(intention: ivar)
    }
    
    private func exitStructDeclarationNode(_ node: ObjcStructDeclaration) {
        guard node.identifier != nil else {
            return
        }
        
        context.popContext() // ObjcStructDeclaration
    }
}

extension IntentionCollector {
    private func recordSourceHistory(intention: FromSourceIntention, node: ASTNode) {
        guard let file = node.originalSource?.filePath, let rule = node.sourceRuleContext?.start else {
            return
        }
        
        intention.history
            .recordCreation(description: "\(file) line \(rule.getLine()) column \(rule.getCharPositionInLine())")
    }
}
