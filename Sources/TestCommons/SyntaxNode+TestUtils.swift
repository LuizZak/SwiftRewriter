import SwiftAST
import SwiftSyntaxSupport
import XCTest

public func assertStatementsEqual(
    actual: Statement?,
    expected: Statement?,
    messageHeader: String = "Failed: Expected statement",
    file: StaticString = #file,
    line: UInt = #line
) {
    guard expected != actual else {
        return
    }

    let producer = SwiftSyntaxProducer()

    func stringify(_ stmt: Statement?) -> String {
        guard let stmt = stmt else {
            return "<nil>"
        }
        
        return producer.generateStatement(stmt).description
    }

    var expString = ""
    var resString = ""

    expString = stringify(expected) + "\n"
    resString = stringify(actual) + "\n"

    // Dump extra information for debug purposes if the string representation of
    // the syntax nodes match.
    if expString == resString {
        dump(expected, to: &expString)
        dump(actual, to: &resString)
    }

    XCTFail(
        """
        \(messageHeader)

        \(expString)

        but received

        \(resString)
        """,
        file: file,
        line: line
    )
}

public func assertExpressionsEqual(
    actual: Expression?,
    expected: Expression?,
    messageHeader: String = "Failed: Expected statement",
    file: StaticString = #file,
    line: UInt = #line
) {
    guard expected != actual else {
        return
    }

    let producer = SwiftSyntaxProducer()

    func stringify(_ exp: Expression?) -> String {
        guard let exp = exp else {
            return "<nil>"
        }

        if exp.isBlock {
            return producer.generateExpression(exp).description
        }

        return exp.description
    }

    var expString = ""
    var resString = ""

    expString = stringify(expected) + "\n"
    resString = stringify(actual) + "\n"

    // Dump extra information for debug purposes if the string representation of
    // the syntax nodes match.
    if expString == resString {
        dump(expected, to: &expString)
        dump(actual, to: &resString)
    }

    XCTFail(
        """
        \(messageHeader)

        \(expString)

        but received

        \(resString)
        """,
        file: file,
        line: line
    )
}
