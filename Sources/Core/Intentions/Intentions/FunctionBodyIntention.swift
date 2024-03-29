import GrammarModelBase
import SwiftAST
import KnownType

/// An intention to generate a body of Swift code.
public class FunctionBodyIntention: FromSourceIntention, KnownMethodBody {
    /// Original source code body to generate
    public var body: CompoundStatement
    
    public init(body: CompoundStatement, source: ASTNode? = nil) {
        self.body = body
        
        super.init(accessLevel: .public, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.body = try container.decodeStatement(forKey: .body)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeStatement(body, forKey: .body)
        
        try super.encode(to: container.superEncoder())
    }

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitFunctionBody(self)
    }
    
    private enum CodingKeys: String, CodingKey {
        case body
    }
}
