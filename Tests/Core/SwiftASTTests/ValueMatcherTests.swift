import SwiftAST
import XCTest

class ValueMatcherTests: XCTestCase {

    func testMatchKeypath() {
        let sut =
            ValueMatcher<TestNodeWithField>()
            .keyPath(\.field, equals: 0)
        let testNode = TestNodeWithField(field: 0)

        XCTAssert(sut.matches(testNode))
        XCTAssert(testNode.didGetField)
    }

    func testMatchKeypathFalse() {
        let sut =
            ValueMatcher<TestNodeWithField>()
            .keyPath(\.field, equals: 0)
        let testNode = TestNodeWithField(field: 1)

        XCTAssertFalse(sut.matches(testNode))
    }

    func testMatchKeypathInvokesGetter() {
        let sut =
            ValueMatcher<TestNodeWithField>()
            .keyPath(\.field, equals: 0)
        let testNode = TestNodeWithField(field: 0)

        XCTAssert(sut.matches(testNode))
        XCTAssert(testNode.didGetField)
    }

    func testMatchWithMatcher() {
        let sut =
            ValueMatcher<TestNodeWithField>()
            .keyPath(\.field, ValueMatcher<Int>().match(.equals(1)))

        XCTAssert(sut.matches(TestNodeWithField(field: 1)))
        XCTAssertFalse(sut.matches(TestNodeWithField(field: 0)))
    }

    func testMatcherWithTwoKeypaths() {
        let sut = ValueMatcher<TestNode>()
            .keyPath(\.intField, equals: 1)
            .keyPath(\.stringField, equals: "abc")

        XCTAssert(sut.matches(TestNode(intField: 1, stringField: "abc")))
        XCTAssertFalse(sut.matches(TestNode(intField: 0, stringField: "")))
        XCTAssertFalse(sut.matches(TestNode(intField: 1, stringField: "")))
        XCTAssertFalse(sut.matches(TestNode(intField: 0, stringField: "abc")))
    }

    func testMatchAST() {
        let sut = ValueMatcher<Expression>()
            .keyPath(\.asBinary?.lhs.asConstant?.constant, equals: .int(0, .decimal))

        XCTAssert(sut.matches(Expression.constant(0).binary(op: .add, rhs: .constant(0))))
        XCTAssertFalse(sut.matches(Expression.constant(1).binary(op: .add, rhs: .constant(0))))
    }

    func testMatchSelf() {
        let sut = ValueMatcher<Int>().match(.equals(0))

        XCTAssert(sut.matches(0))
        XCTAssertFalse(sut.matches(1))
    }

    func testMatchRuleEquals() {
        XCTAssert(MatchRule<Int>.equals(1).evaluate(1))
        XCTAssertFalse(MatchRule<Int>.equals(1).evaluate(2))
    }

    func testMatchRuleDifferentThan() {
        XCTAssertFalse(MatchRule<Int>.differentThan(1).evaluate(1))
        XCTAssert(MatchRule<Int>.differentThan(1).evaluate(2))
    }

    func testMatchRuleClosure() {
        XCTAssert(MatchRule<Int>.closure({ _ in true }).evaluate(1))
        XCTAssertFalse(MatchRule<Int>.closure({ _ in false }).evaluate(1))
    }

    func testMatchRuleType() {
        XCTAssert(
            MatchRule<Expression>.isType(ConstantExpression.self).evaluate(
                ConstantExpression(integerLiteral: 0)
            )
        )
        XCTAssertFalse(
            MatchRule<Expression>.isType(ConstantExpression.self).evaluate(
                IdentifierExpression(identifier: "")
            )
        )
    }

    func testMatchRuleAny() {
        XCTAssert(MatchRule<String>.any.evaluate("a"))
        XCTAssert(MatchRule<String>.any.evaluate("b"))
    }

    func testMatchRuleNone() {
        XCTAssertFalse(MatchRule<String>.none.evaluate("a"))
        XCTAssertFalse(MatchRule<String>.none.evaluate("b"))
    }

    func testMatchRuleAll() {
        XCTAssert(MatchRule<String>.all(["a", .any]).evaluate("a"))
        XCTAssertFalse(MatchRule<String>.all(["a", .none]).evaluate("a"))
    }

    func testMatchRuleAnyOf() {
        XCTAssert(MatchRule<String>.anyOf([.none, "a"]).evaluate("a"))
        XCTAssertFalse(MatchRule<String>.anyOf([.none]).evaluate("a"))
    }

