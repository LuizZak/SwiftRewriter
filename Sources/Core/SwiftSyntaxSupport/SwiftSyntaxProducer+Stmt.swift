import SwiftSyntax
import Intentions
import SwiftAST

extension SwiftSyntaxProducer {
    typealias StatementBlockProducer = (SwiftSyntaxProducer) -> CodeBlockItemSyntax?
    
    // TODO: Consider reducing code duplication within `generateStatement` and
    // `_generateStatements`
    
    /// Generates a code block for the given statement.
    /// This code block might have zero, one or more sub-statements, depending
    /// on the properties of the given statement, e.g. expression statements
    /// which feature zero elements in the expressions array result in an empty
    /// code block.
    ///
    /// This method is provided more as an inspector of generation of syntax
    /// elements for particular statements, and is not used internally by the
    /// syntax producer while generating whole files.
    ///
    /// - Returns: A code block containing the statements generated by the
    /// statement provided.
    public func generateStatement(_ statement: Statement) -> CodeBlockSyntax {
        if let statement = statement as? CompoundStatement {
            return generateCompound(statement)
        }
        
        return CodeBlockSyntax { builder in
            indent()
            defer {
                deindent()
            }
            
            let stmts = generateStatementBlockItems(statement)
            
            for (i, stmt) in stmts.enumerated() {
                if i > 0 {
                    addExtraLeading(.newlines(1))
                }
                
                if let syntax = stmt(self) {
                    builder.addStatement(syntax)
                }
            }
        }
    }
    
    func generateCompound(_ compoundStmt: CompoundStatement) -> CodeBlockSyntax {
        CodeBlockSyntax { builder in
            builder.useLeftBrace(makeStartToken(SyntaxFactory.makeLeftBraceToken))
            
            indent()
            defer {
                deindent()
                builder.useRightBrace(
                    SyntaxFactory
                        .makeRightBraceToken()
                        .onNewline()
                        .addingLeadingTrivia(indentation())
                        .withExtraLeading(consuming: &extraLeading)
                )
            }
            
            let stmts = _generateStatements(compoundStmt.statements)
            
            for stmt in stmts {
                builder.addStatement(stmt)
            }
        }
    }
    
    func _generateStatements(_ stmtList: [Statement]) -> [CodeBlockItemSyntax] {
        var items: [CodeBlockItemSyntax] = []
        
        for (i, stmt) in stmtList.enumerated() {
            let stmtSyntax = generateStatementBlockItems(stmt)
            
            for item in stmtSyntax {
                addExtraLeading(.newlines(1) + indentation())

                if let syntax = item(self) {
                    items.append(syntax)
                }
            }
            
            if i < stmtList.count - 1
                && _shouldEmitNewlineSpacing(between: stmt,
                                             stmt2: stmtList[i + 1]) {
                
                addExtraLeading(.newlines(1))
            }
        }
        
        return items
    }
    
    private func _shouldEmitNewlineSpacing(between stmt1: Statement,
                                           stmt2: Statement) -> Bool {
        
        switch (stmt1, stmt2) {
        case (is ExpressionsStatement, is ExpressionsStatement):
            return false
        case (is VariableDeclarationsStatement, is ExpressionsStatement),
             (is VariableDeclarationsStatement, is VariableDeclarationsStatement):
            return false
            
        default:
            return true
        }
    }
    
    func generateStatementBlockItems(_ stmt: Statement) -> [StatementBlockProducer] {
        var genList: [StatementBlockProducer]
        
        switch stmt {
        case let stmt as StatementKindType:
            genList = generateStatementKind(stmt.statementKind)

        default:
            assertionFailure("Found unknown statement syntax node type \(type(of: stmt))")
            genList = [{ _ in SyntaxFactory.makeBlankExpressionStmt().inCodeBlock() }]
        }
        
        var leadingComments = stmt.comments
        if let label = stmt.label, !stmt.isLabelableStatementType {
            leadingComments.append("// \(label):")
        }
        
        genList = applyingLeadingComments(leadingComments, toList: genList)
        genList = applyingTrailingComment(stmt.trailingComment, toList: genList)
        
        return genList
    }

