import XCTest
import class Foundation.Bundle

final class SwiftRewriterTests: XCTestCase {
    func testPipedInput() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let process = Process()
        process.executableURL = swiftRewriterBinaryPath
        
        let input = """
        @interface A
        - (void)test;
        @end
        """
        
        let result = try runProcess(process, stdin: input)
        
        XCTAssertEqual(result.standardOutput, """
            class A {
                func test() {
                }
            }
            """)
        XCTAssertEqual(result.standardError, "")
        XCTAssertEqual(result.terminationStatus, 0)
    }
    
    func testIgnoreFollowImportsInPipedInputMode() throws {
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let process = Process()
        process.executableURL = swiftRewriterBinaryPath
        process.arguments = [
            "--follow-imports"
        ]
        
        let input = """
        #import "another_file.h"
        
        @interface A
        - (void)test;
        @end
        """
        
        let result = try runProcess(process, stdin: input)
        
        XCTAssertEqual(result.standardOutput, """
            // Preprocessor directives found in file:
            // #import "another_file.h"
            class A {
                func test() {
                }
            }
            """)
        XCTAssertEqual(result.standardError, "")
        XCTAssertEqual(result.terminationStatus, 0)
    }
}
