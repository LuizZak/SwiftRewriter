import XCTest
import Commons
import SwiftRewriterLib
import Utils

class UIColorCompoundTypeTests: XCTestCase {

    func testUIColorDefinition() {
        let type = UIColorCompoundType.create()
        
        assertSignature(type: type, matches: """
            class UIColor: NSObject, NSSecureCoding, NSCopying {
                @_swiftrewriter(renameFrom: blackColor)
                @_swiftrewriter(mapFrom: blackColor())
                static var black: UIColor { get }
                
                @_swiftrewriter(renameFrom: darkGrayColor)
                @_swiftrewriter(mapFrom: darkGrayColor())
                static var darkGray: UIColor { get }
                
                @_swiftrewriter(renameFrom: lightGrayColor)
                @_swiftrewriter(mapFrom: lightGrayColor())
                static var lightGray: UIColor { get }
                
                @_swiftrewriter(renameFrom: whiteColor)
                @_swiftrewriter(mapFrom: whiteColor())
                static var white: UIColor { get }
                
                @_swiftrewriter(renameFrom: grayColor)
                @_swiftrewriter(mapFrom: grayColor())
                static var gray: UIColor { get }
                
                @_swiftrewriter(renameFrom: redColor)
                @_swiftrewriter(mapFrom: redColor())
                static var red: UIColor { get }
                
                @_swiftrewriter(renameFrom: greenColor)
                @_swiftrewriter(mapFrom: greenColor())
                static var green: UIColor { get }
                
                @_swiftrewriter(renameFrom: blueColor)
                @_swiftrewriter(mapFrom: blueColor())
                static var blue: UIColor { get }
                
                @_swiftrewriter(renameFrom: cyanColor)
                @_swiftrewriter(mapFrom: cyanColor())
                static var cyan: UIColor { get }
                
                @_swiftrewriter(renameFrom: yellowColor)
                @_swiftrewriter(mapFrom: yellowColor())
                static var yellow: UIColor { get }
                
                @_swiftrewriter(renameFrom: magentaColor)
                @_swiftrewriter(mapFrom: magentaColor())
                static var magenta: UIColor { get }
                
                @_swiftrewriter(renameFrom: orangeColor)
                @_swiftrewriter(mapFrom: orangeColor())
                static var orange: UIColor { get }
                
                @_swiftrewriter(renameFrom: purpleColor)
                @_swiftrewriter(mapFrom: purpleColor())
                static var purple: UIColor { get }
                
                @_swiftrewriter(renameFrom: brownColor)
                @_swiftrewriter(mapFrom: brownColor())
                static var brown: UIColor { get }
                
                @_swiftrewriter(renameFrom: clearColor)
                @_swiftrewriter(mapFrom: clearColor())
                static var clear: UIColor { get }
                
                @_swiftrewriter(renameFrom: lightTextColor)
                @_swiftrewriter(mapFrom: lightTextColor())
                static var lightText: UIColor { get }
                
                @_swiftrewriter(renameFrom: darkTextColor)
                @_swiftrewriter(mapFrom: darkTextColor())
                static var darkText: UIColor { get }
                
                @_swiftrewriter(renameFrom: groupTableViewBackgroundColor)
                @_swiftrewriter(mapFrom: groupTableViewBackgroundColor())
                static var groupTableViewBackground: UIColor { get }
                
                @_swiftrewriter(renameFrom: viewFlipsideBackgroundColor)
                @_swiftrewriter(mapFrom: viewFlipsideBackgroundColor())
                static var viewFlipsideBackground: UIColor { get }
                
                @_swiftrewriter(renameFrom: scrollViewTexturedBackgroundColor)
                @_swiftrewriter(mapFrom: scrollViewTexturedBackgroundColor())
                static var scrollViewTexturedBackground: UIColor { get }
                
                @_swiftrewriter(renameFrom: underPageBackgroundColor)
                @_swiftrewriter(mapFrom: underPageBackgroundColor())
                static var underPageBackground: UIColor { get }
                
                @_swiftrewriter(renameFrom: CGColor)
                var cgColor: CGColor { get }
                
                @_swiftrewriter(renameFrom: CIColor)
                var ciColor: CGColor { get }
                
                
                @_swiftrewriter(mapFrom: colorWithAlphaComponent(_ alpha: CGFloat) -> UIColor)
                func withAlphaComponent(_ alpha: CGFloat) -> UIColor
            }
            """)
    }

}
