import Foundation
import Console
import Utils

func showSearchPathUi(in menu: MenuController) -> String? {
    let console = menu.console
    let fileManager = FileManager.default
    
    console.clearScreen()
    
    let _path =
        console.parseLineWith(
            prompt: """
                    Please input a path to search .h/.m files at (e.g.: /Users/Me/projects/my-objc-project/Sources)
                    Input an empty line to abort.
                    >
                    """,
            allowEmpty: true,
            parse: { input -> ValueReadResult<String> in
                if input == "" {
                    return .abort
                }
                
                let pathInput = (input as NSString).expandingTildeInPath
                
                var isDirectory = ObjCBool(false)
                let exists = fileManager.fileExists(atPath: pathInput, isDirectory: &isDirectory)
                
                if !exists {
                    return .error("Path '\(pathInput)' does not exists!".terminalColorize(.red))
                }
                if !isDirectory.boolValue {
                    return .error("Path '\(pathInput)' is not a directory!".terminalColorize(.red))
                }
                
                return .success(pathInput)
        })
    
    guard let path = _path else {
        return nil
    }
    
    return path
}

/// Helper for presenting selection of file names on a list
private func presentFileSelection(in menu: MenuController, list: [Path], prompt: String) -> [Path] {
    let prompt = prompt + """
    Type ':all' to select all files.
    """
    var items: [Path] = []

    let config = 
        Pages.PageDisplayConfiguration(commandPrompt: prompt) { input in
            if input.isEmpty {
                return .quit(nil)
            }
            
            if input == ":all" {
                items = list
                return .quit(nil)
            }
            
            if let index = list.indexOfFilename(matching: input, options: .caseInsensitive) {
                items = [list[index + 1]]
                return .quit(nil)
            }
            
            guard let int = Int(input), int > 0 && int <= list.count else {
                return .showMessageThenLoop("Expected an value between 1 and \(list.count)".terminalColorize(.red))
            }
            
            items = [list[int]]
            
            return .quit(nil)
        }
    
    let pages = menu.console.makePages(configuration: config)
    pages.displayPages(withValues: list)

    return items
}

/// Main CLI interface entry point for file exploring services
public class FilesExplorerService {
    var rewriterService: SwiftRewriterService

    init(rewriterService: SwiftRewriterService) {
        self.rewriterService = rewriterService
    }

    func runFileFindMenu(in menu: MenuController) {
        let interface = FileFinderInterface(rewriterService: rewriterService)

        interface.run(in: menu)
    }

    func runFileExploreMenu(in menu: MenuController, url path: URL) {
        let filesExplorer =
            FilesExplorer(console: menu.console,
                          rewriterService: rewriterService,
                          path: path)
        
        let config = Pages.PageDisplayConfiguration(commandHandler: filesExplorer)
        let pages = menu.console.makePages(configuration: config)
        
        do {
            let filesList = try filesExplorer.getFileListProvider()
            
            pages.displayPages(withProvider: filesList)
        } catch {
            menu.console.printLine("Failed to navigate directory contents!".terminalColorize(.red))
        }
    }
    
    func runSuggestConversionMenu(in menu: MenuController) {
        let interface = SuggestConversionInterface(rewriterService: rewriterService)
        
        interface.run(in: menu)
    }
}

class SuggestConversionInterface {
    var rewriterService: SwiftRewriterService
    
    init(rewriterService: SwiftRewriterService) {
        self.rewriterService = rewriterService
    }
    
    func run(in menu: MenuController) {
        guard let path = showSearchPathUi(in: menu) else {
            return
        }
        
        searchAndShowConfirm(in: menu, path: path)
    }
    
