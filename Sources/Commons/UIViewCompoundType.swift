import SwiftAST
import SwiftRewriterLib

// swiftlint:disable line_length
public class UIViewCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "UIView")
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func typeString() -> String {
        let string = """
            class UIView: UIResponder, NSCoding, UIAppearance, UIAppearanceContainer, UIDynamicItem, UITraitEnvironment, UICoordinateSpace, UIFocusItem, CALayerDelegate {
                static var areAnimationsEnabled: Bool { get }
                static var inheritedAnimationDuration: TimeInterval { get }
                static var layerClass: AnyClass { get }
                static var requiresConstraintBasedLayout: Bool { get }
                var alignmentRectInsets: UIEdgeInsets { get }
                var alpha: CGFloat
                var autoresizesSubviews: Bool
                var autoresizingMask: UIViewAutoresizing
                var backgroundColor: UIColor?
                var bottomAnchor: NSLayoutYAxisAnchor { get }
                var bounds: CGRect
                var canBecomeFocused: Bool { get }
                var center: CGPoint
                var centerXAnchor: NSLayoutXAxisAnchor { get }
                var centerYAnchor: NSLayoutYAxisAnchor { get }
                var clearsContextBeforeDrawing: Bool
                var clipsToBounds: Bool
                var constraints: [NSLayoutConstraint] { get }
                var contentMode: UIViewContentMode
                var contentScaleFactor: CGFloat
                var directionalLayoutMargins: NSDirectionalEdgeInsets
                var effectiveUserInterfaceLayoutDirection: UIUserInterfaceLayoutDirection { get }
                var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
                var forFirstBaselineLayout: UIView { get }
                var forLastBaselineLayout: UIView { get }
                var frame: CGRect
                var gestureRecognizers: [UIGestureRecognizer]?
                var hasAmbiguousLayout: Bool { get }
                var heightAnchor: NSLayoutDimension { get }
                var insetsLayoutMarginsFromSafeArea: Bool
                var intrinsicContentSize: CGSize { get }
                var isExclusiveTouch: Bool
                
                @_swiftrewriter(renameFrom: focused)
                var isFocused: Bool { get }
                
                @_swiftrewriter(renameFrom: hidden)
                var isHidden: Bool
                var isMultipleTouchEnabled: Bool
                
                @_swiftrewriter(renameFrom: opaque)
                var isOpaque: Bool
                
                @_swiftrewriter(renameFrom: userInteractionEnabled)
                var isUserInteractionEnabled: Bool
                var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
                var layer: CALayer { get }
                var layoutGuides: [UILayoutGuide] { get }
                var layoutMargins: UIEdgeInsets
                var layoutMarginsGuide: UILayoutGuide { get }
                var leadingAnchor: NSLayoutXAxisAnchor { get }
                var leftAnchor: NSLayoutXAxisAnchor { get }
                var mask: UIView?
                var motionEffects: [UIMotionEffect]
                var preservesSuperviewLayoutMargins: Bool
                var readableContentGuide: UILayoutGuide { get }
                var restorationIdentifier: String?
                var rightAnchor: NSLayoutXAxisAnchor { get }
                var safeAreaInsets: UIEdgeInsets { get }
                var safeAreaLayoutGuide: UILayoutGuide { get }
                var semanticContentAttribute: UISemanticContentAttribute
                var subviews: [UIView] { get }
                var superview: UIView? { get }
                var tag: Int
                var tintAdjustmentMode: UIViewTintAdjustmentMode
                var tintColor: UIColor!
                var topAnchor: NSLayoutYAxisAnchor { get }
                var trailingAnchor: NSLayoutXAxisAnchor { get }
                var transform: CGAffineTransform
                var translatesAutoresizingMaskIntoConstraints: Bool
                var widthAnchor: NSLayoutDimension { get }
                var window: UIWindow? { get }
                
                init(frame: CGRect)
                
                static func addKeyframe(withRelativeStartTime frameStartTime: Double,
                                        relativeDuration frameDuration: Double,
                                        animations: () -> Void)
                
                @_swiftrewriter(mapFrom: animateWithDuration(_:animations:completion:))
                static func animate(withDuration duration: TimeInterval,
                                    animations: () -> Void,
                                    completion: ((Bool) -> Void)?)
                
                @_swiftrewriter(mapFrom: animateWithDuration(_:animations:))
                static func animate(withDuration duration: TimeInterval,
                                    animations: () -> Void)
                
                @_swiftrewriter(mapFrom: animateWithDuration(_:delay:options:animations:completion:))
                static func animate(withDuration duration: TimeInterval,
                                    delay: TimeInterval,
                                    options: UIViewAnimationOptions,
                                    animations: () -> Void,
                                    completion: ((Bool) -> Void)?)
                
                @_swiftrewriter(mapFrom:
                    animateWithDuration(delay:
                                        usingSpringWithDamping:
                                        initialSpringVelocity:
                                        options:
                                        animations:
                                        completion:))
                static func animate(withDuration duration: TimeInterval,
                                    delay: TimeInterval,
                                    usingSpringWithDamping dampingRatio: CGFloat,
                                    initialSpringVelocity velocity: CGFloat,
                                    options: UIViewAnimationOptions,
                                    animations: () -> Void,
                                    completion: ((Bool) -> Void)?)
                
                static func animateKeyframes(withDuration duration: TimeInterval, delay: TimeInterval, options: UIViewKeyframeAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?)
                static func beginAnimations(_ animationID: String?, context: UnsafeMutableRawPointer?)
                static func commitAnimations()
                static func perform(_ animation: UISystemAnimation, on views: [UIView], options: UIViewAnimationOptions, animations parallelAnimations: (() -> Void)?, completion: ((Bool) -> Void)?)
                static func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void)
                static func setAnimationBeginsFromCurrentState(_ fromCurrentState: Bool)
                static func setAnimationCurve(_ curve: UIViewAnimationCurve)
                static func setAnimationDelay(_ delay: TimeInterval)
                static func setAnimationDelegate(_ delegate: Any?)
                static func setAnimationDidStop(_ selector: Selector?)
                static func setAnimationDuration(_ duration: TimeInterval)
                static func setAnimationRepeatAutoreverses(_ repeatAutoreverses: Bool)
                static func setAnimationRepeatCount(_ repeatCount: Float)
                static func setAnimationsEnabled(_ enabled: Bool)
                static func setAnimationStart(_ startDate: Date)
                static func setAnimationTransition(_ transition: UIViewAnimationTransition, for view: UIView, cache: Bool)
                static func setAnimationWillStart(_ selector: Selector?)
                static func transition(from fromView: UIView, to toView: UIView, duration: TimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)?)
                static func transition(with view: UIView, duration: TimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?)
                static func userInterfaceLayoutDirection(for attribute: UISemanticContentAttribute) -> UIUserInterfaceLayoutDirection
                static func userInterfaceLayoutDirection(for semanticContentAttribute: UISemanticContentAttribute, relativeTo layoutDirection: UIUserInterfaceLayoutDirection) -> UIUserInterfaceLayoutDirection
                func addConstraint(_ constraint: NSLayoutConstraint)
                func addConstraints(_ constraints: [NSLayoutConstraint])
                func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer)
                func addLayoutGuide(_ layoutGuide: UILayoutGuide)
                func addMotionEffect(_ effect: UIMotionEffect)
                func addSubview(_ view: UIView)
                func alignmentRect(forFrame frame: CGRect) -> CGRect
                
                @_swiftrewriter(mapFrom: bringSubviewToFront(_:))
                func bringSubview(toFront view: UIView)
                func constraintsAffectingLayout(for axis: UILayoutConstraintAxis) -> [NSLayoutConstraint]
                func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority
                func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority
                
                @_swiftrewriter(mapFrom: convertPoint(_:fromView:))
                func convert(_ point: CGPoint, from view: UIView?) -> CGPoint
                
                @_swiftrewriter(mapFrom: convertPoint(_:toView:))
                func convert(_ point: CGPoint, to view: UIView?) -> CGPoint
                
                @_swiftrewriter(mapFrom: convertRect(_:fromView:))
                func convert(_ rect: CGRect, from view: UIView?) -> CGRect
                
                @_swiftrewriter(mapFrom: convertRect(_:toView:))
                func convert(_ rect: CGRect, to view: UIView?) -> CGRect
                func decodeRestorableState(with coder: NSCoder)
                func didAddSubview(_ subview: UIView)
                func didMoveToSuperview()
                func didMoveToWindow()
                
                @_swiftrewriter(mapFrom: drawRect(_:))
                func draw(_ rect: CGRect)
                func drawHierarchy(in rect: CGRect, afterScreenUpdates afterUpdates: Bool) -> Bool
                func encodeRestorableState(with coder: NSCoder)
                func exchangeSubview(at index1: Int, withSubviewAt index2: Int)
                func exerciseAmbiguityInLayout()
                func forBaselineLayout() -> UIView
                func frame(forAlignmentRect alignmentRect: CGRect) -> CGRect
                func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
                func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
                func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView)
                
                @_swiftrewriter(mapFrom: insertSubview(_:atIndex:))
                func insertSubview(_ view: UIView, at index: Int)
                func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView)
                func invalidateIntrinsicContentSize()
                func isDescendant(of view: UIView) -> Bool
                func layoutIfNeeded()
                func layoutMarginsDidChange()
                func layoutSubviews()
                func needsUpdateConstraints() -> Bool
                func point(inside point: CGPoint, with event: UIEvent?) -> Bool
                func removeConstraint(_ constraint: NSLayoutConstraint)
                func removeConstraints(_ constraints: [NSLayoutConstraint])
                func removeFromSuperview()
                func removeGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer)
                func removeLayoutGuide(_ layoutGuide: UILayoutGuide)
                func removeMotionEffect(_ effect: UIMotionEffect)
                func resizableSnapshotView(from rect: CGRect, afterScreenUpdates afterUpdates: Bool, withCapInsets capInsets: UIEdgeInsets) -> UIView?
                func safeAreaInsetsDidChange()
                func sendSubview(toBack view: UIView)
                func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis)
                func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis)
                func setNeedsDisplay(_ rect: CGRect)
                func setNeedsDisplay()
                func setNeedsLayout()
                func setNeedsUpdateConstraints()
                func sizeThatFits(_ size: CGSize) -> CGSize
                func sizeToFit()
                func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView?
                func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize
                func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize
                func tintColorDidChange()
                func updateConstraints()
                func updateConstraintsIfNeeded()
                func viewWithTag(_ tag: Int) -> UIView?
                @_swiftrewriter(mapFrom: willMoveToSuperview(_:))
                func willMove(toSuperview newSuperview: UIView?)
                @_swiftrewriter(mapFrom: willMoveToWindow(_:))
                func willMove(toWindow newWindow: UIWindow?)
                func willRemoveSubview(_ subview: UIView)
            }
            """
        
        return string
    }
}
