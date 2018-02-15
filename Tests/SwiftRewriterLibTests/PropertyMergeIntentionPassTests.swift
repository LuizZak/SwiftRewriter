//
//  PropertyMergeIntentionPassTests.swift
//  SwiftRewriterLibTests
//
//  Created by Luiz Silva on 15/02/2018.
//

import XCTest
import SwiftRewriterLib

class PropertyMergeIntentionPassTests: XCTestCase {
    func testPassWithGetterAndSetter() throws {
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
            class MyClass: NSObject {
                var value: Bool {
                    get {
                        return false
                    }
                    set {
                    }
                }
            }
            """)
    }
    
    func testPassWithGetter() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            @property (readonly) BOOL value;
            @end

            @implementation MyClass
            - (BOOL)value {
                return NO;
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                var value: Bool {
                    return false
                }
            }
            """)
    }
}