    func searchAndShowConfirm(in menu: MenuController, path directoryPath: String,
                              skipConfirm: Bool = false, overwrite: Bool = false,
                              excludePattern: String? = nil) {
        let console = menu.console
        let fileManager = FileManager.default
        
        console.printLine("Inspecting path \(directoryPath)...")
        
        // Search all files there
        guard let files = fileManager.enumerator(atPath: directoryPath) else {
            console.printLine("Failed to iterate files from path \(directoryPath)".terminalColorize(.red))
            return
        }
        
        var overwriteCount = 0
        
        var objcFiles: [URL] =
            files
                // Type the array properly
                .compactMap { value -> String? in
                    value as? String
                }
                // Filter down to .h/.m files
                .filter { (path: String) -> Bool in
                    ((path as NSString).pathExtension == "m" || (path as NSString).pathExtension == "h")
                }
                // Unfold full paths
                .map { (path: String) -> String in
                    (directoryPath as NSString).appendingPathComponent(path)
                }
                // Sort files, for convenience of better conveying progress to use
                .sorted { (s1: String, s2: String) -> Bool in
                    s1.compare(s2, options: .numeric) == .orderedAscending
                }
                // Convert back to the URL
                .map { (path: String) -> URL in
                    URL(fileURLWithPath: path)
                }
                // Check a matching .swift file doesn't already exist for the paths
                // (if `overwrite` is not on)
                .filter { (url: URL) -> Bool in
                    let swiftFile =
                        ((url.path as NSString)
                            .deletingPathExtension as NSString)
                            .appendingPathExtension("swift")!
                    
                    if !fileManager.fileExists(atPath: swiftFile) {
                        return true
                    }
                    if overwrite {
                        overwriteCount += 1
                        return true
                    }
                    
                    return false
                }
        
        if let excludePattern = excludePattern {
            do {
                let pattern = try NSRegularExpression(pattern: excludePattern, options: .caseInsensitive)
                
                objcFiles = objcFiles.filter { url in
                    let path = url.path
                    
                    let range = NSMakeRange(0, (path as NSString).length)
                    return pattern.firstMatch(in: url.path, range: range) == nil
                }
                
            } catch {
                console.printLine("Error processing regular expression for file exclusion: \(error)")
                if !skipConfirm {
                    _=console.readLineWith(prompt: "Press [Enter] to continue.")
                }
                
                return
            }
        }
        
        if objcFiles.count == 0 {
            console.printLine("No files where found to process.")
            if !skipConfirm {
                _=console.readLineWith(prompt: "Press [Enter] to continue.")
            }
            
            return
        }
        
        if !skipConfirm {
            let prompt: String
                
            if overwriteCount == 0 {
                prompt = "Found \(objcFiles.count) file(s) to convert. Convert now? y/n"
            } else {
                prompt = "Found \(objcFiles.count) file(s) to convert (will overwrite \(overwriteCount) file(s)). Convert now? y/n"
            }
            
            let convert = console.readLineWith(prompt: prompt)?.lowercased() == "y"
            guard convert else {
                return
            }
        }
        
        do {
            try autoreleasepool {
                let rewriter = SwiftRewriterServiceImpl.fileDiskService
                
                try rewriter.rewrite(files: objcFiles)
            }
            
            console.printLine("Finishing converting \(objcFiles.count) files.")
            _=console.readLineWith(prompt: "Press [Enter] to continue.")
        } catch {
            console.printLine("Error converting files: \(error)")
            _=console.readLineWith(prompt: "Press [Enter] to continue.")
        }
    }
}

