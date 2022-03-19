import XCTest

@testable import Intentions

class TypealiasIntentionTests: XCTestCase {
    typealias Sut = TypealiasIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitTypealias(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(fromType: .any, named: "A")
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
