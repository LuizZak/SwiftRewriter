import SwiftSyntax
import Intentions
import SwiftAST

extension SwiftSyntaxProducer {
    func generateCompound(_ compoundStmt: CompoundStatement) -> CodeBlockSyntax {
        return CodeBlockSyntax { builder in
            builder.useLeftBrace(SyntaxFactory.makeLeftBraceToken().withLeadingSpace())
            builder.useRightBrace(SyntaxFactory.makeRightBraceToken().onNewline().addingLeadingTrivia(indentation()))
            
            indent()
            defer {
                deindent()
            }
            
            for stmt in compoundStmt {
                let stmtSyntax = generateStatement(stmt)
                
                for item in stmtSyntax {
                    addExtraLeading(.newlines(1) + indentation())
                    builder.addCodeBlockItem(item())
                }
            }
        }
    }
    
    func _generateStatements(_ stmt: [Statement]) -> [CodeBlockItemSyntax] {
        var items: [CodeBlockItemSyntax] = []
        
        for stmt in stmt {
            let stmtSyntax = generateStatement(stmt)
            
            for item in stmtSyntax {
                addExtraLeading(.newlines(1) + indentation())
                items.append(item())
            }
        }
        
        return items
    }
    
    // TODO: Support for labeling in statements
    func generateStatement(_ stmt: Statement) -> [() -> CodeBlockItemSyntax] {
        switch stmt {
        case let stmt as ReturnStatement:
            return [{ self.generateReturn(stmt).inCodeBlock() }]
            
        case let stmt as ContinueStatement:
            return [{ self.generateContinue(stmt).inCodeBlock() }]
            
        case let stmt as BreakStatement:
            return [{ self.generateBreak(stmt).inCodeBlock() }]
            
        case let stmt as FallthroughStatement:
            return [{ self.generateFallthrough(stmt).inCodeBlock() }]
            
        case let stmt as ExpressionsStatement:
            return generateExpressions(stmt)
            
        case let stmt as VariableDeclarationsStatement:
            return generateVariableDeclarations(stmt)
            
        case let stmt as IfStatement:
            return [{ self.generateIfStmt(stmt).inCodeBlock() }]
            
        case let stmt as SwitchStatement:
            return [{ self.generateSwitchStmt(stmt).inCodeBlock() }]
            
        case let stmt as WhileStatement:
            return [{ self.generateWhileStmt(stmt).inCodeBlock() }]
            
        case let stmt as DoWhileStatement:
            return [{ self.generateDoWhileStmt(stmt).inCodeBlock() }]
            
        case let stmt as ForStatement:
            return [{ self.generateForIn(stmt).inCodeBlock() }]
            
        case let stmt as DeferStatement:
            return [{ self.generateDefer(stmt).inCodeBlock() }]
            
        case is CompoundStatement:
            fatalError("Use generateCompound(_:) to generate syntaxes for compound statements")
            
        case is UnknownStatement:
            return [{ SyntaxFactory.makeBlankUnknownStmt().inCodeBlock() }]
            
        default:
            return [{ SyntaxFactory.makeBlankExpressionStmt().inCodeBlock() }]
        }
    }
    
    func generateExpressions(_ stmt: ExpressionsStatement) -> [() -> CodeBlockItemSyntax] {
        return stmt.expressions
            .map { exp -> () -> CodeBlockItemSyntax in
                return {
                    if self.settings.outputExpressionTypes {
                        self.addExtraLeading(Trivia.lineComment("// type: \(exp.resolvedType ?? "<nil>")"))
                        self.addExtraLeading(.newlines(1))
                        self.addExtraLeading(self.indentation())
                    }
                    
                    return SyntaxFactory.makeCodeBlockItem(item: self.generateExpression(exp), semicolon: nil)
                }
            }
    }
    
    func generateVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> [() -> CodeBlockItemSyntax] {
        return stmt.decl
            .map { decl -> () -> CodeBlockItemSyntax in
                return { SyntaxFactory.makeCodeBlockItem(item: self.generateVariableDecl(decl), semicolon: nil) }
            }
    }
    
    func generateVariableDecl(_ decl: StatementVariableDeclaration) -> VariableDeclSyntax {
        return generateVariableDecl(name: decl.identifier,
                                    storage: decl.storage,
                                    attributes: [],
                                    modifiers: [],
                                    initialization: decl.initialization)
    }
    
