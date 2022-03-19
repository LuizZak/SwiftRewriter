import XCTest
import SwiftAST

@testable import Intentions

class MethodGenerationIntentionTests: XCTestCase {
    typealias Sut = MethodGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitMethod(_ intention: Sut) {
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
