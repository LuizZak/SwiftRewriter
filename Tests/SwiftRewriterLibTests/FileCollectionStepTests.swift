import XCTest
import SwiftRewriterLib

class FileCollectionStepTests: XCTestCase {

}

class TestFileProvider: FileProvider {
    func enumerator(atPath: String) -> [String]? {
        return nil
    }
    func fileExists(atPath: String) -> Bool {
        return false
    }
}


