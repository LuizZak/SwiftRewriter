import XCTest

@testable import Intentions

class PropertyInitialValueGenerationIntentionTests: XCTestCase {
    typealias Sut = PropertyInitialValueGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitPropertyInitialValue(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(expression: .constant(0), source: nil)
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
