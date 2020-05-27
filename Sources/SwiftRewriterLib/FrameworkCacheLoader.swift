import Foundation
import Utils
import SourceKittenFramework

public protocol FrameworkCacheLoaderDelegate: AnyObject {
    func frameworkCacheLoader(_ loader: FrameworkCacheLoader,
                              didConvertModule moduleName: String,
                              contents: String)
    
    func frameworkCacheLoader(_ loader: FrameworkCacheLoader,
                              didReceiveErrorLoadingModule moduleName: String,
                              error: Error)
}

public class FrameworkCacheLoader {
    var framework: KnownFramework
    var settings: FrameworkLoadSettings
    var fileProvider: FileProvider
    
    public weak var delegate: FrameworkCacheLoaderDelegate?
    
    init(framework: KnownFramework,
         settings: FrameworkLoadSettings,
         fileProvider: FileProvider,
         delegate: FrameworkCacheLoaderDelegate?) {
        
        self.framework = framework
        self.settings = settings
        self.fileProvider = fileProvider
        self.delegate = delegate
    }
    
    func load() {
        let baseUrl = framework.headersPath
        
        let files = fileProvider
            .allFilesRecursive(inPath: baseUrl.path)!
            .sorted()
            .map { baseUrl.appendingPathComponent($0) }
        
        let parallelBus = ParallelQueue<InterfaceParseResult>(threadCount: 6)
        parallelBus.addResultProcessor { result in
            switch result.source {
            case .success(let source):
                self.delegate?.frameworkCacheLoader(self,
                                                    didConvertModule: result.moduleName,
                                                    contents: source)
                
            case .failure(let error):
                self.delegate?.frameworkCacheLoader(self,
                                                    didReceiveErrorLoadingModule: result.moduleName,
                                                    error: error)
            }
        }
        
        for (i, file) in files.enumerated() where file.path.hasSuffix(".h") && !file.lastPathComponent.contains("+") {
            if file.lastPathComponent == "\(framework.name).h" {
                continue
            }
            
            parallelBus.enqueue { () -> InterfaceParseResult in
                let moduleName = String(file.lastPathComponent.dropLast(2))
                
                do {
                    let includePath = self.settings
                        .sdkUrl
                        .appendingPathComponent("usr")
                        .appendingPathComponent("local")
                        .appendingPathComponent("include")
                    
                    let frameworkSearchPath = self.settings
                        .sdkUrl
                        .appendingPathComponent("System")
                        .appendingPathComponent("Library")
                        .appendingPathComponent("PrivateFrameworks")
                    
                    let compilerFlags = [
                        "-target",
                        self.settings.targetPlatform,
                        "-sdk",
                        self.settings.sdkUrl.path,
                        "-I",
                        includePath.path,
                        "-F",
                        frameworkSearchPath.path,
                        ""
                    ]
                    
                    let source =
                        try Self.generateSwiftInterface(
                            frameworkName: self.framework.name,
                            moduleName: moduleName,
                            withCompilerFlags: compilerFlags)
                    
                    let result = InterfaceParseResult(index: i,
                                                      moduleName: moduleName,
                                                      source: .success(source))
                    return result
                } catch {
                    let result = InterfaceParseResult(index: i,
                                                      moduleName: moduleName,
                                                      source: .failure(error))
                    return result
                }
            }
        }
        
        parallelBus.wait()
    }
    
    static func generateSwiftInterface(frameworkName: String, moduleName: String, withCompilerFlags compilerFlags: [String]) throws -> String {
        let req = Request.customRequest(request: [
            "key.request": UID("source.request.editor.open.interface"),
            "key.name": NSUUID().uuidString,
            "key.compilerargs": compilerFlags,
            "key.modulename": "\(frameworkName).\(moduleName)"
        ])
        
        let result = try req.send()
        
        guard let srcText = result["key.sourcetext"] as? String, !srcText.isEmpty else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
        }
        
        return srcText
    }
    
    struct InterfaceParseResult {
        var index: Int
        var moduleName: String
        var source: Result<String, Error>
    }
}

public struct FrameworkLoadSettings {
    /// Target platform to pass to SourceKit when generating header files,
    /// e.g.: arm64-apple-ios13.5
    public var targetPlatform: String
    
    /// The filepath to the base SDK to pass to SourceKit when generating header
    /// files, e.g.: /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
    public var sdkUrl: URL
}

public struct KnownFramework {
    public var name: String
    public var headersPath: URL
    
    public init(name: String, headersPath: URL) {
        self.name = name
        self.headersPath = headersPath
    }
}
