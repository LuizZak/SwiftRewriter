import SwiftSyntax
import IDEUtils
import Console

internal class ColorizeSyntaxVisitor: SyntaxVisitor {
    fileprivate typealias Segment = (text: String, color: ConsoleColor?)

    private var _currentColor: ConsoleColor?
    private let _printFunction: (String, ConsoleColor?) -> Void

    var commentColor: ConsoleColor = .green
    var keywordColor: ConsoleColor = .magenta
    var attributeColor: ConsoleColor = .magenta
    var numberLiteralColor: ConsoleColor = .blue
    var stringLiteralColor: ConsoleColor = .red
    var directiveColor: ConsoleColor = .red
    var typeNameColor: ConsoleColor = .blue
    var identifierColor: ConsoleColor = .cyan

    init(printFunction: @escaping (String, ConsoleColor?) -> Void) {
        self._printFunction = printFunction

        super.init(viewMode: .sourceAccurate)
    }

    override func visit(_ node: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        for segment in _splitIntoSegments(node, classification: .stringLiteral).merged() {
            _printFunction(segment.text, segment.color)
        }

        return .skipChildren
    }

    override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
        for segment in _splitIntoSegments(token, color: _currentColor).merged() {
            _printFunction(segment.text, segment.color)
        }

        return .visitChildren
    }

    /// Splits a given token to distinct colorized substring ranges of leading,
    /// token text, and trailing components.
    private func _splitIntoSegments(_ token: TokenSyntax, color: ConsoleColor?) -> [Segment] {
        let classificationColor = colorForClassification(token.tokenClassification.kind)

        // Split token into leading - content - trailing and print in separate
        // parts.
        let content = token.withoutTrivia().description

        return _wrapTrivias(
            leading: token.leadingTrivia,
            (content, color ?? classificationColor),
            trailing: token.trailingTrivia,
            color: color
        )
    }

    /// Splits a given token to distinct colorized substring ranges of leading,
    /// token text, and trailing components.
    private func _splitIntoSegments(_ syntax: SyntaxProtocol, classification: SyntaxClassification?) -> [Segment] {
        let classificationColor = classification.flatMap(colorForClassification)

        // Split token into leading - content - trailing and print in separate
        // parts.
        let content = syntax.withoutTrivia().description

        return _wrapTrivias(
            leading: syntax.leadingTrivia,
            (content, _currentColor ?? classificationColor),
            trailing: syntax.trailingTrivia,
            color: _currentColor
        )
    }

    private func _wrapTrivias(leading: Trivia?, _ segment: Segment, trailing: Trivia?, color: ConsoleColor?) -> [Segment] {
        var segments: [Segment] = []

        if let leading = leading {
            segments.append(contentsOf: _colorizeTrivia(leading, color: color))
        }
        segments.append(segment)
        if let trailing = trailing {
            segments.append(contentsOf: _colorizeTrivia(trailing, color: color))
        }

        return segments
    }

    /// Perform colorization of a given trivia.
    private func _colorizeTrivia(_ trivia: Trivia, color: ConsoleColor?) -> [Segment] {
        trivia.map { piece in
            var text = ""
            piece.write(to: &text)

            switch piece {
            case .blockComment, .lineComment, .docBlockComment, .docLineComment:
                return (text, color ?? commentColor)
            default:
                return (text, color)
            }
        }
    }

    private func colorForClassification(_ classification: SyntaxClassification) -> ConsoleColor? {
        switch classification {
        case .keyword:
            return keywordColor

        case .integerLiteral, .floatingLiteral:
            return numberLiteralColor

        case .stringLiteral:
            return stringLiteralColor

        case .poundDirectiveKeyword:
            return directiveColor

        case .identifier:
            return identifierColor

        case .typeIdentifier:
            return typeNameColor

        default:
            return nil
        }
    }
}

private extension Array where Element == ColorizeSyntaxVisitor.Segment {
    /// Merges runs of segments where the colors are exactly equal.
    func merged() -> [Element] {
        var merged: [Element] = []
        var current = first

        for next in self.dropFirst() {
            if let c = current {
                if c.color == next.color {
                    current = (c.text + next.text, next.color)
                } else {
                    merged.append(c)

                    current = next
                }
            } else {
                current = next
            }
        }

        if let current = current {
            merged.append(current)
        }

        return merged
    }
}
