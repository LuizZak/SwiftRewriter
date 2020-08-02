import Foundation

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

var swiftRewriterBinaryPath: URL {
    productsDirectory.appendingPathComponent("SwiftRewriter")
}

var baseProjectPath: URL {
    URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
}

func asInvocation(_ process: Process) -> String {
    return "\(process.executableURL?.path ?? "<nil>") \(process.arguments?.joined(separator: " ") ?? "")"
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
    
    return ProcessResult(standardOutput: output,
                         standardError: errorOutput,
                         terminationStatus: process.terminationStatus)
}

struct ProcessResult {
    var standardOutput: String
    var standardError: String
    var terminationStatus: Int32
    
    var hasSuccessTerminationStatus: Bool {
        return terminationStatus == 0
    }
}
