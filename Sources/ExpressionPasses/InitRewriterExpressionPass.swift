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
/// within the if check to before the `super.init` call; however, this can lead
/// to invalid code in some scenarios.
public class InitRewriterExpressionPass: ASTRewriterPass {
    private var ownerType: KnownTypeReference?
    
    public override func apply(on statement: Statement, context: ASTRewriterPassContext) -> Statement {
        ownerType = nil
        
        // Can only apply to initializers
        switch context.source {
        case .initializer(let initializer)?:
            self.context = context
            
            if let compound = statement.asCompound {
                compound.statements = analyzeStatementBody(compound)
            }
            
            // Next step is recursive failable super.init analysis- if we lack the
            // context needed to figure out the superclass, quit now
            if initializer.ownerType != nil {
                ownerType = initializer.ownerType
                return super.apply(on: statement, context: context)
            }
            
            return statement
        default:
            return statement
        }
    }
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let newExp = validateFailableSuperInit(exp) {
            notifyChange()
            return newExp
        }
        
        return exp
    }
    
    private func analyzeStatementBody(_ compoundStatement: CompoundStatement) -> [Statement] {
        if let statements = analyzeTraditionalIfSelfInit(compoundStatement) {
            notifyChange()
            
            return statements
        }
        if let statements = analyzeEarlyExitIfStatement(compoundStatement) {
            notifyChange()
            
            return statements
        }
        
        return compoundStatement.statements
    }
    
    private func analyzeTraditionalIfSelfInit(_ compoundStatement: CompoundStatement) -> [Statement]? {
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
            ifSelf.body.copy().statements + [
                .expression(superInitExp.copy())
            ]
        
        return result
    }
    
    private func analyzeEarlyExitIfStatement(_ compoundStatement: CompoundStatement) -> [Statement]? {
        // Detect an early-exit pattern
        //
        // if(!(self = [super init]))) {
        //   return nil;
        // }
        //
        // // Initializer code...
        //
        // return self;
        //
        
        guard let ifSelfInit = compoundStatement.statements.first?.asIf else {
            return nil
        }
        
        // if(!(self = [super init]))
        guard ifSelfInit.body == [.return(.constant(.nil))] else {
            return nil
        }
        guard let superInit = superOrSelfInitExpressionFrom(exp: ifSelfInit.exp) else {
            return nil
        }
        guard superInit.matches(ValueMatcher<Expression>.nilCheck(against: superInit)) else {
            return nil
        }
        
        // return self;
        guard compoundStatement.statements.last == .return(.identifier("self")) else {
            return nil
        }
        
        // Initializer code
        let initializerCode = compoundStatement.dropFirst().dropLast()
        
        let result: [Statement] =
            Array(initializerCode) + [
                .expression(superInit.copy())
            ]
        
        return result
    }
    
    private func superInitExpressionFrom(exp: ExpressionsStatement) -> Expression? {
        
        let matcher =
            ValueMatcher<ExpressionsStatement>()
                .keyPath(\.expressions, hasCount(1))
        
        if matcher.matches(exp), let superInit = superOrSelfInitExpressionFrom(exp: exp.expressions[0]) {
            return superInit
        }
        
        return nil
    }
    
    /// In case a given `super.init` invocation is a failable initializer invocation,
    /// return a transformed, failable init invocation (`super.init?()`) matching
    /// the original invocation.
    private func validateFailableSuperInit(_ exp: Expression) -> Expression? {
        guard let ownerType = ownerType else {
            return nil
        }
        
        var _functionCall: FunctionCallPostfix?
        
        let invertedMatchSuperInit =
            ValueMatcher<PostfixExpression>()
                .inverted { inverted in
                    inverted
                        .hasCount(3)
                        .atIndex(0, equals: .root(.identifier("super")))
                        .atIndex(1, matcher: .keyPath(\.postfix?.asMember?.name, equals: "init"))
                        .atIndex(2, rule: .closure {
                            _functionCall = $0.postfix?.asFunctionCall
                            return $0.postfix is FunctionCallPostfix
                        })
                }.anyExpression()
        
        guard exp.matches(invertedMatchSuperInit), let functionCall = _functionCall else {
            return nil
        }
        
        // Try to find the containing type now
        
        let _constructor =
            context
                .typeSystem
                .constructor(withArgumentLabels: functionCall.argumentKeywords,
                             in: .typeName(ownerType.asTypeName))
        
        guard let constructor = _constructor else {
            return nil
        }
        
        if constructor.isFailable {
            let newExp =
                Expression
                    .identifier("super")
                    .dot("init")
                    .optional()
                    .call(functionCall.arguments.map { $0.copy() },
                          type: functionCall.returnType,
                          callableSignature: functionCall.callableSignature)
            
            return newExp
        }
        
        return nil
    }
    
    private func superOrSelfInitExpressionFrom(exp: Expression) -> Expression? {
        
        var superInit: Expression?
        
        let invertedMatchSuperInit =
            ValueMatcher<PostfixExpression>()
                .inverted { inverted in
                    inverted
                        .hasCount(3)
                        .atIndex(0, rule: .equals(.root(.identifier("super"))) || equals(.root(.identifier("self"))))
                        .atIndex(1, matcher: .keyPath(\.postfix?.asMember?.name, equals: "init"))
                        .atIndex(2, matcher: .isFunctionCall)
                }.anyExpression()
        
        let selfInit =
            Expression.matcher(
                .findAny(thatMatches:
                    ident("self")
                        .assignment(
                            op: .assign,
                            rhs: invertedMatchSuperInit ->> &superInit
                        )
                    .anyExpression()
                )
            )
        
        if selfInit.anyExpression().matches(exp) {
            return superInit
        }
        
        return nil
    }
    
    private static func isNullCheckingSelf(_ exp: Expression) -> Bool {
        let matchSelfEqualsNil =
            Expression.matcher(.nilCheck(against: .identifier("self")))
        
        return matchSelfEqualsNil.matches(exp)
    }
    
}
