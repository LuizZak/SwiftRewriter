import Utils
import XCTest

public protocol DiffTestCaseFailureReporter {
    func recordFailure(withDescription description: String,
                       inFile filePath: String,
                       atLine lineNumber: Int,
                       expected: Bool)
}

public extension DiffTestCaseFailureReporter {
    
    func diffTest(expected input: String,
                  highlightLineInEditor: Bool = true,
                  file: String = #file,
                  line: Int = #line) -> DiffingTest {
        
        let location = DiffLocation(file: file, line: line)
        let diffable = DiffableString(string: input, location: location)
        
        return DiffingTest(expected: diffable,
                           testCase: self,
                           highlightLineInEditor: highlightLineInEditor)
    }
}

/// Represents a location for a diff'd string
public struct DiffLocation {
    var file: String
    var line: Int
    
    public init(file: String, line: Int) {
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
                     file: String = #file,
                     line: Int = #line) {
        
        if expectedDiff.string == res {
            return
        }
        
        testCase.recordFailure(
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
            let resLineContent = res[resLineRanges[diffStartLine - 1]]
            
            testCase.recordFailure(
                withDescription: """
                Difference starts here: Actual line reads '\(resLineContent)'
                """,
                inFile: file,
                atLine: expectedDiff.location.line + diffStartLine,
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
                
                testCase.recordFailure(
                    withDescription: """
                    Difference starts here: Expected matching line '\(resultLineContent)'
                    """,
                    inFile: file,
                    atLine: expectedDiff.location.line + diffStartLine + 1,
                    expected: true
                )
            } else {
                let resLineContent = res[resLineRanges[diffStartLine - 1]]
                
                testCase.recordFailure(
                    withDescription: """
                    Difference starts here: Actual line reads '\(resLineContent)'
                    """,
                    inFile: file,
                    atLine: expectedDiff.location.line + diffStartLine,
                    expected: true
                )
            }
        } else {
            testCase.recordFailure(
                withDescription: """
                Difference starts here: Extraneous content after this line
                """,
                inFile: file,
                atLine: expectedDiff.location.line + expectedLineRanges.count,
                expected: true
            )
        }
    }
}

// MARK: - XCTestCase: TestCaseFailureReporter
extension XCTestCase: DiffTestCaseFailureReporter { }
