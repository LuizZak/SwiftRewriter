import SwiftSyntax
import Intentions
import SwiftAST

extension SwiftSyntaxProducer {
    
    /// Generates an expression syntax for the given expression.
    public func generateExpression(_ expression: Expression) -> ExprSyntax {
        switch expression {
        case let exp as ExpressionKindType:
            return generateExpressionKind(exp.expressionKind)
            
        default:
            assertionFailure("Found unknown expression syntax node type \(type(of: expression))")
            return MissingExprSyntax().asExprSyntax
        }
    }

    /// Returns a parenthesized `ExprSyntax` for a given expression if
    /// `expression.requiresParens` is `true`.
    func generateWithinParensIfNecessary(_ exp: Expression) -> ExprSyntax {
        if exp.requiresParens {
            return parenthesizeSyntax {
                generateExpression(exp)
            }
        }
        
        return generateExpression(exp)
    }
    
    func generateExpressionKind(_ expressionKind: ExpressionKind) -> ExprSyntax {
        switch expressionKind {
        case .identifier(let exp):
            return generateIdentifier(exp).asExprSyntax
            
        case .binary(let exp):
            return generateBinary(exp).asExprSyntax
            
        case .unary(let exp):
            return generateUnary(exp)
            
        case .prefix(let exp):
            return generatePrefix(exp)
            
        case .sizeOf(let exp):
            return generateSizeOf(exp)
            
        case .assignment(let exp):
            return generateAssignment(exp).asExprSyntax
            
        case .constant(let exp):
            return generateConstant(exp)
            
        case .arrayLiteral(let exp):
            return generateArrayLiteral(exp).asExprSyntax
            
        case .dictionaryLiteral(let exp):
            return generateDictionaryLiteral(exp).asExprSyntax
            
        case .postfix(let exp):
            return generatePostfix(exp)
            
        case .parens(let exp):
            return generateParens(exp)
            
        case .cast(let exp):
            return generateCast(exp).asExprSyntax
        
        case .typeCheck(let exp):
            return generateTypeCheck(exp).asExprSyntax
            
        case .ternary(let exp):
            return generateTernary(exp)
            
        case .tuple(let exp):
            return generateTuple(exp)
            
        case .selector(let exp):
            return generateSelector(exp)
            
        case .blockLiteral(let exp):
            return generateClosure(exp).asExprSyntax
        
        case .tryExpression(let exp):
            return generateTry(exp).asExprSyntax

        case .unknown:
            return MissingExprSyntax().asExprSyntax
        }
    }
    
    public func generateSizeOf(_ exp: SizeOfExpression) -> ExprSyntax {
        func _forType(_ type: SwiftType) -> ExprSyntax {
            let baseSyntax = SpecializeExprSyntax(
                expression: IdentifierExprSyntax(identifier: prepareStartToken(
                    makeIdentifier("MemoryLayout")
                )),
                genericArgumentClause: .init(arguments: [
                    .init(argumentType: SwiftTypeConverter.makeTypeSyntax(type, startTokenHandler: self))
                ])
            )
            
            let syntax = generateMemberAccessExpr(base: baseSyntax.asExprSyntax, name: "size")
            return syntax.asExprSyntax
        }
        
        switch exp.value {
        case .expression(let exp):
            if case let .metatype(innerType)? = exp.resolvedType {
                return _forType(innerType)
            }
            
            return generateExpression(
                Expression
                    .identifier("MemoryLayout")
                    .dot("size")
                    .call([.labeled("ofValue", exp.copy())])
            )
        
        case .type(let type):
            return _forType(type)
        }
    }
    
    public func generateParens(_ exp: ParensExpression) -> ExprSyntax {
        return parenthesizeSyntax {
            generateExpression(exp.exp)
        }
    }
    
    public func generateIdentifier(_ exp: IdentifierExpression) -> IdentifierExprSyntax {
        let syntax = IdentifierExprSyntax(identifier: prepareStartToken(makeIdentifier(exp.identifier)))

        return syntax
    }
    
