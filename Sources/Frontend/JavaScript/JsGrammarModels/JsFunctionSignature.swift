public struct JsFunctionSignature: Equatable {
    public var arguments: [JsFunctionArgument]

    public init(arguments: [JsFunctionArgument]) {
        self.arguments = arguments
    }
}

// TODO: Support default argument values.

/// Argument for a JavaScript function signature.
public struct JsFunctionArgument: Equatable {
    public var identifier: String
    public var isVariadic: Bool

    public init(identifier: String, isVariadic: Bool) {
        self.identifier = identifier
        self.isVariadic = isVariadic
    }
}
