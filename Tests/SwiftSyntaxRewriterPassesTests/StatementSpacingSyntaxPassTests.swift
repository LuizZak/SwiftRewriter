import XCTest
import SwiftSyntax
import SwiftSyntaxRewriterPasses

class StatementSpacingSyntaxPassTests: BaseSyntaxRewriterPassTest {
    override func setUp() {
        super.setUp()
        
        sut = StatementSpacingSyntaxPass()
    }
    
    func testRewrite() {
        assertRewrite(
            input: """
            func f() {
                var fooBar = FooBar()
                fooBar.foo = true
                fooBar.bar = false
                fooBar.call()
                print("done!")
            }
            """,
            expected: """
            func f() {
                var fooBar = FooBar()

                fooBar.foo = true
                fooBar.bar = false
                fooBar.call()

                print("done!")
            }
            """
        )
    }
    
    func testAddSpacingBetweenExpressionAndStatements() {
        assertRewrite(
            input: """
            func f() {
                var fooBar = FooBar()
                fooBar.foo = true
                if true {
                    fooBar.foo = true
                }
                fooBar.foo = true
            }
            """,
            expected: """
            func f() {
                var fooBar = FooBar()

                fooBar.foo = true

                if true {
                    fooBar.foo = true
                }

                fooBar.foo = true
            }
            """
        )
    }
}