    public func generateCast(_ exp: CastExpression) -> AsExprSyntax {
        let expSyntax = generateWithinParensIfNecessary(exp.exp)

        let syntax: AsExprSyntax

        if exp.isOptionalCast {
            syntax = AsExprSyntax(
                expression: expSyntax,
                asTok: .keyword(.as).withLeadingSpace(),
                questionOrExclamationMark: .postfixQuestionMarkToken().withTrailingSpace(),
                typeName: SwiftTypeConverter.makeTypeSyntax(exp.type, startTokenHandler: self)
            )
        } else {
            syntax = AsExprSyntax(
                expression: expSyntax,
                asTok: .keyword(.as).addingSurroundingSpaces(),
                typeName: SwiftTypeConverter.makeTypeSyntax(exp.type, startTokenHandler: self)
            )
        }
        
        return syntax
    }
    
    public func generateTypeCheck(_ exp: TypeCheckExpression) -> IsExprSyntax {
        let expSyntax = generateWithinParensIfNecessary(exp.exp)

        let syntax: IsExprSyntax = IsExprSyntax(
            expression: expSyntax,
            isTok: prepareStartToken(.keyword(.is)).addingSurroundingSpaces(),
            typeName: SwiftTypeConverter.makeTypeSyntax(exp.type, startTokenHandler: self)
        )
        
        return syntax
    }
    
    public func generateClosure(_ exp: BlockLiteralExpression) -> ClosureExprSyntax {
        var syntax = ClosureExprSyntax(statements: [])

        let hasParameters = !exp.parameters.isEmpty
        let requiresTypeSignature =
            exp.resolvedType == nil || exp.resolvedType != exp.expectedType
        
        let requiresInToken = hasParameters || requiresTypeSignature

        // Prepare leading comments for the block
        var leadingComments: Trivia?
        if !exp.body.comments.isEmpty {
            indent() // Temporarily indent for leading comments generation

            leadingComments =
                .newlines(1)
                + indentation()
                + toCommentsTrivia(
                    exp.body.comments,
                    addNewLineAfter: !exp.body.isEmpty
                )
            
            deindent()
        }
        
        var leftBrace = prepareStartToken(.leftBraceToken())
        
        if !requiresInToken, let leadingComments {
            leftBrace = leftBrace.withTrailingTrivia(
                leadingComments
            )
        }

        syntax = syntax.with(\.leftBrace, leftBrace)

        var signatureSyntax = ClosureSignatureSyntax()

        addExtraLeading(.spaces(1))
        
        if requiresTypeSignature {
            var parametersSyntax = ClosureParameterClauseSyntax(parameters: [])

            parametersSyntax = parametersSyntax.with(\.leftParen, 
                .leftParen
                    .withExtraLeading(from: self)
            )
            
            parametersSyntax = parametersSyntax.with(\.rightParen, .rightParen)
            
            iterateWithComma(exp.parameters) { (arg, hasComma) in
                var paramSyntax = ClosureParameterSyntax(
                    firstName: makeIdentifier(arg.name).withExtraLeading(from: self),
                    colon: .colon.withTrailingSpace(),
                    type: SwiftTypeConverter.makeTypeSyntax(arg.type, startTokenHandler: self)
                )
                
                if hasComma {
                    paramSyntax = paramSyntax.with(\.trailingComma, 
                        .comma.withTrailingSpace()
                    )
                }

                parametersSyntax = parametersSyntax.addParameter(paramSyntax)
            }
            
            signatureSyntax = signatureSyntax.with(\.input, .input(parametersSyntax))
        } else if hasParameters {
            var parametersSyntax = ClosureParamListSyntax()

            iterateWithComma(exp.parameters) { (arg, hasComma) in
                var paramSyntax = ClosureParamSyntax(
                    name: makeIdentifier(arg.name).withExtraLeading(from: self)
                )
                
                if hasComma {
                    paramSyntax = paramSyntax.with(\.trailingComma, 
                        .comma.withTrailingSpace()
                    )
                }

                parametersSyntax = parametersSyntax.appending(paramSyntax)
            }

            signatureSyntax = signatureSyntax.with(\.input, .simpleInput(parametersSyntax))
        }

        if requiresInToken {
            var inToken = TokenSyntax.in.addingLeadingSpace()

            if let leadingComments {
                inToken = inToken.withTrailingTrivia(
                    leadingComments
                )
            }

            signatureSyntax = signatureSyntax.with(\.inTok, inToken)
        }
        
        if requiresTypeSignature {
            signatureSyntax = signatureSyntax.with(\.output, generateReturnType(exp.returnType))
        }

        if requiresInToken || requiresTypeSignature || hasParameters {
            syntax = syntax.with(\.signature, signatureSyntax)
        }
        
        indent()
        
        extraLeading = nil
        
        let statements = _generateStatements(exp.body.statements)
        for stmt in statements {
            syntax = syntax.addStatement(stmt)
        }
        
        deindent()
        
        extraLeading = .newlines(1) + indentation()
        
        syntax = syntax.with(\.rightBrace, prepareStartToken(.rightBrace))

        return syntax
    }
    
