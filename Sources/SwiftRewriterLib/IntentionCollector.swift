import GrammarModels
import ObjcParser
import SwiftAST

public protocol IntentionCollectorDelegate {
    func isNodeInNonnullContext(_ node: ASTNode) -> Bool
    func reportForLazyParsing(intention: Intention)
    func reportForLazyResolving(intention: Intention)
    func typeMapper(for intentionCollector: IntentionCollector) -> TypeMapper
    func typeParser(for intentionCollector: IntentionCollector) -> TypeParsing
}

/// Traverses a provided AST node, and produces intentions that are recorded by
/// pushing and popping them as contexts on a delegate's context object.
public class IntentionCollector {
    public let delegate: IntentionCollectorDelegate
    
    var context: TypeConstructionContext
    
    public init(delegate: IntentionCollectorDelegate, context: TypeConstructionContext) {
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
            if let ctx = self.context.findContext(ofType: AssumeNonnullContext.self) {
                ctx.isNonnullOn = self.delegate.isNodeInNonnullContext(node)
            }
            
            switch node {
            case let n as ObjcClassInterface:
                self.enterObjcClassInterfaceNode(n)
            case let n as ObjcClassCategoryInterface:
                self.enterObjcClassCategoryNode(n)
            case let n as ObjcClassImplementation:
                self.enterObjcClassImplementationNode(n)
            case let n as ObjcClassCategoryImplementation:
                self.enterObjcClassCategoryImplementationNode(n)
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
                
            case let n as ProtocolReferenceList:
                self.visitObjcClassProtocolReferenceListNode(n)
                
            case let n as SuperclassName:
                self.visitObjcClassSuperclassName(n)
                
            case let n as IVarDeclaration:
                self.visitObjcClassIVarDeclarationNode(n)
                
            case let n as VariableDeclaration:
                self.visitVariableDeclarationNode(n)
                
            case let n as ObjcEnumCase:
                self.visitObjcEnumCaseNode(n)
                
            case let n as Identifier
                where n.name == "NS_ASSUME_NONNULL_BEGIN":
                self.context.findContext(ofType: AssumeNonnullContext.self)?.isNonnullOn = true
                
            case let n as Identifier
                where n.name == "NS_ASSUME_NONNULL_END":
                self.context.findContext(ofType: AssumeNonnullContext.self)?.isNonnullOn = false
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
            case let n as ProtocolDeclaration:
                self.exitProtocolDeclarationNode(n)
            case let n as IVarsList:
                self.exitObjcClassIVarsListNode(n)
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
        
        let intent = TypealiasIntention(fromType: type.type, named: name)
        recordSourceHistory(intention: intent, node: node)
        intent.inNonnullContext = delegate.isNodeInNonnullContext(node)
        
        ctx.addTypealias(intent)
    }
    
    private func visitKeywordNode(_ node: KeywordNode) {
        // ivar list accessibility specification
        if let ctx = context.findContext(ofType: IVarListContext.self) {
            switch node.keyword {
            case .atPrivate:
                ctx.accessLevel = .private
            case .atPublic:
                ctx.accessLevel = .public
            case .atPackage:
                ctx.accessLevel = .internal
            case .atProtected:
                ctx.accessLevel = .internal
            default:
                break
            }
        }
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
        intent.inNonnullContext = delegate.isNodeInNonnullContext(node)
        recordSourceHistory(intention: intent, node: node)
        
        if let initialExpression = node.initialExpression {
            let initialExpr =
                GlobalVariableInitialValueIntention(expression: .constant(0),
                                                    source: initialExpression)
            
            delegate.reportForLazyParsing(intention: initialExpr)
            
            intent.initialValueExpr = initialExpr
        }
        
        ctx.addGlobalVariable(intent)
        
        delegate.reportForLazyResolving(intention: intent)
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
    
    // MARK: -
    
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
            prop.inNonnullContext = delegate.isNodeInNonnullContext(node)
            recordSourceHistory(intention: prop, node: node)
            
            ctx.addProperty(prop)
            
            delegate.reportForLazyResolving(intention: prop)
        } else {
            let prop = PropertyGenerationIntention(name: node.identifier?.name ?? "",
                                                   storage: storage,
                                                   attributes: attributes,
                                                   source: node)
            prop.inNonnullContext = delegate.isNodeInNonnullContext(node)
            recordSourceHistory(intention: prop, node: node)
            
            ctx.addProperty(prop)
            
            delegate.reportForLazyResolving(intention: prop)
        }
    }
    
