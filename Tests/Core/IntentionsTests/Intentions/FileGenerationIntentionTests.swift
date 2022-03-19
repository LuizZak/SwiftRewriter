import XCTest

@testable import Intentions

class FileGenerationIntentionTests: XCTestCase {
    typealias Sut = FileGenerationIntention

    func testAccept() {
        class TestVisitor: TestIntentionVisitor {
            let exp: XCTestExpectation

            init(exp: XCTestExpectation) {
                self.exp = exp
            }

            override func visitFile(_ intention: Sut) {
                exp.fulfill()
            }
        }
        let sut = Sut(sourcePath: "A", targetPath: "A.swift")
        let exp = expectation(description: "visit")
        let visitor = TestVisitor(exp: exp)

        sut.accept(visitor)

        waitForExpectations(timeout: 0.0)
    }
}
