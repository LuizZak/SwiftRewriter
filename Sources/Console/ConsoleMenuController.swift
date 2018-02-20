import Utils
import Foundation

/// Basic class for menu navigation
open class MenuController {
    
    /// Console client to interact with
    public let console: ConsoleClient
    
    /// Current menu under construction.
    /// Used only during `initMenus()`.
    var currentBuildingMenu: MenuItem?
    
    public init(console: ConsoleClient) {
        self.console = console
    }
    
    /// Main entry point for menu interface
    public func main() {
        let menu = initMenus()
        displayMenu(menu: menu)
    }
    
    open func initMenus() -> MenuItem {
        return self.createMenu(name: "Menu", initializer: { (_, _) in })
    }
    
    public func performAction(action: Action, parents: [MenuItem]) {
        switch(action) {
        case .exit:
            console.recordExitCode(0)
        case .closure(let closure):
            autoreleasepool {
                closure()
            }
        case .subMenu(let menu):
            autoreleasepool {
                displayMenu(menu: menu, parents: parents)
            }
        }
    }
    
    public func displayMenu(menu: MenuItem, parents: [MenuItem] = []) {
        // Perform automatic action
        if let action = menu.initAction {
            performAction(action: action, parents: parents + [menu])
        }
        
        let menusBreadcrumb = (parents + [menu]).map { $0.name }.joined(separator: " = ")
        
        var message: String? = nil

        repeat {
            let result: Console.CommandMenuResult = autoreleasepool {
                console.clearScreen()

                console.printLine("= \(menusBreadcrumb)")
                console.printLine("Please select an option bellow:")
                
                // Print options
                for (i, action) in menu.actions.enumerated() {
                    console.printLine("\(i + 1): \(action.title)")
                }
                
                // Print 0-eth item to return
                if let superMenu = parents.last {
                    console.printLine("0: Return to \(superMenu.name)")
                } else {
                    console.printLine("0: Exit")
                }

                if let msg = message {
                    console.printLine(msg)
                    message = nil
                }
                
                guard let input = console.readLineWith(prompt: ">") else {
                    console.recordExitCode(0)
                    return .quit
                }
                
                if input.hasPrefix("e") || input.hasPrefix("q") {
                    console.recordExitCode(0)
                    return .quit
                }
                
                guard let option = Int(input) else {
                    message = "Invalid option \(input)"
                    return .loop
                }
                
                if option > 0 && menu.actions.count == 0 {
                    message = "Invalid option index \(option)"
                    return .loop
                }
                
                switch option {
                case 0:
                    if parents.count > 0 { // Return to parent
                        return .quit
                    }
                    
                    console.printLine("Babye!")
                    console.recordExitCode(0)
                    return .quit
                case (1...menu.actions.count):
                    performAction(action: menu.actions[option - 1].action, parents: parents + [menu])
                default:
                    message = "Invalid option \(input)"
                }
                
                return .loop
            }
            
            if result == .quit {
                return
            }
        } while true
    }
    
    @discardableResult
    public func createMenu(name: String, initializer: (_ controller: MenuController, _ item: inout MenuItem) -> Void) -> MenuItem {
        let menu = currentBuildingMenu
        defer {
            currentBuildingMenu = menu
        }
        var acts = currentBuildingMenu?.actions
        let m = createMenu(name: name, targetActions: &acts, initializer: { currentBuildingMenu = $1; initializer($0, &$1) })
        menu?.actions = acts ?? []
        return m
    }
    
    public func createMenu(name: String, targetActions: inout [(title: String, action: Action)]?, initializer: (_ controller: MenuController, _ item: inout MenuItem) -> Void) -> MenuItem {
        var item = MenuItem(name: name, actions: [])
        targetActions?.append((name, .subMenu(menu: item)))
        initializer(self, &item)
        return item
    }
    
    public func addAction(name: String, closure: @escaping (MenuController) -> ()) {
        let cl: () -> Void = { [weak self] in
            if let sSelf = self {
                closure(sSelf)
            }
        }
        
        currentBuildingMenu?.actions.append((name, .closure(executing: cl)))
    }
    
    public class MenuItem {
        public var name: String
        public var actions: [(title: String, action: Action)]
        
        /// Action that is fired automatically when the submenu is opened.
        /// Is not recurrent when returning to the menu from one of it's submenus,
        /// firing only when displaying the menu from above.
        public var initAction: Action?
        
        public init(name: String, actions: [(String, Action)] = [], initAction: Action? = nil) {
            self.name = name
            self.actions = actions
        }
    }
    
    public indirect enum Action {
        case closure(executing: () -> ())
        case subMenu(menu: MenuItem)
        case exit
    }
}

fileprivate func strongSelf(_ value: MenuController?, execute: (MenuController) -> ()) {
    if let value = value {
        execute(value)
    }
}
