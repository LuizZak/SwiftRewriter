import XCTest
import SwiftRewriterLib
import SwiftAST

class SwiftRewriter_IntentionPassHistoryTests: XCTestCase {
    func testPrintIntentionHistory() throws {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)setValue:(BOOL)value {
                
            }
            - (BOOL)value {
                return NO;
            }
            - (NSString*)aMethod {
            }
            @end
            
            @interface MyClass
            @property BOOL value;

            - (nonnull NSString*)aMethod;
            @end
            """,
            swift: """
            // [Creation]  line 1 column 1
            // [Creation]  line 12 column 1
            // [PropertyMergeIntentionPass:1] Removed method MyClass.value() -> Bool since deduced it is a getter for property MyClass.value: Bool
            // [PropertyMergeIntentionPass:1] Removed method MyClass.setValue(_ value: Bool) since deduced it is a setter for property MyClass.value: Bool
            class MyClass {
                // [Creation]  line 13 column 1
                // [PropertyMergeIntentionPass:1] Merged MyClass.value() -> Bool and MyClass.setValue(_ value: Bool) into property MyClass.value: Bool
                var value: Bool {
                    get {
                        return false
                    }
                    set(value) {
                    }
                }
                
                // [Creation]  line 8 column 3
                // [TypeMerge] Updated nullability signature from () -> String! to: () -> String
                func aMethod() -> String {
                }
            }
            """,
            options: ASTWriterOptions(printIntentionHistory: true))
    }
    
    func testCFilesHistoryTracking() {
        MultiFileTestBuilder(test: self)
            .file(name: "A.h", """
            typedef struct tree234_Tag tree234;
            typedef int (*cmpfn234)(void *, void *);
            typedef void *(*copyfn234)(void *state, void *element);
            """)
            .file(name: "A.c", """
                        
            struct tree234_Tag {
                node234 *root;
                cmpfn234 cmp;
            };
            """)
            .expectSwiftFile(name: "A.swift", """
            typealias tree234 = tree234_Tag
            typealias cmpfn234 = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> CInt
            typealias copyfn234 = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?

            struct tree234_Tag {
                // [Creation]  line 3 column 5
                var root: UnsafeMutablePointer<node234>!
                // [Creation]  line 4 column 5
                var cmp: cmpfn234!
                
                // [Creation] Synthesizing parameterless constructor for struct
                init() {
                    root = nil
                    cmp = nil
                }
                // [Creation] Synthesizing parameterized constructor for struct
                init(root: UnsafeMutablePointer<node234>!, cmp: cmpfn234!) {
                    self.root = root
                    self.cmp = cmp
                }
            }
            // End of file A.swift
            """)
            .transpile(options: ASTWriterOptions(printIntentionHistory: true))
            .assertExpectedSwiftFiles()
    }
}
