import XCTest

@testable import Intentions

class SubscriptGenerationIntentionTests: XCTestCase {
    typealias Sut = SubscriptGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitSubscript(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(parameters: [], returnType: .any, mode: .getter(.init(body: [])))
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
