import Foundation
import XCTest

@available(macOS 10.13, *)
class TestFixture {
    let baseUrl: URL
    let gitRepository: GitRepositoryManager
    
    init(baseUrl: URL) throws {
        self.gitRepository = try GitRepositoryManager.makeDefault()
        self.baseUrl = baseUrl
    }
    
    /// Runs a full transpilation test on the base URL, asserting that no unexpected
    /// changes have been introduced since the last execution.
    func runTranspileTest() {
        assertStatusClean(message: "Git status for fixture directory is dirty, please commit changes prior to continuing:")
        
        let process = Process()
        process.executableURL = swiftRewriterBinaryPath
        process.arguments = ["path", baseUrl.path, "-t", "8", "-s", "-o"]
        
        print("Running $ \(asInvocation(process))")
        
        do {
            let result = try runProcess(process, stdin: nil)
            
            XCTAssertEqual(result.terminationStatus, 0, "Error executing SwiftRewriter: \n\(result.standardOutput)")
            
            assertStatusClean(message: """
                Unexpected changes introduced to test fixture project, please check command execution
                and result - command:
                
                \(asInvocation(process))
                
                dirty files:
                """)
        } catch {
            XCTFail("Failed test: \(error)")
        }
    }
    
    private func assertStatusClean(message: String) {
        do {
            let status = try gitRepository.status()
            
            let dirtyFiles = status.fileEntries.filter { $0.path.path.contains(baseUrl.path) }
            if !dirtyFiles.isEmpty {
                XCTFail("""
                    \(message)
                    \(dirtyFiles.map { "\($0.status) \($0.path.path)" }.joined(separator: "\n"))
                    """)
            }
        } catch {
            XCTFail("Error while inspecting repository status: \(error)")
        }
    }
}