    private func generateStatementKind(_ statementKind: StatementKind) -> [StatementBlockProducer] {
        switch statementKind {
        case .return(let stmt):
            return [{ $0.generateReturn(stmt).inCodeBlock() }]
            
        case .continue(let stmt):
            return [{ $0.generateContinue(stmt).inCodeBlock() }]
            
        case .break(let stmt):
            return [{ $0.generateBreak(stmt).inCodeBlock() }]
            
        case .fallthrough(let stmt):
            return [{ $0.generateFallthrough(stmt).inCodeBlock() }]
            
        case .expressions(let stmt):
            return generateExpressions(stmt)
            
        case .variableDeclarations(let stmt):
            return generateVariableDeclarations(stmt)
            
        case .if(let stmt):
            return [{ $0.generateIfStmt(stmt).inCodeBlock() }]
            
        case .switch(let stmt):
            return [{ $0.generateSwitchStmt(stmt).inCodeBlock() }]
            
        case .while(let stmt):
            return [{ $0.generateWhileStmt(stmt).inCodeBlock() }]
            
        case .do(let stmt):
            return [{ $0.generateDo(stmt).inCodeBlock() }]
            
        case .doWhile(let stmt):
            return [{ $0.generateDoWhileStmt(stmt).inCodeBlock() }]
            
        case .for(let stmt):
            return [{ $0.generateForIn(stmt).inCodeBlock() }]
            
        case .defer(let stmt):
            return [{ $0.generateDefer(stmt).inCodeBlock() }]
            
        case .compound(let stmt):
            return stmt.statements.flatMap(generateStatementBlockItems)

        case .localFunction(let stmt):
            return [{ $0.generateLocalFunction(stmt).inCodeBlock() }]

        case .throw(let stmt):
            return [{ $0.generateThrow(stmt).inCodeBlock() }]
            
        case .unknown(let stmt):
            return [self.generateUnknown(stmt)]
        }
    }
    
    private func applyingLeadingComments(
        _ comments: [String],
        toList list: [StatementBlockProducer]
    ) -> [StatementBlockProducer] {
        
        guard !comments.isEmpty, let first = list.first else {
            return list
        }
        
        var list = list
        
        list[0] = {
            $0.addComments(comments)
            
            return first($0)
        }
        
        return list
    }
    
    private func applyingTrailingComment(
        _ comment: String?,
        toList list: [StatementBlockProducer]
    ) -> [StatementBlockProducer] {

        guard let comment = comment, let last = list.last else {
            return list
        }
        
        var list = list
        
        list[list.count - 1] = {
            return last($0)?.withTrailingTrivia(.spaces(1) + .lineComment(comment))
        }
        
        return list
    }
    
    /// Processes an unknown statement, adding the 
    func generateUnknown(_ unknown: UnknownStatement) -> StatementBlockProducer {
        return {
            let indent = $0.indentationString()
        
            $0.addExtraLeading(
                .blockComment("""
                    /*
                    \(indent)\(unknown.context.description)
                    \(indent)*/
                    """
                )
            )

            return nil
        }
    }
    
    func generateExpressions(_ stmt: ExpressionsStatement) -> [StatementBlockProducer] {
        stmt.expressions
            .map { exp -> (SwiftSyntaxProducer) -> CodeBlockItemSyntax in
                return {
                    if $0.settings.outputExpressionTypes {
                        let type = "// type: \(exp.resolvedType ?? "<nil>")"
                        
                        $0.addExtraLeading(Trivia.lineComment(type))
                        $0.addExtraLeading(.newlines(1) + $0.indentation())
                    }
                    
                    return $0.generateExpression(exp).inCodeBlock()
                }
            }
    }
    
    func generateVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> [StatementBlockProducer] {
        if stmt.decl.isEmpty {
            return []
        }
        
        return varDeclGenerator
            .generateVariableDeclarations(stmt)
            .enumerated()
            .map { (i, decl) in
                return {
                    if $0.settings.outputExpressionTypes {
                        let declType = "// decl type: \(stmt.decl[i].type)"
                        
                        $0.addExtraLeading(Trivia.lineComment(declType))
                        $0.addExtraLeading(.newlines(1) + $0.indentation())

                        if let exp = stmt.decl[i].initialization {
                            let initType = "// init type: \(exp.resolvedType ?? "<nil>")"
                            
                            $0.addExtraLeading(Trivia.lineComment(initType))
                            $0.addExtraLeading(.newlines(1) + $0.indentation())
                        }
                    }

                    return SyntaxFactory.makeCodeBlockItem(
                        item: decl().asSyntax,
                        semicolon: nil,
                        errorTokens: nil
                    )
                }
            }
    }
    
    func generateReturn(_ stmt: ReturnStatement) -> ReturnStmtSyntax {
        ReturnStmtSyntax { builder in
            var returnToken = makeStartToken(SyntaxFactory.makeReturnKeyword)
            
            if let exp = stmt.exp {
                returnToken = returnToken.addingTrailingSpace()
                builder.useExpression(generateExpression(exp))
            }
            
            builder.useReturnKeyword(returnToken)
        }
    }
    
