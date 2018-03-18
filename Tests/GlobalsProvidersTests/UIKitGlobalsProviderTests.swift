import XCTest
import GlobalsProviders

class UIKitGlobalsProviderTests: BaseGlobalsProviderTestCase {
    override func setUp() {
        super.setUp()
        
        sut = UIKitGlobalsProvider()
        
        sut.registerDefinitions(on: globals)
        sut.registerTypes(in: types)
    }
    
    func testDefinedUIView() {
        assertDefined(typeName: "UIView", signature: """
            class UIView: UIResponder {
                var tag: Int
                var isUserInteractionEnabled: Bool
                var frame: CGRect { get set }
                var bounds: CGRect { get set }
                var layer: CALayer { get }
                
                init(frame: CGRect)
                func draw(_ rect: CGRect)
            }
            """)
    }
}