    func generateReturn(_ stmt: ReturnStatement) -> ReturnStmtSyntax {
        return ReturnStmtSyntax { builder in
            var returnToken = makeStartToken(SyntaxFactory.makeReturnKeyword)
            
            if let exp = stmt.exp {
                returnToken = returnToken.addingTrailingSpace()
                builder.useExpression(generateExpression(exp))
            }
            
            builder.useReturnKeyword(returnToken)
        }
    }
    
    func generateContinue(_ stmt: ContinueStatement) -> ContinueStmtSyntax {
        return ContinueStmtSyntax { builder in
            builder.useContinueKeyword(makeStartToken(SyntaxFactory.makeContinueKeyword))
            
            if let label = stmt.targetLabel {
                builder.useLabel(makeIdentifier(label).withLeadingSpace())
            }
        }
    }
    
    func generateBreak(_ stmt: BreakStatement) -> BreakStmtSyntax {
        return BreakStmtSyntax { builder in
            builder.useBreakKeyword(makeStartToken(SyntaxFactory.makeBreakKeyword))
            
            if let label = stmt.targetLabel {
                builder.useLabel(makeIdentifier(label).withLeadingSpace())
            }
        }
    }
    
    func generateFallthrough(_ stmt: FallthroughStatement) -> FallthroughStmtSyntax {
        return FallthroughStmtSyntax { builder in
            builder.useFallthroughKeyword(makeStartToken(SyntaxFactory.makeFallthroughKeyword))
        }
    }
    
    func generateIfStmt(_ stmt: IfStatement) -> IfStmtSyntax {
        return IfStmtSyntax { builder in
            builder.useIfKeyword(makeStartToken(SyntaxFactory.makeIfKeyword).withTrailingSpace())
            
            if let pattern = stmt.pattern {
                builder.addConditionElement(ConditionElementSyntax { builder in
                    builder.useCondition(OptionalBindingConditionSyntax { builder in
                        builder.useLetOrVarKeyword(SyntaxFactory.makeLetKeyword().withTrailingSpace())
                        
                        builder.usePattern(generatePattern(pattern))
                        
                        builder.useInitializer(InitializerClauseSyntax { builder in
                            builder.useEqual(SyntaxFactory.makeEqualToken().withTrailingSpace().withLeadingSpace())
                            builder.useValue(generateExpression(stmt.exp))
                        })
                    })
                })
            } else {
                builder.addConditionElement(ConditionElementSyntax { builder in
                    builder.useCondition(generateExpression(stmt.exp))
                })
            }
            
            builder.useBody(generateCompound(stmt.body))
            
            if let _else = stmt.elseBody {
                builder.useElseKeyword(makeStartToken(SyntaxFactory.makeElseKeyword).addingLeadingSpace())
                builder.useElseBody(generateCompound(_else))
            }
        }
    }
    
    func generateSwitchStmt(_ stmt: SwitchStatement) -> SwitchStmtSyntax {
        return SwitchStmtSyntax { builder in
            builder.useSwitchKeyword(makeStartToken(SyntaxFactory.makeSwitchKeyword).withTrailingSpace())
            builder.useLeftBrace(SyntaxFactory.makeLeftBraceToken().withLeadingSpace())
            builder.useRightBrace(SyntaxFactory.makeRightBraceToken().withLeadingTrivia(.newlines(1) + indentation()))
            builder.useExpression(generateExpression(stmt.exp))
            
            var syntaxes: [Syntax] = []
            
            for _case in stmt.cases {
                addExtraLeading(.newlines(1) + indentation())
                
                let label = generateSwitchCaseLabel(_case)
                syntaxes.append(generateSwitchCase(label, statements: _case.statements))
            }
            
            if let _default = stmt.defaultCase {
                addExtraLeading(.newlines(1) + indentation())
                
                let label = SwitchDefaultLabelSyntax { builder in
                    builder.useDefaultKeyword(makeStartToken(SyntaxFactory.makeDefaultKeyword))
                    builder.useColon(SyntaxFactory.makeColonToken())
                }
                syntaxes.append(generateSwitchCase(label, statements: _default))
            }
            
            builder.addSyntax(SyntaxFactory.makeSwitchCaseList(syntaxes))
        }
    }
    