    func generateContinue(_ stmt: ContinueStatement) -> ContinueStmtSyntax {
        ContinueStmtSyntax { builder in
            builder.useContinueKeyword(
                makeStartToken(SyntaxFactory.makeContinueKeyword)
            )
            
            if let label = stmt.targetLabel {
                builder.useLabel(makeIdentifier(label).withLeadingSpace())
            }
        }
    }
    
    func generateBreak(_ stmt: BreakStatement) -> BreakStmtSyntax {
        BreakStmtSyntax { builder in
            builder.useBreakKeyword(makeStartToken(SyntaxFactory.makeBreakKeyword))
            
            if let label = stmt.targetLabel {
                builder.useLabel(makeIdentifier(label).withLeadingSpace())
            }
        }
    }
    
    func generateFallthrough(_ stmt: FallthroughStatement) -> FallthroughStmtSyntax {
        FallthroughStmtSyntax { builder in
            builder.useFallthroughKeyword(
                makeStartToken(SyntaxFactory.makeFallthroughKeyword)
            )
        }
    }
    
    func generateIfStmt(_ stmt: IfStatement) -> IfStmtSyntax {
        IfStmtSyntax { builder in
            if let label = stmt.label {
                builder.useLabelName(
                    prepareStartToken(SyntaxFactory.makeIdentifier(label))
                )
                
                builder.useLabelColon(SyntaxFactory.makeColonToken())
                addExtraLeading(.newlines(1) + indentation())
            }
            
            builder.useIfKeyword(
                makeStartToken(SyntaxFactory.makeIfKeyword)
                    .withTrailingSpace()
            )
            
            if let pattern = stmt.pattern {
                builder.addCondition(ConditionElementSyntax { builder in
                    builder.useCondition(OptionalBindingConditionSyntax { builder in
                        builder.useLetOrVarKeyword(
                            SyntaxFactory
                                .makeLetKeyword()
                                .withTrailingSpace()
                        )
                        
                        builder.usePattern(generatePattern(pattern))
                        
                        builder.useInitializer(InitializerClauseSyntax { builder in
                            builder.useEqual(
                                SyntaxFactory
                                    .makeEqualToken()
                                    .withTrailingSpace()
                                    .withLeadingSpace()
                            )
                            
                            builder.useValue(generateExpression(stmt.exp))
                        })
                    }.asSyntax)
                }.withTrailingSpace())
            } else {
                builder.addCondition(ConditionElementSyntax { builder in
                    builder.useCondition(
                        generateExpression(stmt.exp)
                        .asSyntax
                        .withTrailingSpace()
                    )
                })
            }
            
            builder.useBody(generateCompound(stmt.body))
            
            if let _else = stmt.elseBody {
                builder.useElseKeyword(
                    makeStartToken(SyntaxFactory.makeElseKeyword)
                        .addingSurroundingSpaces()
                )
                
                if _else.statements.count == 1, let elseIfStmt = _else.statements[0] as? IfStatement {
                    builder.useElseBody(generateIfStmt(elseIfStmt).asSyntax)
                } else {
                    builder.useElseBody(generateCompound(_else).asSyntax)
                }
            }
        }
    }
    
    func generateSwitchStmt(_ stmt: SwitchStatement) -> SwitchStmtSyntax {
        SwitchStmtSyntax { builder in
            if let label = stmt.label {
                builder.useLabelName(
                    prepareStartToken(SyntaxFactory.makeIdentifier(label))
                )
                
                builder.useLabelColon(SyntaxFactory.makeColonToken())
                addExtraLeading(.newlines(1) + indentation())
            }
            
            builder.useSwitchKeyword(
                makeStartToken(SyntaxFactory.makeSwitchKeyword)
                    .withTrailingSpace()
            )
            
            builder.useLeftBrace(
                SyntaxFactory
                    .makeLeftBraceToken()
                    .withLeadingSpace()
            )
            
            builder.useRightBrace(
                SyntaxFactory
                    .makeRightBraceToken()
                    .withLeadingTrivia(.newlines(1) + indentation())
            )
            
            builder.useExpression(generateExpression(stmt.exp))
            
            var syntaxes: [Syntax] = []
            
            for _case in stmt.cases {
                addExtraLeading(.newlines(1) + indentation())
                
                let label = generateSwitchCaseLabel(_case).asSyntax
                let switchCase
                    = generateSwitchCase(label, statements: _case.statements)
                
                syntaxes.append(switchCase.asSyntax)
            }
            
            if let _default = stmt.defaultCase {
                addExtraLeading(.newlines(1) + indentation())
                
                let label = SwitchDefaultLabelSyntax { builder in
                    builder.useDefaultKeyword(
                        makeStartToken(SyntaxFactory.makeDefaultKeyword)
                    )
                    
                    builder.useColon(SyntaxFactory.makeColonToken())
                }.asSyntax
                
                let switchCase = generateSwitchCase(label, statements: _default)
                
                syntaxes.append(switchCase.asSyntax)
            }
            
            builder.addCase(SyntaxFactory.makeSwitchCaseList(syntaxes).asSyntax)
        }
    }
    
