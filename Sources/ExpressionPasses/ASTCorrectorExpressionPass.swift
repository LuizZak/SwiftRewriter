import SwiftRewriterLib
import SwiftAST

public class ASTCorrectorExpressionPass: ASTRewriterPass {
    private func varNameForExpression(_ exp: Expression) -> String? {
        if let identifier = exp.asIdentifier {
            return identifier.identifier
        }
        if let member = exp.asPostfix?.member {
            return member.name
        }
        
        return nil
    }
    
    public override func visitBaseExpression(_ exp: Expression) -> Expression {
        let exp = super.visitBaseExpression(exp)
        
        if !(exp.parent is ExpressionsStatement), let type = exp.resolvedType,
            type.isOptional && typeSystem.isScalarType(type.deepUnwrapped) {
            
            // If an expected type is present, sub-expression visitors will handle
            // this expression for us.
            guard exp.expectedType == nil else {
                return exp
            }
            
            exp.expectedType = exp.resolvedType?.deepUnwrapped
            
            if let newExp = correctToDefaultValue(exp) {
                notifyChange()
                
                return super.visitExpression(newExp)
            } else {
                exp.expectedType = nil
            }
        }
        
        return exp
    }
    
    public override func visitExpressions(_ stmt: ExpressionsStatement) -> Statement {
        // TODO: Deal with multiple expressions on a single line, maybe.
        
        var pf: PostfixExpression?
        var functionCall = FunctionCallPostfix(arguments: [])
        let matcher =
            ExpressionsStatement.matcher()
                .keyPath(\.expressions, hasCount(1))
                .keyPath(\.expressions[0].asPostfix) { postfix in
                    postfix
                        .bind(to: &pf)
                        .keyPath(\.functionCall, !isNil() ->> &functionCall)
                        .keyPath(\.functionCall?.arguments, hasCount(1))
                }
        
        guard matcher.matches(stmt), let postfix = pf else {
            return super.visitExpressions(stmt)
        }
        
        // Apply potential if-let patterns to simple 1-parameter function calls
        guard case .block(_, let args)? = functionCall.callableSignature else {
            return super.visitExpressions(stmt)
        }
        
        let argument = functionCall.arguments[0].expression
        
        // Check the receiving argument is non-optional, but the argument's type
        // in the expression is an optional (but not an implicitly unwrapped, since
        // Swift takes care of unwrapping that automatically)
        guard let resolvedType = argument.resolvedType, !args[0].isOptional
            && resolvedType.isOptional == true
            && argument.resolvedType?.isImplicitlyUnwrapped == false else {
            return super.visitExpressions(stmt)
        }
        
        // Scalars are dealt directly in another portion of the AST corrector.
        guard !context.typeSystem.isScalarType(resolvedType.deepUnwrapped) else {
            return super.visitExpressions(stmt)
        }
        
        guard let name = varNameForExpression(argument) else {
            return super.visitExpressions(stmt)
        }
        
        // if let <name> = <arg0> {
        //   func(<name>)
        // }
        let newOp = functionCall.replacingArguments([.identifier(name)])
        let newPostfix = postfix.copy()
        newPostfix.op = newOp
        
        let stmt =
            Statement.ifLet(
                .identifier(name), argument.copy(),
                body: [
                    .expression(newPostfix)
                ],
                else: nil)
        
        notifyChange()
        
        return super.visitStatement(stmt)
    }
    
    public override func visitExpression(_ exp: Expression) -> Expression {
        guard let expectedType = exp.expectedType, expectedType != exp.resolvedType else {
            return super.visitExpression(exp)
        }
        
        let exp = super.visitExpression(exp)
        
        // Don't correct top-level expressions
        if exp.parent is ExpressionsStatement {
            return exp
        }
        
        if context.typeSystem.isNumeric(expectedType) {
            if let corrected = correctToNumeric(exp) {
                notifyChange()
                
                return super.visitExpression(corrected)
            }
        } else if expectedType == .bool {
            // Parenthesize depending on parent expression type to avoid issues
            // with operator precedence
            let shouldParenthesize = exp.parent is UnaryExpression || exp.parent is BinaryExpression
            
            if var corrected = correctToBoolean(exp) {
                notifyChange()
                
                corrected.expectedType = nil
                corrected.resolvedType = .bool
                
                if shouldParenthesize {
                    corrected = .parens(corrected)
                    corrected.resolvedType = .bool
                }
                
                return super.visitExpression(corrected)
            }
        } else if let corrected = correctToDefaultValue(exp) {
            notifyChange()
            
            return super.visitExpression(corrected)
        }
        
        return super.visitExpression(exp)
    }
    
    public override func visitIf(_ stmt: IfStatement) -> Statement {
        return super.visitIf(stmt)
    }
    
    public override func visitWhile(_ stmt: WhileStatement) -> Statement {
        return super.visitWhile(stmt)
    }
    
    public override func visitUnary(_ exp: UnaryExpression) -> Expression {
        switch exp.op.category {
        case .logical:
            exp.exp = super.visitExpression(exp.exp)
            
            if let exp = correctToBoolean(exp) {
                notifyChange()
                
                return .parens(exp) // Parenthesize, just to be sure
            }
            
            return exp
        case .arithmetic:
            exp.exp = super.visitExpression(exp.exp)
            
            if let newExp = correctToNumeric(exp.exp) {
                notifyChange()
                
                return .unary(op: exp.op, newExp)
            }
            
            return exp
        default:
            return super.visitUnary(exp)
        }
    }
    
