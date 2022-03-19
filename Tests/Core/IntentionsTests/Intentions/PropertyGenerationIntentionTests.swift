import XCTest

@testable import Intentions

class PropertyGenerationIntentionTests: XCTestCase {
    typealias Sut = PropertyGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitProperty(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(name: "a", type: .int, objcAttributes: [])
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
