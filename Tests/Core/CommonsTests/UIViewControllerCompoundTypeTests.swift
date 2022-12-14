import Commons
import SwiftRewriterLib
import Utils
import XCTest

class UIViewControllerCompoundTypeTests: XCTestCase {

    func testUIViewControllerDefinition() {
        let type = UIViewControllerCompoundType.create()

        XCTAssert(type.nonCanonicalNames.isEmpty)
        XCTAssertEqual(type.transformations.count, 0)
        XCTAssertEqual(type.supertype?.asTypeName, "UIResponder")

        assertSignature(
            type: type,
            matches: """
                class UIViewController: UIResponder, NSCoding, UIAppearanceContainer, UITraitEnvironment, UIContentContainer, UIFocusEnvironment {
                    var view: UIView
                    
                    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
                    func viewDidLoad()
                    func viewWillAppear(_ animated: Bool)
                    func viewDidAppear(_ animated: Bool)
                    func viewWillDisappear(_ animated: Bool)
                    func viewDidDisappear(_ animated: Bool)
                    func viewWillLayoutSubviews()
                    func viewDidLayoutSubviews()
                }
                """
        )
    }
}
