import SwiftRewriterLib
import SwiftAST
import XCTest

class SwiftRewriterNullabilityTests: XCTestCase {
    
    func testNonNilInitializedImplicitUnwrappedVariableKeepsNullabilityInCaseNilIsAssignedLater() {
        // We use initial values of locals to help with determining whether or
        // not a variable is supposed to be nil or not, since it is very common
        // to create variables in Objective-C with no explicit nullability
        // annotations in method bodies.
        //
        // This test verifies that when we later assign nil to a variable that
        // is created with an initial value that is non-nil, the transpiler is
        // able to detect that case and keep the nullability state of the variable
        // as implicitly-unwrapped optional (in case no explicit nullability
        // annotations are defined)
        
        assertRewrite(
            objc: """
            @interface A
            - (instancetype)init;
            @end
            
            void test() {
                A *nonNil = [A new];
                A *constantNonNil = [A new];
                A *lateNilAssignment = [A new];
                nonNil = [A new];
                lateNilAssignment = nil;
            }
            """,
            swift: """
            func test() {
                var nonNil = A()
                let constantNonNil = A()
                var lateNilAssignment: A! = A()

                nonNil = A()
                lateNilAssignment = nil
            }

            class A {
                override init() {
                }
            }
            """)
    }
    
    func testNilInitialValueWithSubsequentNonNilAssignment() {
        assertRewrite(
            objc: """
            @interface A
            - (instancetype)init;
            @end
            
            void test() {
                NSString *local;
                 if (test) {
                     local = @"value";
                 }
                 [self foo:local];
            }
            """,
            swift: """
            func test() {
                var local: String!

                if test {
                    local = "value"
                }

                self.foo(local)
            }

            class A {
                override init() {
                }
            }
            """)
    }
}
