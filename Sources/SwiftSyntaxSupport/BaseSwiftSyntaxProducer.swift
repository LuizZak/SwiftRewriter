import SwiftSyntax

public class BaseSwiftSyntaxProducer {
    var spacesInIndentation: Int = 4
    var indentationLevel: Int = 0
    
    var extraLeading: Trivia?
    
    let modifiersDecorations =
        ModifiersSyntaxDecoratorApplier
            .makeDefaultDecoratorApplier()
    
    func indentation() -> Trivia {
        return indentationLevel == 0
            ? .zero
            : Trivia.spaces(indentationLevel * spacesInIndentation)
    }
    
    func indentationString() -> String {
        var trivia = ""
        for piece in indentation() {
            piece.write(to: &trivia)
        }
        return trivia
    }
    
    func indent() {
        indentationLevel += 1
    }
    func deindent() {
        indentationLevel -= 1
    }
    
    func addExtraLeading(_ trivia: Trivia) {
        if let lead = extraLeading {
            extraLeading = lead + trivia
        } else {
            extraLeading = trivia
        }
    }
}

// MARK: - Utilities
extension BaseSwiftSyntaxProducer {
    
    func makeStartToken(_ builder: (_ leading: Trivia, _ trailing: Trivia) -> TokenSyntax) -> TokenSyntax {
        prepareStartToken(builder([], []))
    }
    
    func prepareStartToken(_ token: TokenSyntax) -> TokenSyntax {
        token.withExtraLeading(consuming: &extraLeading)
    }
    
    func iterating<T>(_ elements: [T],
                      inBetweenSpacing: Trivia = .newlines(1),
                      postSeparator: Trivia = .newlines(2),
                      do block: (T) -> Void) {
        
        for (i, item) in elements.enumerated() {
            if i > 0 {
                extraLeading = inBetweenSpacing
            }
            
            block(item)
        }
        
        if !elements.isEmpty {
            extraLeading = postSeparator
        }
    }
}
