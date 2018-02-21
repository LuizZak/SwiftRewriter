import Console
import XCTest

class ConsoleMenuControllerTests: ConsoleTestCase {
    func testExitMenu() {
        let mock = makeMockConsole()
        mock.addMockInput(line: "0")
        
        let sut = MenuController(console: mock)
        
        sut.main()
        
        mock.beginOutputAssertion()
            .checkNext("""
            = Menu
            Please select an option bellow:
            """)
            .checkInputEntered("0")
            .checkNext("Babye!")
            .printIfAsserted()
    }
    
    func testInvalidMenuIndex() {
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "0")
        
        let sut = MenuController(console: mock)
        
        sut.main()
        
        mock.beginOutputAssertion()
            .checkNext("Please select an option bellow:")
            .checkInputEntered("1")
            .checkNext("""
                = Menu
                Please select an option bellow:
                0: Exit
                Invalid option index 1
                """)
            .checkInputEntered("0")
            .checkNext("Babye!")
            .printIfAsserted()
    }
    
    func testNoMemoryCyclesInMenuBuilding() {
        var didDeinit = false
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "0")
        
        autoreleasepool {
            let sut = TestMenuController(console: mock, onDeinit: { didDeinit = true })
            
            sut.main()
            
            mock.beginOutputAssertion()
                .checkNext("Please select an option bellow:")
                .checkInputEntered("1")
                .checkNext("Selected menu 1!")
                .checkNext("Please select an option bellow:")
                .checkInputEntered("0")
                .checkNext("Babye!")
                .printIfAsserted()
        }
        
        XCTAssert(didDeinit)
    }
    
    func testNoMemoryCyclesInMenuWithinMenuBuilding() {
        var didDeinit = false
        let mock = makeMockConsole()
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "1")
        mock.addMockInput(line: "0")
        mock.addMockInput(line: "0")
        
        autoreleasepool {
            let sut = TestMenuController(console: mock, onDeinit: { didDeinit = true })
            sut.builder = { menu in
                menu.createMenu(name: "Menu 1") { menu, item in
                    menu.createMenu(name: "Menu 2") { menu, item in
                        menu.addAction(name: "An action") { menu in
                            menu.console.printLine("Selected Menu 1 - Menu 2")
                            
                            menu.createMenu(name: "Menu 3") { _, _ in }
                        }
                    }
                }
            }
            
            sut.main()
            
            mock.beginOutputAssertion()
                .checkNext("= Menu 1")
                .checkNext("Please select an option bellow:")
                .checkInputEntered("1")
                .checkNext("= Menu 1 = Menu 2")
                .checkNext("Selected Menu 1 - Menu 2")
                .checkInputEntered("0")
                .checkNext("= Menu 1")
                .checkNext("Please select an option bellow:")
                .checkInputEntered("0")
                .checkNext("Babye!")
                .printIfAsserted()
        }
        
        XCTAssert(didDeinit)
    }
}

class TestMenuController: MenuController {
    var onDeinit: () -> ()
    var builder: ((MenuController) -> (MenuController.MenuItem))?
    
    override init(console: ConsoleClient) {
        self.onDeinit = { () in }
        super.init(console: console)
    }
    
    init(console: ConsoleClient, onDeinit: @escaping () -> ()) {
        self.onDeinit = onDeinit
        super.init(console: console)
    }
    
    deinit {
        onDeinit()
    }
    
    override func initMenus() -> MenuController.MenuItem {
        if let builder = builder {
            return builder(self)
        }
        
        return createMenu(name: "Main menu") { menu, item in
            menu.addAction(name: "Test menu") { menu in
                menu.console.printLine("Selected menu 1!")
            }
        }
    }
}
