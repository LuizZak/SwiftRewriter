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
        
        return createMenu(name: "Main") { menu, item in
            item.initAction = .closure {
                menu.console.printLine("Welcome to Swift Rewriter")
            }
            
            makeExploreFilesMenu(in: menu)
        }
    }
    
    func makeExploreFilesMenu(in menu: MenuController) {
        menu.addAction(name: "Explore files") { [rewriterService] menu in
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
