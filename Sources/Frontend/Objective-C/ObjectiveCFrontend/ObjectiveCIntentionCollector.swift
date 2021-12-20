import GrammarModelBase
import ObjcGrammarModels
import ObjcParser
import SwiftAST
import KnownType
import Intentions
import TypeSystem

public protocol ObjectiveCIntentionCollectorDelegate: AnyObject {
    func isNodeInNonnullContext(_ node: ObjcASTNode) -> Bool
    func reportForLazyParsing(intention: Intention)
    func reportForLazyResolving(intention: Intention)
    func typeMapper(for intentionCollector: ObjectiveCIntentionCollector) -> TypeMapper
    func typeParser(for intentionCollector: ObjectiveCIntentionCollector) -> ObjcTypeParser
}

/// Traverses a provided AST node, and produces intentions that are recorded by
/// pushing and popping them as contexts on a delegate's context object.
public class ObjectiveCIntentionCollector {
    /// Represents a local context for constructing types with.
    public class Context {
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
            contexts.reversed().first { $0 is T } as? T
        }
        
        /// Returns the topmost context on the contexts stack casted to a specific type.
        ///
        /// If the topmost context is not T, nil is returned instead.
        public func currentContext<T: Intention>(as type: T.Type = T.self) -> T? {
            contexts.last as? T
        }
        