    func testMatchRuleAllOperator() {
        let rule: MatchRule<String> = "a" && ("b" && "c")

        switch rule {
        case .all(let r) where r.count == 3:
            if case .equals("a") = r[0],
                case .equals("b") = r[1],
                case .equals("c") = r[2]
            {
                // Success!
                return
            }
        default:
            break
        }

        XCTFail("Expected && to compose into MatchRule.all")
    }

    func testMatchRuleAnyOfOperator() {
        let rule: MatchRule<String> = "a" || ("b" || "c")

        switch rule {
        case .anyOf(let r) where r.count == 3:
            if case .equals("a") = r[0],
                case .equals("b") = r[1],
                case .equals("c") = r[2]
            {
                // Success!
                return
            }
        default:
            break
        }

        XCTFail("Expected && to compose into MatchRule.anyOf")
    }

    func testMatchRuleExtract() {
        let extractor = ValueMatcherExtractor("")

        XCTAssert(MatchRule<String>.extract(.any, extractor).evaluate("abc"))
        XCTAssertFalse(MatchRule<String>.extract(.none, extractor).evaluate("def"))

        XCTAssertEqual(extractor.value, "abc")
    }

    func testMatchRuleExtractOptional() {
        let instance1 = TestEquatable()
        let instance2 = TestEquatable()

        let extractor = ValueMatcherExtractor<TestEquatable?>()

        XCTAssert(MatchRule<TestEquatable>.extractOptional(.any, extractor).evaluate(instance1))
        XCTAssertFalse(
            MatchRule<TestEquatable>.extractOptional(.none, extractor).evaluate(instance2)
        )

        XCTAssert(extractor.value === instance1)
        XCTAssert(extractor.value !== instance2)
    }

    func testMatchRuleExtractOperator() {
        let result = ValueMatcherExtractor("")

        let rule = MatchRule<String>.any ->> result

        switch rule {
        case .extract(.any, let extractor):
            extractor.extract("abc")
            XCTAssertEqual(result.value, "abc")
        default:
            XCTFail("Expected ->> to produce `.extract` rule, but produced \(rule) instead.")
        }
    }

    func testMatchRuleExtractOptionalOperator() {
        let output = ValueMatcherExtractor<String?>()

        let rule = MatchRule<String>.any ->> output

        switch rule {
        case .extractOptional(.any, let extractor):
            extractor.extract("abc")
            XCTAssertEqual(output.value, "abc")
        default:
            XCTFail(
                "Expected ->> to produce `.extractOptional` rule, but produced \(rule) instead."
            )
        }
    }

    func testMatchRuleExtractOptionalToNonOptionalOperator() {
        let output = ValueMatcherExtractor(TestEquatable())

        let rule = MatchRule<TestEquatable?>.any ->> output

        switch rule {
        case .closure:
            // Success!
            break
        default:
            XCTFail(
                "Expected ->> to produce `.extractOptional` rule, but produced \(rule) instead."
            )
        }
    }

    func testBindKeypath() {
        let test = TestNode(intField: 123, stringField: "")
        var output: Int = 0

        let rule =
            ValueMatcher<TestNode>()
            .bind(keyPath: \.intField, to: &output)

        XCTAssert(rule.matches(test))
        XCTAssertEqual(output, 123)
    }

    func testBindMatch() {
        let output = ValueMatcherExtractor(0)

        let rule =
            ValueMatcher<Int>()
            .bind(to: output)

        XCTAssert(rule.matches(123))
        XCTAssertEqual(output.value, 123)
    }

    func testCreateMatcherWithKeypath() {
        let rule =
            ValueMatcher<TestNode>()
            .stringField
            .count == 3

        XCTAssert(rule.matches(TestNode(intField: 123, stringField: "123")))
        XCTAssertFalse(rule.matches(TestNode(intField: 123, stringField: "")))
    }
}

private class TestNodeWithField: SyntaxNode {

    var didGetField = false

    var _field: Int

    var field: Int {
        didGetField = true
        return _field
    }

    init(field: Int) {
        _field = field
    }
}

private class TestNode: SyntaxNode {

    var intField: Int
    var stringField: String

    init(intField: Int, stringField: String) {
        self.intField = intField
        self.stringField = stringField
    }

}

private final class TestEquatable: Equatable {

    public static func == (lhs: TestEquatable, rhs: TestEquatable) -> Bool {
        return true
    }
}
