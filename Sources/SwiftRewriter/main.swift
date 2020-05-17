import Foundation
import Utils
import SwiftRewriterLib
import SourceKittenFramework

func generateSwiftInterface(moduleName: String, withCompilerFlags compilerFlags: [String]) throws -> String {
    let req = Request.customRequest(request: [
        "key.request": UID("source.request.editor.open.interface"),
        "key.name": NSUUID().uuidString,
        "key.compilerargs": compilerFlags,
        "key.modulename": "UIKit.\(moduleName)"
    ])
    
    let result = try req.send()
    
    guard let srcText = result["key.sourcetext"] as? String, !srcText.isEmpty else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
    }
    
    return srcText
}

extension String {
    func stripComments() -> String {
        var result = self
        for range in cStyleCommentSectionRanges().reversed() {
            result.replaceSubrange(range, with: "\n")
        }
        return result
    }
}

func main() throws {
    
    let baseUrl = URL(fileURLWithPath: "/Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/UIKit.framework/Headers/")
    
    let files = FileManager
        .default
        .enumerator(atPath: baseUrl.path)!
        .map { $0 as! String }
        .sorted()
        .map { baseUrl.appendingPathComponent($0) }
    
    let parallelBus = ParallelQueue<String>(threadCount: 6)
    parallelBus.addResultProcessor { result in
        print(result)
    }
    
    for file in files where file.path.hasSuffix(".h") && !file.lastPathComponent.contains("+") {
        if file.lastPathComponent == "UIKit.h" {
            continue
        }
        
        parallelBus.enqueue { () -> String in
            let moduleName = String(file.lastPathComponent.dropLast(2))
            
            let result = try! generateSwiftInterface(moduleName: moduleName, withCompilerFlags: [
                "-target",
                "arm64-apple-ios13.5",
                "-sdk",
                "/Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.5.sdk",
                "-I",
                "/Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.5.sdk/usr/local/include",
                "-F",
                "/Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.5.sdk/System/Library/PrivateFrameworks",
                ""
            ])
            
            return moduleName
        }
        
        //print(result)
    }
    
    parallelBus.wait()
    
//    let output = NullWriterOutput()
//    var settings = Settings()
//    settings.rewriter.verbose = true
//
//    let service = SwiftRewriterServiceImpl(output: output, settings: settings)
//
//    try service.rewrite(files: files)
//
//    print("Done!")
}

try main()

//SwiftRewriterCommand.main()
