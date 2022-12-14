import Foundation
import Console
import Utils
import SwiftRewriterLib

func showSearchPathUi(in menu: MenuController, fileProvider: FileProvider) -> URL? {
    let console = menu.console
    
    console.clearScreen()
    
    let _path =
        console.parseLineWith(
            // TODO: Allow frontends to specify this prompt.
            prompt: """
                Please input a path to search .h/.m files at (e.g.: /Users/Me/projects/my-objc-project/Sources)
                Input an empty line to abort.
                >
                """,
            allowEmpty: true,
            parse: { input -> ValueReadResult<URL> in
                if input == "" {
                    return .abort
                }
                
                let pathUrl = URL(fileURLWithPath: (input as NSString).expandingTildeInPath)
                
                var isDirectory: Bool = false
                let exists = fileProvider.fileExists(atUrl: pathUrl, isDirectory: &isDirectory)
                
                if !exists {
                    return .error("Path '\(pathUrl.path)' does not exists!".terminalColorize(.red))
                }
                if !isDirectory {
                    return .error("Path '\(pathUrl.path)' is not a directory!".terminalColorize(.red))
                }
                
                return .success(pathUrl)
            })
    
    guard let path = _path else {
        return nil
    }
    
    return path
}

/// Helper for presenting selection of file names on a list
private func presentFileSelection(in menu: MenuController, list: [URL], prompt: String) -> [URL] {
    let prompt = prompt + """
    Type ':all' to select all files.
    """
    var items: [URL] = []

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
    var rewriterFrontend: SwiftRewriterFrontend
    let fileProvider: FileProvider

    public init(rewriterFrontend: SwiftRewriterFrontend, fileProvider: FileProvider) {
        self.rewriterFrontend = rewriterFrontend
        self.fileProvider = fileProvider
    }

    public func runFileFindMenu(in menu: MenuController) {
        let interface = FileFinderInterface(
            rewriterFrontend: rewriterFrontend,
            fileProvider: fileProvider
        )

        interface.run(in: menu)
    }

    public func runFileExploreMenu(in menu: MenuController, url path: URL) {
        let filesExplorer =
            FilesExplorer(
                console: menu.console,
                fileProvider: fileProvider,
                rewriterFrontend: rewriterFrontend,
                path: path
            )
        
        let config = Pages.PageDisplayConfiguration(commandHandler: filesExplorer)
        let pages = menu.console.makePages(configuration: config)
        
        do {
            let filesList = try filesExplorer.getFileListProvider()
            
            pages.displayPages(withProvider: filesList)
        } catch {
            menu.console.printLine("Failed to navigate directory contents!".terminalColorize(.red))
        }
    }
    
    public func runSuggestConversionMenu(in menu: MenuController) {
        let interface = SuggestConversionInterface(
            rewriterFrontend: rewriterFrontend,
            fileProvider: fileProvider
        )
        
        interface.run(in: menu)
    }
}

public class SuggestConversionInterface {
    public struct Options {
        public static let `default` = Options(
            overwrite: false,
            skipConfirm: false,
            followImports: false,
            excludePattern: nil,
            includePattern: nil,
            verbose: false
        )
        
        public var overwrite: Bool
        public var skipConfirm: Bool
        public var followImports: Bool
        public var excludePattern: String?
        public var includePattern: String?
        public var verbose: Bool

        public init(
            overwrite: Bool,
            skipConfirm: Bool,
            followImports: Bool,
            excludePattern: String? = nil,
            includePattern: String? = nil,
            verbose: Bool
        ) {
            self.overwrite = overwrite
            self.skipConfirm = skipConfirm
            self.followImports = followImports
            self.excludePattern = excludePattern
            self.includePattern = includePattern
            self.verbose = verbose
        }

        public func makeFrontendFileCollectOptions() -> SwiftRewriterFrontendFileCollectionOptions {
            .init(followImports: followImports, excludePattern: excludePattern, includePattern: includePattern, verbose: verbose)
        }
    }
    
