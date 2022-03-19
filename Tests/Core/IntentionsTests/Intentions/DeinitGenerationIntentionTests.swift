import XCTest

@testable import Intentions

class DeinitGenerationIntentionTests: XCTestCase {
    typealias Sut = DeinitGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitDeinit(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut()
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
