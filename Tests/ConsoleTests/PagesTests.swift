import Foundation
import XCTest
import Console

class PagesTests: ConsoleTestCase {
    func testPages() {
        let pageItems: [String] = [
            "Item 1", "Item 2", "Item 3", "Item 4"
        ]
        
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "0")
        mock.addMockInput(line: "0")
        
        let sut = TestMenuController(console: mock)
        sut.builder = { menu in
            menu.createMenu(name: "Menu") { (menu, _) in
                menu.addAction(name: "Show pages") { _ in
                    let pages = menu.console.makePages()
                    
                    pages.displayPages(withValues: pageItems)
                }
            }
        }
        
        sut.main()
        
        mock.beginOutputAssertion()
            .checkNext("""
            = Menu
            Please select an option bellow:
            """)
            .checkNext("""
            ----
            1: Item 1
            2: Item 2
            3: Item 3
            4: Item 4
            ---- 1 to 4
            """)
            .checkNext("[INPUT] '0'")
            .checkNext("Babye!")
            .printIfAsserted()
    }
    
    func testPagesWithPaging() {
        let pageItems: [String] = [
            "Item 1", "Item 2", "Item 3", "Item 4"
        ]
        
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "2")
        mock.addMockInput(line: "0")
        mock.addMockInput(line: "0")
        
        let sut = TestMenuController(console: mock)
        sut.builder = { menu in
            menu.createMenu(name: "Menu") { (menu, _) in
                menu.addAction(name: "Show pages") { _ in
                    let pages = menu.console.makePages()
                    
                    pages.displayPages(withValues: pageItems, perPageCount: 2)
                }
            }
        }
        
        sut.main()
        
        mock.beginOutputAssertion()
            .checkNext("""
            = Menu
            Please select an option bellow:
            """)
            .checkNext("""
            ----
            1: Item 1
            2: Item 2
            ---- 1 to 2
            = Page 1 of 2
            [INPUT] '2'
            ----
            3: Item 3
            4: Item 4
            ---- 3 to 4
            = Page 2 of 2
            [INPUT] '0'
            """)
            .checkNext("Babye!")
            .printIfAsserted()
    }
}