    public func generateArrayLiteral(_ exp: ArrayLiteralExpression) -> ArrayExprSyntax {
        var syntax = ArrayExprSyntax(
            leftSquare: prepareStartToken(.leftSquare),
            elements: []
        )
        
        iterateWithComma(exp.items) { (item: Expression, hasComma) in
            var elementSyntax = ArrayElementSyntax(expression: generateExpression(item))

            if hasComma {
                elementSyntax = elementSyntax.with(\.trailingComma, 
                    .comma.withTrailingSpace()
                )
            }

            syntax = syntax.addElement(elementSyntax)
        }

        return syntax
    }
    
    public func generateDictionaryLiteral(_ exp: DictionaryLiteralExpression) -> DictionaryExprSyntax {
        var syntax = DictionaryExprSyntax(
            leftSquare: prepareStartToken(.leftSquare)
        )

        if exp.pairs.isEmpty {
            syntax = syntax.with(\.content, .colon(.colon))
        } else {
            var elements: [DictionaryElementSyntax] = []
            
            iterateWithComma(exp.pairs) { (item, hasComma) in
                var elementSyntax = DictionaryElementSyntax(
                    keyExpression: generateExpression(item.key),
                    colon: .colon.withTrailingSpace(),
                    valueExpression: generateExpression(item.value)
                )
                
                if hasComma {
                    elementSyntax = elementSyntax.with(\.trailingComma, 
                        .comma.withTrailingSpace()
                    )
                }

                elements.append(elementSyntax)
            }
            
            syntax = syntax.with(\.content, .elements(.init(elements)))
        }

        return syntax
    }
    
    public func generateAssignment(_ exp: AssignmentExpression) -> SequenceExprSyntax {
        var syntax = SequenceExprSyntax(elements: [])
        
        syntax = syntax.addElement(generateExpression(exp.lhs))
        
        addExtraLeading(.spaces(1))
        
        syntax = syntax.addElement(generateOperator(exp.op, mode: .assignment))
        
        addExtraLeading(.spaces(1))
        
        syntax = syntax.addElement(generateExpression(exp.rhs))

        return syntax
    }
    
    public func generateUnary(_ exp: UnaryExpression) -> ExprSyntax {
        generateOperator(exp.op, mode: .prefix({ self.generateWithinParensIfNecessary(exp.exp) }))
    }
    
    public func generatePrefix(_ exp: PrefixExpression) -> ExprSyntax {
        generateOperator(exp.op, mode: .prefix({ self.generateWithinParensIfNecessary(exp.exp) }))
    }
    
    public func generateBinary(_ exp: BinaryExpression) -> SequenceExprSyntax {
        var syntax = SequenceExprSyntax(elements: [])

        syntax = syntax.addElement(generateExpression(exp.lhs))
        
        if exp.op.category != .range {
            addExtraLeading(.spaces(1))
        }
        
        syntax = syntax.addElement(generateOperator(exp.op, mode: .infix))
        
        if exp.op.category != .range {
            addExtraLeading(.spaces(1))
        }
        
        syntax = syntax.addElement(generateExpression(exp.rhs))

        return syntax
    }
    
