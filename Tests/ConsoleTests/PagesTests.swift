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
        
        let sut = makePagesTestMenu(console: mock, items: pageItems, perPageCount: 30)
        
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
            .checkInputEntered("0")
            .checkNext("Babye!")
            .printIfAsserted()
    }
    
    func testPagesWithPaging() {
        let pageItems: [String] = [
            "Item 1", "Item 2", "Item 3", "Item 4"
        ]
        
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "=2")
        mock.addMockInput(line: "0")
        mock.addMockInput(line: "0")
        
        let sut = makePagesTestMenu(console: mock, items: pageItems, perPageCount: 2)
        
        sut.main()
        
        mock.beginOutputAssertion()
            .checkNext("""
            = Menu
            Please select an option bellow:
            """)
            .checkNext("""
            A list of things
            ----
            1: Item 1
            2: Item 2
            ---- 1 to 2
            = Page 1 of 2
            [INPUT] '=2'
            A list of things
            ----
            3: Item 3
            4: Item 4
            ---- 3 to 4
            = Page 2 of 2
            """)
            .checkInputEntered("0")
            .checkNext("Babye!")
            .printIfAsserted()
    }
    
    func testEmptyLineQuitsPageMenu() {
        let pageItems: [String] = [
            "Item 1", "Item 2", "Item 3", "Item 4"
        ]
        
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "")
        mock.addMockInput(line: "0")
        
        let sut = makePagesTestMenu(console: mock, items: pageItems, perPageCount: 2)
        
        sut.main()
        
        mock.beginOutputAssertion()
            .checkNext("""
            = Menu
            Please select an option bellow:
            """)
            .checkNext("""
            = Page 1 of 2
            """)
            .checkInputEntered("")
            .checkNext("""
            = Menu
            """)
            .checkNextNot(contain: "Issued command")
            .checkNext("Babye!")
            .printIfAsserted()
    }
    
    func testPass0ToQuitPagesWithCommands() {
        let pageItems: [String] = [
            "Item 1", "Item 2", "Item 3", "Item 4"
        ]
        
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "0")
        mock.addMockInput(line: "0")
        
        let sut =
            makePagesTestMenu(console: mock, items: pageItems, perPageCount: 2, command: { _ in
                XCTFail("Did not expect to invoke command handler")
                return .quit("Issued command")
            })
        
        sut.main()
        
        mock.beginOutputAssertion()
            .checkNext("""
            = Menu
            Please select an option bellow:
            """)
            .checkNext("= Page 1 of 2")
            .checkInputEntered("0")
            .checkNext("= Menu")
            .checkNextNot(contain: "Issued command")
            .checkNext("Babye!")
            .printIfAsserted()
    }
    
    func testEmptyLineQuitsPageMenuWithCommand() {
        let pageItems: [String] = [
            "Item 1", "Item 2", "Item 3", "Item 4"
        ]
        
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "")
        mock.addMockInput(line: "0")
        
        let sut =
            makePagesTestMenu(console: mock, items: pageItems, perPageCount: 2, command: { _ in
                XCTFail("Did not expect to invoke command handler")
                return .quit("Issued command")
            })
        
        sut.main()
        
        mock.beginOutputAssertion()
            .checkNext("""
            = Menu
            Please select an option bellow:
            """)
            .checkNext("= Page 1 of 2")
            .checkInputEntered("")
            .checkNext("= Menu")
            .checkNextNot(contain: "Issued command")
            .checkNext("Babye!")
            .printIfAsserted()
    }
    
    func testNumbersWithPlusAndMinusArePageNavigationAndNotCommandInputs() {
        let pageItems: [String] = [
            "Item 1", "Item 2", "Item 3", "Item 4"
        ]
        
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "+1")
        mock.addMockInput(line: "-1")
        mock.addMockInput(line: "0")
        mock.addMockInput(line: "0")
        
        let sut =
            makePagesTestMenu(console: mock, items: pageItems, perPageCount: 2, command: { _ in
                XCTFail("Did not expect to invoke command handler")
                return .quit("Issued command")
            })
        
        sut.main()
        
        mock.beginOutputAssertion()
            .checkNext("""
            = Menu
            Please select an option bellow:
            """)
            .checkNext("""
            A list of things
            ----
            1: Item 1
            2: Item 2
            ---- 1 to 2
            = Page 1 of 2
            """)
            .checkInputEntered("+1")
            .checkNext("""
            A list of things
            ----
            3: Item 3
            4: Item 4
            ---- 3 to 4
            = Page 2 of 2
            """)
            .checkInputEntered("-1")
            .checkNext("""
            A list of things
            ----
            1: Item 1
            2: Item 2
            ---- 1 to 2
            = Page 1 of 2
            """)
            .checkInputEntered("0")
            .checkNext("Babye!")
            .printIfAsserted()
    }
    
    func testNavigatingPagesRelativelyDoesntOverflow() {
        let pageItems: [String] = [
            "Item 1", "Item 2", "Item 3", "Item 4"
        ]
        
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "+5")
        mock.addMockInput(line: "-5")
        mock.addMockInput(line: "0")
        mock.addMockInput(line: "0")
        
        let sut =
            makePagesTestMenu(console: mock, items: pageItems, perPageCount: 2, command: { _ in
                XCTFail("Did not expect to invoke command handler")
                return .quit("Issued command")
            })
        
        sut.main()
        
        mock.beginOutputAssertion()
            .checkNext("""
            = Menu
            Please select an option bellow:
            """)
            .checkNext("""
            A list of things
            ----
            1: Item 1
            2: Item 2
            ---- 1 to 2
            = Page 1 of 2
            """)
            .checkInputEntered("+5")
            .checkNext("""
            A list of things
            ----
            3: Item 3
            4: Item 4
            ---- 3 to 4
            = Page 2 of 2
            """)
            .checkInputEntered("-5")
            .checkNext("""
            A list of things
            ----
            1: Item 1
            2: Item 2
            ---- 1 to 2
            = Page 1 of 2
            """)
            .printIfAsserted()
    }
}

