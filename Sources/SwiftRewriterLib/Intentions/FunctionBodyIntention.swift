import GrammarModels
import SwiftAST

/// An intention to generate a body of Swift code from an equivalent Objective-C
/// source.
public class FunctionBodyIntention: FromSourceIntention, KnownMethodBody {
    public var typedSource: MethodBody? {
        return source as? MethodBody
    }
    
    /// Original source code body to generate
    public var body: CompoundStatement
    
    public init(body: CompoundStatement, source: ASTNode? = nil) {
        self.body = body
        
        super.init(accessLevel: .public, source: source)
    }
}
