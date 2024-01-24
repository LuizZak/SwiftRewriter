import SwiftAST

extension StatementEmitter: ExpressionVisitor {
    func parenthesizeIfRequired(_ exp: Expression) {
        if exp.requiresParens { emit("(") }
        visitExpression(exp)
        if exp.requiresParens { emit(")") }
    }

    func visitExpression(_ exp: Expression) {
        exp.accept(self)
    }

    func visitAssignment(_ exp: AssignmentExpression) {
        visitExpression(exp.lhs)
        if exp.op.requiresSpacing {
            emit(" \(exp.op.description) ")
        } else {
            emit(exp.op.description)
        }
        visitExpression(exp.rhs)
    }

    func visitBinary(_ exp: BinaryExpression) {
        visitExpression(exp.lhs)
        if exp.op.requiresSpacing {
            emit(" \(exp.op.description) ")
        } else {
            emit(exp.op.description)
        }
        visitExpression(exp.rhs)
    }

    func visitUnary(_ exp: UnaryExpression) {
        emit(exp.op.description)
        parenthesizeIfRequired(exp.exp)
    }

    func visitSizeOf(_ exp: SizeOfExpression) {
        switch exp.value {
        case .expression(let innerExp):
            if case .metatype(let inner) = innerExp.resolvedType {
                emit("MemoryLayout<")
                emit(inner)
                emit(">.size")
            } else {
                emit("MemoryLayout.size(ofValue: ")
                visitExpression(innerExp)
                emit(")")
            }
            
        case .type(let type):
            emit("MemoryLayout<")
            emit(type)
            emit(">.size")
        }
    }

    func visitPrefix(_ exp: PrefixExpression) {
        emit(exp.op.description)
        parenthesizeIfRequired(exp.exp)
    }

    func visitFunctionArguments(_ arguments: [FunctionArgument]) {
        producer.emitWithSeparators(arguments, separator: ", ") { argument in
            if let label = argument.label {
                emit("\(label): ")
            }

            visitExpression(argument.expression)
        }
    }

    func visitPostfix(_ exp: PostfixExpression) {
        parenthesizeIfRequired(exp.exp)

        switch exp.op.optionalAccessKind {
        case .none:
            break
        case .forceUnwrap:
            emit("!")
        case .safeUnwrap:
            emit("?")
        }
        
        switch exp.op {
        case let fc as FunctionCallPostfix:
            // If the last argument is a block type, close the
            // parameters list earlier and use the block as a
            // trailing closure.
            // Exception: If the second-to-last argument is also a closure argument,
            // don't use trailing closure syntax, since it results in confusing-looking
            // code.
            var arguments = fc.arguments
            var trailing: BlockLiteralExpression?
            
            if isTrailingClosureCandidate(fc) {
                trailing = arguments.removeLast().expression.asBlock
            }

            if trailing == nil || !arguments.isEmpty {
                emit("(")
                visitFunctionArguments(arguments)
                emit(")")
            }

            if let trailing {
                emitSpaceSeparator()
                visitBlock(trailing)
            }

        case let sub as SubscriptPostfix:
            emit("[")
            visitFunctionArguments(sub.arguments)
            emit("]")

        case let member as MemberPostfix:
            emit(".")
            emit(member.name)

        default:
            break
        }
    }

    func visitConstant(_ exp: ConstantExpression) {
        emit(exp.description)
    }

    func visitParens(_ exp: ParensExpression) {
        emit("(")
        visitExpression(exp.exp)
        emit(")")
    }

    func visitIdentifier(_ exp: IdentifierExpression) {
        emit(exp.identifier)
    }

    func visitCast(_ exp: CastExpression) {
        parenthesizeIfRequired(exp.exp)
        emit(" as")
        if exp.isOptionalCast {
            emit("?")
        }
        emit(" ")
        emit(exp.type)
    }

    func visitTypeCheck(_ exp: TypeCheckExpression) {
        parenthesizeIfRequired(exp.exp)
        emit(" is ")
        emit(exp.type)
    }

    func visitArray(_ exp: ArrayLiteralExpression) {
        emit("[")
        producer.emitWithSeparators(exp.items, separator: ", ") { item in
            visitExpression(item)
        }
        emit("]")
    }

    func visitDictionary(_ exp: DictionaryLiteralExpression) {
        emit("[")
        producer.emitWithSeparators(exp.pairs, separator: ", ") { pair in
            visitExpression(pair.key)
            emit(": ")
            visitExpression(pair.value)
        }
        if exp.pairs.isEmpty {
            emit(":")
        }
        emit("]")
    }

    func visitBlock(_ exp: BlockLiteralExpression) {
        producer.emitBlock { () -> Void in
            let hasParameters = !exp.parameters.isEmpty
            
            if closureRequiresSignature(exp) || hasParameters {
                producer.backtrackWhitespace()
                emitSpaceSeparator()

                if isShorthandClosureCandidate(exp) {
                    producer.emitWithSeparators(exp.parameters, separator: ", ") { param in
                        emit(param.name)
                    }
                } else {
                    emit("(")
                    producer.emitWithSeparators(exp.parameters, separator: ", ") { param in
                        emit(param.name)
                        emit(": ")
                        emit(param.type)
                    }
                    emit(")")
                    emit(" -> ")
                    emitReturnType(exp.returnType)
                }

                producer.emitLine(" in")
            }

            // Emit body comments
            emitComments(exp.body.comments)

            pushClosureStack()
            emitStatements(exp.body.statements)
            popClosureStack()
        }

        // Backtrack to close brace, allowing closure expressions to sit inline
        // with other expressions
        producer.backtrackWhitespace()
    }

    func visitTernary(_ exp: TernaryExpression) {
        parenthesizeIfRequired(exp.exp)
        emit(" ? ")
        visitExpression(exp.ifTrue)
        emit(" : ")
        visitExpression(exp.ifFalse)
    }

    func visitTuple(_ exp: TupleExpression) {
        emit("(")
        producer.emitWithSeparators(
            exp.elements,
            separator: ", ",
            visitExpression
        )
        emit(")")
    }

    func visitSelector(_ exp: SelectorExpression) {
        emit(exp.description)
    }

    func visitTry(_ exp: TryExpression) {
        emit("try")
        switch exp.mode {
        case .throwable:
            break
        case .optional:
            emit("?")
        case .forced:
            emit("!")
        }

        emitSpaceSeparator()

        parenthesizeIfRequired(exp.exp)
    }

    func visitUnknown(_ exp: UnknownExpression) {
        
    }
}

