import SwiftAST
import SwiftSyntax

struct LabeledStmtBuilder {
    /// Static constructor for unlabeled statements.
    static var unlabeled: LabeledStmtBuilder = .init(label: nil)

    var label: (TokenSyntax, labelText: String, colon: TokenSyntax)?

    init(label: (TokenSyntax, labelText: String, colon: TokenSyntax)? = nil) {
        self.label = label
    }

    init(labelToken: TokenSyntax, labelText: String, colon: TokenSyntax = .colonToken()) {
        self.label = (labelToken, labelText, colon)
    }

    func buildSyntax<S: StmtSyntaxProtocol>(_ syntax: S) -> StmtSyntax {
        guard let (labelToken, labelText, colon) = label else {
            return syntax.asStmtSyntax
        }

        return LabeledStmtSyntax(
            leadingTrivia: labelToken.leadingTrivia,
            label: .identifier(labelText),
            colon: colon,
            statement: syntax
        ).asStmtSyntax
    }

    static func wrapStatement<S: Statement>(producer: SwiftSyntaxProducer, _ stmt: S, _ generator: () -> any StmtSyntaxProtocol) -> StmtSyntax {
        guard let label = stmt.label else {
            return generator().asStmtSyntax
        }

        let labeledStatement: LabeledStmtBuilder
        labeledStatement = .init(labelToken: producer.prepareStartToken(.identifier(label)), labelText: label)

        producer.addExtraLeading(.newlines(1) + producer.indentation())

        return labeledStatement.buildSyntax(generator())
    }
}
