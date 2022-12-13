import SwiftAST
import ExpressionPasses

public class ObjectiveCASTCorrectorExpressionPass: ASTRewriterPass {
    public override func visitCompound(_ stmt: CompoundStatement) -> Statement {
        if let stmt = suggestSplit(stmt) {
            notifyChange()

            return visitStatement(stmt)
        }

        return super.visitCompound(stmt)
    }

    public override func visitExpressions(_ stmt: ExpressionsStatement) -> Statement {
        // Attempt to apply if-let pattern to expressions
        if let ifLetStmt = suggestIfLetPattern(stmt) {
            notifyChange()
            
            return visitStatement(ifLetStmt)
        }

        // Check if any expression needs to be broken down
        if let split = suggestSplit(stmt) {
            notifyChange()

            return visitStatement(split)
        }

        return super.visitExpressions(stmt)
    }
    
    public override func visitBaseExpression(_ exp: Expression) -> Expression {
        let exp = super.visitBaseExpression(exp)
        
        if !(exp.parent is ExpressionsStatement), let type = exp.resolvedType,
            type.isOptional && typeSystem.isScalarType(type.deepUnwrapped) {
            
            // If an expected type is present (and no resolved type is present,
            // or the expected type matches the resolved type), leave it alone
            // since sub-expression visitors will handle this expression for us.
            if let expectedType = exp.expectedType {
                guard let resolvedType = exp.resolvedType else {
                    return exp
                }
                
                if typeSystem.typesMatch(expectedType, resolvedType, ignoreNullability: true) {
                    return exp
                }
            }
            
            if let newExp = correctToDefaultValue(exp, targetType: exp.resolvedType?.deepUnwrapped) {
                notifyChange()
                
                return super.visitExpression(newExp)
            } else {
                exp.expectedType = nil
            }
        }
        
        return exp
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
        
        if typeSystem.isNumeric(expectedType) {
            if let corrected = correctToNumeric(exp) {
                notifyChange()
                
                return super.visitExpression(corrected)
            }
        } else if expectedType == .bool {
            // Parenthesize depending on parent expression type to avoid issues
            // with operator precedence
            let shouldParenthesize =
                exp.parent is UnaryExpression
                    || exp.parent is BinaryExpression
            
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
             .arithmetic,
             .bitwise:
            
            // Mark left hand side and right hand side of comparison expressions
            // to expect non-optional of numeric values, in case they are numeric
            // themselves.
            if let lhsType = exp.lhs.resolvedType?.unwrapped,
                typeSystem.isNumeric(lhsType) {
                
                exp.lhs.expectedType = lhsType
            }
            if let rhsType = exp.rhs.resolvedType?.unwrapped,
                typeSystem.isNumeric(rhsType) {
                
                exp.rhs.expectedType = rhsType
            }
            
            if exp.op.category == .arithmetic {
                // Correct binary operations containing operands of different
                // numerical types
                guard let lhsType = exp.lhs.resolvedType, let rhsType = exp.rhs.resolvedType else {
                    break
                }
                
                if !typeSystem.isNumeric(lhsType)
                    || !typeSystem.isNumeric(rhsType)
                    || lhsType == rhsType {
                    break
                }
                
                // Let literals be naturally coerced
                if exp.lhs.isLiteralExpression || exp.rhs.isLiteralExpression {
                    break
                }
                
                if let expectedType = exp.expectedType {
                    exp.lhs.expectedType = expectedType
                    exp.rhs.expectedType = expectedType
                }
                
                let targetLhsType = exp.lhs.expectedType ?? lhsType
                let targetRhsType = exp.rhs.expectedType ?? rhsType
                
                let _targetType =
                    typeSystem
                        .implicitCoercedNumericType(for: targetLhsType,
                                                    targetRhsType)
                
                guard let targetType = _targetType else {
                    break
                }
                
                if let newLhs = castNumeric(exp.lhs, to: targetType) {
                    exp.lhs = newLhs
                }
                
                if let newRhs = castNumeric(exp.rhs, to: targetType) {
                    exp.rhs = newRhs
                }
                
                notifyChange()
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
            
            guard memberType.isOptional && !memberType.canBeImplicitlyUnwrapped
                && typeSystem.isScalarType(memberType.deepUnwrapped) else {
                return super.visitPostfix(exp)
            }
            
            guard let initValue = typeSystem.defaultValue(for: memberType.deepUnwrapped) else {
                return super.visitPostfix(exp)
            }
            
            var res: Expression =
                Expression
                    .parens(
                        member.copy().typed(expected: nil)
                            .binary(op: .nullCoalesce, rhs: initValue)
                    ).typed(memberType.deepUnwrapped)
            
            res = .postfix(res, memberPostfix.op.copy().withOptionalAccess(kind: .none))
            
            res.resolvedType = memberPostfix.resolvedType
            
            res.asPostfix?.op.returnType = res.asPostfix?.op.returnType?.unwrapped
            
            res = .postfix(res, exp.op.copy())
            
            res.resolvedType = exp.resolvedType?.unwrapped
            res.asPostfix?.exp.resolvedType = res.asPostfix?.exp.resolvedType?.unwrapped
            res.asPostfix?.exp.asPostfix?.exp.expectedType = nil
            
            notifyChange()
            
            return super.visitExpression(res)
        }
        
        return super.visitPostfix(exp)
    }

    // MARK: - Internals

    /// Suggests a split to a sequence of statements that could be potentially
    /// invalid in Swift (like chained assignment variable declaration, `var a = b = c`)
    func suggestSplit(_ stmt: CompoundStatement) -> CompoundStatement? {
        var stmts: [Statement] = []

        for stmt in stmt.statements {
            guard let varDecl = stmt.asVariableDeclaration else {
                stmts.append(stmt)
                continue
            }

            if let split = suggestSplit(varDecl) {
                stmts.append(contentsOf: split)
            } else {
                stmts.append(varDecl)
            }
        }

        guard stmts.count != stmt.statements.count else {
            return nil
        }

        let copy = stmt.copy()
        copy.statements = stmts
        return copy
    }

    /// Suggests a split to chained assignment variable declarations like,
    /// `var a = b = c`.
    func suggestSplit(_ stmt: VariableDeclarationsStatement) -> [Statement]? {
        var splitCandidates: [Int: (assignment: Expression, lhs: Expression)] = [:]
        for (i, decl) in stmt.decl.enumerated() {
            guard let rhsAssignment = decl.initialization?.asAssignment else {
                continue
            }

            let lhs = rhsAssignment.lhs
            guard canSplitChainedAssignmentLhs(lhs) else {
                continue
            }

            splitCandidates[i] = (
                assignment: rhsAssignment,
                lhs: lhs
            )
        }

        guard !splitCandidates.isEmpty else {
            return nil
        }

        var stmts: [Statement] = []

        for (i, decl) in stmt.decl.enumerated() {
            if let assignment = splitCandidates[i] {
                stmts.append(.expression(assignment.assignment.copy()))
                stmts.append(
                    .variableDeclaration(
                        identifier: decl.identifier,
                        type: decl.type,
                        initialization: assignment.lhs.copy()
                    )
                )
            } else {
                stmts.append(.variableDeclarations([decl.copy()]))
            }
        }

        // Copy metadata to the first statement
        stmts[0] = stmts[0].copyMetadata(from: stmt)

        return stmts
    }

    /// Suggests a split to an expression that could be potentially invalid in
    /// Swift (like chained assignments, `a = b = c`)
    func suggestSplit(_ stmt: ExpressionsStatement) -> ExpressionsStatement? {
        // Break sequential expressions
        var sequence: [Expression] = []
        for exp in stmt.expressions {
            if let split = suggestSplit(exp) {
                sequence.append(contentsOf: split)
            } else {
                sequence.append(exp.copy())
            }
        }

        if sequence.count != stmt.expressions.count {
            return .expressions(sequence).copyMetadata(from: stmt)
        }

        return nil
    }

    /// Suggests a split to an expression that could be potentially invalid in
    /// Swift (like chained assignments, `a = b = c`)
    func suggestSplit(_ exp: Expression) -> [Expression]? {
        assignmentSplit:
        if let assignment = exp.asAssignment {
            let lhs = assignment.lhs

            guard let rhsAssignment = assignment.rhs.asAssignment else {
                break assignmentSplit
            }

            let rhsLhs = rhsAssignment.lhs
            guard canSplitChainedAssignmentLhs(rhsLhs) else {
                break assignmentSplit
            }

            let exp1 = rhsLhs.copy()
                .assignment(
                    op: rhsAssignment.op,
                    rhs: rhsAssignment.rhs.copy()
                )
            let exp2 = lhs.copy()
                .assignment(
                    op: assignment.op,
                    rhs: rhsLhs.copy()
                )
            
            // Attempt to further split the expressions recursively
            let exp1Sequence = suggestSplit(exp1) ?? [exp1]

            return exp1Sequence + [
                exp2,
            ]
        }

        return nil
    }

    /// Checks if the lhs of a chained assignment is more or less safe to split
    /// into a separate expression.
    func canSplitChainedAssignmentLhs(_ lhs: Expression) -> Bool {
        if lhs.isIdentifier {
            return true
        }
        guard let postfixExp = lhs.asPostfix else {
            return false
        }

        for access in PostfixChainInverter(expression: postfixExp).invert() {
            switch access {
            case .root(let exp):
                if !canSplitChainedAssignmentLhs(exp) {
                    return false
                }
            case .member:
                break
            case .subscript, .call:
                return false
            }
        }

        return true
    }

    func suggestIfLetPattern(_ stmt: ExpressionsStatement) -> IfStatement? {
        // TODO: Deal with multiple expressions on a single line, maybe.
        
        let pf = ValueMatcherExtractor<PostfixExpression?>()
        let functionCall = ValueMatcherExtractor(FunctionCallPostfix(arguments: []))
        let matcher =
            ExpressionsStatement.matcher()
                .keyPath(\.expressions, hasCount(1))
                .keyPath(\.expressions[0].asPostfix) { postfix in
                    postfix
                        .bind(to: pf)
                        .keyPath(\.functionCall, !isNil() ->> functionCall)
                        .keyPath(\.functionCall?.arguments, hasCount(1))
                }
        
        guard matcher.matches(stmt), let postfix = pf.value else {
            return nil
        }
        
        // Apply potential if-let patterns to simple 1-parameter function calls
        guard let blockType = functionCall.value.callableSignature else {
            return nil
        }
        let params = blockType.parameters
        
        let argument = functionCall.value.arguments[0].expression
        
        // Check the receiving argument is non-optional, but the argument's type
        // in the expression is an optional (but not an implicitly unwrapped, since
        // Swift takes care of unwrapping that automatically)
        guard let resolvedType = argument.resolvedType, !params[0].isOptional
            && resolvedType.isOptional == true
            && argument.resolvedType?.canBeImplicitlyUnwrapped == false else {
            return nil
        }
        
        // Scalars are dealt directly in another portion of the AST corrector.
        guard !typeSystem.isScalarType(resolvedType.deepUnwrapped) else {
            return nil
        }
        
        let name = varNameForExpression(argument)
        
        // if let <name> = <arg0> {
        //   func(<name>)
        // }
        let newOp = functionCall.value.replacingArguments([
            .identifier(name).typed(resolvedType.deepUnwrapped)
        ])
        let newPostfix = postfix.copy()
        newPostfix.op = newOp
        
        let stmt =
            Statement.ifLet(
                .identifier(name), argument.copy(),
                body: [
                    .expression(newPostfix)
                ])
        
        return stmt
    }

    private func varNameForExpression(_ exp: Expression) -> String {
        if let identifier = exp.asIdentifier {
            return identifier.identifier
        }
        if let member = exp.asPostfix?.member {
            return member.name
        }
        if let callPostfix = exp.asPostfix, callPostfix.functionCall != nil,
            let memberPostfix = callPostfix.exp.asPostfix, let member = memberPostfix.member {
            return member.name
        }
        
        return "value"
    }

    func correctToDefaultValue(_ exp: Expression,
                               targetType: SwiftType? = nil) -> Expression? {
        
        guard let expectedType = targetType ?? exp.expectedType else {
            return nil
        }
        guard expectedType == exp.resolvedType?.deepUnwrapped else {
            return nil
        }
        guard exp.resolvedType?.canBeImplicitlyUnwrapped == false else {
            return nil
        }
        guard let defValue = typeSystem.defaultValue(for: expectedType) else {
            return nil
        }
        guard defValue.resolvedType?.isOptional == false else {
            return nil
        }
        
        let newExp = exp.copy()
        
        newExp.expectedType = nil
        
        let converted: Expression
        
        if newExp.requiresParens {
            converted = .parens(newExp).binary(op: .nullCoalesce, rhs: defValue)
        } else {
            converted = newExp.binary(op: .nullCoalesce, rhs: defValue)
        }
        
        converted.resolvedType = defValue.resolvedType
        converted.expectedType = converted.resolvedType
        
        return .parens(converted).typed(defValue.resolvedType?.deepUnwrapped)
    }
    
    func correctToNumeric(_ exp: Expression) -> Expression? {
        guard let type = exp.resolvedType else {
            return nil
        }
        
        if type.isOptional && typeSystem.isNumeric(type.deepUnwrapped) {
            guard let defaultExp = typeSystem.defaultValue(for: type.deepUnwrapped) else {
                return nil
            }
            
            let newExp: Expression
            
            do {
                let expCopy = exp.copy()
                
                if expCopy.requiresParens {
                    newExp =
                        Expression
                            .parens(expCopy)
                            .binary(op: .nullCoalesce,
                                    rhs: defaultExp)
                } else {
                    newExp = .parens(expCopy.binary(op: .nullCoalesce, rhs: defaultExp))
                }
                
                newExp.expectedType = expCopy.expectedType
                newExp.resolvedType = type.deepUnwrapped
                
                expCopy.expectedType = nil
            }
            
            return newExp
        }
        
        return nil
    }
    
    func castNumeric(_ exp: Expression, to type: SwiftType) -> Expression? {
        guard let typeName = type.typeName else {
            return nil
        }
        guard let resolvedType = exp.resolvedType, typeSystem.isNumeric(resolvedType) else {
            return nil
        }
        
        if resolvedType == type {
            return nil
        }
        
        let cast = Expression
            .identifier(typeName)
            .typed(.metatype(for: type))
            .call([exp.copy().typed(expected: nil)])
            .typed(type)
            .typed(expected: type)
        
        return cast
    }
    
    func correctToBoolean(_ exp: Expression) -> Expression? {
        func innerHandle(_ exp: Expression, negated: Bool) -> Expression? {
            guard let type = exp.resolvedType else {
                return nil
            }
            
            let newExp = exp.copy()
            
            // <Numeric>
            if typeSystem.isNumeric(type.deepUnwrapped) {
                newExp.expectedType = nil
                
                let outer =
                    newExp.binary(op: negated ? .equals : .unequals,
                                  rhs: .constant(0))
                
                outer.resolvedType = .bool
                
                return outer
            }
            
            switch type {
            // <Bool?> -> <Bool?> == true
            // !<Bool?> -> <Bool?> != true (negated)
            case .optional(.bool):
                newExp.expectedType = nil
                
                let outer =
                    newExp.binary(op: negated ? .unequals : .equals,
                                  rhs: .constant(true))
                
                outer.resolvedType = .bool
                
                return outer
                
            // <nullable> -> <nullable> != nil
            // <nullable> -> <nullable> == nil (negated)
            case .optional:
                newExp.expectedType = nil
                
                let outer =
                    newExp.binary(op: negated ? .equals : .unequals,
                                  rhs: .constant(.nil))
                
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
