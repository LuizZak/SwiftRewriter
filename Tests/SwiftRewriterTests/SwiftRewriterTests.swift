import XCTest
import SwiftRewriter
import ObjcParser
import GrammarModels

class SwiftRewriterTests: XCTestCase {
    
    func testRewriteClassInterface() throws {
        // Arrange
        let expected = """
            class MyClass {
            }
            """
        let cls = ObjcClassInterface()
        cls.identifier = .valid(Identifier(name: "MyClass"))
        let output = StringRewriterOutput()
        let rewriter = SwiftRewriter(outputTarget: output, globalNode: GlobalContextNode())
        rewriter.add(classInterface: cls)
        
        // Act
        try rewriter.rewrite()
        
        // Assert
        XCTAssertEqual(output.buffer, expected)
    }
    
    func testRewriteEmptyClass() throws {
        try assertObjcTypeParse(
            objc: """
            @interface MyClass
            @end
            """,
            swift: """
            class MyClass {
            }
            """)
    }
    
    func testRewriteClassWithProperty() throws {
        try assertObjcTypeParse(
            objc: """
            @interface MyClass
            @property BOOL someField;
            @property NSInteger someOtherField;
            @property (nonnull) NSString* aRatherStringlyField;
            @property (nullable) NSString* specifiedNull;
            @property NSString* nonSpecifiedNull;
            @end
            """,
            swift: """
            class MyClass {
                var someField: Bool
                var someOtherField: Int
                var aRatherStringlyField: String
                var specifiedNull: String?
                var nonSpecifiedNull: String!
            }
            """)
    }
    
    func testRewriteNSArray() throws {
        try assertObjcTypeParse(
            objc: """
            @interface MyClass
            @property (nonnull) NSArray* nontypedArray;
            @property NSArray<NSString*>* stringArray;
            @property NSArray<SomeType*>* clsArray;
            @end
            """,
            swift: """
            class MyClass {
                var nontypedArray: NSArray
                var stringArray: [String]
                var clsArray: [SomeType]
            }
            """)
    }
    
    private func assertObjcTypeParse(objc: String, swift expectedSwift: String, file: String = #file, line: Int = #line) throws {
        let sut = ObjcParser(string: objc)
        
        do {
            try sut.parse()
            
            let globalNode = sut.rootNode
            
            let output = StringRewriterOutput()
            let rewriter = SwiftRewriter(outputTarget: output, globalNode: globalNode)
            
            try rewriter.rewrite()
            
            if output.buffer != expectedSwift {
                recordFailure(withDescription: "Failed: Expected to translate Objective-C \(objc) as \(expectedSwift), but translate as \(output.buffer)", inFile: file, atLine: line, expected: false)
            }
            
            if sut.diagnostics.errors.count != 0 {
                recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(sut.diagnostics.errors.description)", inFile: file, atLine: line, expected: false)
            }
        } catch {
            recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(error)", inFile: file, atLine: line, expected: false)
        }
    }
}
