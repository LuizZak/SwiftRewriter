import XCTest

@testable import Intentions

class ProtocolPropertyGenerationIntentionTests: XCTestCase {
    typealias Sut = ProtocolPropertyGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitProtocolProperty(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(name: "a", storage: .constant(ofType: .int), objcAttributes: [])
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
