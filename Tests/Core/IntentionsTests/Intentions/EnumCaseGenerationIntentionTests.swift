import XCTest

@testable import Intentions

class EnumCaseGenerationIntentionTests: XCTestCase {
    typealias Sut = EnumCaseGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitEnumCase(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(name: "A", expression: nil)
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