    func generateSwitchCase(_ caseLabel: Syntax,
                            statements: [Statement]) -> SwitchCaseSyntax {
        
        SwitchCaseSyntax { builder in
            builder.useLabel(caseLabel)
            
            indent()
            defer {
                deindent()
            }
            
            let stmts = _generateStatements(statements)
            
            for stmt in stmts {
                builder.addStatement(stmt)
            }
        }
    }
    
    func generateSwitchCaseLabel(_ _case: SwitchCase) -> SwitchCaseLabelSyntax {
        SwitchCaseLabelSyntax { builder in
            builder.useCaseKeyword(
                makeStartToken(SyntaxFactory.makeCaseKeyword)
                    .withTrailingSpace()
            )
            
            builder.useColon(SyntaxFactory.makeColonToken())
            
            iterateWithComma(_case.patterns) { (item, hasComma) in
                builder.addCaseItem(CaseItemSyntax { builder in
                    builder.usePattern(generatePattern(item))
                    
                    if hasComma {
                        builder.useTrailingComma(
                            SyntaxFactory
                                .makeCommaToken()
                                .withTrailingSpace()
                        )
                    }
                })
            }
        }
    }
    
    func generateWhileStmt(_ stmt: WhileStatement) -> WhileStmtSyntax {
        WhileStmtSyntax { builder in
            if let label = stmt.label {
                builder.useLabelName(
                    prepareStartToken(SyntaxFactory.makeIdentifier(label))
                )
                
                builder.useLabelColon(SyntaxFactory.makeColonToken())
                addExtraLeading(.newlines(1) + indentation())
            }
            
            builder.useWhileKeyword(
                makeStartToken(SyntaxFactory.makeWhileKeyword)
                    .withTrailingSpace()
            )
            
            builder.addCondition(ConditionElementSyntax { builder in
                builder.useCondition(
                    generateExpression(stmt.exp)
                    .asSyntax
                    .withTrailingSpace()
                )
            })
            
            builder.useBody(generateCompound(stmt.body))
        }
    }
    
    func generateDoWhileStmt(_ stmt: DoWhileStatement) -> RepeatWhileStmtSyntax {
        RepeatWhileStmtSyntax { builder in
            if let label = stmt.label {
                builder.useLabelName(
                    prepareStartToken(SyntaxFactory.makeIdentifier(label))
                )
                
                builder.useLabelColon(SyntaxFactory.makeColonToken())
                addExtraLeading(.newlines(1) + indentation())
            }
            
            builder.useRepeatKeyword(
                makeStartToken(SyntaxFactory.makeRepeatKeyword)
                    .withTrailingSpace()
            )
            
            builder.useBody(generateCompound(stmt.body))
            builder.useWhileKeyword(
                SyntaxFactory
                    .makeWhileKeyword()
                    .addingSurroundingSpaces()
            )
            
            builder.useCondition(generateExpression(stmt.exp))
        }
    }
    
    func generateForIn(_ stmt: ForStatement) -> ForInStmtSyntax {
        ForInStmtSyntax { builder in
            if let label = stmt.label {
                builder.useLabelName(
                    prepareStartToken(SyntaxFactory.makeIdentifier(label))
                )
                
                builder.useLabelColon(SyntaxFactory.makeColonToken())
                addExtraLeading(.newlines(1) + indentation())
            }
            
            builder.useForKeyword(
                makeStartToken(SyntaxFactory.makeForKeyword)
                    .withTrailingSpace()
            )
            
            builder.useInKeyword(
                SyntaxFactory
                    .makeInKeyword()
                    .addingSurroundingSpaces()
            )
            
            builder.usePattern(generatePattern(stmt.pattern))
            builder.useSequenceExpr(generateExpression(stmt.exp).withTrailingSpace())
            builder.useBody(generateCompound(stmt.body))
        }
    }
    
