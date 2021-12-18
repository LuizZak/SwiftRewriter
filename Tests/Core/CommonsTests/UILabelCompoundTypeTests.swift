import XCTest
import Commons
import SwiftRewriterLib
import Utils

class UILabelCompoundTypeTests: XCTestCase {

    func testUILabelDefinition() {
        let type = UILabelCompoundType.create()
        
        XCTAssert(type.nonCanonicalNames.isEmpty)
        XCTAssertEqual(type.transformations.count, 0)
        XCTAssertEqual(type.supertype?.asTypeName, "UIView")
        
        assertSignature(type: type, matches: """
            @available(iOS 2.0, *)
            class UILabel: UIView, NSCoding, UIContentSizeCategoryAdjusting {
                var text: String?
                var font: UIFont!
                var textColor: UIColor!
                var shadowColor: UIColor?
                var shadowOffset: CGSize
                var textAlignment: NSTextAlignment
                var lineBreakMode: NSLineBreakMode
                @NSCopying var attributedText: NSAttributedString?
                var highlightedTextColor: UIColor?
                var isHighlighted: Bool
                var isUserInteractionEnabled: Bool
                var isEnabled: Bool
                var numberOfLines: Int
                var adjustsFontSizeToFitWidth: Bool
                var baselineAdjustment: UIBaselineAdjustment
                
                @available(iOS 6.0, *)
                var minimumScaleFactor: CGFloat
                
                @available(iOS 9.0, *)
                var allowsDefaultTighteningForTruncation: Bool
                
                @available(iOS 6.0, *)
                var preferredMaxLayoutWidth: CGFloat
                
                func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect
                func drawText(in rect: CGRect)
            }
            """)
    }
}
