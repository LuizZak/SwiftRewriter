import XCTest

@testable import Intentions

class ProtocolGenerationIntentionTests: XCTestCase {
    typealias Sut = ProtocolGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitProtocol(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(typeName: "A")
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
