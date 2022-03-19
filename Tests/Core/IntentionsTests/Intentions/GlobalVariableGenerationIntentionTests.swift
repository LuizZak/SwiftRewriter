import XCTest

@testable import Intentions

class GlobalVariableGenerationIntentionTests: XCTestCase {
    typealias Sut = GlobalVariableGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitGlobalVariable(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(name: "a", type: .int)
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
