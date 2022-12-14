import XCTest

@testable import Intentions

class InitGenerationIntentionTests: XCTestCase {
    typealias Sut = InitGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitInit(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(parameters: [])
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
