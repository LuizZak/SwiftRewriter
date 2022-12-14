import XCTest

@testable import Intentions

class EnumGenerationIntentionTests: XCTestCase {
    typealias Sut = EnumGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitEnum(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(typeName: "A", rawValueType: .int)
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
