import SwiftAST
import Intentions

/// Analyzes all function definitions and changes functions that do not return
/// a value to a Void return type.
public class DetectNoReturnsIntentionPass: FunctionIntentionVisitor {
    private let tag = "\(DetectNoReturnsIntentionPass.self)"

    public override init() {

    }

    override func apply(on element: FunctionCarryingElement) {
        guard var signature = element.signature else {
            return
        }

        switch element {
        case .function(let function):
            guard let body = function.functionBody else {
                break
            }

            if !hasReturnStatement(body.body) {
                signature.returnType = .void

                element.changeSignature(signature)
            }

        case .localFunction(let function):
            if !hasReturnStatement(function.function.body) {
                signature.returnType = .void

                element.changeSignature(signature)
            }

        // No signature to change
        case .initializer, .deinitializer, .bareFunctionBody:
            break
        }
    }

    private func hasReturnStatement(_ body: CompoundStatement) -> Bool {
        let visitor = ReturnStatementVisitor()

        return body.accept(visitor).count > 0
    }
}
