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
                extraLeading = .newlines(1) + indentation()
                
                let stmtSyntax = generateStatement(stmt)
                
                for item in stmtSyntax {
                    builder.addCodeBlockItem(item)
                }
            }
        }
    }
    
    func generateStatement(_ stmt: Statement) -> [CodeBlockItemSyntax] {
        switch stmt {
        case let stmt as ReturnStatement:
            return [generateReturn(stmt).inCodeBlock()]
            
        case let stmt as ExpressionsStatement:
            return generateExpressions(stmt)
            
        case let stmt as IfStatement:
            return [generateIfStmt(stmt).inCodeBlock()]
            
        default:
            return [SyntaxFactory.makeBlankExpressionStmt().inCodeBlock()]
        }
    }
    
    private func generateExpressions(_ stmt: ExpressionsStatement) -> [CodeBlockItemSyntax] {
        return stmt.expressions
            .map(generateExpression)
            .map { SyntaxFactory.makeCodeBlockItem(item: $0, semicolon: nil) }
    }
    
    private func generateReturn(_ stmt: ReturnStatement) -> ReturnStmtSyntax {
        return ReturnStmtSyntax { builder in
            var returnToken = makeStartToken(SyntaxFactory.makeReturnKeyword)
            
            if let exp = stmt.exp {
                returnToken = returnToken.addingTrailingSpace()
                builder.useExpression(generateExpression(exp))
            }
            
            builder.useReturnKeyword(returnToken)
        }
    }
    
    private func generateIfStmt(_ stmt: IfStatement) -> IfStmtSyntax {
        return IfStmtSyntax { builder in
            builder.useIfKeyword(makeStartToken(SyntaxFactory.makeIfKeyword).withTrailingSpace())
            
            if let pattern = stmt.pattern {
                builder.addConditionElement(ConditionElementSyntax { builder in
                    builder.useCondition(OptionalBindingConditionSyntax { builder in
                        builder.usePattern(generatePattern(pattern))
                    })
                })
            } else {
                builder.addConditionElement(ConditionElementSyntax { builder in
                    builder.useCondition(generateExpression(stmt.exp))
                })
            }
            
            builder.useBody(generateCompound(stmt.body))
            
            if let _else = stmt.elseBody {
                builder.useElseKeyword(SyntaxFactory.makeElseKeyword())
                builder.useElseBody(generateCompound(_else))
            }
        }
    }
    
    private func generatePattern(_ pattern: Pattern) -> PatternSyntax {
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
