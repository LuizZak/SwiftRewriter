import XCTest
import SwiftRewriterLib

class PropertyMergeIntentionPassTests: XCTestCase {
    func testPassWithGetterAndSetter() {
        assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc var value: Bool {
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
    
    func testPassWithGetter() {
        assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc var value: Bool {
                    return false
                }
            }
            """)
    }
    
    func testPassWithGetterAndSetterWithSynthesizedField() {
        assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                private var _value: Bool = false
                @objc var value: Bool {
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
    
    func testCollapsePropertiesAndMethods() {
        assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc var value: Bool {
                    return false
                }
            }
            """)
    }
    
    func testCollapsePropertiesAndMethodsWithTypeSignatureMatching() {
        assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc var value: MyClass {
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
    
    func testSetterOnly() {
        assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                private var _ganttStartDate: Date = Date()
                @objc var ganttStartDate: Date {
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
