import XCTest
import GlobalsProviders

class CoreGraphicsGlobalsProviderTests: BaseGlobalsProviderTestCase {
    override func setUp() {
        super.setUp()
        
        sut = CoreGraphicsGlobalsProvider()
        
        sut.registerDefinitions(on: globals)
        sut.registerTypes(in: types)
    }
    
    func testDefinedCGRect() {
        assertDefined(typeName: "CGRect", signature: """
            struct CGRect {
                static let null: CGRect
                static let infinite: CGRect
                static var zero: CGRect { get }
                var origin: CGPoint
                var size: CGSize
                var minX: CGFloat { get }
                var midX: CGFloat { get }
                var maxX: CGFloat { get }
                var minY: CGFloat { get }
                var midY: CGFloat { get }
                var maxY: CGFloat { get }
                var width: CGFloat { get }
                var height: CGFloat { get }
                var standardized: CGRect { get }
                var isEmpty: Bool { get }
                var isNull: Bool { get }
                var isInfinite: Bool { get }
                var integral: CGRect { get }
                
                init()
                init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
                func insetBy(dx: CGFloat, dy: CGFloat) -> CGRect
                func offsetBy(dx: CGFloat, dy: CGFloat) -> CGRect
            }
            """)
    }
}
