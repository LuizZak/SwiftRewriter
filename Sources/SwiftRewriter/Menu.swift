import Foundation
import Console
import ObjectiveCFrontend

/// Main menu for the application, when the user does not provide initial inputs
/// for processing.
public class Menu: MenuController {
    var rewriterFrontend: SwiftRewriterFrontend
    
    public init(rewriterFrontend: SwiftRewriterFrontend, console: ConsoleClient) {
        self.rewriterFrontend = rewriterFrontend
        super.init(console: console)
    }
    
    public override func initMenus() -> MenuController.MenuItem {
        createMenu(name: "Main - \(rewriterFrontend.name)") { menu, item in
            item.initAction = .closure(executing: {
                menu.console.printLine("Welcome to Swift Rewriter")
            })
            
            makeFindFilesMenu(in: menu)
            makeExploreFilesMenu(in: menu)
            makeSuggestConversionsMenu(in: menu)
        }
    }

    func makeFindFilesMenu(in menu: MenuController) {
        menu.addAction(name: "Find files") { [rewriterFrontend] menu in
            let service = FilesExplorerService(rewriterFrontend: rewriterFrontend)
            service.runFileFindMenu(in: menu)
        }
    }
    
    func makeExploreFilesMenu(in menu: MenuController) {
        menu.addAction(name: "Explore files") { [rewriterFrontend] menu in
            let path = URL(fileURLWithPath: NSHomeDirectory())
            
            let service = FilesExplorerService(rewriterFrontend: rewriterFrontend)
            service.runFileExploreMenu(in: menu, url: path)
        }
    }
    
    func makeSuggestConversionsMenu(in menu: MenuController) {
        menu.addAction(name: "Suggest conversion at path") { [rewriterFrontend] (menu) in
            let service = FilesExplorerService(rewriterFrontend: rewriterFrontend)
            service.runSuggestConversionMenu(in: menu)
        }
    }
}