    public override func visitBinary(_ exp: BinaryExpression) -> Expression {
        switch exp.op.category {
        case .comparison where exp.op != .equals && exp.op != .unequals,
             .arithmetic, .bitwise:
            // Mark left hand side and right hand side of comparison expressions
            // to expect non-optional of numeric values, in case they are numeric
            // themselves.
            if let lhsType = exp.lhs.resolvedType?.unwrapped, context.typeSystem.isNumeric(lhsType) {
                exp.lhs.expectedType = lhsType
            }
            if let rhsType = exp.rhs.resolvedType?.unwrapped, context.typeSystem.isNumeric(rhsType) {
                exp.rhs.expectedType = rhsType
            }
        default:
            break
        }
        
        return super.visitBinary(exp)
    }
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        
        // Get <value>.<member>(<call>) postfix values
        if exp.op.asFunctionCall != nil, let memberPostfix = exp.exp.asPostfix,
            let memberType = memberPostfix.exp.resolvedType {
            
            let member = memberPostfix.exp
            
            guard memberType.isOptional && !memberType.isImplicitlyUnwrapped
                && context.typeSystem.isScalarType(memberType.deepUnwrapped) else {
                return super.visitPostfix(exp)
            }
            
            guard let initValue = context.typeSystem.defaultValue(for: memberType.deepUnwrapped) else {
                return super.visitPostfix(exp)
            }
            
            var res: Expression = Expression.parens(member.copy().typed(expected: nil).binary(op: .nullCoalesce, rhs: initValue))
            res.resolvedType = memberType.deepUnwrapped
            
            res = Expression.postfix(res, memberPostfix.op.copy())
            
            res.resolvedType = memberPostfix.resolvedType
            
            res.asPostfix?.op.returnType = res.asPostfix?.op.returnType?.unwrapped
            
            res = Expression.postfix(res, exp.op.copy())
            
            res.resolvedType = exp.resolvedType?.unwrapped
            res.asPostfix?.exp.resolvedType = res.asPostfix?.exp.resolvedType?.unwrapped
            res.asPostfix?.exp.asPostfix?.exp.expectedType = nil
            
            notifyChange()
            
            return super.visitExpression(res)
        }
        
        return super.visitPostfix(exp)
    }
    
    func correctToDefaultValue(_ exp: Expression) -> Expression? {
        guard let expectedType = exp.expectedType else {
            return nil
        }
        guard expectedType == exp.resolvedType?.deepUnwrapped else {
            return nil
        }
        guard exp.resolvedType?.isImplicitlyUnwrapped == false else {
            return nil
        }
        guard let defValue = context.typeSystem.defaultValue(for: expectedType) else {
            return nil
        }
        guard defValue.resolvedType?.isOptional == false else {
            return nil
        }
        
        let newExp = exp.copy()
        
        newExp.expectedType = nil
        
        let converted: Expression
        
        if newExp.requiresParens {
            converted = Expression.parens(newExp).binary(op: .nullCoalesce, rhs: defValue)
        } else {
            converted = newExp.binary(op: .nullCoalesce, rhs: defValue)
        }
        
        converted.resolvedType = defValue.resolvedType
        converted.expectedType = converted.resolvedType
        
        return .parens(converted)
    }
    
    func correctToNumeric(_ exp: Expression) -> Expression? {
        guard let type = exp.resolvedType else {
            return nil
        }
        
        if type.isOptional && context.typeSystem.isNumeric(type.deepUnwrapped) {
            guard let defaultExp = context.typeSystem.defaultValue(for: type.deepUnwrapped) else {
                return nil
            }
            
            let expCopy = exp.copy()
            
            let newExp: Expression
            
            if expCopy.requiresParens {
                newExp = Expression.parens(expCopy).binary(op: .nullCoalesce, rhs: defaultExp)
            } else {
                newExp = .parens(expCopy.binary(op: .nullCoalesce, rhs: defaultExp))
            }
            
            newExp.expectedType = expCopy.expectedType
            newExp.resolvedType = type.deepUnwrapped
            
            expCopy.expectedType = nil
            
            return newExp
        }
        
        return nil
    }
    
    func correctToBoolean(_ exp: Expression) -> Expression? {
        func innerHandle(_ exp: Expression, negated: Bool) -> Expression? {
            guard let type = exp.resolvedType else {
                return nil
            }
            
            let newExp = exp.copy()
            
            // <Numeric>
            if context.typeSystem.isNumeric(type.deepUnwrapped) {
                newExp.expectedType = nil
                
                let outer = newExp.binary(op: negated ? .equals : .unequals, rhs: .constant(0))
                outer.resolvedType = .bool
                
                return outer
            }
            
            switch type {
            // <Bool?> -> <Bool?> == true
            // !<Bool?> -> <Bool?> != true (negated)
            case .optional(.bool):
                newExp.expectedType = nil
                
                let outer = newExp.binary(op: negated ? .unequals : .equals, rhs: .constant(true))
                outer.resolvedType = .bool
                
                return outer
                
            // <nullable> -> <nullable> != nil
            // <nullable> -> <nullable> == nil (negated)
            case .optional:
                newExp.expectedType = nil
                
                let outer = newExp.binary(op: negated ? .equals : .unequals, rhs: .constant(.nil))
                outer.resolvedType = .bool
                
                return outer
                
            default:
                return nil
            }
        }
        
        if exp.resolvedType == .bool {
            return nil
        }
        
        if let unary = exp.asUnary, unary.op == .negate {
            return innerHandle(unary.exp, negated: true)
        } else {
            return innerHandle(exp, negated: false)
        }
    }
}
