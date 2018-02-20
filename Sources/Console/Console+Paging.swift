import Cocoa

/// Allows the user to navigate and select through pages of items, allowing them
/// to perform specific actions on items, as well.
public class Pages {
    
    var console: Console
    var configuration: PageDisplayConfiguration?
    
    public init(console: Console, configuration: PageDisplayConfiguration? = nil) {
        self.console = console
        self.configuration = configuration
    }
    
    /// Displays a sequence of items as a paged list of items, which the user 
    /// can interacy by selecting the page to display.
    /// The data is understood as a sequence of columns.
    /// The function also supports a special command closure that interprets 
    /// lines started with '=' with a special closure
    public func displayPages<T: ConsoleDataProvider>(withProvider provider: T,
                                                     perPageCount: Int = 30) where T.Data == [String] {
        
        var page = 0
        let pageCount = Int(ceil(Float(provider.count) / Float(perPageCount)))
        repeat {
            let result: Console.CommandMenuResult = autoreleasepool {
                let minItem = min(page * perPageCount, provider.count)
                let maxItem = min(minItem + perPageCount, provider.count)
                
                if !provider.header.isEmpty {
                    console.printLine(provider.header)
                }
                
                // Use this to pad the numbers
                console.printLine("----")
                
                // Map each value into [[1, item1], [2, item2], [3, item3], ...]
                // and pass it into the table display routine to allow it to evenly nice the items
                var table: [[String]] = []
                
                for index in minItem..<maxItem {
                    var input = ["\(index + 1):"]
                    input.append(contentsOf: provider.data(atIndex: index))
                    
                    table.append(input)
                }
                
                console.displayTable(withValues: table, separator: " ")
                
                console.printLine("---- \(minItem + 1) to \(maxItem)")
                console.printLine("= Page \(page + 1) of \(pageCount)")
                
                // Closure that validates two types of inputs:
                // - Relative page changes (e.g.: '+1', '-10', '+2' etc., with no bounds)
                // - Absolute page (e.g. 1, 2, 3, etc., from 1 - pageCount)
                let pageValidateNew: (String) -> Bool = { [console, configuration] input in
                    // 0: Return tu upper menu
                    if input == "0" {
                        return true
                    }
                    
                    // Decrease/increase page
                    if input.hasPrefix("-") || input.hasPrefix("+") {
                        if(input.count == 1) {
                            console.printLine("Invalid page index \(input). Must be between 1 and \(pageCount)")
                            return false
                        }
                        // Try to read an integer value
                        if Int(input.dropFirst()) == nil {
                            console.printLine("Invalid page index \(input). Must be between 1 and \(pageCount)")
                            return false
                        }
                        
                        return true
                    }
                    
                    // Command
                    if !input.hasPrefix("=") && configuration?.commandHandler.commandClosure != nil {
                        return true
                    }
                    
                    // Direct page index
                    guard input.hasPrefix("="), let index = Int(input.dropFirst()) else {
                        // If not a number, check with command
                        if configuration?.commandHandler.commandClosure != nil {
                            return true
                        }
                        
                        console.printLine("Invalid page number '\(input)'. Must be a number between 1 and \(pageCount)")
                        return false
                    }
                    if index != 0 && (index < 1 || index > pageCount) {
                        console.printLine("Invalid page index \(input). Must be between 1 and \(pageCount)")
                        return false
                    }
                    
                    return true
                }
                
                var prompt: String = "Input page (0 or empty to close):"
                if let configPrompt = configuration?.commandHandler.commandPrompt {
                    prompt += "\n\(configPrompt)"
                }
                prompt += "\n>"
                
                guard let newPage = console.readLineWith(prompt: prompt, allowEmpty: true, validate: pageValidateNew) else {
                    return .quit
                }
                
                // Quit
                if newPage == "0" || newPage == "" {
                    return .quit
                }
                
                // Command
                if (!newPage.hasPrefix("=") || Int(newPage.dropFirst()) == nil) && configuration?.commandHandler.commandClosure != nil {
                    if let command = configuration?.commandHandler.commandClosure {
                        do {
                            return try autoreleasepool {
                                let com = newPage.hasPrefix("=") ? String(newPage.dropFirst()) : newPage
                                
                                switch try command(com) {
                                case .loop(let msg):
                                    if let msg = msg {
                                        console.printLine(msg)
                                    }
                                    return .loop
                                    
                                case .showMessageThenLoop(let msg):
                                    if let msg = msg {
                                        console.printLine(msg)
                                        _=console.readLineWith(prompt: "Press [Enter] to continue")
                                    }
                                    return .loop
                                    
                                case .quit(let msg):
                                    if let msg = msg {
                                        console.printLine(msg)
                                    }
                                    return .quit
                                    
                                case .modifyList(let closure):
                                    defer {
                                        closure(self)
                                    }
                                    return .quit
                                }
                            }
                        } catch {
                            console.printLine("\(error)")
                            _=readLine()
                            return .loop
                        }
                    } else {
                        console.printLine("Commands not supported/not setup for this page displayer")
                        return .loop
                    }
                }
                
                // Page increment-decrement
                if newPage.hasPrefix("-") || newPage.hasPrefix("+") {
                    let increment = newPage.hasPrefix("+")
                    
                    if let skipCount = Int(newPage.dropFirst()) {
                        let change = increment ? skipCount : -skipCount
                        page = min(pageCount - 1, max(0, page + change))
                        return .loop
                    }
                }
                
                guard newPage.hasPrefix("="), let newPageIndex = Int(newPage.dropFirst()) else {
                    return .quit
                }
                
                if newPageIndex == 0 {
                    return .quit
                }
                
                page = newPageIndex - 1
                
                return .loop
            }
            
            if result == .quit {
                return
            }
        } while(true)
    }
    