extension PagesTests {
    func makePagesTestMenu(console: ConsoleClient, items: [String], perPageCount: Int) -> TestMenuController {
        return makePagesTestMenu(console: console) { menu in
            let pages = menu.console.makePages()
            
            pages.displayPages(withValues: items, header: "A list of things",
                               perPageCount: perPageCount)
        }
    }
    
    func makePagesTestMenu(console: ConsoleClient, items: [String], perPageCount: Int,
                           command: @escaping (String) throws -> Pages.PagesCommandResult) -> TestMenuController {
        
        let configuration =
            Pages.PageDisplayConfiguration(commandPrompt: nil, commandClosure: command)
        
        return makePagesTestMenu(console: console) { menu in
            let pages = menu.console.makePages(configuration: configuration)
            
            pages.displayPages(withValues: items, header: "A list of things",
                               perPageCount: perPageCount)
        }
    }
    
    func makePagesTestMenu(console: ConsoleClient, items: [String], perPageCount: Int,
                           command: PagesCommandHandler) -> TestMenuController {
        
        return makePagesTestMenu(console: console) { menu in
            let config = Pages.PageDisplayConfiguration(commandHandler: command)
            let pages = menu.console.makePages(configuration: config)
            
            pages.displayPages(withValues: items, header: "A list of things",
                               perPageCount: perPageCount)
        }
    }
    
    func makePagesTestMenu(console: ConsoleClient, with closure: @escaping (MenuController) -> ()) -> TestMenuController {
        let menu = TestMenuController(console: console)
        menu.builder = { menu in
            menu.createMenu(name: "Menu") { (menu, _) in
                menu.addAction(name: "Show pages") { menu in
                    closure(menu)
                }
            }
        }
        
        return menu
    }
}
