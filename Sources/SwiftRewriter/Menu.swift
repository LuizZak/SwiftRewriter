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
            item.initAction = .closure(executing: {
                menu.console.printLine("Welcome to Swift Rewriter")
            })
            
            makeFindFilesMenu(in: menu)
            makeExploreFilesMenu(in: menu)
            makeSuggestConversionsMenu(in: menu)
        }
    }

    func makeFindFilesMenu(in menu: MenuController) {
        menu.addAction(name: "Find files") { [rewriterService] menu in
            let service = FilesExplorerService(rewriterService: rewriterService)
            service.runFileFindMenu(in: menu)
        }
    }
    
    func makeExploreFilesMenu(in menu: MenuController) {
        menu.addAction(name: "Explore files") { [rewriterService] menu in
            let path = URL(fileURLWithPath: NSHomeDirectory())
            
            let service = FilesExplorerService(rewriterService: rewriterService)
            service.runFileExploreMenu(in: menu, url: path)
        }
    }
    
    func makeSuggestConversionsMenu(in menu: MenuController) {
        menu.addAction(name: "Suggest conversion at path") { [rewriterService] (menu) in
            let service = FilesExplorerService(rewriterService: rewriterService)
            service.runSuggestConversionMenu(in: menu)
        }
    }
}
