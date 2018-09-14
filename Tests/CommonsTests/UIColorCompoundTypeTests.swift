import XCTest
import Commons
import SwiftRewriterLib
import Utils

class UIColorCompoundTypeTests: XCTestCase {

    func testUIColorDefinition() {
        let type = UIColorCompoundType.create()
        
        assertSignature(type: type, matches: """
            class UIColor: NSObject, NSSecureCoding, NSCopying {
                // Convert from static var blackColor
                // Convert from static func blackColor()
                static var black: UIColor { get }
                
                // Convert from static var darkGrayColor
                // Convert from static func darkGrayColor()
                static var darkGray: UIColor { get }
                
                // Convert from static var lightGrayColor
                // Convert from static func lightGrayColor()
                static var lightGray: UIColor { get }
                
                // Convert from static var whiteColor
                // Convert from static func whiteColor()
                static var white: UIColor { get }
                
                // Convert from static var grayColor
                // Convert from static func grayColor()
                static var gray: UIColor { get }
                
                // Convert from static var redColor
                // Convert from static func redColor()
                static var red: UIColor { get }
                
                // Convert from static var greenColor
                // Convert from static func greenColor()
                static var green: UIColor { get }
                
                // Convert from static var blueColor
                // Convert from static func blueColor()
                static var blue: UIColor { get }
                
                // Convert from static var cyanColor
                // Convert from static func cyanColor()
                static var cyan: UIColor { get }
                
                // Convert from static var yellowColor
                // Convert from static func yellowColor()
                static var yellow: UIColor { get }
                
                // Convert from static var magentaColor
                // Convert from static func magentaColor()
                static var magenta: UIColor { get }
                
                // Convert from static var orangeColor
                // Convert from static func orangeColor()
                static var orange: UIColor { get }
                
                // Convert from static var purpleColor
                // Convert from static func purpleColor()
                static var purple: UIColor { get }
                
                // Convert from static var brownColor
                // Convert from static func brownColor()
                static var brown: UIColor { get }
                
                // Convert from static var clearColor
                // Convert from static func clearColor()
                static var clear: UIColor { get }
                
                // Convert from static var lightTextColor
                // Convert from static func lightTextColor()
                static var lightText: UIColor { get }
                
                // Convert from static var darkTextColor
                // Convert from static func darkTextColor()
                static var darkText: UIColor { get }
                
                // Convert from static var groupTableViewBackgroundColor
                // Convert from static func groupTableViewBackgroundColor()
                static var groupTableViewBackground: UIColor { get }
                
                // Convert from static var viewFlipsideBackgroundColor
                // Convert from static func viewFlipsideBackgroundColor()
                static var viewFlipsideBackground: UIColor { get }
                
                // Convert from static var scrollViewTexturedBackgroundColor
                // Convert from static func scrollViewTexturedBackgroundColor()
                static var scrollViewTexturedBackground: UIColor { get }
                
                // Convert from static var underPageBackgroundColor
                // Convert from static func underPageBackgroundColor()
                static var underPageBackground: UIColor { get }
                
                // Convert from var CGColor
                var cgColor: CGColor { get }
                
                // Convert from var CIColor
                var ciColor: CGColor { get }
                
                
                @_swiftrewriter(mapFrom: colorWithAlphaComponent(_ alpha: CGFloat) -> UIColor)
                func withAlphaComponent(_ alpha: CGFloat) -> UIColor
            }
            """)
    }

}