    public func generatePostfix(_ exp: PostfixExpression) -> ExprSyntax {
        func makeExprSyntax(
            _ exp: Expression,
            optionalAccessKind: Postfix.OptionalAccessKind
        ) -> ExprSyntax {
            
            let base = generateWithinParensIfNecessary(exp)
            
            switch optionalAccessKind {
            case .none:
                return base
                
            case .safeUnwrap:
                return OptionalChainingExprSyntax(expression: base).asExprSyntax
                
            case .forceUnwrap:
                return ForcedValueExprSyntax(expression: base).asExprSyntax
            }
        }
        
        let subExp = makeExprSyntax(exp.exp, optionalAccessKind: exp.op.optionalAccessKind)
        
        switch exp.op {
        case let member as MemberPostfix:
            return generateMemberAccessExpr(base: subExp, name: member.name).asExprSyntax
            
        case let subs as SubscriptPostfix:
            var subscriptSyntax = SubscriptExprSyntax(calledExpression: subExp, arguments: [])

            iterateWithComma(subs.arguments) { (arg, hasComma) in
                subscriptSyntax = subscriptSyntax.addArgument(
                    generateTupleExprElement(
                        label: arg.label,
                        exp: arg.expression,
                        hasComma: hasComma
                    )
                )
            }

            return subscriptSyntax.asExprSyntax
            
        case let call as FunctionCallPostfix:
            var arguments = call.arguments
            
            var trailingClosure: BlockLiteralExpression?
            // If the last argument is a block type, close the
            // parameters list earlier and use the block as a
            // trailing closure.
            // Exception: If the second-to-last argument is also a closure argument,
            // don't use trailing closure syntax, since it results in confusing-looking
            // code.
            if let block = arguments.last?.expression as? BlockLiteralExpression,
                !(arguments.dropLast().last?.expression is BlockLiteralExpression) {
                
                trailingClosure = block
                arguments.removeLast()
            }
            
            var syntax = FunctionCallExprSyntax(calledExpression: subExp, arguments: [])
            
            iterateWithComma(arguments) { (arg, hasComma) in
                syntax = syntax.addArgument(
                    generateTupleExprElement(
                        label: arg.label,
                        exp: arg.expression,
                        hasComma: hasComma
                    )
                )
            }
            
            if let trailingClosure = trailingClosure {
                addExtraLeading(.spaces(1))
                syntax = syntax.with(\.trailingClosure, 
                    generateClosure(trailingClosure)
                )
            }
            
            // No need to emit parenthesis if a trailing closure
            // is present as the only argument of the function
            if !arguments.isEmpty || trailingClosure == nil {
                syntax = syntax.with(\.leftParen, .leftParen)
                syntax = syntax.with(\.rightParen, .rightParen)
            }

            return syntax.asExprSyntax
            
        default:
            return MissingExprSyntax().asExprSyntax
        }
    }

    internal func generateTupleExprElement(label: String?, exp: Expression, hasComma: Bool) -> TupleExprElementSyntax {
        var elementSyntax: TupleExprElementSyntax

        if let label = label {
            elementSyntax = TupleExprElementSyntax(
                label: makeIdentifier(label),
                colon: .colon.withTrailingSpace(),
                expression: generateExpression(exp)
            )
        } else {
            elementSyntax = TupleExprElementSyntax(
                expression: generateExpression(exp)
            )
        }
        
        if hasComma {
            elementSyntax = elementSyntax.with(\.trailingComma, 
                .comma.withTrailingSpace()
            )
        }

        return elementSyntax
    }
    
    public func generateTernary(_ exp: TernaryExpression) -> ExprSyntax {
        let syntax = TernaryExprSyntax(
            conditionExpression: generateExpression(exp.exp),
            questionMark: .infixQuestionMarkToken().addingSurroundingSpaces(),
            firstChoice: generateExpression(exp.ifTrue),
            colonMark: .colon.addingSurroundingSpaces(),
            secondChoice: generateExpression(exp.ifFalse)
        )

        return syntax.asExprSyntax
    }
    
    public func generateTuple(_ exp: TupleExpression) -> ExprSyntax {
        var syntax = TupleExprSyntax(leftParen: prepareStartToken(.leftParen), elements: [])

        iterateWithComma(exp.elements) { (item, hasComma) in
            var elementSyntax = TupleExprElementSyntax(expression: generateExpression(item))
            if hasComma {
                elementSyntax = elementSyntax.with(\.trailingComma, 
                    .comma.withTrailingSpace()
                )
            }

            syntax = syntax.addElement(elementSyntax)
        }
        
        return syntax.asExprSyntax
    }
    
