import XCTest

import class Foundation.Bundle

final class SwiftRewriterTests: XCTestCase {
    func testPipedInput() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        let process = Process()
        process.executableURL = binaryPath

        let input = """
            @interface A
            - (void)test;
            @end
            """

        let result = try runProcess(process, stdin: input)

        XCTAssertEqual(
            result.standardOutput,
            """
            class A {
                func test() {
                }
            }
            """
        )
        XCTAssertEqual(result.standardError, "")
        XCTAssertEqual(result.terminationStatus, 0)
    }

    func testIgnoreFollowImportsInPipedInputMode() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        let process = Process()
        process.executableURL = binaryPath
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

        XCTAssertEqual(
            result.standardOutput,
            """
            // Preprocessor directives found in file:
            // #import "another_file.h"
            class A {
                func test() {
                }
            }
            """
        )
        XCTAssertEqual(result.standardError, "")
        XCTAssertEqual(result.terminationStatus, 0)
    }

    @available(OSX 10.13, *)
    func runProcess(_ process: Process, stdin: String?) throws -> ProcessResult {
        try runProcess(process, stdinData: stdin?.data(using: .utf8))
    }

    @available(OSX 10.13, *)
    func runProcess(_ process: Process, stdinData: Data?) throws -> ProcessResult {
        let pipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = pipe
        process.standardError = errorPipe

        if let stdin = stdinData {
            let stdinPipe = Pipe()
            stdinPipe.fileHandleForWriting.write(stdin)

            process.standardInput = stdinPipe
        }

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: data, as: UTF8.self)

        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let errorOutput = String(decoding: errorData, as: UTF8.self)

        return ProcessResult(
            standardOutput: output,
            standardError: errorOutput,
            terminationStatus: process.terminationStatus
        )
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
            for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
                return bundle.bundleURL.deletingLastPathComponent()
            }
            fatalError("couldn't find the products directory")
        #else
            return Bundle.main.bundleURL
        #endif
    }

    var binaryPath: URL {
        productsDirectory.appendingPathComponent("SwiftRewriter")
    }

    struct ProcessResult {
        var standardOutput: String
        var standardError: String
        var terminationStatus: Int32
    }
}
