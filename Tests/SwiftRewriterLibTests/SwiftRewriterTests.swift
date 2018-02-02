import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class SwiftRewriterTests: XCTestCase {
    
    func testParseNonnullMacros() throws {
        try assertObjcParse(objc: """
            NS_ASSUME_NONNULL_BEGIN
            NS_ASSUME_NONNULL_END
            """, swift: """
            """)
    }
    
    func testRewriteEmptyClass() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass: NSObject
            @end
            """,
            swift: """
            class MyClass: NSObject {
            }
            """)
    }
    
    func testRewriteInfersNSObjectSuperclass() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            @end
            """,
            swift: """
            class MyClass: NSObject {
            }
            """)
    }
    
    func testRewriteInheritance() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass : UIView
            @end
            """,
            swift: """
            class MyClass: UIView {
            }
            """)
    }
    
    func testRewriteProtocolSpecification() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass : UIView <UITableViewDelegate>
            @end
            """,
            swift: """
            class MyClass: UIView, UITableViewDelegate {
            }
            """)
    }
    
    func testRewriteClassProperties() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            @property BOOL someField;
            @property NSInteger someOtherField;
            @property (nonnull) NSString *aRatherStringlyField;
            @property (nullable) NSString *specifiedNull;
            @property NSString *_Nonnull nonNullWithQualifier;
            @property NSString *nonSpecifiedNull;
            @property id idType;
            @property (weak) id<MyDelegate, MyDataSource> delegate;
            @property (nonnull) UITableView<UITableViewDataSource> *tableWithDataSource;
            @property (weak) UIView<UIDelegate> *weakViewWithDelegate;
            @property (assign, nonnull) MyClass *assignProp;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                var someField: Bool
                var someOtherField: Int
                var aRatherStringlyField: String
                var specifiedNull: String?
                var nonNullWithQualifier: String
                var nonSpecifiedNull: String!
                var idType: AnyObject!
                weak var delegate: AnyObject<MyDelegate, MyDataSource>?
                var tableWithDataSource: UITableView & UITableViewDataSource
                weak var weakViewWithDelegate: (UIView & UIDelegate)?
                unowned(unsafe) var assignProp: MyClass
            }
            """)
    }
    
    func testRewriteNSArray() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            @property (nonnull) NSArray* nontypedArray;
            @property (nullable) NSArray* nontypedArrayNull;
            @property NSArray<NSString*>* stringArray;
            @property (nonnull) NSArray<SomeType*>* clsArray;
            @property (nullable) NSArray<SomeType*>* clsArrayNull;
            @property (nonnull) SomeType<SomeDelegate> *delegateable;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                var nontypedArray: NSArray
                var nontypedArrayNull: NSArray?
                var stringArray: [String]!
                var clsArray: [SomeType]
                var clsArrayNull: [SomeType]?
                var delegateable: SomeType & SomeDelegate
            }
            """)
    }
    
    func testRewriteInstanceVariables() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            {
                NSString *_myString;
                __weak id _delegate;
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                private var _myString: String!
                private weak var _delegate: AnyObject?
            }
            """)
    }
    
    func testRewriteEmptyMethod() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (void)myMethod;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                func myMethod() {
                }
            }
            """)
    }
    
    func testRewriteEmptyClassMethod() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            + (void)myMethod;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                static func myMethod() {
                }
            }
            """)
    }
    
    func testRewriteMethodSignatures() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (void)myMethod;
            - (NSInteger)myOtherMethod:(NSInteger)abc aString:(nonnull NSString*)str;
            - (NSInteger)myAnonParamMethod:(NSInteger)abc :(nonnull NSString*)str;
            - (nullable NSArray*)someNullArray;
            - (void):a;
            - :a;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                func myMethod() {
                }
                func myOtherMethod(abc: Int, aString str: String) -> Int {
                }
                func myAnonParamMethod(abc: Int, _ str: String) -> Int {
                }
                func someNullArray() -> NSArray? {
                }
                func __(a: AnyObject!) {
                }
                func __(a: AnyObject!) -> AnyObject! {
                }
            }
            """)
    }
    
    func testRewriteInitMethods() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (instancetype)init;
            - (instancetype)initWithThing:(id)thing;
            - (instancetype)initWithNumber:(nonnull NSNumber*)number;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                init() {
                }
                init(with thing: AnyObject!) {
                }
                init(with number: NSNumber) {
                }
            }
            """)
    }
    
    func testRewriteIVarsWithAccessControls() throws {
        try assertObjcParse(objc: """
            @interface MyClass
            {
                NSString *_myString;
            @package
                __weak id _delegate;
            @public
                NSInteger _myInt;
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                private var _myString: String!
                weak var _delegate: AnyObject?
                public var _myInt: Int
            }
            """)
    }
    
    func testRewriteInterfaceWithImplementation() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (instancetype)initWithThing:(id)thing;
            - (void)myMethod;
            @end
            
            @implementation MyClass
            - (instancetype)initWithThing:(id)thing {
                // Init here
            }
            - (void)myMethod {
                // Function body here
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                init(with thing: AnyObject!) {
                    // Init here
                }
                func myMethod() {
                    // Function body here
                }
            }
            """)
    }
    
    func testRewriteInterfaceWithCategoryWithImplementation() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (instancetype)initWithThing:(id)thing;
            - (void)myMethod;
            @end

            @interface MyClass () <MyDelegate>
            {
                /// Coments that are meant to be ignored.
                /// None of these should affect parsing
                NSInteger anIVar;
            }
            - (void)methodFromCategory;
            @end
            
            @implementation MyClass
            - (instancetype)initWithThing:(id)thing {
                // Init here
            }
            - (void)myMethod {
                // Function body here
            }
            @end
            """,
            swift: """
            class MyClass: NSObject, MyDelegate {
                private var anIVar: Int
                
                init(with thing: AnyObject!) {
                    // Init here
                }
                func myMethod() {
                    // Function body here
                }
                func methodFromCategory() {
                }
            }
            """)
    }
    
    func testWhenRewritingMethodsSignaturesWithNullabilityOverrideSignaturesWithout() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (instancetype)initWithThing:(nonnull id)thing;
            - (void)myMethod;
            @end
            
            @implementation MyClass
            - (instancetype)initWithThing:(id)thing {
                // Init here
            }
            - (void)myMethod {
                // Function body here
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                init(with thing: AnyObject) {
                    // Init here
                }
                func myMethod() {
                    // Function body here
                }
            }
            """)
    }
    
    func testRewriteGlobalVariableDeclaration() throws {
        try assertObjcParse(
            objc: """
            const NSInteger myGlobal;
            NSInteger myOtherGlobal;
            """,
            swift: """
            let myGlobal: Int
            var myOtherGlobal: Int
            """)
    }
    
    func testRewriteGlobalVariableDeclarationWithInitialValue() throws {
        try assertObjcParse(
            objc: """
            const CGFloat kMyConstantValue = 45;
            NSString *_Nonnull kMyNotConstantValue;
            """,
            swift: """
            let kMyConstantValue: CGFloat = 45
            var kMyNotConstantValue: String
            """)
    }
    
    func testRewriterUsesNonnullMacrosForNullabilityInferring() throws {
        try assertObjcParse(
            objc: """
            NS_ASSUME_NONNULL_BEGIN
            @interface MyClass1
            - (id)aMethod:(NSString*)param;
            @end
            NS_ASSUME_NONNULL_END
            @interface MyClass2
            - (id)aMethod:(NSString*)param;
            @end
            """,
            swift: """
            class MyClass1: NSObject {
                func aMethod(param: String) -> AnyObject {
                }
            }
            class MyClass2: NSObject {
                func aMethod(param: String!) -> AnyObject! {
                }
            }
            """)
    }
    
    func testRewriterMergesNonnullMacrosForNullabilityInferring() throws {
        try assertObjcParse(
            objc: """
            NS_ASSUME_NONNULL_BEGIN
            @interface MyClass
            - (id)aMethod:(NSString*)param;
            @end
            NS_ASSUME_NONNULL_END
            @implementation MyClass
            - (id)aMethod:(NSString*)param {
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                func aMethod(param: String) -> AnyObject {
                    
                }
            }
            """)
    }
    
    private func assertObjcParse(objc: String, swift expectedSwift: String, file: String = #file, line: Int = #line) throws {
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

private class TestSingleInputProvider: InputSourcesProvider, InputSource {
    var code: String
    
    init(code: String) {
        self.code = code
    }
    
    func sources() -> [InputSource] {
        return [self]
    }
    
    func sourceName() -> String {
        return "\(type(of: self)).m"
    }
    
    func loadSource() throws -> CodeSource {
        return StringCodeSource(source: code)
    }
}

private class TestWriterOutput: WriterOutput, FileOutput {
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
