import XCTest
import Foundation

class TestFixtureTests: XCTestCase {
    override func setUpWithError() throws {
        super.setUp()
        
        try XCTSkipUnless(isEndToEndTesting, "End-to-end testing is not enabled for this test configuration")
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
            .appendingPathComponent("SCLAlertView")
    }
    
    var isEndToEndTesting: Bool {
        return ProcessInfo.processInfo.environment["END_TO_END_TESTING"] == "YES"
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
