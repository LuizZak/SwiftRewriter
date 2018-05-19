import GrammarModels
import SwiftAST

/// An intention to generate the initial value for a global variable.
public class GlobalVariableInitialValueIntention: FromSourceIntention {
    public var typedSource: InitialExpression? {
        return source as? InitialExpression
    }
    
    public var expression: Expression
    
    public init(expression: Expression, source: ASTNode?) {
        self.expression = expression
        
        super.init(accessLevel: .public, source: source)
    }
}