fileprivate class FileFinderInterface {
    var rewriterService: SwiftRewriterService
    
    init(rewriterService: SwiftRewriterService) {
        self.rewriterService = rewriterService
    }

    func run(in menu: MenuController) {
        guard let path = showSearchPathUi(in: menu) else {
            return
        }
        
        exploreFilesUi(path: path, menu: menu)
    }
    
    func exploreFilesUi(path: String, menu: MenuController) {
        let console = menu.console
        let fileManager = FileManager.default

        repeat {
            console.clearScreen()

            guard let files = fileManager.enumerator(atPath: path)?.lazy else {
                console.printLine("Failed to iterate files from path \(path)".terminalColorize(.red))
                return
            }

            let fileName =
                console.readSureLineWith(prompt: """
                    \(path)
                    Enter a file name to search on the current path (e.g.: MyFile.m), or empty to quit:
                    > 
                    """)
            
            if fileName.isEmpty {
                return
            }

            console.printLine("Searching...")
            
            let matchesSource = files.compactMap { $0 as? String }.filter {
                (($0 as NSString).pathExtension == "m" || ($0 as NSString).pathExtension == "h") &&
                ($0 as NSString).lastPathComponent.localizedCaseInsensitiveContains(fileName)
            }
            var matches = Array(matchesSource.prefix(300))
            matches.sort { s1, s2 in
                s1.compare(s2, options: .numeric) == .orderedAscending
            }
            
            if matches.count == 0 {
                console.printLine("Found 0 matches in directory!".terminalColorize(.yellow))
                _=console.readLineWith(prompt: "Press [Enter] to return")
                continue
            }

            repeat {
                // Present selection to user
                let matchesString = matches.count == 50 ? "Showing the first 50 matches" : "Showing all files found"
                
                let indexes = presentFileSelection(in: menu, list: matches.asPaths, prompt: "\(matchesString), select one to convert")
                guard indexes.count > 0 else {
                    return
                }
                
                do {
                    let fileUrls = indexes.map {
                        URL(fileURLWithPath: (path as NSString).appendingPathComponent($0.fullPath))
                    }
                    try rewriterService.rewrite(files: fileUrls)
                    _=console.readLineWith(prompt: "\nPress [Enter] to convert another file")
                } catch {
                    console.printLine("Error while converting file: \(error)".terminalColorize(.red))
                    _=console.readLineWith(prompt: "Press [Enter] to return")
                    return
                }
            } while true
        } while true
    }
}

/// Presents a CLI-gui for navigating folders and selecting files to process
/// into SwiftRewriter
fileprivate class FilesExplorer: PagesCommandHandler {
    var commandPrompt: String? {
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
            return .quit("Error: No file list to explore. Returning...".terminalColorize(.red))
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
                return .loop("Invalid index \(index): Only have \(fileList.count) files to select!".terminalColorize(.red))
            }
            
            newPath = fileList.fileList[index - 1]
        } else {
            return .loop("Could not locate file or folder '\(input)'".terminalColorize(.red))
        }
        
        do {
            path = newPath
            let newList = try self.getFileListProvider()
            
            return .modifyList { pages in
                pages.displayPages(withProvider: newList)
            }
        } catch {
            return .loop("Error during operation: \(error)".terminalColorize(.red))
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
                console.printLine("Error during rewriting: \(error)".terminalColorize(.red))
                _=console.readLineWith(prompt: "Press [Enter] to continue")
            }
            
            return true
        }
        
        do {
            let searchPath = newPath.deletingLastPathComponent()
            
            if !FileManager.default.fileExists(atPath: searchPath.relativePath,
                                               isDirectory: &isDirectory) {
                console.printLine("Directory \(searchPath) does not exists.".terminalColorize(.red))
                _=console.readLineWith(prompt: "Press [Enter] to continue")
                return false
            }
            if !isDirectory.boolValue {
                console.printLine("Path \(searchPath) is not a directory".terminalColorize(.red))
                _=console.readLineWith(prompt: "Press [Enter] to continue")
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
                    $0.absoluteURL.relativePath
                        .lowercased()
                        .hasPrefix(newPath.relativePath.lowercased()) &&
                    ($0.pathExtension == "h" || $0.pathExtension == "m")
                }
            
            if matches.count == 0 {
                return false
            }
            
            console.printLine("Found \(matches.count) files to convert:")
            for (i, path) in matches.enumerated() {
                console.printLine("\((i + 1)): \(path.lastPathComponent)")
            }
            let result = console.readLineWith(prompt: "Continue with conversion? y/n")
            if result?.lowercased() == "y" {
                try rewriterService.rewrite(files: matches)
                _=console.readLineWith(prompt: "Press [Enter] to convert another file")
            }
            return true
        } catch {
            console.printLine("Error while loading files: \(error)".terminalColorize(.red))
            _=console.readLineWith(prompt: "Press [Enter] to continue")
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