    // MARK: - Method Declaration
    private func visitObjcClassMethodNode(_ node: MethodDefinition) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }
        
        let localMapper =
            DefaultTypeMapper(context:
                TypeConstructionContext(typeSystem:
                    DefaultTypeSystem.defaultTypeSystem
                )
        )
        
        let signGen = SwiftMethodSignatureGen(context: context, typeMapper: localMapper)
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
        
        method.inNonnullContext = delegate.isNodeInNonnullContext(node)
        
        recordSourceHistory(intention: method, node: node)
        
        if let body = node.body {
            let methodBodyIntention = FunctionBodyIntention(body: [], source: body)
            recordSourceHistory(intention: methodBodyIntention, node: body)
            
            delegate.reportForLazyParsing(intention: methodBodyIntention)
            method.functionBody = methodBodyIntention
        }
        
        ctx.addMethod(method)
        
        delegate.reportForLazyResolving(intention: method)
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
        let ctx = IVarListContext(accessLevel: .private)
        context.pushContext(ctx)
    }
    
    private func visitObjcClassIVarDeclarationNode(_ node: IVarDeclaration) {
        guard let classCtx = context.findContext(ofType: BaseClassIntention.self) else {
            return
        }
        let ivarCtx = context.findContext(ofType: IVarListContext.self)
        
        let access = ivarCtx?.accessLevel ?? .private
        
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
        ivar.inNonnullContext = delegate.isNodeInNonnullContext(node)
        recordSourceHistory(intention: ivar, node: node)
        
        classCtx.addInstanceVariable(ivar)
        
        delegate.reportForLazyResolving(intention: ivar)
    }
    
    private func exitObjcClassIVarsListNode(_ node: IVarsList) {
        context.popContext() // InstanceVarContext
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
        enumIntention.inNonnullContext = delegate.isNodeInNonnullContext(node)
        recordSourceHistory(intention: enumIntention, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(enumIntention)
        
        context.pushContext(enumIntention)
        
        delegate.reportForLazyResolving(intention: enumIntention)
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
        
        delegate.reportForLazyParsing(intention: enumCase)
        
        ctx.addCase(enumCase)
    }
    
    private func exitObjcEnumDeclarationNode(_ node: ObjcEnumDeclaration) {
        guard node.identifier != nil && node.type != nil else {
            return
        }
        
        context.popContext() // EnumGenerationIntention
    }
    
    // Mark: - Function Definition
    private func enterFunctionDefinitionNode(_ node: FunctionDefinition) {
        guard node.identifier != nil else {
            return
        }
        
        let mapper = delegate.typeMapper(for: self)
        
        let gen = SwiftMethodSignatureGen(context: context, typeMapper: mapper)
        let signature = gen.generateDefinitionSignature(from: node)
        
        let globalFunc = GlobalFunctionGenerationIntention(signature: signature, source: node)
        recordSourceHistory(intention: globalFunc, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addGlobalFunction(globalFunc)
        
        context.pushContext(globalFunc)
        
        delegate.reportForLazyResolving(intention: globalFunc)
    }
    
    private func exitFunctionDefinitionNode(_ node: FunctionDefinition) {
        guard node.identifier != nil else {
            return
        }
        
        context.popContext() // GlobalFunctionGenerationIntention
    }
    
    private func recordSourceHistory(intention: FromSourceIntention, node: ASTNode) {
        guard let file = node.originalSource?.filePath, let rule = node.sourceRuleContext?.start else {
            return
        }
        
        intention.history
            .recordCreation(description: "\(file) line \(rule.getLine()) column \(rule.getCharPositionInLine())")
    }
}

/// Used while collecting instance variable intentions to assign proper accessibility
/// annotations to them.
private class IVarListContext: Context {
    var accessLevel: AccessLevel
    
    init(accessLevel: AccessLevel = .private) {
        self.accessLevel = accessLevel
    }
}