    func generateDo(_ stmt: DoStatement) -> DoStmtSyntax {
        DoStmtSyntax { builder in
            if let label = stmt.label {
                builder.useLabelName(
                    prepareStartToken(SyntaxFactory.makeIdentifier(label))
                )
                
                builder.useLabelColon(SyntaxFactory.makeColonToken())
                addExtraLeading(.newlines(1) + indentation())
            }
            
            builder.useDoKeyword(
                makeStartToken(SyntaxFactory.makeDoKeyword)
                .withTrailingSpace()
            )
            builder.useBody(generateCompound(stmt.body))

            for catchBlock in stmt.catchBlocks {
                builder.addCatchClause(
                    generateCatchBlock(catchBlock)
                    .withLeadingSpace()
                )
            }
        }
    }

    func generateCatchBlock(_ catchBlock: CatchBlock) -> CatchClauseSyntax {
        CatchClauseSyntax { builder in
            builder.useCatchKeyword(
                SyntaxFactory.makeCatchKeyword()
                .withTrailingSpace()
            )
            
            if let pattern = catchBlock.pattern {
                builder.addCatchItem(
                    generateCatchItem(from: pattern)
                    .withTrailingSpace()
                )
            }

            builder.useBody(generateCompound(catchBlock.body))
        }
    }

    func generateCatchItem(from pattern: Pattern, hasComma: Bool = false) -> CatchItemSyntax {
        CatchItemSyntax { builder in
            builder.usePattern(
                generateValueBindingPattern(pattern)
                .asPatternSyntax
            )

            if hasComma {
                builder.useTrailingComma(SyntaxFactory.makeCommaToken())
            }
        }
    }
    
    func generateDefer(_ stmt: DeferStatement) -> DeferStmtSyntax {
        DeferStmtSyntax { builder in
            builder.useDeferKeyword(
                makeStartToken(SyntaxFactory.makeDeferKeyword)
                .withTrailingSpace()
            )
            builder.useBody(generateCompound(stmt.body))
        }
    }

    func generateLocalFunction(_ stmt: LocalFunctionStatement) -> FunctionDeclSyntax {
        FunctionDeclSyntax { builder in
            builder.useFuncKeyword(makeStartToken(SyntaxFactory.makeFuncKeyword).withTrailingSpace())
            builder.useIdentifier(makeIdentifier(stmt.function.identifier))
            builder.useSignature(generateSignature(stmt.function.signature).withTrailingSpace())
            builder.useBody(generateCompound(stmt.function.body))
        }
    }

    func generateThrow(_ stmt: ThrowStatement) -> ThrowStmtSyntax {
        ThrowStmtSyntax { builder in
            builder.useThrowKeyword(
                makeStartToken(SyntaxFactory.makeThrowKeyword)
                .addingTrailingSpace()
            )
            builder.useExpression(generateExpression(stmt.exp))
        }
    }
    
    func generatePattern(_ pattern: Pattern) -> PatternSyntax {
        switch pattern {
        case .identifier(let ident):
            return IdentifierPatternSyntax {
                $0.useIdentifier(makeIdentifier(ident))
            }.asPatternSyntax
            
        case .expression(let exp):
            return ExpressionPatternSyntax {
                $0.useExpression(generateExpression(exp))
            }.asPatternSyntax
            
        case .tuple(let items):
            return TuplePatternSyntax { builder in
                builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
                builder.useRightParen(SyntaxFactory.makeRightParenToken())
                
                iterateWithComma(items) { (item, hasComma) in
                    builder.addElement(
                        TuplePatternElementSyntax { builder in
                            builder.usePattern(generatePattern(item))
                            
                            if hasComma {
                                builder.useTrailingComma(SyntaxFactory
                                    .makeCommaToken()
                                    .withTrailingSpace()
                                )
                            }
                        }
                    )
                }
            }.asPatternSyntax
        }
    }
    
    func generateValueBindingPattern(_ pattern: Pattern, isConstant: Bool = true) -> ValueBindingPatternSyntax {
        ValueBindingPatternSyntax { builder in
            if isConstant {
                builder.useLetOrVarKeyword(
                    SyntaxFactory.makeLetKeyword()
                        .withTrailingSpace()
                )
            } else {
                builder.useLetOrVarKeyword(
                    SyntaxFactory.makeVarKeyword()
                        .withTrailingSpace()
                )
            }
            
            builder.useValuePattern(generatePattern(pattern))
        }
    }
}