    func generateSwitchCase(_ caseLabel: Syntax, statements: [Statement]) -> SwitchCaseSyntax {
        return SwitchCaseSyntax { builder in
            builder.useLabel(caseLabel)
            
            indent()
            defer {
                deindent()
            }
            
            let stmts = _generateStatements(statements)
            
            for stmt in stmts {
                builder.addCodeBlockItem(stmt)
            }
        }
    }
    
    func generateSwitchCaseLabel(_ _case: SwitchCase) -> SwitchCaseLabelSyntax {
        return SwitchCaseLabelSyntax { builder in
            builder.useCaseKeyword(makeStartToken(SyntaxFactory.makeCaseKeyword).withTrailingSpace())
            builder.useColon(SyntaxFactory.makeColonToken())
            
            iterateWithComma(_case.patterns) { (item, hasComma) in
                builder.addCaseItem(CaseItemSyntax { builder in
                    builder.usePattern(generatePattern(item))
                    
                    if hasComma {
                        builder.useTrailingComma(SyntaxFactory.makeCommaToken().withTrailingSpace())
                    }
                })
            }
        }
    }
    
    func generateWhileStmt(_ stmt: WhileStatement) -> WhileStmtSyntax {
        return WhileStmtSyntax { builder in
            builder.useWhileKeyword(makeStartToken(SyntaxFactory.makeWhileKeyword).withTrailingSpace())
            
            builder.addConditionElement(ConditionElementSyntax { builder in
                builder.useCondition(generateExpression(stmt.exp))
            })
            
            builder.useBody(generateCompound(stmt.body))
        }
    }
    
    func generateDoWhileStmt(_ stmt: DoWhileStatement) -> RepeatWhileStmtSyntax {
        return RepeatWhileStmtSyntax { builder in
            builder.useRepeatKeyword(makeStartToken(SyntaxFactory.makeRepeatKeyword))
            builder.useWhileKeyword(SyntaxFactory.makeWhileKeyword().addingSurroundingSpaces())
            
            builder.useBody(generateCompound(stmt.body))
            builder.useCondition(generateExpression(stmt.exp))
        }
    }
    
    func generateForIn(_ stmt: ForStatement) -> ForInStmtSyntax {
        return ForInStmtSyntax { builder in
            builder.useForKeyword(makeStartToken(SyntaxFactory.makeForKeyword).withTrailingSpace())
            builder.useInKeyword(SyntaxFactory.makeInKeyword().addingSurroundingSpaces())
            builder.useBody(generateCompound(stmt.body))
            builder.usePattern(generatePattern(stmt.pattern))
            builder.useSequenceExpr(generateExpression(stmt.exp))
        }
    }
    
    func generateDo(_ stmt: DoStatement) -> DoStmtSyntax {
        return DoStmtSyntax { builder in
            builder.useDoKeyword(makeStartToken(SyntaxFactory.makeDoKeyword))
            builder.useBody(generateCompound(stmt.body))
        }
    }
    
    func generateDefer(_ stmt: DeferStatement) -> DeferStmtSyntax {
        return DeferStmtSyntax { builder in
            builder.useDeferKeyword(makeStartToken(SyntaxFactory.makeDeferKeyword))
            builder.useBody(generateCompound(stmt.body))
        }
    }
    
    func generatePattern(_ pattern: Pattern) -> PatternSyntax {
        switch pattern {
        case .identifier(let ident):
            return IdentifierPatternSyntax { $0.useIdentifier(makeIdentifier(ident)) }
            
        case .expression(let exp):
            return ExpressionPatternSyntax { $0.useExpression(generateExpression(exp)) }
            
        case .tuple(let items):
            return TuplePatternSyntax { builder in
                builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
                builder.useRightParen(SyntaxFactory.makeRightParenToken())
                
                iterateWithComma(items, postSeparator: []) { (item, hasComma) in
                    builder.addTuplePatternElement(
                        TuplePatternElementSyntax { builder in
                            builder.usePattern(generatePattern(item))
                            
                            if hasComma {
                                builder.useTrailingComma(SyntaxFactory
                                    .makeCommaToken()
                                    .withTrailingSpace())
                            }
                        }
                    )
                }
            }
        }
    }
}

private extension ExprSyntax {
    func inCodeBlock() -> CodeBlockItemSyntax {
        return CodeBlockItemSyntax { $0.useItem(self) }
    }
}

private extension StmtSyntax {
    func inCodeBlock() -> CodeBlockItemSyntax {
        return CodeBlockItemSyntax { $0.useItem(self) }
    }
}
