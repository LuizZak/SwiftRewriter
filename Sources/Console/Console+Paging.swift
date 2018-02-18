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
                let pageValidateNew: (String) -> Bool = { [console] in
                    // Command
                    if($0.hasPrefix("=") && self.configuration?.commandClosure != nil) {
                        return true
                    }
                    
                    // Decrease/increase page
                    if($0.hasPrefix("-") || $0.hasPrefix("+")) {
                        if($0.count == 1) {
                            console.printLine("Invalid page index \($0). Must be between 1 and \(pageCount)")
                            return false
                        }
                        // Try to read an integer value
                        if Int($0[$0.index(after: $0.startIndex)...]) == nil {
                            console.printLine("Invalid page index \($0). Must be between 1 and \(pageCount)")
                            return false
                        }
                        
                        return true
                    }
                    
                    // Direct page
                    guard let index = Int($0) else {
                        console.printLine("Invalid page index \($0). Must be between 1 and \(pageCount)")
                        return false
                    }
                    if(index != 0 && (index < 1 || index > pageCount)) {
                        console.printLine("Invalid page index \($0). Must be between 1 and \(pageCount)")
                        return false
                    }
                    
                    return true
                }
                
                var prompt: String = "Input page (0 or empty to close):"
                if let configPrompt = configuration?.commandPrompt {
                    prompt += "\n\(configPrompt)"
                }
                prompt += "\n>"
                
                guard let newPage = console.readLineWith(prompt: prompt, allowEmpty: true, validate: pageValidateNew) else {
                    return .quit
                }
                
                // Command
                if(newPage.hasPrefix("=") && configuration?.commandClosure != nil) {
                    if let command = configuration?.commandClosure {
                        do {
                            return try autoreleasepool {
                                try command(String(newPage[newPage.index(after: newPage.startIndex)...]))
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
                if(newPage.hasPrefix("-") || newPage.hasPrefix("+")) {
                    let increment = newPage.hasPrefix("+")
                    
                    if let skipCount = Int(newPage[newPage.index(after: newPage.startIndex)...]) {
                        let change = increment ? skipCount : -skipCount
                        page = min(pageCount - 1, max(0, page + change))
                        return .loop
                    }
                }
                
                guard let newPageIndex = Int(newPage) else {
                    return .quit
                }
                
                if(newPageIndex == 0) {
                    return .quit
                }
                
                page = newPageIndex - 1
                
                return .loop
            }
            
            if(result == .quit) {
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
    public func displayPages(withValues values: [String], perPageCount: Int = 30) {
        let provider = AnyConsoleDataProvider(count: values.count) { index -> [String] in
            return [values[index]]
        }
        
        displayPages(withProvider: provider, perPageCount: perPageCount)
    }
    
    /// Structure for customization of paged displays
    public struct PageDisplayConfiguration {
        public var commandPrompt: String?
        public var commandClosure: ((String) throws -> Console.CommandMenuResult)?
        
        public init(commandPrompt: String? = nil, commandClosure: ((String) throws -> Console.CommandMenuResult)? = nil) {
            self.commandPrompt = commandPrompt
            self.commandClosure = commandClosure
        }
    }
}
