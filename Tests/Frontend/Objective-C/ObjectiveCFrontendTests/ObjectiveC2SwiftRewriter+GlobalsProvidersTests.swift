import XCTest

@testable import ObjectiveCFrontend

class ObjectiveC2SwiftRewriter_GlobalsProvidersTests: XCTestCase {
    func testSeesUIViewDefinition() throws {
        assertRewrite(
            objc: """
                @interface A : UIView
                @end

                @implementation A
                - (void)method {
                    (self.frame);
                    [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                    (self.window);
                }
                @end
                """,
            swift: """
                class A: UIView {
                    func method() {
                        // type: CGRect
                        self.frame
                        // type: UIView
                        UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                        // type: UIWindow?
                        self.window
                    }
                }
                """,
            options: SwiftSyntaxOptions.default.with(\.outputExpressionTypes, true)
        )
    }
}
