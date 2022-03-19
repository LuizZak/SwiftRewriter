import XCTest
import SwiftAST

@testable import Intentions

class ProtocolMethodGenerationIntentionTests: XCTestCase {
    typealias Sut = ProtocolMethodGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitProtocolMethod(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(signature: FunctionSignature(name: "a"))
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
