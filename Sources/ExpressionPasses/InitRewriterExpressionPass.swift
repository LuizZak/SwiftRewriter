import Foundation
import SwiftRewriterLib
import SwiftAST

/// Attempts to convert some common init patterns from Objective-C to Swift
///
/// e.g.:
///
/// ```objective-c
/// - (instancetype)initWithFrame:(CGRect)frame {
///     self = [super initWithFrame:frame];
///     if(self) {
///         self.property = @"abc";
///     }
///     return self;
/// }
/// ```
///
/// will be converted to Swift as:
///
/// ```swift
/// init(frame: CGRect) {
///     self.property = "abc"
///     super.init(frame: frame)
/// }
/// ```
///
/// Conversion is conservative in that it always moves the initialization code
/// within the if check to before the `super.init` call; this could be wrong in
/// some scenarios, however.
public class InitRewriterExpressionPass: ASTRewriterPass {
    
    public override func apply(on statement: Statement, context: ASTRewriterPassContext) -> Statement {
        
        // Can only apply to initializers
        switch context.source {
        case .initializer?:
            self.context = context
            
            if let compound = statement.asCompound {
                compound.statements = analyzeStatementBody(compound)
            }
            
            return statement
        default:
            return statement
        }
        
    }
    
    private func analyzeStatementBody(_ compoundStatement: CompoundStatement) -> [Statement] {
        if let statements = analyzeTraditionalIfSelfInit(compoundStatement) {
            return statements
        }
        
        return compoundStatement.statements
    }
    
    func analyzeTraditionalIfSelfInit(_ compoundStatement: CompoundStatement) -> [Statement]? {
        // Detect more common
        //
        // self = [super init];
        // if(self) {
        //   // initializer code...
        // }
        // return self;
        //
        // pattern
        if compoundStatement.statements.count != 3 {
            return nil
        }
        
        let _superInit = compoundStatement.statements[0].asExpressions
        let _ifSelf = compoundStatement.statements[1].asIf
        let _returnSelf = compoundStatement.statements[2].asReturn
        
        guard let superInit = _superInit, let ifSelf = _ifSelf, let returnSelf = _returnSelf else {
            return nil
        }
        
        // Do a quick validation of the pattern we're seeing
        guard let superInitExp = superInitExpressionFrom(exp: superInit) else {
            return nil
        }
        guard InitRewriterExpressionPass.isNullCheckingSelf(ifSelf.exp) else {
            return nil
        }
        guard returnSelf.exp?.asIdentifier?.identifier == "self" else {
            return nil
        }
        
        // Create a new init body, now
        let result: [Statement] =
            ifSelf.body.statements + [
                .expression(superInitExp)
            ]
        
        notifyChange()
        
        return result
    }
    
    func superInitExpressionFrom(exp: ExpressionsStatement) -> Expression? {
        
        var superInit: Expression?
        
        let selfInit =
            Expression.matcher(
                ident("self")
                    .assignment(op: .assign, rhs: .any ->> &superInit))
        
        let matcher =
            Statement.matcher(
                ValueMatcher<ExpressionsStatement>()
                    .keyPath(\.expressions, hasCount(1))
                    .keyPath(\.expressions[0], selfInit.anyExpression()))
        
        if matcher.matches(exp), let superInit = superInit {
            return superInit
        }
        
        return nil
    }
    
    static func isNullCheckingSelf(_ exp: Expression) -> Bool {
        if exp.asIdentifier?.identifier == "self" {
            return true
        }
        
        let matchSelfEqualsNil =
            Expression.matcher(
                ident("self")
                    .binary(op: .equals, rhs: .nil)
                    .anyExpression())
        
        return matchSelfEqualsNil.matches(exp)
    }
    
}