    var rewriterFrontend: SwiftRewriterFrontend
    let fileProvider: FileProvider
    
    public init(rewriterFrontend: SwiftRewriterFrontend, fileProvider: FileProvider) {
        self.rewriterFrontend = rewriterFrontend
        self.fileProvider = fileProvider
    }
    
    public func run(in menu: MenuController) {
        guard let path = showSearchPathUi(in: menu, fileProvider: fileProvider) else {
            return
        }
        
        searchAndShowConfirm(in: menu, url: path)
    }
    
    public func searchAndShowConfirm(
        in menu: MenuController,
        url: URL,
        options: Options = .default
    ) {
        let console = menu.console
        
        console.printLine("Inspecting path \(url.path)...")
        
        var overwriteCount = 0

        let fileProvider = FileDiskProvider()
        let files: [DiskInputFile]

        do {
            files = try rewriterFrontend.collectFiles(
                from: url,
                fileProvider: fileProvider,
                options: options.makeFrontendFileCollectOptions()
            )
        } catch {
            console.printLine("Error finding files: \(error).")
            if !options.skipConfirm {
                _=console.readLineWith(prompt: "Press [Enter] to continue.")
            }

            return
        }
        
        let objcFiles: [URL] = files
            .filter { $0.isPrimary }
            .map { $0.url }
            // Check a matching .swift file doesn't already exist for the paths
            // (if `overwrite` is not on)
            .filter { (url: URL) -> Bool in
                let swiftFile = url.appendingPathExtension("swift")

                if !fileProvider.fileExists(atUrl: swiftFile) {
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
                try rewriterFrontend.makeRewriterService().rewrite(files: objcFiles)
            }
            
            let duration = stopwatch.stop()
            
            console.printLine("Finished converting \(objcFiles.count) files in \(String(format: "%.2lf", duration))s.")
        } catch {
            console.printLine("Error converting files: \(error)")
        }

        _=console.readLineWith(prompt: "Press [Enter] to continue.")
    }
}

private class FileFinderInterface {
    var rewriterFrontend: SwiftRewriterFrontend
    var fileProvider: FileProvider
    
    init(rewriterFrontend: SwiftRewriterFrontend, fileProvider: FileProvider) {
        self.rewriterFrontend = rewriterFrontend
        self.fileProvider = fileProvider
    }

    func run(in menu: MenuController) {
        guard let path = showSearchPathUi(in: menu, fileProvider: fileProvider) else {
            return
        }
        
        exploreFilesUi(url: path, menu: menu)
    }
    
