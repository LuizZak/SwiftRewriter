import SwiftAST
import KnownType

/// Resolves function call queries onto types that may potentially implement
/// `func callAsFunction()`.
class CallableTypeResolver {
    private let typeSystem: TypeSystem
    private let type: KnownType

    init(typeSystem: TypeSystem, type: KnownType) {
        self.typeSystem = typeSystem
        self.type = type
    }

    /// Attempts to resolve a call to the underlying type with a given set of
    /// parameters.
    func resolveCall(_ parameters: [FunctionArgument]) -> [Result] {
        let identifier = FunctionIdentifier(
            name: "callAsFunction",
            arguments: parameters
        )
        let typeHints = parameters.map(\.expression.resolvedType)

        // Attempt type system query first
        if let method = typeSystem.method(
            withIdentifier: identifier,
            invocationTypeHints: typeHints,
            static: false,
            includeOptional: false,
            in: type
        ) {
            return [
                .init(
                    method: method,
                    isMutating: method.signature.isMutating,
                    isThrowing: method.signature.isThrowing,
                    resolvedType: method.signature.returnType
                )
            ]
        }

        // TODO: Implement manual inspection of known methods in the underlying type

        return []
    }

    /// A potential `callAsFunction` query result representing one of the available
    /// overloads of the method for the underlying type.
    struct Result {
        /// The actual method that is being invoked.
        var method: KnownMethod

        /// Whether this invocation result is a mutating call.
        var isMutating: Bool

        /// Whether this invocation result is throwable.
        var isThrowing: Bool

        /// The resolved type for the specific invocation of the method.
        var resolvedType: SwiftType
    }
}
