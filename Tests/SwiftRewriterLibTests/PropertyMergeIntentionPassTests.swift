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
                self->_value = value;
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
                    set(value) {
                        self._value = value
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
    
    func testPassWithGetterAndSetterWithSynthesizedField() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            {
                BOOL _value;
            }
            @property BOOL value;
            @end

            @implementation MyClass
            - (void)setValue:(BOOL)value {
                self->_value = value;
            }
            - (BOOL)value {
                return self->_value;
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                private var _value: Bool
                var value: Bool {
                    get {
                        return self._value
                    }
                    set(value) {
                        self._value = value
                    }
                }
            }
            """)
    }
    
    func testCollapsePropertiesAndMethods() throws {
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
    
    func testCollapsePropertiesAndMethodsWithTypeSignatureMatching() throws {
        try assertObjcParse(
            objc: """
            NS_ASSUME_NONNULL_BEGIN
            
            @interface MyClass
            @property (readonly) MyClass *value;
            @end
            
            NS_ASSUME_NONNULL_END
            
            @implementation MyClass
            - (MyClass*)value {
                return [[MyClass alloc] init];
            }
            - (void)setValue:(MyClass*)value {
                thing();
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                var value: MyClass {
                    get {
                        return MyClass()
                    }
                    set(value) {
                        thing()
                    }
                }
            }
            """)
    }
    
    func testSetterOnly() throws {
        try assertObjcParse(
            objc: """
            NS_ASSUME_NONNULL_BEGIN
            
            @interface MyClass
            @property (nonatomic) NSDate *ganttStartDate;
            @end
            
            NS_ASSUME_NONNULL_END
            
            @implementation MyClass
            - (void)setGanttStartDate:(NSDate*)ganttStartDate {
                self->_ganttStartDate = ganttStartDate;
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                private var _ganttStartDate: NSDate
                var ganttStartDate: NSDate {
                    get {
                        return _ganttStartDate
                    }
                    set(ganttStartDate) {
                        self._ganttStartDate = ganttStartDate
                    }
                }
            }
            """)
    }
}