    /// Displays a sequence of items as a paged list of items, which the user 
    /// can interact by selecting the page to display
    public func displayPages<T: ConsoleDataProvider>(withProvider provider: T,
                                                     perPageCount: Int = 30) where T.Data == String {
        
        let provider = AnyConsoleDataProvider(provider: provider) { (source: String) -> [String] in
            return [source]
        }
        
        displayPages(withProvider: provider, perPageCount: perPageCount)
    }
    
    /// Displays a sequence of items as a paged list of items, which the user
    /// can interact by selecting the page to display
    public func displayPages(withValues values: [String], header: String = "", perPageCount: Int = 30) {
        let provider = AnyConsoleDataProvider(count: values.count, header: header) { index -> [String] in
            return [values[index]]
        }
        
        displayPages(withProvider: provider, perPageCount: perPageCount)
    }
    
    /// Structure for customization of paged displays
    public struct PageDisplayConfiguration {
        public let commandHandler: PagesCommandHandler
        
        public init(commandPrompt: String? = nil, commandClosure: ((String) throws -> PagesCommandResult)? = nil) {
            commandHandler =
                InnerPageCommandHandler(commandPrompt: commandPrompt, commandClosure: commandClosure)
        }
        
        public init(commandHandler: PagesCommandHandler) {
            self.commandHandler = commandHandler
        }
    }
    
    /// Result of a paging command
    ///
    /// - loop: Loops the page back to where it is
    /// - showMessageThenLoop: Shows a message, halting the standard input until
    /// the user presses enter, then resumes in loop mode.
    /// - quit: Quits the page back to the calling menu
    /// - print: Prints a message to the console and re-loops
    /// - modifyList: Called to modify the contents being displayed on the list
    public enum PagesCommandResult {
        case loop(String?)
        case showMessageThenLoop(String?)
        case quit(String?)
        case modifyList((Pages) -> ())
    }
    
    private struct InnerPageCommandHandler: PagesCommandHandler {
        public let commandPrompt: String?
        public let commandClosure: ((String) throws -> PagesCommandResult)?
        
        public init(commandPrompt: String? = nil, commandClosure: ((String) throws -> PagesCommandResult)? = nil) {
            self.commandPrompt = commandPrompt
            self.commandClosure = commandClosure
        }
    }
}

/// Handler for paging commands
public protocol PagesCommandHandler {
    var commandPrompt: String? { get }
    var commandClosure: ((String) throws -> Pages.PagesCommandResult)? { get }
}
