import XCTest

@testable import Intentions

class PropertySynthesizationIntentionTests: XCTestCase {
    typealias Sut = PropertySynthesizationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitPropertySynthesization(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(propertyName: "a", ivarName: "a", isExplicit: true, type: .synthesize)
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
