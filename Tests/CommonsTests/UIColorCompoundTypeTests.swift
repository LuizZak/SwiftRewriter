import XCTest
import Commons
import SwiftRewriterLib
import Utils

class UIColorCompoundTypeTests: XCTestCase {

    func testUIColorDefinition() {
        let type = UIColorCompoundType.create()
        
        assertSignature(type: type, matches: """
            class UIColor: NSObject, NSSecureCoding, NSCopying {
                static var black: UIColor { get }
                static var darkGray: UIColor { get }
                static var lightGray: UIColor { get }
                static var white: UIColor { get }
                static var gray: UIColor { get }
                static var red: UIColor { get }
                static var green: UIColor { get }
                static var blue: UIColor { get }
                static var cyan: UIColor { get }
                static var yellow: UIColor { get }
                static var magenta: UIColor { get }
                static var orange: UIColor { get }
                static var purple: UIColor { get }
                static var brown: UIColor { get }
                static var clear: UIColor { get }
                var cgColor: CGColor { get }
                var ciColor: CGColor { get }
            }
            """)
    }

}
