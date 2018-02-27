//
//  SwiftRewriter+IntentionPassHistoryTests.swift
//  SwiftRewriterLibTests
//
//  Created by Luiz Silva on 27/02/2018.
//

import XCTest
import SwiftRewriterLib
import SwiftAST

class SwiftRewriter_IntentionPassHistoryTests: XCTestCase {
    func testPrintIntentionHistory() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            @property BOOL value;
            @end
            @implementation MyClass
            - (void)setValue:(BOOL)value {
                
            }
            - (BOOL)value {
                return NO;
            }
            @end
            """,
            swift: """
            // [PropertyMergeIntentionPass] Removed method MyClass.value() -> Bool since deduced it is a getter for property MyClass.value: Bool
            // [PropertyMergeIntentionPass] Removed method MyClass.setValue(_ value: Bool) since deduced it is a setter for property MyClass.value: Bool
            @objc
            class MyClass: NSObject {
                // [PropertyMergeIntentionPass] Merged MyClass.value() -> Bool and MyClass.setValue(_ value: Bool) into property MyClass.value: Bool
                @objc var value: Bool {
                    get {
                        return false
                    }
                    set(value) {
                    }
                }
            }
            """,
            options: ASTWriterOptions(printIntentionHistory: true))
    }
}
