import XCTest

@testable import Intentions

class ProtocolInheritanceIntentionTests: XCTestCase {
    typealias Sut = ProtocolInheritanceIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitProtocolInheritance(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(protocolName: "A")
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
