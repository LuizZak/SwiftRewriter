import SwiftAST
import XCTest

class ValueMatcher_MatchersTests: XCTestCase {

    func testNot() {
        let rule = not(equals(1))

        XCTAssert(rule.evaluate(0))
        XCTAssertFalse(rule.evaluate(1))
    }

    func testNotOnMatcher() {
        let rule = not(ValueMatcher().match(equals(1)))

        XCTAssert(rule.matches(0))
        XCTAssertFalse(rule.matches(1))
    }

    func testNotOperator() {
        let rule = !ValueMatcher().match(equals(1))

        XCTAssert(rule.matches(0))
        XCTAssertFalse(rule.matches(1))
    }

    func testNotOperatorOnMatchRule() {
        let rule = !MatchRule<Int>.equals(1)

        XCTAssert(rule.evaluate(0))
        XCTAssertFalse(rule.evaluate(1))
    }

    func testEquals() {
        switch equals(1) {
        case .equals(1):
            // Success!
            break
        default:
            XCTFail("Expected `equals` to produce a MatchRule.equals case")
        }
    }

    func testEqualsExecute() {
        let sut = ValueMatcher().match(equals(1))

        XCTAssert(sut.matches(1))
        XCTAssertFalse(sut.matches(2))
    }

    func testEqualsWithNonNilOptional() {
        let sut = ValueMatcher<Int>().match(equals(1 as Int?))

        XCTAssert(sut.matches(1))
        XCTAssertFalse(sut.matches(2))
    }

    func testEqualsNil() {
        let sut = ValueMatcher<Int>().match(equals(nil))

        XCTAssertFalse(sut.matches(0))
    }

    func testLazyEquals() {
        switch lazyEquals(1) {
        case .lazyEquals:
            // Success!
            break
        default:
            XCTFail("Expected `lazyEquals` to produce a MatchRule.lazyEquals case")
        }
    }

    func testLazyEqualsExecute() {
        let sut = ValueMatcher().match(lazyEquals(1))

        XCTAssert(sut.matches(1))
        XCTAssertFalse(sut.matches(2))
    }

    func testLazyEqualsWithNonNilOptional() {
        let sut = ValueMatcher<Int>().match(lazyEquals(1 as Int?))

        XCTAssert(sut.matches(1))
        XCTAssertFalse(sut.matches(2))
    }

    func testLazyEqualsNil() {
        let sut = ValueMatcher<Int>().match(lazyEquals(nil))

        XCTAssertFalse(sut.matches(0))
    }

    func testLazyEqualsOnlyExecutesWhenMatching() {
        var didGet = false
        var value: Int {
            didGet = true
            return 1
        }

        let sut = ValueMatcher<Int>().match(.equals(1)).match(lazyEquals(value))

        _ = sut.matches(1)

        XCTAssert(didGet)
    }

    func testLazyEqualsDoesNotExecuteWhenPreviousMatchingFails() {
        var didGet = false
        var value: Int {
            didGet = true
            return 1
        }

        let sut = ValueMatcher<Int>().match(.equals(1)).match(lazyEquals(value))

        _ = sut.matches(0)

        XCTAssertFalse(didGet)
    }

    func testIsNil() {
        let sut = ValueMatcher<Int?>().match(if: isNil())

        XCTAssert(sut.matches(nil))
        XCTAssertFalse(sut.matches(0))
    }

    func testHasCount() {
        let sut = ValueMatcher<[Int]>().match(if: hasCount(2))

        XCTAssert(sut.matches([1, 2]))
        XCTAssertFalse(sut.matches([]))
        XCTAssertFalse(sut.matches([1]))
        XCTAssertFalse(sut.matches([1, 2, 3]))
    }

    func testEquateValueMatcherToBooleanTrue() {
        let sut = ValueMatcher<Int>().match(1) == true

        XCTAssert(sut.matches(1))
        XCTAssertFalse(sut.matches(2))
    }

    func testEquateValueMatcherToBooleanFalse() {
        let sut = ValueMatcher<Int>().match(1) == false

        XCTAssertFalse(sut.matches(1))
        XCTAssert(sut.matches(2))
    }

    func testCollectionHasCount() {
        let sut = ValueMatcher<[Int]>().hasCount(2)

        XCTAssertFalse(sut.matches([1]))
        XCTAssert(sut.matches([1, 2]))
        XCTAssertFalse(sut.matches([1, 2, 3]))
    }

    func testCollectionAtIndexRule() {
        let sut =
            ValueMatcher<[Int]>()
            .atIndex(1, rule: .differentThan(1))

        XCTAssert(sut.matches([0, 2]))
        XCTAssertFalse(sut.matches([0, 1]))
        XCTAssertFalse(sut.matches([0]))
    }

    func testCollectionAtIndexEquals() {
        let sut =
            ValueMatcher<[Int]>()
            .atIndex(1, equals: 1)

        XCTAssert(sut.matches([0, 1]))
        XCTAssertFalse(sut.matches([0]))
        XCTAssertFalse(sut.matches([0, 2]))
    }

    func testCollectionAtIndexMatcher() {
        let sut =
            ValueMatcher<[Int]>()
            .atIndex(1, matcher: ValueMatcher<Int>().match(if: .equals(1)))

        XCTAssert(sut.matches([0, 1]))
        XCTAssertFalse(sut.matches([0]))
        XCTAssertFalse(sut.matches([0, 2]))
    }
}
