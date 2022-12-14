import Intentions
import SwiftAST

/// Base class for intention passes that alter function body and function
/// definitions.
public class FunctionIntentionVisitor: IntentionPass {
    internal var context: IntentionPassContext!
    
    func notifyChange() {
        context.notifyChange()
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        self.context = context
        
        for file in intentionCollection.fileIntentions() {
            applyOnFile(file)
        }
    }

    func apply(on element: FunctionCarryingElement) {

    }

    // MARK: - Traversal
    
    private func applyOnFile(_ file: FileGenerationIntention) {
        for intention in file.globalFunctionIntentions {
            applyOnGlobalFunction(intention)
        }

        for intention in file.globalVariableIntentions {
            applyOnGlobalVariable(intention)
        }

        for intention in file.typeIntentions {
            applyOnType(intention)
        }
    }
    
    private func applyOnType(_ intention: TypeGenerationIntention) {
        if let cls = intention as? BaseClassIntention {
            for ivar in cls.instanceVariables {
                applyOnInstanceVar(ivar)
            }
        }
        
        for property in intention.properties {
            applyOnProperty(property)
        }
        
        for method in intention.methods {
            applyOnMethod(method)
        }
        
        for sub in intention.subscripts {
            applyOnSubscript(sub)
        }
        
        if let deinitIntent = (intention as? BaseClassIntention)?.deinitIntention {
            applyOnDeinit(deinitIntent)
        }
    }

    private func applyOnGlobalVariable(_ intention: GlobalVariableGenerationIntention) {
        if let initializer = intention.initialValueIntention {
            initializer.expression = visitExpression(initializer.expression)
        }
    }

    private func applyOnGlobalFunction(_ intention: GlobalFunctionGenerationIntention) {
        applyOnIntention(intention)
    }
    
    private func applyOnDeinit(_ intention: DeinitGenerationIntention) {
        applyOnFunctionBody(intention.functionBody)
        apply(on: .deinitializer(intention))
    }
    
    private func applyOnInstanceVar(_ intention: InstanceVariableGenerationIntention) {
        
    }
    
    private func applyOnMethod(_ intention: MethodGenerationIntention) {
        applyOnIntention(intention)
    }
    
    private func applyOnProperty(_ intention: PropertyGenerationIntention) {
        switch intention.mode {
        case .asField:
            break

        case .computed(let intention):
            applyOnFunctionBody(intention)
            apply(on: .bareFunctionBody(intention))
        
        case .property(let getter, let setter):
            applyOnFunctionBody(getter)
            apply(on: .bareFunctionBody(getter))
            applyOnFunctionBody(setter.body)
            apply(on: .bareFunctionBody(setter.body))
        }

        if let initializer = intention.initialValueIntention {
            initializer.expression = visitExpression(initializer.expression)
        }
    }
    
    private func applyOnSubscript(_ intention: SubscriptGenerationIntention) {
        switch intention.mode {
        case .getter(let intention):
            applyOnFunctionBody(intention)
            apply(on: .bareFunctionBody(intention))
        
        case .getterAndSetter(let getter, let setter):
            applyOnFunctionBody(getter)
            apply(on: .bareFunctionBody(getter))

            applyOnFunctionBody(setter.body)
            apply(on: .bareFunctionBody(setter.body))
        }
    }

    private func applyOnIntention(_ intention: MutableSignatureFunctionIntention) {
        applyOnFunctionBody(intention.functionBody)

        apply(on: .function(intention))
    }

    private func applyOnFunctionBody(_ intention: FunctionBodyIntention?) {
        guard let intention = intention else {
            return
        }

        let result = visitStatement(intention.body)
        if let body = result.asCompound {
            intention.body = body
        } else {
            intention.body = .compound([result])
        }
    }

    private func applyOnStatement(_ statement: LocalFunctionStatement) -> LocalFunctionStatement {
        let visitor = makeVisitor()
        _ = visitor.visitStatement(statement)

        apply(on: .localFunction(statement))

        return statement
    }

    private func visitExpression(_ expression: Expression) -> Expression {
        makeVisitor().visitExpression(expression)
    }

    private func visitStatement(_ statement: Statement) -> Statement {
        makeVisitor().visitStatement(statement)
    }

    private func makeVisitor() -> FunctionStatementVisitor {
        FunctionStatementVisitor { stmt in
            self.apply(on: FunctionCarryingElement.localFunction(stmt))

            return stmt
        }
    }
}

private class FunctionStatementVisitor: SyntaxNodeRewriter {
    var visitor: (LocalFunctionStatement) -> LocalFunctionStatement

    init(visitor: @escaping (LocalFunctionStatement) -> LocalFunctionStatement) {
        self.visitor = visitor
    }

    override func visitLocalFunction(_ stmt: LocalFunctionStatement) -> Statement {
        return super.visitLocalFunction(visitor(stmt))
    }
}

enum FunctionCarryingElement {
    case function(MutableSignatureFunctionIntention)
    case initializer(InitGenerationIntention)
    case deinitializer(DeinitGenerationIntention)
    case bareFunctionBody(FunctionBodyIntention)
    case localFunction(LocalFunctionStatement)

    var signature: FunctionSignature? {
        get {
            switch self {
            case .function(let intention):
                return intention.signature

            case .localFunction(let stmt):
                return stmt.function.signature
            
            case .initializer(let intention):
                return intention.signature
            
            case .deinitializer, .bareFunctionBody:
                return nil
            }
        }
    }

    var body: CompoundStatement? {
        get {
            switch self {
            case .function(let intention):
                return intention.functionBody?.body

            case .localFunction(let stmt):
                return stmt.function.body
            
            case .initializer(let intention):
                return intention.functionBody?.body
            
            case .deinitializer(let intention):
                return intention.functionBody?.body
            
            case .bareFunctionBody(let intention):
                return intention.body
            }
        }
    }

    @discardableResult
    func changeSignature(_ signature: FunctionSignature) -> FunctionCarryingElement {
        switch self {
        case .function(let intention):
            intention.signature = signature

        case .localFunction(let stmt):
            stmt.function.signature = signature
        
        case .initializer(let intention):
            intention.parameters = signature.parameters
        
        case .deinitializer, .bareFunctionBody:
            // TODO: Warn on attempts to change signature on deinitializers or
            // TODO: bare function bodies.
            break
        }

        return self
    }

    @discardableResult
    func changeBody(_ body: CompoundStatement) -> FunctionCarryingElement {
        switch self {
        case .function(let intention):
            intention.functionBody?.body = body

        case .localFunction(let stmt):
            stmt.function.body = body

        case .initializer(let intention):
            intention.functionBody?.body = body
        
        case .deinitializer(let intention):
            intention.functionBody?.body = body
        
        case .bareFunctionBody(let intention):
            intention.body = body
        }

        return self
    }
}
