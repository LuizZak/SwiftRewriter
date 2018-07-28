import XCTest
import SwiftAST

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
        XCTAssert(MatchRule<Expression>.isType(ConstantExpression.self).evaluate(ConstantExpression(integerLiteral: 0)))
        XCTAssertFalse(MatchRule<Expression>.isType(ConstantExpression.self).evaluate(IdentifierExpression(identifier: "")))
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
                case .equals("c") = r[2] {
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
                case .equals("c") = r[2] {
                // Success!
                return
            }
        default:
            break
        }
        
        XCTFail("Expected && to compose into MatchRule.anyOf")
    }
    
    func testMatchRuleExtract() {
        var result: String = ""
        
        XCTAssert(MatchRule<String>.extract(.any, &result).evaluate("abc"))
        XCTAssertFalse(MatchRule<String>.extract(.none, &result).evaluate("def"))
        
        XCTAssertEqual(result, "abc")
    }
    
    func testMatchRuleExtractOptional() {
        let instance1 = TestEquatable()
        let instance2 = TestEquatable()
        var output: TestEquatable?
        
        XCTAssert(MatchRule<TestEquatable>.extractOptional(.any, &output).evaluate(instance1))
        XCTAssertFalse(MatchRule<TestEquatable>.extractOptional(.none, &output).evaluate(instance2))
        
        XCTAssert(output === instance1)
        XCTAssert(output !== instance2)
    }
    
    func testMatchRuleExtractOperator() {
        var result: String = ""
        
        let rule = MatchRule<String>.any ->> &result
        
        switch rule {
        case .extract(.any, &result):
            // Success!
            break
        default:
            XCTFail("Expected ->> to produce `.extract` rule, but produced \(rule) instead.")
        }
    }
    
    func testMatchRuleExtractOptionalOperator() {
        var output: TestEquatable?
        
        let rule = MatchRule<TestEquatable>.any ->> &output
        
        switch rule {
        case .extractOptional(.any, _):
            // Success!
            break
        default:
            XCTFail("Expected ->> to produce `.extractOptional` rule, but produced \(rule) instead.")
        }
    }
    
    func testMatchRuleExtractOptionalToNonOptionalOperator() {
        var output = TestEquatable()
        
        let rule = MatchRule<TestEquatable?>.any ->> &output
        
        switch rule {
        case .closure:
            // Success!
            break
        default:
            XCTFail("Expected ->> to produce `.extractOptional` rule, but produced \(rule) instead.")
        }
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
