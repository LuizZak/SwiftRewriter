import Foundation
import Console

/// Main menu for the application, when the user does not provide initial inputs
/// for processing.
public class Menu: MenuController {
    var rewriterService: SwiftRewriterService
    
    public init(rewriterService: SwiftRewriterService, console: ConsoleClient) {
        self.rewriterService = rewriterService
        super.init(console: console)
    }
    
    public override func initMenus() -> MenuController.MenuItem {
        
        return createMenu(name: "Main") { [rewriterService] menu, item in
            item.initAction = .closure {
                menu.console.printLine("Welcome to Swift Rewriter")
            }
            
            menu.addAction(name: "Explore files") { menu in
                menu.createMenu(name: "Explore files") { menu, item in
                    let path = URL(fileURLWithPath: NSHomeDirectory())
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
                        menu.console.printLine("Failed to navigate directory contents!")
                    }
                }
            }
        }
    }
}
