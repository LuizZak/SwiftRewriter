import XCTest
import ObjcParser
import GrammarModels

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
