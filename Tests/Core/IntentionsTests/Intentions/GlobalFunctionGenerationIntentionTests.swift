import XCTest
import SwiftAST

@testable import Intentions

class GlobalFunctionGenerationIntentionTests: XCTestCase {
    typealias Sut = GlobalFunctionGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitGlobalFunction(_ intention: Sut) {
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
