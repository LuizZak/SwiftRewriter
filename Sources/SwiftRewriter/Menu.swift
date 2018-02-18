import Console

/// Main menu for the application, when the user does not provide initial inputs
/// for processing.
public class Menu: MenuController {
    public override func initMenus() -> MenuController.MenuItem {
        
        return createMenu(name: "Main") { menu, item in
            item.initAction = .closure {
                menu.console.printLine("Welcome to Swift Rewriter")
            }
            
            menu.createMenu(name: "Explore files") { menu, item in
                
            }
        }
    }
}
