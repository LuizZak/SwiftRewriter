import XCTest
import class Foundation.Bundle

class TestFixtureTests: XCTestCase {
    override func setUpWithError() throws {
        super.setUp()
        
        try XCTSkipUnless(isInGitRepository, "Requires project to be located in a git repository")
    }
    
    func testSclAlertViewTranspile() throws {
        let fixture = try TestFixture(baseUrl: sclAlertViewFixturePath)
        
        fixture.runTranspileTest()
    }
}

extension TestFixtureTests {
    var sclAlertViewFixturePath: URL {
        baseProjectPath
            .appendingPathComponent("TestFixtures")
            .appendingPathComponent("SCLAlertView")
    }
    
    @available(OSX 10.13, *)
    var isInGitRepository: Bool {
        do {
            return try GitRepositoryManager(basePath: baseProjectPath).exists()
        } catch {
            return false
        }
    }
}
