import SwiftAST
import SwiftSyntaxSupport
import XCTest

public func assertStatementsEqual(
    actual: Statement?,
    expected: Statement?,
    messageHeader: String = "Failed: Expected statement",
    printTypes: Bool = false,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard expected != actual else {
        return
    }

    func stringify(_ stmt: Statement?) -> String {
        guard let stmt = stmt else {
            return "<nil>"
        }

        var result: String = ""

        if printTypes {
            result = "\(type(of: stmt)): "
        }

        result += SwiftProducer.generateStatement(stmt)

        return result
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
    actual: SwiftAST.Expression?,
    expected: SwiftAST.Expression?,
    messageHeader: String = "Failed: Expected statement",
    printTypes: Bool = false,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard expected != actual else {
        return
    }

    func stringify(_ exp: SwiftAST.Expression?) -> String {
        guard let exp = exp else {
            return "<nil>"
        }

        var result: String = ""

        if printTypes {
            result = "\(type(of: exp)): "
        }

        if exp.isBlock {
            result += SwiftProducer.generateExpression(exp)
        } else {
            result += exp.description
        }

        return result
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
