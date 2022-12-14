import XCTest

@testable import Intentions

class InstanceVariableGenerationIntentionTests: XCTestCase {
    typealias Sut = InstanceVariableGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitInstanceVariable(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(name: "a", storage: .constant(ofType: .int))
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
