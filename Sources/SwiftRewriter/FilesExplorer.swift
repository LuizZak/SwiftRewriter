import Foundation
import Console

/// Presents a CLI-gui for navigating folders and selecting files to process
/// into SwiftRewriter
public class FilesExplorer: PagesCommandHandler {
    public var commandPrompt: String? {
        return "Select a file above or input '0' to quit"
    }
    
    private var fileList: FileListConsoleProvider?
    
    public var commandClosure: ((String) throws -> Pages.PagesCommandResult)?
    
    public var console: ConsoleClient
    public var rewriterService: SwiftRewriterService
    public var path: URL
    
    public init(console: ConsoleClient, rewriterService: SwiftRewriterService, path: URL) {
        self.console = console
        self.rewriterService = rewriterService
        self.path = path
        
        commandClosure = { [weak self] input in
            guard let sSelf = self else { return .quit(nil) }
            
            return sSelf.navigateOption(input)
        }
    }
    
    public func getFileListProvider() throws -> FileListConsoleProvider {
        var files =
            try FileManager.default
                .contentsOfDirectory(at: path, includingPropertiesForKeys: nil,
                                     options: [.skipsHiddenFiles,
                                               .skipsSubdirectoryDescendants])
        
        files.sort(by: { $0.lastPathComponent < $1.lastPathComponent })
        
        let fileListProvider = FileListConsoleProvider(path: path, fileList: files)
        fileList = fileListProvider
        
        return fileListProvider
    }
    
    func navigateOption(_ input: String) -> Pages.PagesCommandResult {
        guard let fileList = fileList else {
            return .quit("Error: No file list to explore. Returning...")
        }
        
        let newPath: URL
        
        let newPathAttempt: URL?
        if #available(OSX 10.11, *) {
            newPathAttempt = URL(fileURLWithPath: input, relativeTo: path)
        } else {
            newPathAttempt = nil
        }
        
        if verifyFilesNamed(input, from: path) {
            return .loop(nil)
        }
        
        // Work with relative paths
        if let newPathAttempt = newPathAttempt, FileManager.default.fileExists(atPath: newPathAttempt.absoluteURL.relativePath) {
            newPath = newPathAttempt.absoluteURL
        }
        // Search file name from list
        else if let file = fileList.fileList.first(where: {
            $0.lastPathComponent.compare(input, options: [.diacriticInsensitive, .caseInsensitive]) == .orderedSame
        }) {
            newPath = file
        }
        // Check if it's an index
        else if let index = Int(input) {
            guard index > 0 && index <= fileList.count else {
                return .loop("Invalid index \(index): Only have \(fileList.count) files to select!")
            }
            
            newPath = fileList.fileList[index - 1]
        } else {
            return .loop("Could not locate file or folder '\(input)'")
        }
        
        path = newPath
        let newList = try! self.getFileListProvider()
        
        return .modifyList { pages in
            pages.displayPages(withProvider: newList)
        }
    }
    
    func verifyFilesNamed(_ file: String, from url: URL) -> Bool {
        let newPath = url.appendingPathComponent(file).absoluteURL
        
        var isDirectory = ObjCBool(false)
        
        // Check if we're not pointing at a directory the user might want to navigate
        // to
        if FileManager.default.fileExists(atPath: newPath.relativePath,
                                          isDirectory: &isDirectory)
            && isDirectory.boolValue {
            return false
        }
        
        
        // Raw .h/.m file
        if file.hasSuffix(".h") || file.hasSuffix(".m") {
            guard FileManager.default.fileExists(atPath: newPath.relativePath, isDirectory: &isDirectory) && !isDirectory.boolValue else {
                return false
            }
            
            do {
                try rewriterService.rewrite(files: [newPath])
            } catch {
                console.printLine("Error during rewriting: \(error)")
            }
            
            return true
        }
        
        do {
            let searchPath = newPath.deletingLastPathComponent()
            
            if !FileManager.default.fileExists(atPath: searchPath.relativePath,
                                               isDirectory: &isDirectory) {
                console.printLine("Directory \(searchPath) does not exists.")
                return false
            }
            if !isDirectory.boolValue {
                console.printLine("Path \(searchPath) is not a directory")
                return false
            }
            
            // Search for .h/.m pairs with a similar name
            let filesInDir =
                try
                    FileManager.default
                        .contentsOfDirectory(at: newPath.deletingLastPathComponent(),
                                             includingPropertiesForKeys: nil,
                                             options: [.skipsHiddenFiles,
                                                       .skipsSubdirectoryDescendants])
            
            // Match all files in directory
            let matches =
                filesInDir.filter {
                    $0.absoluteURL.relativePath.hasPrefix(newPath.relativePath)
                }
            
            if matches.count != 2 {
                console.printLine("Search is ambiguous: Found the following files:")
                for (i, path) in matches.enumerated() {
                    console.printLine("\((i + 1)): \(path.lastPathComponent)")
                }
                return true
            }
            
            guard let header = matches.first(where: { $0.lastPathComponent.hasSuffix(".h") }),
                let impl = matches.first(where: { $0.lastPathComponent.hasSuffix(".m") }) else
            {
                console.printLine("""
                    Expected search '\(file)' to find a .h header and .m \
                    implementation, but found \(matches.map { $0.lastPathComponent }.joined(separator: ", ")) \
                    files instead.
                    """)
                return true
            }
            
            console.printLine("""
                Found files \(header.deletingPathExtension().lastPathComponent) \
                .h/.m to convert, converting...
                """)
            
            try rewriterService.rewrite(files: [header, impl])
            return true
        } catch {
            console.printLine("Error while loading files: \(error)")
            return false
        }
    }
}

public class FileListConsoleProvider: ConsoleDataProvider {
    public typealias Data = String
    
    let path: URL
    let fileList: [URL]
    
    public var header: String {
        return path.relativePath
    }
    
    public var count: Int {
        return fileList.count
    }
    
    public init(path: URL, fileList: [URL]) {
        self.path = path
        self.fileList = fileList
    }
    
    public func data(atIndex index: Int) -> String {
        let url = fileList[index]
        let fullPath = url.standardizedFileURL.relativePath
        
        var isDirectory: ObjCBool = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDirectory) else {
            return ""
        }
        
        if isDirectory.boolValue {
            return url.lastPathComponent.terminalColorize(.magenta)
        }
        
        return url.lastPathComponent
    }
}
