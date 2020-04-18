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
                ~ Difference at start of string.
               ---
               """
           )
           
           XCTAssertEqual(
               testReporter.messages[1],
               """
               test.swift:1: Difference starts here: Actual line reads 'test'
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
}

extension StringDiffTestingTests {
    public func diffTest(expected input: String,
                         file: String = #file,
                         line: Int = #line) -> DiffingTest {
        
        let location = DiffLocation(file: file, line: line)
        let diffable = DiffableString(string: input, location: location)
        
        return DiffingTest(expected: diffable,
                           testCase: testReporter,
                           highlightLineInEditor: true)
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
