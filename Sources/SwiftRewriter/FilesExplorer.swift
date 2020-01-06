import Foundation
import Console
import Utils
import SwiftRewriterLib

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
    struct Options {
        static var `default` = Options(overwrite: false, skipConfirm: false,
                                       excludePattern: nil, includePattern: nil)
        
        var overwrite: Bool
        var skipConfirm: Bool
        var excludePattern: String?
        var includePattern: String?
    }
    
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
    
    func searchAndShowConfirm(in menu: MenuController,
                              path directoryPath: String,
                              options: Options = .default) {
        
        let console = menu.console
        
        console.printLine("Inspecting path \(directoryPath)...")
        
        var overwriteCount = 0

        let fileProvider = FileDiskProvider()
        let searchStep = FileCollectionStep(fileProvider: fileProvider)
        do {
            try searchStep.addFromDirectory(URL(fileURLWithPath: directoryPath),
                                            recursive: true,
                                            includePattern: options.includePattern,
                                            excludePattern: options.excludePattern)
        } catch {
            console.printLine("Error finding files: \(error).")
            if !options.skipConfirm {
                _=console.readLineWith(prompt: "Press [Enter] to continue.")
            }

            return
        }
        
        let objcFiles: [URL] = searchStep
            .files.map { $0.url }
            // Check a matching .swift file doesn't already exist for the paths
            // (if `overwrite` is not on)
            .filter { (url: URL) -> Bool in
                let swiftFile =
                    ((url.path as NSString)
                        .deletingPathExtension as NSString)
                        .appendingPathExtension("swift")!

                if !fileProvider.fileExists(atPath: swiftFile) {
                    return true
                }
                if options.overwrite {
                    overwriteCount += 1
                    return true
                }

                return false
            }

        if objcFiles.isEmpty {
            console.printLine("No files where found to process.")
            if !options.skipConfirm {
                _=console.readLineWith(prompt: "Press [Enter] to continue.")
            }
            
            return
        }
        
        if !options.skipConfirm {
            let prompt: String
                
            if overwriteCount == 0 {
                prompt = "Found \(objcFiles.count) file(s) to convert. Convert now? y/n"
            } else {
                prompt = """
                Found \(objcFiles.count) file(s) to convert \
                (will overwrite \(overwriteCount) file(s)). Convert now? y/n
                """
            }
            
            let convert = console.readLineWith(prompt: prompt)?.lowercased() == "y"
            guard convert else {
                return
            }
        }
        
        do {
            let stopwatch = Stopwatch.start()
            
            try autoreleasepool {
                try rewriterService.rewrite(files: objcFiles)
            }
            
            let duration = stopwatch.stop()
            
            console.printLine("Finishing converting \(objcFiles.count) files in \(String(format: "%.2lf", duration))s.")
            _=console.readLineWith(prompt: "Press [Enter] to continue.")
        } catch {
            console.printLine("Error converting files: \(error)")
            _=console.readLineWith(prompt: "Press [Enter] to continue.")
        }
    }
}

private class FileFinderInterface {
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
        let maxFilesShown = 300

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
            
            var matches = Array(matchesSource.prefix(maxFilesShown))
            matches.sort { s1, s2 in
                s1.compare(s2, options: .numeric) == .orderedAscending
            }
            
            if matches.isEmpty {
                console.printLine("Found 0 matches in directory!".terminalColorize(.yellow))
                _=console.readLineWith(prompt: "Press [Enter] to return")
                continue
            }

            repeat {
                // Present selection to user
                let matchesString =
                    matches.count == maxFilesShown
                        ? "Showing first \(maxFilesShown) matches"
                        : "Showing all files found"
                
                let indexes = presentFileSelection(
                    in: menu, list: matches.asPaths,
                    prompt: "\(matchesString), select one to convert")
                
                guard !indexes.isEmpty else {
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
private class FilesExplorer: PagesCommandHandler {
    var acceptsCommands: Bool = true
    var canHandleEmptyInput: Bool = false
    
    var commandPrompt: String? {
        "Select a file above or input '0' to quit"
    }
    
    private var fileList: FileListConsoleProvider?
    
    public var console: ConsoleClient
    public var rewriterService: SwiftRewriterService
    public var path: URL
    
    public init(console: ConsoleClient, rewriterService: SwiftRewriterService, path: URL) {
        self.console = console
        self.rewriterService = rewriterService
        self.path = path
    }
    
    func executeCommand(_ input: String) throws -> Pages.PagesCommandResult {
        self.navigateOption(input)
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
            newPathAttempt = URL(string: input, relativeTo: path)
        }
        
        if verifyFilesNamed(input, from: path) {
            return .loop(nil)
        }
        
        // Work with relative paths
        if let newPathAttempt = newPathAttempt,
            FileManager.default.fileExists(atPath: newPathAttempt.absoluteURL.relativePath) {
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
                return .loop(
                    "Invalid index \(index): Only have \(fileList.count) files to select!"
                    .terminalColorize(.red))
            }
            
            newPath = fileList.fileList[index - 1]
        } else {
            return .loop("Could not locate file or folder '\(input)'".terminalColorize(.red))
        }
        
        do {
            path = newPath
            let newList = try getFileListProvider()
            
            return .modifyList(keepPageIndex: true) { _ in
                newList
            }
        } catch {
            return .loop("Error during operation: \(error)".terminalColorize(.red))
        }
    }
    
    func verifyFilesNamed(_ file: String, from url: URL) -> Bool {
        let newPath = url.appendingPathComponent(file).absoluteURL
        
        var isDirectory = ObjCBool(false)
        
        // Check if we're not pointing at a directory the user might want to
        // navigate to
        if FileManager.default.fileExists(atPath: newPath.relativePath,
                                          isDirectory: &isDirectory)
            && isDirectory.boolValue {
            return false
        }
        
        // Raw .h/.m file
        if file.hasSuffix(".h") || file.hasSuffix(".m") {
            let exists = FileManager.default.fileExists(atPath: newPath.relativePath,
                                                        isDirectory: &isDirectory)
            guard exists && !isDirectory.boolValue else {
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
                try FileManager.default
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
            
            if matches.isEmpty {
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
    
    let path: URL
    let fileList: [URL]
    
    public var header: String {
        path.relativePath
    }
    
    public var count: Int {
        fileList.count
    }
    
    public init(path: URL, fileList: [URL]) {
        self.path = path
        self.fileList = fileList
    }
    
    public func displayTitles(forRow row: Int) -> [CustomStringConvertible] {
        let url = fileList[row]
        let fullPath = url.standardizedFileURL.relativePath
        
        var isDirectory = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDirectory) else {
            return [""]
        }
        
        if isDirectory.boolValue {
            return [url.lastPathComponent.terminalColorize(.magenta)]
        }
        
        return [url.lastPathComponent]
    }
}