    func exploreFilesUi(url: URL, menu: MenuController) {
        let console = menu.console
        let maxFilesShown = 300

        repeat {
            console.clearScreen()

            guard let files = fileProvider.enumerator(atUrl: url)?.lazy else {
                console.printLine("Failed to iterate files from path \(url.path)".terminalColorize(.red))
                return
            }

            // TODO: Allow frontends to specify this prompt.
            let fileName =
                console.readSureLineWith(prompt: """
                    \(url.path)
                    Enter a file name to search on the current path (e.g.: MyFile.m), or empty to quit:
                    > 
                    """)
            
            if fileName.isEmpty {
                return
            }

            console.printLine("Searching...")
            
            // TODO: Allow frontends to specify this search filter pattern.
            let matchesSource = files.filter {
                $0.pathExtension == "m" || $0.pathExtension == "h" && $0.lastPathComponent.localizedCaseInsensitiveContains(fileName)
            }
            
            var matches = Array(matchesSource.prefix(maxFilesShown))
            matches.sort { s1, s2 in
                s1.path.compare(s1.path, options: .numeric) == .orderedAscending
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
                    in: menu,
                    list: matches,
                    prompt: "\(matchesString), select one to convert"
                )
                
                guard !indexes.isEmpty else {
                    return
                }
                
                do {
                    let rewriterService = rewriterFrontend.makeRewriterService()

                    try rewriterService.rewrite(files: indexes)

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
    public var rewriterFrontend: SwiftRewriterFrontend
    public var fileProvider: FileProvider
    public var path: URL
    
    public init(
        console: ConsoleClient,
        fileProvider: FileProvider,
        rewriterFrontend: SwiftRewriterFrontend,
        path: URL
    ) {
        self.console = console
        self.fileProvider = fileProvider
        self.rewriterFrontend = rewriterFrontend
        self.path = path
    }
    
    func executeCommand(_ input: String) throws -> Pages.PagesCommandResult {
        self.navigateOption(input)
    }

    public func getFileListProvider() throws -> FileListConsoleProvider {
        var files = try fileProvider
            .contentsOfDirectory(
                atUrl: path,
                shallow: true
            )
        
        files.sort(by: { $0.lastPathComponent < $1.lastPathComponent })
        
        let fileListProvider = FileListConsoleProvider(
            fileProvider: fileProvider,
            path: path,
            fileList: files
        )
        
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
            fileProvider.fileExists(atUrl: newPathAttempt.absoluteURL) {
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
                    "Invalid index \(index): There are only \(fileList.count) files to select from!"
                    .terminalColorize(.red)
                )
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
        let rewriterService = rewriterFrontend.makeRewriterService()

        let newPath = url.appendingPathComponent(file).absoluteURL
        
        var isDirectory = false
        
        // Check if we're not pointing at a directory the user might want to
        // navigate to
        
        if fileProvider.fileExists(atUrl: newPath,
                                   isDirectory: &isDirectory)
            && isDirectory {
            return false
        }
        
        // TODO: Allow frontends to specify this filter pattern.
        // Raw .h/.m file
        if file.hasSuffix(".h") || file.hasSuffix(".m") {
            let exists = fileProvider
                .fileExists(
                    atUrl: newPath,
                    isDirectory: &isDirectory
                )
            
            guard exists && !isDirectory else {
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
            
            if !fileProvider.fileExists(atUrl: searchPath,
                                        isDirectory: &isDirectory) {
                console.printLine("Directory \(searchPath) does not exists.".terminalColorize(.red))
                _=console.readLineWith(prompt: "Press [Enter] to continue")
                return false
            }
            if !isDirectory {
                console.printLine("Path \(searchPath) is not a directory".terminalColorize(.red))
                _=console.readLineWith(prompt: "Press [Enter] to continue")
                return false
            }
            
            // TODO: Delegate this to frontends.

            // Search for .h/.m pairs with a similar name
            let filesInDir =
                try fileProvider
                    .contentsOfDirectory(
                        atUrl: newPath.deletingLastPathComponent(),
                        shallow: true
                    )
            
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
    let fileProvider: FileProvider
    let path: URL
    let fileList: [URL]
    
    public var header: String {
        path.relativePath
    }
    
    public var count: Int {
        fileList.count
    }
    
    public init(fileProvider: FileProvider, path: URL, fileList: [URL]) {
        self.fileProvider = fileProvider
        self.path = path
        self.fileList = fileList
    }
    
    public func displayTitles(forRow row: Int) -> [CustomStringConvertible] {
        let url = fileList[row]
        let fullPath = url.standardizedFileURL
        
        var isDirectory = false
        guard fileProvider.fileExists(atUrl: fullPath, isDirectory: &isDirectory) else {
            return [""]
        }
        
        if isDirectory {
            return [url.lastPathComponent.terminalColorize(.magenta)]
        }
        
        return [url.lastPathComponent]
    }
}

extension Collection where Element == URL {
    func indexOfFilename(matching string: String, options: String.CompareOptions = .literal) -> Index? {
        firstIndex {
            $0.lastPathComponent.compare(string, options: options) == .orderedSame
        }
    }
}
