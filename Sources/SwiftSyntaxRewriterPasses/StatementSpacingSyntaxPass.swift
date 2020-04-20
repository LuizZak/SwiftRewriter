import SwiftSyntax
import SwiftSyntaxSupport
import Utils

/// Syntax pass which spaces lines of statements based on their similarity
public class StatementSpacingSyntaxPass: SwiftSyntaxRewriterPass {
    public init() {
        
    }
    
    public func rewrite(_ file: SourceFileSyntax) -> SourceFileSyntax {
        let rewriter = InnerSyntaxRewriter()
        return SourceFileSyntax(rewriter.visit(file)) ?? file
    }
}

private class InnerSyntaxRewriter: SyntaxRewriter {
    override func visit(_ node: CodeBlockSyntax) -> Syntax {
        var statements = node.statements
        
        // Get long-running sequences of expressions to separate
        let ranges = rangeOfExpressionStatements(in: node.statements)
        
        // Add leading line breaks between expression sequence boundaries, making
        // sure expressions are always separated by at least one empty line from
        // other statement kinds
        for range in ranges {
            let rangeStart = statements.index(statements.startIndex, offsetBy: range.lowerBound)
            let rangeEnd = statements.index(statements.startIndex, offsetBy: range.upperBound)
            
            if range.lowerBound > 0 {
                statements = statements.replacing(
                    childAt: range.lowerBound,
                    with: CodeBlockItemSyntax(SetEmptyLineLeadingTrivia().visit(statements[rangeStart]))!
                )
            }
            
            if statements.count > range.upperBound {
                statements = statements.replacing(
                    childAt: range.upperBound,
                    with: CodeBlockItemSyntax(SetEmptyLineLeadingTrivia().visit(statements[rangeEnd]))!
                )
            }
        }
        
        return Syntax(ranges.reduce(node) { node, range in
            node.withStatements(analyzeRange(range, in: statements))
        })
    }
    
    func analyzeRange(_ range: Range<Int>, in stmts: CodeBlockItemListSyntax) -> CodeBlockItemListSyntax {
        if range.count < 4 {
            return stmts
        }
        
        var stmts = stmts
        let rangeStart = stmts.index(stmts.startIndex, offsetBy: range.lowerBound)
        let rangeEnd = stmts.index(stmts.startIndex, offsetBy: range.upperBound)
        let expressions = stmts[rangeStart..<rangeEnd]
        
        // Indexed distances between string of expression at [x] and [x + 1]
        let distance: [Int] =
            expressions
                .enumerated()
                .dropLast()
                .map { (arg) -> Int in
                    let (i, exp) = arg
                    
                    let newIndex = expressions.index(expressions.startIndex, offsetBy: i + 1)
                    
                    return Levenshtein.distanceBetween(
                        exp.description,
                        and: expressions[newIndex].description
                    )
                }
        
        for i in 1..<(expressions.count - 1) {
            let fromLast = distance[i - 1]
            let toNext = distance[i]
            
            // If we have too sharp of an increase of the distance between the
            // last and next expressions, add an empty line between the current
            // and next expressions
            if abs(fromLast - toNext) > 2 {
                let newIndex = expressions.index(expressions.startIndex, offsetBy: i + 1)
                
                let next = expressions[newIndex]
                let childIndex = stmts.distance(from: stmts.startIndex, to: newIndex)
                
                stmts = stmts.replacing(
                    childAt: childIndex,
                    with: CodeBlockItemSyntax(SetEmptyLineLeadingTrivia().visit(next))!
                )
            }
        }
        
        return stmts
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
        
        override func visit(_ token: TokenSyntax) -> Syntax {
            if isFirstVisit {
                isFirstVisit = false
                return Syntax(token.withLeadingTrivia(.newlines(2) + indentation(for: token) + removingLeadingWhitespace(token.leadingTrivia)))
            }
            
            return Syntax(token)
        }
    }
}

// Returns only the indentation of a given token's leading trivia
private func indentation(for token: TokenSyntax) -> Trivia {
    var leading: Trivia = .zero
    for trivia in token.leadingTrivia {
        switch trivia {
        case .spaces, .tabs:
            leading = leading.appending(trivia)
        // Reset on newlines
        case .newlines:
            leading = .zero
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
