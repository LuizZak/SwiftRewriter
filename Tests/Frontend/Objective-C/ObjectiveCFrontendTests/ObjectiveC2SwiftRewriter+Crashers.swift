import ObjcGrammarModels
import ObjcParser
import XCTest

@testable import ObjectiveCFrontend

class ObjectiveC2SwiftRewriter_CrashersTests: XCTestCase {
    func testCrashInSwitchCaseWithCompoundStatement() {
        assertRewrite(
            objc: """
                void test() {
                    switch (foo) {
                        case 0: {
                            foo();
                        }
                            bar();
                            break;
                        default:
                            break;
                    }
                }
                """,
            swift: """
                func test() {
                    switch foo {
                    case 0:
                        foo()

                        bar()
                    default:
                        break
                    }
                }
                """
        )
    }
}
