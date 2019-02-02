import SwiftAST

public enum UILabelCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "UILabel")
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    private static func typeString() -> String {
        let type = """
            @available(iOS 2.0, *)
            class UILabel: UIView, NSCoding, UIContentSizeCategoryAdjusting {
                open var text: String?
                open var font: UIFont!
                open var textColor: UIColor!
                open var shadowColor: UIColor?
                open var shadowOffset: CGSize
                open var textAlignment: NSTextAlignment
                open var lineBreakMode: NSLineBreakMode
                
                @NSCopying open var attributedText: NSAttributedString?
                
                open var highlightedTextColor: UIColor?
                open var isHighlighted: Bool
                open var isUserInteractionEnabled: Bool
                open var isEnabled: Bool
                open var numberOfLines: Int
                open var adjustsFontSizeToFitWidth: Bool
                open var baselineAdjustment: UIBaselineAdjustment
                @available(iOS 6.0, *)
                open var minimumScaleFactor: CGFloat
                @available(iOS 9.0, *)
                open var allowsDefaultTighteningForTruncation: Bool
                open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect
                open func drawText(in rect: CGRect)
                @available(iOS 6.0, *)
                open var preferredMaxLayoutWidth: CGFloat
            }
            """
        
        return type
    }
}