    public func generateSelector(_ exp: SelectorExpression) -> ExprSyntax {
        var syntax = MacroExpansionExprSyntax(
            macro: prepareStartToken(makeIdentifier("selector")),
            leftParen: .leftParen,
            argumentList: [],
            rightParen: .rightParen
        )

        func makePropReference(type: SwiftType?, property: String) -> ExprSyntax {
            if let type = type {
                let syntax = generateMemberAccessExpr(
                    base: SwiftTypeConverter.makeTypeSyntax(type, startTokenHandler: self),
                    name: property
                )

                return syntax.asExprSyntax
            }

            return IdentifierExprSyntax(
                identifier: makeIdentifier(property)
            ).asExprSyntax
        }

        switch exp.kind {
        case let .function(type, identifier):
            syntax = syntax.addArgument(
                .init(expression: generateFunctionIdentifier(type: type, identifier))
            )

        case let .getter(type, property):
            syntax = syntax.addArgument(
                .init(
                    label: makeIdentifier("getter"),
                    colon: .colonToken().withTrailingSpace(),
                    expression: makePropReference(type: type, property: property)
                )
            )

        case let .setter(type, property):
            syntax = syntax.addArgument(
                .init(
                    label: makeIdentifier("setter"),
                    colon: .colonToken().withTrailingSpace(),
                    expression: makePropReference(type: type, property: property)
                )
            )
        }
        
        return syntax.asExprSyntax
    }
    
    public func generateConstant(_ constant: ConstantExpression) -> ExprSyntax {
        switch constant.constant {
        case .boolean(let bool):
            let booleanToken = bool ? TokenSyntax.keyword(.true) : TokenSyntax.keyword(.false)
            let token = prepareStartToken(booleanToken)
            
            return BooleanLiteralExprSyntax(booleanLiteral: token).asExprSyntax
            
        case .nil:
            return NilLiteralExprSyntax(nilKeyword: prepareStartToken(.keyword(.nil)))
                .asExprSyntax
            
        case let .int(value, type):
            let digits: TokenSyntax
            
            switch type {
            case .binary:
                digits = .integerLiteral("0b" + String(value, radix: 2))
                
            case .decimal:
                digits = .integerLiteral(value.description)
                
            case .octal:
                digits = .integerLiteral("0o" + String(value, radix: 8))
                
            case .hexadecimal:
                digits = .integerLiteral("0x" + String(value, radix: 16))
            }
            
            return IntegerLiteralExprSyntax(digits: prepareStartToken(digits))
                .asExprSyntax
            
        case .float(let value):
            let digits = prepareStartToken(
                .floatingLiteral(value.description)
            )
            
            return FloatLiteralExprSyntax(floatingDigits: digits)
                .asExprSyntax
            
        case .double(let value):
            let digits = prepareStartToken(
                .floatingLiteral(value.description)
            )
            
            return FloatLiteralExprSyntax(floatingDigits: digits)
                .asExprSyntax
            
        case .string(let string):
            return StringLiteralExprSyntax(
                openQuote: prepareStartToken(.stringQuoteToken()),
                segments: [
                    .init(StringSegmentSyntax(content: .stringSegment(string)))
                ],
                closeQuote: .stringQuoteToken()
            ).asExprSyntax
            
        case .rawConstant(let constant):
            return IdentifierExprSyntax(
                identifier: prepareStartToken(makeIdentifier(constant))
            ).asExprSyntax
        }
    }

    public func generateTry(_ exp: TryExpression) -> TryExprSyntax {
        let questionOrExclamationMark: TokenSyntax?

        switch exp.mode {
        case .throwable:
            questionOrExclamationMark = nil

        case .forced:
            questionOrExclamationMark = .exclamationMarkToken()
        case .optional:
            questionOrExclamationMark = .infixQuestionMarkToken()
        }

        let tryKeyword = prepareStartToken(.keyword(.try))
        addExtraLeading(.spaces(1))
        let exprSyntax = generateExpression(exp.exp)

        let syntax = TryExprSyntax(
            tryKeyword: tryKeyword,
            questionOrExclamationMark: questionOrExclamationMark,
            expression: exprSyntax
        )

        return syntax
    }
    
