import SwiftAST
import XCTest

class StatementTests: XCTestCase {
    func testCreatingCompoundStatementWithLiteralProperlySetsParents() {
        let brk = BreakStatement()
        let stmt: CompoundStatement = [
            brk
        ]

        XCTAssert(brk.parent === stmt)
    }

    func testIsLabelableStatementType() {
        XCTAssertFalse(Statement.break().isLabelableStatementType)
        XCTAssertFalse(Statement.continue().isLabelableStatementType)
        XCTAssertFalse(Statement.compound([]).isLabelableStatementType)
        XCTAssertFalse(Statement.defer([]).isLabelableStatementType)
        XCTAssertFalse(Statement.expressions([]).isLabelableStatementType)
        XCTAssertFalse(Statement.fallthrough.isLabelableStatementType)
        XCTAssertFalse(Statement.return(.constant(.nil)).isLabelableStatementType)
        XCTAssertFalse(Statement.unknown(UnknownASTContext(context: "")).isLabelableStatementType)
        XCTAssertFalse(Statement.variableDeclarations([]).isLabelableStatementType)

        XCTAssertTrue(Statement.do([]).isLabelableStatementType)
        XCTAssertTrue(Statement.repeatWhile(.constant(true), body: []).isLabelableStatementType)
        XCTAssertTrue(
            Statement.for(.expression(.constant(true)), .constant(true), body: [])
                .isLabelableStatementType
        )
        XCTAssertTrue(Statement.if(.constant(true), body: [], else: nil).isLabelableStatementType)
        XCTAssertTrue(
            Statement.switch(.constant(true), cases: [], default: nil).isLabelableStatementType
        )
        XCTAssertTrue(Statement.while(.constant(true), body: []).isLabelableStatementType)
    }
}
