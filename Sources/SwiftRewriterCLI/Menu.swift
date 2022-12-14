import Foundation
import Console
import SwiftRewriterLib

/// Main menu for the application, when the user does not provide initial inputs
/// for processing.
public class Menu: MenuController {
    var rewriterFrontend: SwiftRewriterFrontend
    let fileProvider: FileProvider
    let filesExplorerService: FilesExplorerService
    
    public init(rewriterFrontend: SwiftRewriterFrontend, fileProvider: FileProvider, console: ConsoleClient) {
        self.rewriterFrontend = rewriterFrontend
        self.fileProvider = fileProvider
        filesExplorerService = FilesExplorerService(
            rewriterFrontend: rewriterFrontend,
            fileProvider: fileProvider
        )

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
        menu.addAction(name: "Find files") { [filesExplorerService] menu in
            filesExplorerService.runFileFindMenu(in: menu)
        }
    }
    
    func makeExploreFilesMenu(in menu: MenuController) {
        menu.addAction(name: "Explore files") { [filesExplorerService] menu in
            let path = URL(fileURLWithPath: NSHomeDirectory())
            
            filesExplorerService.runFileExploreMenu(in: menu, url: path)
        }
    }
    
    func makeSuggestConversionsMenu(in menu: MenuController) {
        menu.addAction(name: "Suggest conversion at path") { [filesExplorerService] (menu) in
            filesExplorerService.runSuggestConversionMenu(in: menu)
        }
    }
}
