import SwiftAST
import XCTest

@testable import ObjectiveCFrontend

class ObjectiveC2SwiftRewriter_IntentionPassHistoryTests: XCTestCase {
    func testPrintIntentionHistory() throws {
        assertRewrite(
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
                // [Creation] test.m line 1 column 1
                // [Creation] test.m line 12 column 1
                // [PropertyMergeIntentionPass:1] Removed method MyClass.value() -> Bool since deduced it is a getter for property MyClass.value: Bool
                // [PropertyMergeIntentionPass:1] Removed method MyClass.setValue(_ value: Bool) since deduced it is a setter for property MyClass.value: Bool
                class MyClass {
                    // [Creation] test.m line 13 column 1
                    // [PropertyMergeIntentionPass:1] Merged MyClass.value() -> Bool and MyClass.setValue(_ value: Bool) into property MyClass.value: Bool
                    var value: Bool {
                        get {
                            return false
                        }
                        set(value) {
                        }
                    }

                    // [Creation] test.m line 8 column 3
                    // [TypeMerge:FileTypeMergingIntentionPass] Updated nullability signature from () -> String! to: () -> String
                    func aMethod() -> String {
                    }
                }
                """,
            options: SwiftSyntaxOptions.default.with(\.printIntentionHistory, true)
        )
    }

    func testCFilesHistoryTracking() {
        MultiFileTestBuilder(test: self)
            .file(
                name: "A.h",
                """
                /*
                    A multi-line comment to test line/column count resilience
                */
                // A single line comment
                typedef struct tree234_Tag tree234;
                typedef int (*cmpfn234)(void *, void *);
                typedef void *(*copyfn234)(void *state, void *element);
                """
            )
            .file(
                name: "A.c",
                """
                /*
                    A multi-line comment to test line/column count resilience
                */
                // A single line comment
                #include <stdio.h>
                #include <stdlib.h>
                #include <assert.h>

                #include "tree234.h"

                #include "puzzles.h"               /* for smalloc/sfree */

                #ifdef TEST
                #define LOG(x) (printf x)
                #define smalloc malloc
                #define srealloc realloc
                #define sfree free
                #else
                #define LOG(x) (printf x)
                #endif

                typedef struct node234_Tag node234;

                struct tree234_Tag {
                    node234 *root;
                    cmpfn234 cmp;
                };
                struct node234_Tag {
                    node234 *parent;
                    node234 *kids[4];
                    int counts[4];
                    void *elems[3];
                };
                """
            )
            .expectSwiftFile(
                name: "A.swift",
                """
                // Preprocessor directives found in file:
                // #include <stdio.h>
                // #include <stdlib.h>
                // #include <assert.h>
                // #include "tree234.h"
                // #include "puzzles.h"               /* for smalloc/sfree */
                // #ifdef TEST
                // #define LOG(x) (printf x)
                // #define smalloc malloc
                // #define srealloc realloc
                // #define sfree free
                // #else
                // #define LOG(x) (printf x)
                // #endif
                // [Creation] A.c line 22 column 28
                typealias node234 = node234_Tag
                // [Creation] A.h line 5 column 28
                typealias tree234 = tree234_Tag
                // [Creation] A.h line 6 column 1
                typealias cmpfn234 = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> CInt
                // [Creation] A.h line 7 column 1
                typealias copyfn234 = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?

                // [Creation] A.c line 24 column 1
                struct tree234_Tag {
                    // [Creation] A.c line 25 column 5
                    var root: UnsafeMutablePointer<node234>!
                    // [Creation] A.c line 26 column 5
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
                // [Creation] A.c line 28 column 1
                struct node234_Tag {
                    // [Creation] A.c line 29 column 5
                    var parent: UnsafeMutablePointer<node234>!
                    // [Creation] A.c line 30 column 5
                    var kids: (UnsafeMutablePointer<node234>!, UnsafeMutablePointer<node234>!, UnsafeMutablePointer<node234>!, UnsafeMutablePointer<node234>!)
                    // [Creation] A.c line 31 column 5
                    var counts: (CInt, CInt, CInt, CInt)
                    // [Creation] A.c line 32 column 5
                    var elems: (UnsafeMutableRawPointer!, UnsafeMutableRawPointer!, UnsafeMutableRawPointer!)

                    // [Creation] Synthesizing parameterless constructor for struct
                    init() {
                        parent = nil

                        kids = (nil, nil, nil, nil)

                        counts = (0, 0, 0, 0)

                        elems = (nil, nil, nil)
                    }
                    // [Creation] Synthesizing parameterized constructor for struct
                    init(parent: UnsafeMutablePointer<node234>!, kids: (UnsafeMutablePointer<node234>!, UnsafeMutablePointer<node234>!, UnsafeMutablePointer<node234>!, UnsafeMutablePointer<node234>!), counts: (CInt, CInt, CInt, CInt), elems: (UnsafeMutableRawPointer!, UnsafeMutableRawPointer!, UnsafeMutableRawPointer!)) {
                        self.parent = parent

                        self.kids = kids

                        self.counts = counts

                        self.elems = elems
                    }
                }
                // End of file A.swift
                """
            )
            .transpile(options: SwiftSyntaxOptions.default.with(\.printIntentionHistory, true))
            .assertExpectedSwiftFiles()
    }

    func testDefineDeclarationHistoryTracking() {
        assertRewrite(
            objc: """
                #define CONSTANT 1
                """,
            swift: """
                // Preprocessor directives found in file:
                // #define CONSTANT 1
                // [Creation] Converted from compiler directive from test.m line 1: #define CONSTANT 1
                private let CONSTANT: Int = 1
                """,
            options: SwiftSyntaxOptions.default.with(\.printIntentionHistory, true)
        )
    }
}
