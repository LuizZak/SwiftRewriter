import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class SwiftRewriterTests_Crashers: XCTestCase {
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
