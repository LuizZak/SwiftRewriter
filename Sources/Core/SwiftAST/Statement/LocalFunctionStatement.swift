public class LocalFunctionStatement: Statement, StatementKindType {
    public var statementKind: StatementKind {
        .localFunction(self)
    }

    /// Gets or sets the function for this local function statement.
    public var function: LocalFunction {
        didSet {
            oldValue.body.parent = nil
            function.body.parent = self
        }
    }
    
    public override var children: [SyntaxNode] {
        [function.body]
    }
    
    public init(function: LocalFunction) {
        self.function = function
        
        super.init()
        
        function.body.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        function = try container.decode(LocalFunction.self, forKey: .function)
        
        try super.init(from: container.superDecoder())
        
        function.body.parent = self
    }
    
    @inlinable
    public override func copy() -> LocalFunctionStatement {
        LocalFunctionStatement(function: function).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitLocalFunction(self)
    }
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitLocalFunction(self, state: state)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as LocalFunctionStatement:
            return function.signature == rhs.function.signature && function.body.isEqual(to: rhs.function.body)
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(function, forKey: .function)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case function
    }
}
public extension Statement {
    /// Returns `self as? LocalFunctionStatement`.
    @inlinable
    var asLocalFunction: LocalFunctionStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `LocalFunctionStatement`
    /// class.
    @inlinable
    var isLocalFunction: Bool {
        asLocalFunction != nil
    }

    /// Creates a `LocalFunctionStatement` instance using the local function
    /// definition.
    static func localFunction(
        _ localFunction: LocalFunction
    ) -> LocalFunctionStatement {
        LocalFunctionStatement(function: localFunction)
    }

    /// Creates a `LocalFunctionStatement` instance by using a set of parameters
    /// for its local function definition.
    static func localFunction(
        identifier: String,
        parameters: [ParameterSignature],
        returnType: SwiftType,
        body: CompoundStatement
    ) -> LocalFunctionStatement {

        LocalFunctionStatement(function: 
            .init(
                identifier: identifier,
                parameters: parameters,
                returnType: returnType,
                body: body
            )
        )
    }

    /// Creates a `LocalFunctionStatement` instance by using a signature and
    /// function body.
    static func localFunction(
        signature: FunctionSignature,
        body: CompoundStatement
    ) -> LocalFunctionStatement {
        
        LocalFunctionStatement(function: LocalFunction(signature: signature, body: body))
    }
}
