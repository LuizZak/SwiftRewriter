import SwiftAST

/// Delegate for controlling some aspects of SwiftSyntax AST generation
public protocol SwiftSyntaxProducerDelegate: class {
    func swiftSyntaxProducer(_ producer: SwiftSyntaxProducer,
                             shouldEmitTypeFor storage: ValueStorage,
                             initialValue: Expression?) -> Bool
}
