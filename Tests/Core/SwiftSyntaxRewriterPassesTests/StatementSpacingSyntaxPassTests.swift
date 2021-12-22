import SwiftSyntax
import SwiftSyntaxRewriterPasses
import XCTest

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

    func testRewriteRepeatedIdentifiers() {
        assertRewrite(
            input: """
                func f() {
                    var fooBar = FooBar()
                    fooBar.foo = true
                    fooBar.bar = false
                    fooBar.call()
                    print("done!")
                    print("another print!")
                    fooBar.call()
                }
                """,
            expected: """
                func f() {
                    var fooBar = FooBar()

                    fooBar.foo = true
                    fooBar.bar = false
                    fooBar.call()

                    print("done!")
                    print("another print!")

                    fooBar.call()
                }
                """
        )
    }

    func testRewriteRepeatedIdentifiersIgnoresTrivia() {
        assertRewrite(
            input: """
                func f() {
                    var fooBar = FooBar()
                    fooBar.foo = true
                    // A trivia
                    fooBar.bar = false
                    fooBar.call()
                    // Another trivia
                    print("done!")
                    print("another print!")
                    fooBar.call()
                }
                """,
            expected: """
                func f() {
                    var fooBar = FooBar()

                    fooBar.foo = true
                    // A trivia
                    fooBar.bar = false
                    fooBar.call()

                    // Another trivia
                    print("done!")
                    print("another print!")

                    fooBar.call()
                }
                """
        )
    }

    func testRewriteDetectSelfPropertyAccesses() {
        assertRewrite(
            input: """
                func f() {
                    self.fooBar = FooBar()
                    self.fooBar.foo = true
                    self.fooBar.bar = false
                    self.fooBar.call()
                    self.baz.call()
                    self.baz.bar = false
                    self.fooBar.call()
                    print("done!")
                }
                """,
            expected: """
                func f() {
                    self.fooBar = FooBar()
                    self.fooBar.foo = true
                    self.fooBar.bar = false
                    self.fooBar.call()

                    self.baz.call()
                    self.baz.bar = false

                    self.fooBar.call()

                    print("done!")
                }
                """
        )
    }

    func testNestedStatement() {
        assertRewrite(
            input: """
                func f() {
                    var i: UInt = 0

                    while i < liscences.count {
                        defer {
                            i += 1
                        }

                        let liscence = liscences[Int(i)]
                        let block = CPLabeledBlockView(frame: CGRect(x: 0, y: 0, width: 100, height: 40), text: liscence.code, andColor: UIColor.lightGray)
                        block.translatesAutoresizingMaskIntoConstraints = false
                        block.sizeToFit()
                        block.alpha = 0.0
                        habilitationsContainer.addSubview(block)
                        UIView.animate(withDuration: 0.2) {
                            block.alpha = 1.0
                        }
                    }

                    self.updateContentPositioningAnimated(true)
                }
                """,
            expected: """
                func f() {
                    var i: UInt = 0

                    while i < liscences.count {
                        defer {
                            i += 1
                        }

                        let liscence = liscences[Int(i)]
                        let block = CPLabeledBlockView(frame: CGRect(x: 0, y: 0, width: 100, height: 40), text: liscence.code, andColor: UIColor.lightGray)

                        block.translatesAutoresizingMaskIntoConstraints = false
                        block.sizeToFit()
                        block.alpha = 0.0

                        habilitationsContainer.addSubview(block)

                        UIView.animate(withDuration: 0.2) {
                            block.alpha = 1.0
                        }
                    }

                    self.updateContentPositioningAnimated(true)
                }
                """
        )
    }

    func testRewriterInClosure() {
        assertRewrite(
            input: """
                func f() {
                    // Reset display
                    UIView.performWithoutAnimation { () -> Void in
                        menuView.beginUpdate()
                        self.andonesDataSource.loadAndones([])
                        menuView.endUpdate()
                        self.isBackupSet = false
                        // Re-fold menu back
                        menuView.itemNamed("ETRDate")?.visible = false
                        menuView.itemNamed("NIDate")?.visible = false
                        menuView.itemNamed("StartDate")?.visible = false
                        menuView.itemNamed("EndDate")?.visible = false
                        self.reloadWorkPackageDisplay()
                    }
                }
                """,
            expected: """
                func f() {
                    // Reset display
                    UIView.performWithoutAnimation { () -> Void in
                        menuView.beginUpdate()

                        self.andonesDataSource.loadAndones([])

                        menuView.endUpdate()

                        self.isBackupSet = false

                        // Re-fold menu back
                        menuView.itemNamed("ETRDate")?.visible = false
                        menuView.itemNamed("NIDate")?.visible = false
                        menuView.itemNamed("StartDate")?.visible = false
                        menuView.itemNamed("EndDate")?.visible = false

                        self.reloadWorkPackageDisplay()
                    }
                }
                """
        )
    }

    func testRewriterBlockStatementInClosure() {
        assertRewrite(
            input: """
                func f() {
                    // Reset display
                    UIView.performWithoutAnimation { () -> Void in
                        if true {
                            menuView.beginUpdate()
                            self.andonesDataSource.loadAndones([])
                            menuView.endUpdate()
                            self.isBackupSet = false
                            // Re-fold menu back
                            menuView.itemNamed("ETRDate")?.visible = false
                            menuView.itemNamed("NIDate")?.visible = false
                            menuView.itemNamed("StartDate")?.visible = false
                            menuView.itemNamed("EndDate")?.visible = false
                            self.reloadWorkPackageDisplay()
                        }
                    }
                }
                """,
            expected: """
                func f() {
                    // Reset display
                    UIView.performWithoutAnimation { () -> Void in
                        if true {
                            menuView.beginUpdate()

                            self.andonesDataSource.loadAndones([])

                            menuView.endUpdate()

                            self.isBackupSet = false

                            // Re-fold menu back
                            menuView.itemNamed("ETRDate")?.visible = false
                            menuView.itemNamed("NIDate")?.visible = false
                            menuView.itemNamed("StartDate")?.visible = false
                            menuView.itemNamed("EndDate")?.visible = false

                            self.reloadWorkPackageDisplay()
                        }
                    }
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

    func testDontApplySpacingToFirstExpressionInMethod() {
        assertRewrite(
            input: """
                func f() {
                    stmt()
                }
                """,
            expected: """
                func f() {
                    stmt()
                }
                """
        )
    }

    func testKeepExistingLeadingTrivia() {
        assertRewrite(
            input: """
                func f() {
                    let a: Int = 0
                    // A comment
                    stmt()
                }
                """,
            expected: """
                func f() {
                    let a: Int = 0

                    // A comment
                    stmt()
                }
                """
        )
    }
}
