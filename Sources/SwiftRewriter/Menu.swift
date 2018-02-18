import Console

/// Main menu for the application, when the user does not provide initial inputs
/// for processing.
public class Menu: MenuController {
    public override func initMenus() -> MenuController.MenuItem {
        
        return createMenu(name: "Main menu") { menu, item in
            menu.addAction(name: "Test menu") { menu in
                menu.console.printLine("Oppie!")
            }
        }
    }
}
