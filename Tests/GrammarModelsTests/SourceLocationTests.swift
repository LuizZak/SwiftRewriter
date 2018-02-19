import XCTest
import GrammarModels

class SourceLocationTests: XCTestCase {
    func testLocationLazyEvaluation() {
        let source = TestSource(string: "Abcdef")
        let location1 = SourceLocation(source: source, intRange: 1..<3)
        let location2 =
            SourceLocation(source: source,
                           range: .range(source.string.index(after: source.string.startIndex)..<source.string.index(source.string.startIndex, offsetBy: 3)))
        
        XCTAssertEqual(location1, location2)
    }
    
    private final class TestSource: Source {
        public let fileName: String = ""
        
        var string: String
        
        init(string: String) {
            self.string = string
        }
        
        func isEqual(to other: Source) -> Bool {
            return other is TestSource
        }
        
        func stringIndex(forCharOffset offset: Int) -> String.Index {
            return string.index(string.startIndex, offsetBy: offset)
        }
        
        func lineNumber(at index: String.Index) -> Int {
            return 0
        }
        
        func columnNumber(at index: String.Index) -> Int {
            return 0
        }
    }
}