        public func popContext() {
            contexts.removeLast()
        }
    }

    public weak var delegate: ObjectiveCIntentionCollectorDelegate?
    
    var context: Context
    
    public init(delegate: ObjectiveCIntentionCollectorDelegate, context: Context) {
        self.delegate = delegate
        self.context = context
    }
    
    public func collectIntentions(_ node: ObjcASTNode) {
        startNodeVisit(node)
    }
    
    private func startNodeVisit(_ node: ObjcASTNode) {
        let visitor = AnyASTVisitor()
        let traverser = ASTTraverser(node: node, visitor: visitor)
        
        visitor.onEnterClosure = { node in
            if let objcNode = node as? ObjcASTNode {
                self.context.inNonnullContext
                    = self.delegate?.isNodeInNonnullContext(objcNode) ?? false
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
            case let n as ObjcStructDeclaration:
                self.enterStructDeclarationNode(n)
            case let n as ObjcProtocolDeclaration:
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
            case let n as ObjcProtocolDeclaration:
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
        if !node.typeDeclarators.isEmpty {
            guard let name = node.typeDeclarators[0].identifier?.name else {
                return
            }
            
            let intent =
                TypealiasIntention(originalObjcType: type.type, fromType: .void,
                                   named: name)
            recordSourceHistory(intention: intent, node: node)
            intent.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
            
            ctx.addTypealias(intent)
            
            delegate?.reportForLazyResolving(intention: intent)
            
            return
        }
        
        // Attempt to interpret as a function pointer typealias
        if let identifier = node.identifier, let typeNode = node.type {
            
            let intent =
                TypealiasIntention(originalObjcType: typeNode.type,
                                   fromType: .void,
                                   named: identifier.name)
            
            recordSourceHistory(intention: intent, node: node)
            intent.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
            
            ctx.addTypealias(intent)
            
            delegate?.reportForLazyResolving(intention: intent)
            
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
        let isConstant = _isConstant(fromType: type.type)
        
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
        intent.isInterfaceSource = true
        
        mapComments(node, intent)
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
        intent.isInterfaceSource = true
        delegate?.reportForLazyResolving(intention: intent)
        intent.categoryName = node.categoryName?.name
        
        mapComments(node, intent)
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
        
        mapComments(node, intent)
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
        
        mapComments(node, intent)
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
    private func enterProtocolDeclarationNode(_ node: ObjcProtocolDeclaration) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent = ProtocolGenerationIntention(typeName: name, source: node)
        
        mapComments(node, intent)
        recordSourceHistory(intention: intent, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addProtocol(intent)
        
        context.pushContext(intent)
    }
    
    private func exitProtocolDeclarationNode(_ node: ObjcProtocolDeclaration) {
        if node.identifier?.name != nil {
            context.popContext() // ProtocolGenerationIntention
        }
    }
    
    // MARK: - Property definition
    private func visitPropertyDefinitionNode(_ node: PropertyDefinition) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }
        
        var knownAttributes: [KnownAttribute] = []
        
        if node.hasIbOutletSpecifier {
            knownAttributes.append(KnownAttribute(name: "IBOutlet"))
        }
        if node.hasIbInspectableSpecifier {
            knownAttributes.append(KnownAttribute(name: "IBInspectable"))
        }
        
        let swiftType: SwiftType = .anyObject
        
        var ownership: Ownership = .strong
        if let type = node.type?.type {
            ownership = evaluateOwnershipPrefix(inType: type, property: node)
        }
        
        let attributes =
            node.attributesList?
                .attributes.map { attr -> ObjcPropertyAttribute in
                    switch attr.attribute {
                    case .getter(let getter):
                        return ObjcPropertyAttribute.getterName(getter)
                    case .setter(let setter):
                        return ObjcPropertyAttribute.setterName(setter)
                    case .keyword(let keyword):
                        return ObjcPropertyAttribute.attribute(keyword)
                    }
                } ?? []
        
        let storage =
            ValueStorage(type: swiftType, ownership: ownership, isConstant: false)
        
        // Protocol property
        if context.findContext(ofType: ProtocolGenerationIntention.self) != nil {
            let prop =
                ProtocolPropertyGenerationIntention(name: node.identifier?.name ?? "",
                                                    storage: storage,
                                                    objcAttributes: attributes,
                                                    source: node)
            prop.isOptional = node.isOptionalProperty
            prop.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
            prop.knownAttributes = knownAttributes
            
            mapComments(node, prop)
            recordSourceHistory(intention: prop, node: node)
            
            ctx.addProperty(prop)
            
            delegate?.reportForLazyResolving(intention: prop)
        } else {
            let prop =
                PropertyGenerationIntention(name: node.identifier?.name ?? "",
                                            storage: storage,
                                            objcAttributes: attributes,
                                            source: node)
            prop.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
            prop.knownAttributes = knownAttributes
            
            mapComments(node, prop)
            recordSourceHistory(intention: prop, node: node)
            
            ctx.addProperty(prop)
            
            delegate?.reportForLazyResolving(intention: prop)
        }
    }
    
    // MARK: - Property Implementation
    private func visitPropertySynthesizeItemNode(_ node: PropertySynthesizeItem) {
        if node.isDynamic { // Dynamic property implementations are not yet supported
            return
        }
        
        guard let ctx = context.findContext(ofType: BaseClassIntention.self) else {
            return
        }
        
        guard let propertyName = node.propertyName else {
            return
        }
        
        let ivarName = node.instanceVarName?.name ?? propertyName.name
        
        let intent =
            PropertySynthesizationIntention(
                propertyName: propertyName.name, ivarName: ivarName, isExplicit: true,
                type: node.isDynamic ? .dynamic : .synthesize)
        
        mapComments(node, intent)
        recordSourceHistory(intention: intent, node: node)
        
        ctx.addSynthesization(intent)
    }
    
    // MARK: - Method Declaration
    private func visitObjcClassMethodNode(_ node: MethodDefinition) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }
        
        guard let mapper = delegate?.typeMapper(for: self) else {
            return
        }
        
        let signGen = ObjectiveCMethodSignatureConverter(
            typeMapper: mapper,
            inNonnullContext: context.inNonnullContext
        )
        let sign = signGen.generateDefinitionSignature(from: node)
        
        if sign == FunctionSignature(name: "dealloc") {
            let deinitIntention = DeinitGenerationIntention(accessLevel: .internal, source: node)
            
            deinitIntention.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
            
            mapComments(node, deinitIntention)
            recordSourceHistory(intention: deinitIntention, node: node)
            
            if let body = node.body {
                let bodyIntention = FunctionBodyIntention(body: [], source: body)
                recordSourceHistory(intention: bodyIntention, node: body)
                
                delegate?.reportForLazyParsing(intention: bodyIntention)
                deinitIntention.functionBody = bodyIntention
            }
            
            if let baseClass = ctx as? BaseClassIntention {
                baseClass.deinitIntention = deinitIntention
            }
        } else {
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
            
            mapComments(node, method)
            recordSourceHistory(intention: method, node: node)
            
            if let body = node.body {
                let bodyIntention = FunctionBodyIntention(body: [], source: body)
                recordSourceHistory(intention: bodyIntention, node: body)
                
                delegate?.reportForLazyParsing(intention: bodyIntention)
                method.functionBody = bodyIntention
            }
            
            ctx.addMethod(method)
            
            delegate?.reportForLazyResolving(intention: method)
        }
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
            isConstant = _isConstant(fromType: type)
        }
        
        let storage = ValueStorage(type: swiftType, ownership: ownership, isConstant: isConstant)
        let ivar =
            InstanceVariableGenerationIntention(name: node.identifier?.name ?? "",
                                                storage: storage,
                                                accessLevel: access,
                                                source: node)
        
        ivar.inNonnullContext = delegate?.isNodeInNonnullContext(node) ?? false
        
        mapComments(node, ivar)
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
        
        mapComments(node, enumIntention)
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
        
        mapComments(node, enumCase)
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
        
        let gen = ObjectiveCMethodSignatureConverter(
            typeMapper: mapper,
            inNonnullContext: context.inNonnullContext,
            instanceTypeAlias: nil
        )
        let signature = gen.generateDefinitionSignature(from: node)
        
        let globalFunc = GlobalFunctionGenerationIntention(signature: signature, source: node)
        
        mapComments(node, globalFunc)
        recordSourceHistory(intention: globalFunc, node: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addGlobalFunction(globalFunc)
        
        context.pushContext(globalFunc)
        
        if let body = node.methodBody {
            let methodBodyIntention = FunctionBodyIntention(body: [], source: body)
            globalFunc.functionBody = methodBodyIntention

            recordSourceHistory(intention: methodBodyIntention, node: body)

            delegate?.reportForLazyParsing(intention: methodBodyIntention)
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
        var declarators: [TypeDeclaratorNode] = []
        var nodeIdentifiers: [Identifier] = []
        if let identifier = node.identifier {
            nodeIdentifiers = [identifier]
        }
        if let parentNode = node.parent as? TypedefNode {
            nodeIdentifiers.append(contentsOf: parentNode.childrenMatching(type: Identifier.self))
            declarators.append(contentsOf: parentNode.childrenMatching(type: TypeDeclaratorNode.self))
        }
        
        guard let identifier = nodeIdentifiers.first ?? declarators.first?.identifier else {
            return
        }
        
        let fileIntent = context.findContext(ofType: FileGenerationIntention.self)
        
        let structIntent = StructGenerationIntention(typeName: identifier.name, source: node)
        
        mapComments(node, structIntent)
        recordSourceHistory(intention: structIntent, node: node)
        
        if let parentNode = node.parent as? TypedefNode {
            mapComments(parentNode, structIntent)
        }
        
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
        
        var shouldRecord = true
        var isOpaqueStruct = false
        
        if let delegate = delegate {
            if node.body == nil {
                isOpaqueStruct  = true
                shouldRecord = false
            }
            
            let typeParser = delegate.typeParser(for: self)
            
            let effectiveDeclarators =
                (nodeIdentifiers.isEmpty ? Array(declarators.dropFirst()) : declarators)
            
            for declarator in effectiveDeclarators {
                guard let identifier = declarator.identifier else {
                    continue
                }
                
                let objcType: ObjcType?
                
                if let pointer = declarator.pointerNode {
                    objcType = typeParser.parseObjcType("\(structIntent.typeName)\(pointer.asString)")
                } else {
                    objcType = .struct(structIntent.typeName)
                }
                
                if var objcType = objcType {
                    if isOpaqueStruct && objcType.isPointer {
                        // TODO: Support pointer-to-opaque pointers
                        objcType = ObjcType.struct("OpaquePointer")
                    }
                    
                    let inNonnull = delegate.isNodeInNonnullContext(declarator)
                    
                    let alias = TypealiasIntention(originalObjcType: objcType,
                                                   fromType: .void,
                                                   named: identifier.name)
                    recordSourceHistory(intention: alias, node: identifier)
                    
                    alias.inNonnullContext = inNonnull
                    
                    fileIntent?.addTypealias(alias)
                    
                    delegate.reportForLazyResolving(intention: alias)
                }
            }
            
            // Analyze if this is an opaque pointer struct reference
            if effectiveDeclarators.isEmpty && nodeIdentifiers.isEmpty {
                if let declarator = declarators.first,
                    declarator.pointerNode != nil,
                    let identifier = declarator.identifier {
                    
                    shouldRecord = false
                    
                    let inNonnull = delegate.isNodeInNonnullContext(declarator)
                    
                    let alias = TypealiasIntention(originalObjcType: .struct("OpaquePointer"),
                                                   fromType: .void,
                                                   named: identifier.name)
                    recordSourceHistory(intention: alias, node: identifier)
                    alias.inNonnullContext = inNonnull
                    
                    fileIntent?.addTypealias(alias)
                    
                    delegate.reportForLazyResolving(intention: alias)
                }
            }
        } else {
            shouldRecord = false
        }
        
        if shouldRecord {
            fileIntent?.addType(structIntent)
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
        
        mapComments(node, ivar)
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

extension ObjectiveCIntentionCollector {
    private func recordSourceHistory(intention: FromSourceIntention, node: ObjcASTNode) {
        intention.history.recordSourceHistory(node: node)
    }
}

extension ObjectiveCIntentionCollector {
    private func mapComments(_ node: ObjcASTNode, _ intention: FromSourceIntention) {
        intention.precedingComments.append(contentsOf: convertComments(node.precedingComments))
    }
    
    private func convertComments(_ comments: [CodeComment]) -> [String] {
        return comments.map { $0.string.trimmingWhitespaces() }
    }
}
