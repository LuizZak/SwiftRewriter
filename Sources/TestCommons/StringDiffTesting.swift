import Utils
import XCTest

public protocol DiffTestCaseFailureReporter {
    func _recordFailure(withDescription description: String,
                        inFile filePath: StaticString,
                        atLine lineNumber: UInt,
                        expected: Bool)
}

public extension DiffTestCaseFailureReporter {
    
    func diffTest(expected input: String,
                  highlightLineInEditor: Bool = true,
                  file: StaticString = #filePath,
                  line: UInt = #line) -> DiffingTest {
        
        let location = DiffLocation(file: file, line: line)
        let diffable = DiffableString(string: input, location: location)
        
        return DiffingTest(expected: diffable,
                           testCase: self,
                           highlightLineInEditor: highlightLineInEditor)
    }
}

/// Represents a location for a diff'd string
public struct DiffLocation {
    var file: StaticString
    var line: UInt
    
    public init(file: StaticString, line: UInt) {
        self.file = file
        self.line = line
    }
}

public struct DiffableString {
    var string: String
    var location: DiffLocation
    
    public init(string: String,
                location: DiffLocation) {
        self.string = string
        self.location = location
    }
}

public class DiffingTest {
    var expectedDiff: DiffableString
    let testCase: DiffTestCaseFailureReporter
    let highlightLineInEditor: Bool
    
    public init(expected: DiffableString,
                testCase: DiffTestCaseFailureReporter,
                highlightLineInEditor: Bool) {
        
        self.expectedDiff = expected
        self.testCase = testCase
        self.highlightLineInEditor = highlightLineInEditor
    }
    
    public func diff(_ res: String,
                     file: StaticString = #filePath,
                     line: UInt = #line) {
        
        if expectedDiff.string == res {
            return
        }
        
        testCase._recordFailure(
            withDescription: """
            Strings don't match:
            
            Expected (between ---):
            
            ---
            \(expectedDiff.string)
            ---
            
            Actual result (between ---):
            
            ---
            \(res)
            ---
            
            Diff (between ---):
            
            ---
            \(res.makeDifferenceMarkString(against: expectedDiff.string))
            ---
            """,
            inFile: file,
            atLine: line,
            expected: true
        )
        
        if !highlightLineInEditor {
            return
        }
        
        // Report inline in Xcode now
        guard let (diffStartLine, diffStartColumn) = res.firstDifferingLineColumn(against: expectedDiff.string) else {
            return
        }
        
        let expectedLineRanges = expectedDiff.string.lineRanges()
        let resLineRanges = res.lineRanges()
        
        if diffStartLine - 1 < expectedLineRanges.count && resLineRanges.count == expectedLineRanges.count {
            let resLineContent = res[resLineRanges[max(0, diffStartLine - 1)]]
            
            testCase._recordFailure(
                withDescription: """
                Difference starts here: Actual line reads '\(resLineContent)'
                """,
                inFile: file,
                atLine: expectedDiff.location.line + UInt(diffStartLine),
                expected: true
            )
        } else if resLineRanges.count < expectedLineRanges.count {
            let isAtLastColumn: Bool = {
                guard let last = expectedLineRanges.last else {
                    return false
                }
                
                let dist = expectedDiff.string.distance(from: last.lowerBound, to: last.upperBound)
                
                return diffStartColumn == dist + 1
            }()
            
            if diffStartLine == expectedLineRanges.count - 1 && isAtLastColumn {
                let resultLineContent = expectedDiff.string[expectedLineRanges[diffStartLine]]
                
                testCase._recordFailure(
                    withDescription: """
                    Difference starts here: Expected matching line '\(resultLineContent)'
                    """,
                    inFile: file,
                    atLine: expectedDiff.location.line + UInt(diffStartLine + 1),
                    expected: true
                )
            } else {
                let resLineContent = res[resLineRanges[max(0, diffStartLine - 1)]]
                
                testCase._recordFailure(
                    withDescription: """
                    Difference starts here: Actual line reads '\(resLineContent)'
                    """,
                    inFile: file,
                    atLine: expectedDiff.location.line + UInt(diffStartLine),
                    expected: true
                )
            }
        } else {
            testCase._recordFailure(
                withDescription: """
                Difference starts here: Extraneous content after this line
                """,
                inFile: file,
                atLine: expectedDiff.location.line + UInt(expectedLineRanges.count),
                expected: true
            )
        }
    }
}

// MARK: - XCTestCase: TestCaseFailureReporter
extension XCTestCase: DiffTestCaseFailureReporter {
    public func _recordFailure(withDescription description: String, inFile filePath: StaticString, atLine lineNumber: UInt, expected: Bool) {
        XCTFail(description, file: filePath, line: lineNumber)
    }
}
