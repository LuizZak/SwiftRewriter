import XCTest
import TestCommons

class StringDiffTestingTests: XCTestCase {
    var testReporter: TestDiffReporter!
    
    override func setUp() {
        super.setUp()
        
        testReporter = TestDiffReporter()
    }
    
    func testDiffSimpleString() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: """
                abc
                def
                """).diff("""
                abc
                df
                """)
        #sourceLocation()
        
        XCTAssertEqual(
            testReporter.messages[0],
            """
            test.swift:4: Strings don't match:

            Expected (between ---):

            ---
            abc
            def
            ---

            Actual result (between ---):

            ---
            abc
            df
            ---

            Diff (between ---):

            ---
            abc
            df
            ~^ Difference starts here
            ---
            """
        )
        
        XCTAssertEqual(
            testReporter.messages[1],
            """
            test.swift:3: Difference starts here: Actual line reads 'df'
            """
        )
    }
    
    func testDiffEmptyStrings() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: "").diff("")
        #sourceLocation()
        
        XCTAssertEqual(testReporter.messages.count, 0)
    }
    
    func testDiffEqualStrings() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: """
                abc
                def
                """).diff("""
                abc
                def
                """)
        #sourceLocation()
        
        XCTAssertEqual(testReporter.messages.count, 0)
    }
    
    func testDiffWhitespaceString() {
           #sourceLocation(file: "test.swift", line: 1)
           diffTest(expected: """
                
                """).diff("test")
           #sourceLocation()
           
           XCTAssertEqual(
               testReporter.messages[0],
               """
               test.swift:3: Strings don't match:

               Expected (between ---):

               ---

               ---

               Actual result (between ---):

               ---
               test
               ---

               Diff (between ---):

               ---
               test
               ^ Difference starts here
               ---
               """
           )
           
           XCTAssertEqual(
               testReporter.messages[1],
               """
               test.swift:2: Difference starts here: Actual line reads 'test'
               """
           )
       }
    
    func testDiffLargerExpectedString() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: """
                abc
                def
                ghi
                """).diff("""
                abc
                def
                """)
        #sourceLocation()
        
        XCTAssertEqual(
            testReporter.messages[0],
            """
            test.swift:5: Strings don't match:

            Expected (between ---):

            ---
            abc
            def
            ghi
            ---

            Actual result (between ---):

            ---
            abc
            def
            ---

            Diff (between ---):

            ---
            abc
            def
            ~~~^ Difference starts here
            ---
            """
        )
        
        XCTAssertEqual(
            testReporter.messages[1],
            """
            test.swift:4: Difference starts here: Expected matching line 'ghi'
            """
        )
    }
    
    func testDiffLargerExpectedStringWithMismatchInMiddle() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: """
                abc
                def
                ghi
                """).diff("""
                abc
                xyz
                """)
        #sourceLocation()
        
        XCTAssertEqual(
            testReporter.messages[0],
            """
            test.swift:5: Strings don't match:

            Expected (between ---):

            ---
            abc
            def
            ghi
            ---

            Actual result (between ---):

            ---
            abc
            xyz
            ---

            Diff (between ---):

            ---
            abc
            xyz
            ^ Difference starts here
            ---
            """
        )
        
        XCTAssertEqual(
            testReporter.messages[1],
            """
            test.swift:3: Difference starts here: Actual line reads 'xyz'
            """
        )
    }
    
    func testDiffLargerResultString() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: """
                abc
                def
                """).diff("""
                abc
                def
                ghi
                """)
        #sourceLocation()
        
        XCTAssertEqual(
            testReporter.messages[0],
            """
            test.swift:4: Strings don't match:

            Expected (between ---):

            ---
            abc
            def
            ---

            Actual result (between ---):

            ---
            abc
            def
            ghi
            ---

            Diff (between ---):

            ---
            abc
            def
            ghi
            ~~~^ Difference starts here
            ---
            """
        )
        
        XCTAssertEqual(
            testReporter.messages[1],
            """
            test.swift:3: Difference starts here: Extraneous content after this line
            """
        )
    }
    
    func testDiffLargerExpectedStringWithChangeAtFirstLine() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: """
                label:
                if true {
                }
                """).diff("""
                if true {
                    }
                """)
        #sourceLocation()
        
        XCTAssertEqual(
            testReporter.messages[0],
            """
            test.swift:5: Strings don't match:

            Expected (between ---):

            ---
            label:
            if true {
            }
            ---

            Actual result (between ---):

            ---
            if true {
                }
            ---

            Diff (between ---):

            ---
            if true {
            ^ Difference starts here
                }
            ---
            """
        )
        
        XCTAssertEqual(
            testReporter.messages[1],
            """
            test.swift:2: Difference starts here: Actual line reads 'if true {'
            """
        )
    }
    
    func testDiffLargeMultiLineStrings() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: """
                line 1
                line 2
                line 3
                line 4
                line 5
                line 6
                line 7
                line 8
                line 9
                line 10
                """).diff("""
                line 1
                line 2
                line 3
                line 4
                DIFFERENCE
                line 6
                line 7
                line 8
                line 9
                line 10
                """)
        #sourceLocation()
        
        XCTAssertEqual(
            testReporter.messages[0],
            """
            test.swift:12: Strings don't match:

            Expected (between ---):

            ---
            line 1
            line 2
            line 3
            line 4
            line 5
            line 6
            line 7
            line 8
            line 9
            line 10
            ---

            Actual result (between ---):

            ---
            line 1
            line 2
            line 3
            line 4
            DIFFERENCE
            line 6
            line 7
            line 8
            line 9
            line 10
            ---

            Diff (between ---):

            --- [2 lines omitted]
            line 3
            line 4
            DIFFERENCE
            ^ Difference starts here
            line 6
            line 7
            --- [3 lines omitted]
            """
        )
        
        XCTAssertEqual(
            testReporter.messages[1],
            """
            test.swift:6: Difference starts here: Actual line reads 'DIFFERENCE'
            """
        )
    }
    
    func testDiffLargeMultiLineStringsNoLinesOmittedBefore() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: """
                line 1
                line 2
                line 3
                line 4
                line 5
                """).diff("""
                DIFFERENCE
                line 2
                line 3
                line 4
                line 5
                """)
        #sourceLocation()
        
        XCTAssertEqual(
            testReporter.messages[0],
            """
            test.swift:7: Strings don't match:

            Expected (between ---):

            ---
            line 1
            line 2
            line 3
            line 4
            line 5
            ---

            Actual result (between ---):

            ---
            DIFFERENCE
            line 2
            line 3
            line 4
            line 5
            ---

            Diff (between ---):

            ---
            DIFFERENCE
            ^ Difference starts here
            line 2
            line 3
            --- [2 lines omitted]
            """
        )
        
        XCTAssertEqual(
            testReporter.messages[1],
            """
            test.swift:2: Difference starts here: Actual line reads 'DIFFERENCE'
            """
        )
    }
    
    func testDiffLargeMultiLineStringsNoLinesOmittedAfter() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: """
                line 1
                line 2
                line 3
                line 4
                line 5
                """).diff("""
                line 1
                line 2
                line 3
                line 4
                DIFFERENCE
                """)
        #sourceLocation()
        
        XCTAssertEqual(
            testReporter.messages[0],
            """
            test.swift:7: Strings don't match:

            Expected (between ---):

            ---
            line 1
            line 2
            line 3
            line 4
            line 5
            ---

            Actual result (between ---):

            ---
            line 1
            line 2
            line 3
            line 4
            DIFFERENCE
            ---

            Diff (between ---):

            --- [2 lines omitted]
            line 3
            line 4
            DIFFERENCE
            ^ Difference starts here
            ---
            """
        )
        
        XCTAssertEqual(
            testReporter.messages[1],
            """
            test.swift:6: Difference starts here: Actual line reads 'DIFFERENCE'
            """
        )
    }
    
    func testDiffOnly() {
        #sourceLocation(file: "test.swift", line: 1)
        diffTest(expected: """
                abc
                def
                """, diffOnly: true).diff("""
                abc
                df
                """)
        #sourceLocation()
        
        XCTAssertEqual(
            testReporter.messages[0],
            """
            test.swift:4: Strings don't match:

            Diff (between ---):

            ---
            abc
            df
            ~^ Difference starts here
            ---
            """
        )
        
        XCTAssertEqual(
            testReporter.messages[1],
            """
            test.swift:3: Difference starts here: Actual line reads 'df'
            """
        )
    }
}

extension StringDiffTestingTests {
    public func diffTest(expected input: String,
                         diffOnly: Bool = false,
                         file: String = #file,
                         line: Int = #line) -> DiffingTest {
        
        let location = DiffLocation(file: file, line: line)
        let diffable = DiffableString(string: input, location: location)
        
        return DiffingTest(expected: diffable,
                           testCase: testReporter,
                           highlightLineInEditor: true,
                           diffOnly: diffOnly)
    }
}

class TestDiffReporter: DiffTestCaseFailureReporter {
    var messages: [String] = []
    
    func recordFailure(withDescription description: String,
                       inFile filePath: String,
                       atLine lineNumber: Int,
                       expected: Bool) {
        
        messages.append("\(filePath):\(lineNumber): " + description)
        
    }
}
