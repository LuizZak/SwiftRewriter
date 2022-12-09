import XCTest
import Intentions

public extension Asserter where Object == IntentionCollection {
    /// Opens an asserter context for the list of files in the underlying
    /// `IntentionCollection` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForFiles<Result>(
        _ closure: (Asserter<[FileGenerationIntention]>) -> Result?
    ) -> Self? {
        
        let files = object.fileIntentions()

        return asserter(for: files) { files in
            files.inClosure(closure)
        }.map(self)
    }

    /// Opens an asserter context for a file with a given target path in the
    /// underlying `IntentionCollection` object being tested.
    ///
    /// Name checking is performed against the full
    /// `FileGenerationIntention.targetPath` of each file.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forTargetPathFile targetPath: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<FileGenerationIntention>) -> Result?
    ) -> Self? {
        
        asserterForFiles { files in
            files.asserterForFirstElement(
                message: #"Could not find file with target path "\#(targetPath)""#,
                file: file,
                line: line
            ) {
                $0.targetPath == targetPath
            }?.inClosure(closure)
        }
    }
    
    /// Asserts that the underlying `IntentionCollection` object being tested
    /// has a specified count of files.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        fileCount: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserterForFiles {
            $0.assertCount(fileCount, file: file, line: line)
        }
    }
}
