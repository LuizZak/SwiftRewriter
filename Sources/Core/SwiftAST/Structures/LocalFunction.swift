/// Provides context for a local function in a function's body.
public struct LocalFunction: Codable {
    /// The signature of this local function.
    public var signature: FunctionSignature {
        get {
            .init(
                name: identifier,
                parameters: parameters,
                returnType: returnType,
                isStatic: false,
                isMutating: false
            )
        }
        set {
            identifier = newValue.name
            parameters = newValue.parameters
            returnType = newValue.returnType
        }
    }

    /// This function's identifier name.
    public var identifier: String

    /// Information for the parameters of this local function.
    public var parameters: [ParameterSignature]
    
    /// Return type for this local function.
    public var returnType: SwiftType

    /// This local function's body.
    public var body: CompoundStatement

    public init(
        identifier: String,
        parameters: [ParameterSignature],
        returnType: SwiftType,
        body: CompoundStatement
    ) {
        
        self.identifier = identifier
        self.parameters = parameters
        self.returnType = returnType
        self.body = body
    }

    public init(signature: FunctionSignature, body: CompoundStatement) {
        self.identifier = signature.name
        self.parameters = signature.parameters
        self.returnType = signature.returnType
        self.body = body
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        parameters = try container.decode([ParameterSignature].self, forKey: .parameters)
        returnType = try container.decode(SwiftType.self, forKey: .returnType)
        body = try container.decodeStatement(CompoundStatement.self, forKey: .body)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(parameters, forKey: .parameters)
        try container.encode(returnType, forKey: .returnType)
        try container.encodeStatement(body, forKey: .body)
    }
    
    private enum CodingKeys: String, CodingKey {
        case identifier
        case parameters
        case returnType
        case body
    }
}
