import XCTest
import SwiftRewriter
import ObjcParser
import GrammarModels

class SwiftRewriterTests: XCTestCase {
    
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
            @property NSString *_Nonnull nonNullWithQualifier;
            @property NSString* nonSpecifiedNull;
            @end
            """,
            swift: """
            class MyClass {
                var someField: Bool
                var someOtherField: Int
                var aRatherStringlyField: String
                var specifiedNull: String?
                var nonNullWithQualifier: String
                var nonSpecifiedNull: String!
            }
            """)
    }
    
    func testRewriteNSArray() throws {
        try assertObjcTypeParse(
            objc: """
            @interface MyClass
            @property (nonnull) NSArray* nontypedArray;
            @property (nullable) NSArray* nontypedArrayNull;
            @property NSArray<NSString*>* stringArray;
            @property (nonnull) NSArray<SomeType*>* clsArray;
            @property (nullable) NSArray<SomeType*>* clsArrayNull;
            @end
            """,
            swift: """
            class MyClass {
                var nontypedArray: NSArray
                var nontypedArrayNull: NSArray?
                var stringArray: [String]!
                var clsArray: [SomeType]
                var clsArrayNull: [SomeType]?
            }
            """)
    }
    
    func testRewriteMethod() throws {
        try assertObjcTypeParse(
            objc: """
            @interface MyClass
            - (void)myMethod;
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                }
            }
            """)
    }
    
    private func assertObjcTypeParse(objc: String, swift expectedSwift: String, file: String = #file, line: Int = #line) throws {
        let output = TestWriterOutput()
        let input = TestSingleInputProvider(code: objc)
        
        let sut = SwiftRewriter(input: input, output: output)
        
        do {
            try sut.rewrite()
            
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

class TestSingleInputProvider: InputSourcesProvider, InputSource {
    var code: String
    
    init(code: String) {
        self.code = code
    }
    
    func sources() -> [InputSource] {
        return [self]
    }
    
    func loadSource() throws -> CodeSource {
        return StringCodeSource(source: code)
    }
}

class TestWriterOutput: WriterOutput, FileOutput {
    var buffer: String = ""
    
    func createFile(path: String) -> FileOutput {
        return self
    }
    
    func close() {
        
    }
    
    func outputTarget() -> RewriterOutputTarget {
        let target = StringRewriterOutput()
        
        target.onChangeBuffer = { value in
            self.buffer = value
        }
        
        return target
    }
}
