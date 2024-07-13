import SwiftSyntax
import SwiftSyntaxSupport
import Utils
import MiniLexer

/// Syntax pass which spaces lines of statements based on their similarity by
/// comparing if the leading identifier on the expression line (ignoring 'self.')
/// matches the identifier from the previous line.
public class StatementSpacingSyntaxPass: SwiftSyntaxRewriterPass {
    public init() {
        
    }
    
    public func rewrite(_ file: SourceFileSyntax) -> SourceFileSyntax {
        let rewriter = InnerSyntaxRewriter()
        return rewriter.visit(file).as(SourceFileSyntax.self) ?? file
    }
}

private class InnerSyntaxRewriter: SyntaxRewriter {
    override func visit(_ node: CodeBlockItemListSyntax) -> CodeBlockItemListSyntax {
        var statements = super.visit(node).as(CodeBlockItemListSyntax.self)!
        
        let ranges = rangeOfExpressionStatements(in: node)
        statements = separateExpressions(in: statements, ranges: ranges)

        let result = ranges.reduce(statements) { stmts, range in
            analyzeRange(range, in: stmts)
        }
        
        return result
    }
    
    func separateExpressions(
        in statements: CodeBlockItemListSyntax,
        ranges: [Range<Int>]
    ) -> CodeBlockItemListSyntax {
        
        var statements = statements
        
        // Add leading line breaks between expression sequence boundaries, making
        // sure expressions are always separated by at least one empty line from
        // other statement kinds
        for range in ranges {
            let rangeStart = statements.index(statements.startIndex, offsetBy: range.lowerBound)
            let rangeEnd = statements.index(statements.startIndex, offsetBy: range.upperBound)
            
            if range.lowerBound > 0 {
                statements = statements.with(
                    \.[statements.index(statements.startIndex, offsetBy: range.lowerBound)],
                    CodeBlockItemSyntax(SetEmptyLineLeadingTrivia().visit(statements[rangeStart]))!
                )
            }
            
            if statements.count > range.upperBound {
                statements = statements.with(
                    \.[statements.index(statements.startIndex, offsetBy: range.upperBound)],
                    CodeBlockItemSyntax(SetEmptyLineLeadingTrivia().visit(statements[rangeEnd]))!
                )
            }
        }
        
        return statements
    }
    
    func analyzeRange(_ range: Range<Int>, in stmts: CodeBlockItemListSyntax) -> CodeBlockItemListSyntax {
        if range.count < 4 {
            return stmts
        }
        
        var stmts = stmts
        let rangeStart = stmts.index(stmts.startIndex, offsetBy: range.lowerBound)
        let rangeEnd = stmts.index(stmts.startIndex, offsetBy: range.upperBound)
        let expressions = stmts[rangeStart..<rangeEnd]
        
        func addLineSpace(_ block: CodeBlockItemSyntax, _ index: CodeBlockItemListSyntax.Index) {
            let childIndex = stmts.distance(from: stmts.startIndex, to: index)
            
            stmts = stmts.with(
                \.[stmts.index(stmts.startIndex, offsetBy: childIndex)],
                CodeBlockItemSyntax(SetEmptyLineLeadingTrivia().visit(block))!
            )
        }
        
        var currentIdent: String? = identInStmt(stmts[rangeStart])
        
        for i in 1..<expressions.count {
            let index = expressions.index(expressions.startIndex, offsetBy: i)
            let curr = expressions[index]
            
            let nextIdent = identInStmt(curr)
            
            if currentIdent != nextIdent {
                currentIdent = nextIdent
                addLineSpace(curr, index)
            }
        }
        
        return stmts
    }
    
    func identInStmt(_ stmt: CodeBlockItemSyntax) -> String? {
        let desc = stmt.trimmed.description
        
        let lexer = Lexer(input: desc)
        lexer.skipWhitespace()
        guard lexer.safeNextCharPasses(with: { Lexer.isLetter($0) || $0 == "_" }) else {
            return nil
        }
        
        var str = lexer.consumeString { lex in
            lex.advance(while: { Lexer.isAlphanumeric($0) || $0 == "_" })
        }
        
        // Attempt to consume property after 'self'
        if str == "self" {
            if lexer.advanceIf(equals: ".") {
                str = lexer.consumeString { lex in
                    lex.advance(while: { Lexer.isAlphanumeric($0) || $0 == "_" })
                }
            }
        }
        
        return str.isEmpty ? nil : String(str)
    }
    
    /// Returns a list of indexes which represent running sequences of expression
    /// statements.
    /// The return is such that the list of ranges overlaps exactly all top-level
    /// expression statements found on the input code block item list.
    func rangeOfExpressionStatements(in statements: CodeBlockItemListSyntax) -> [Range<Int>] {
        // Start scanning the statements, and whenever we reach an expression,
        // start counting until we hit another non-expression statement; the final
        // range between the start of the scan and the current non-expression
        // statement is the range of expressions (non-inclusive)
        var currentRangeStart: Int?
        var ranges: [Range<Int>] = []
        
        for (i, stmt) in statements.enumerated() {
            if stmt.item.is(ExprSyntax.self) {
                currentRangeStart = currentRangeStart ?? i
            } else if let current = currentRangeStart {
                ranges.append(current..<i)
                currentRangeStart = nil
            }
        }
        
        // Found an open range- actual range is all remaining statements from
        // where the counting started.
        if let currentRangeStart = currentRangeStart {
            ranges.append(currentRangeStart..<statements.count)
        }
        
        return ranges
    }
    
    private class SetEmptyLineLeadingTrivia: SyntaxRewriter {
        var isFirstVisit: Bool = true
        
        override func visit(_ token: TokenSyntax) -> TokenSyntax {
            if isFirstVisit {
                isFirstVisit = false
                let trivia = .newlines(2)
                    + indentation(for: token)
                    + removingLeadingWhitespace(token.leadingTrivia)
                
                return token.with(\.leadingTrivia, trivia)
            }
            
            return token
        }
    }
}

// Returns only the indentation of a given token's leading trivia
private func indentation(for token: TokenSyntax) -> Trivia {
    var leading: Trivia = []
    for trivia in token.leadingTrivia {
        switch trivia {
        case .spaces, .tabs:
            leading = leading.appending(trivia)
        // Reset on newlines
        case .newlines:
            leading = []
        default:
            continue
        }
    }
    
    return leading
}

private func removingLeadingWhitespace(_ trivia: Trivia) -> Trivia {
    let newTrivia = trivia.drop { piece in
        switch piece {
        case .spaces, .tabs, .newlines, .carriageReturns, .carriageReturnLineFeeds,
             .formfeeds, .verticalTabs:
            return true
        default:
            return false
        }
    }
    
    return Trivia(pieces: Array(newTrivia))
}