    func generateOperator(_ op: SwiftOperator, mode: OperatorMode) -> ExprSyntax {
        let producer: (SwiftOperator) -> ExprSyntax
        
        switch mode {
        case .assignment:
            producer = { op in
                let token = self.prepareStartToken(.spacedBinaryOperator(op.rawValue))

                return AssignmentExprSyntax(assignToken: token).asExprSyntax
            }
            
        case .prefix(let exp):
            producer = { op in
                let token = self.prepareStartToken(.prefixOperator(op.rawValue))

                return PrefixOperatorExprSyntax(
                    operatorToken: token,
                    postfixExpression: exp()
                ).asExprSyntax
            }
        case .infix:
            producer = { op in
                let token = self.prepareStartToken(.spacedBinaryOperator(op.rawValue))

                return BinaryOperatorExprSyntax(operatorToken: token).asExprSyntax
            }
        case .postfix(let exp):
            producer = { op in
                return PostfixUnaryExprSyntax(
                    expression: exp(),
                    operatorToken: self.prepareStartToken(.postfixOperator(op.rawValue))
                ).asExprSyntax
            }
        }
        
        return producer(op)
    }
    
    func generateFunctionIdentifier(type: SwiftType?, _ ident: FunctionIdentifier) -> ExprSyntax {
        if let type = type {
            let typeSyntax = SwiftTypeConverter.makeTypeSyntax(type, startTokenHandler: self)
            
            let syntax = generateMemberAccessExpr(
                base: TypeExprSyntax(type: typeSyntax).asExprSyntax,
                name: ident.name,
                declNameArguments: generateDeclNameArguments(argumentLabels: ident.argumentLabels)
            )

            return syntax.asExprSyntax
        } else {
            return IdentifierExprSyntax(
                identifier: prepareStartToken(makeIdentifier(ident.name)),
                declNameArguments: generateDeclNameArguments(argumentLabels: ident.argumentLabels)
            ).asExprSyntax
        }
    }

    func generateMemberAccessExpr(
        base: TypeSyntax,
        name: String,
        declNameArguments: DeclNameArgumentsSyntax? = nil
    ) -> MemberAccessExprSyntax {

        return generateMemberAccessExpr(
            base: TypeExprSyntax(type: base),
            name: name,
            declNameArguments: declNameArguments
        )
    }

    func generateMemberAccessExpr(
        base: TypeExprSyntax,
        name: String,
        declNameArguments: DeclNameArgumentsSyntax? = nil
    ) -> MemberAccessExprSyntax {

        return generateMemberAccessExpr(
            base: base.asExprSyntax,
            name: name,
            declNameArguments: declNameArguments
        )
    }

    func generateMemberAccessExpr(
        base: ExprSyntax,
        name: String,
        declNameArguments: DeclNameArgumentsSyntax? = nil
    ) -> MemberAccessExprSyntax {

        let syntax = MemberAccessExprSyntax(
            base: base,
            name: makeIdentifier(name),
            declNameArguments: declNameArguments
        )

        return syntax
    }

    func generateDeclNameArguments(argumentLabels: [String?]) -> DeclNameArgumentsSyntax {
        var declArgsSyntax = DeclNameArgumentsSyntax(arguments: [])

        for arg in argumentLabels {
            var argSyntax: DeclNameArgumentSyntax

            if let arg = arg {
                argSyntax = .init(name: makeIdentifier(arg))
            } else {
                argSyntax = .init(name: .wildcard)
            }
            
            argSyntax = argSyntax.with(\.colon, .colon)

            declArgsSyntax = declArgsSyntax.addArgument(argSyntax)
        }

        return declArgsSyntax
    }
    
    func parenthesizeSyntax(_ exprBuilder: () -> ExprSyntax) -> ExprSyntax {
        return TupleExprSyntax(
            leftParen: prepareStartToken(.leftParen),
            elementList: [.init(expression: exprBuilder())]
        ).asExprSyntax
    }
    
    enum OperatorMode {
        case assignment
        case prefix(() -> ExprSyntax)
        case infix
        case postfix(() -> ExprSyntax)
    }
}
