import XCTest
import GlobalsProviders

class UIKitGlobalsProviderTests: BaseGlobalsProviderTestCase {
    override func setUp() {
        super.setUp()
        
        sut = UIKitGlobalsProvider()
        
        sut.registerDefinitions(on: globals)
        sut.registerTypes(in: types)
    }
    
    func testDefinedUIGraphicsGetCurrentContext() {
        assertDefined(function: "UIGraphicsGetCurrentContext", paramTypes: [],
                      returnType: .optional(.typeName("CGContext")))
    }
    
    func testDefinedUIViewNoIntrinsicMetric() {
        assertDefined(variable: "UIViewNoIntrinsicMetric", type: .cgFloat)
    }
    
    func testDefinedUILayoutFittingCompressedSize() {
        assertDefined(variable: "UILayoutFittingCompressedSize", type: "CGSize")
    }
    
    func testDefinedUILayoutFittingExpandedSize() {
        assertDefined(variable: "UILayoutFittingExpandedSize", type: "CGSize")
    }
    
    func testDefinedUIViewController() {
        assertDefined(typeName: "UIViewController", signature: """
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
            """)
    }
    
    func testDefinedUILayoutConstraintAxis() {
        assertDefined(typeName: "UILayoutConstraintAxis", signature: """
            enum UILayoutConstraintAxis: Int {
                case horizontal
                case vertical
            }
            """)
    }
    
    func testDefinedUIView() {
        assertDefined(typeName: "UIView", signature: """
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
                var isFocused: Bool { get }
                var isHidden: Bool
                var isMultipleTouchEnabled: Bool
                var isOpaque: Bool
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
                static func addKeyframe(withRelativeStartTime frameStartTime: Double, relativeDuration frameDuration: Double, animations: () -> Void)
                static func animate(withDuration duration: TimeInterval, animations: () -> Void, completion: ((Bool) -> Void)?)
                static func animate(withDuration duration: TimeInterval, animations: () -> Void)
                static func animate(withDuration duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?)
                static func animate(withDuration duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?)
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
                func bringSubview(toFront view: UIView)
                func constraintsAffectingLayout(for axis: UILayoutConstraintAxis) -> [NSLayoutConstraint]
                func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority
                func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority
                func convert(_ point: CGPoint, from view: UIView?) -> CGPoint
                func convert(_ point: CGPoint, to view: UIView?) -> CGPoint
                func convert(_ rect: CGRect, from view: UIView?) -> CGRect
                func convert(_ rect: CGRect, to view: UIView?) -> CGRect
                func decodeRestorableState(with coder: NSCoder)
                func didAddSubview(_ subview: UIView)
                func didMoveToSuperview()
                func didMoveToWindow()
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
                func willMove(toSuperview newSuperview: UIView?)
                func willMove(toWindow newWindow: UIWindow?)
                func willRemoveSubview(_ subview: UIView)
            }
            """)
    }
    
    func testDefinedUIWindow() {
        assertDefined(typeName: "UIWindow", signature: """
            class UIWindow: UIView {
            }
            """)
    }
    
    func testDefinedUITableViewCell() {
        assertDefined(typeName: "UITableViewCell", signature: """
            class UITableViewCell: UIView, UIGestureRecognizerDelegate {
                var accessoryType: UITableViewCellAccessoryType
                var accessoryView: UIView?
                var backgroundView: UIView?
                var contentView: UIView { get }
                var detailTextLabel: UILabel? { get }
                var editingAccessoryType: UITableViewCellAccessoryType
                var editingAccessoryView: UIView?
                var editingStyle: UITableViewCellEditingStyle { get }
                var focusStyle: UITableViewCellFocusStyle
                var imageView: UIImageView? { get }
                var indentationLevel: Int
                var indentationWidth: CGFloat
                var isEditing: Bool
                var isHighlighted: Bool
                var isSelected: Bool
                var multipleSelectionBackgroundView: UIView?
                var reuseIdentifier: String? { get }
                var selectedBackgroundView: UIView?
                var selectionStyle: UITableViewCellSelectionStyle
                var separatorInset: UIEdgeInsets
                var shouldIndentWhileEditing: Bool
                var showingDeleteConfirmation: Bool { get }
                var showsReorderControl: Bool
                var textLabel: UILabel? { get }
                var userInteractionEnabledWhileDragging: Bool
                
                init(style: UITableViewCellStyle, reuseIdentifier: String?)
                func didTransition(to state: UITableViewCellStateMask)
                func dragStateDidChange(_ dragState: UITableViewCellDragState)
                func prepareForReuse()
                func setEditing(_ editing: Bool, animated: Bool)
                func setHighlighted(_ highlighted: Bool, animated: Bool)
                func setSelected(_ selected: Bool, animated: Bool)
                func willTransition(to state: UITableViewCellStateMask)
            }
            """)
    }
    
    func testDefinedUIScrollView() {
        assertDefined(typeName: "UIScrollView", signature: """
            class UIScrollView: UIView {
                var adjustedContentInset: UIEdgeInsets { get }
                var alwaysBounceHorizontal: Bool
                var alwaysBounceVertical: Bool
                var bounces: Bool
                var bouncesZoom: Bool
                var canCancelContentTouches: Bool
                var contentInset: UIEdgeInsets
                var contentInsetAdjustmentBehavior: UIScrollViewContentInsetAdjustmentBehavior
                var contentLayoutGuide: UILayoutGuide { get }
                var contentOffset: CGPoint
                var contentSize: CGSize
                var decelerationRate: CGFloat
                var delaysContentTouches: Bool
                var directionalPressGestureRecognizer: UIGestureRecognizer { get }
                var frameLayoutGuide: UILayoutGuide { get }
                var indexDisplayMode: UIScrollViewIndexDisplayMode
                var indicatorStyle: UIScrollViewIndicatorStyle
                var isDecelerating: Bool { get }
                var isDirectionalLockEnabled: Bool
                var isDragging: Bool { get }
                var isPagingEnabled: Bool
                var isScrollEnabled: Bool
                var isTracking: Bool { get }
                var isZoomBouncing: Bool { get }
                var isZooming: Bool { get }
                var keyboardDismissMode: UIScrollViewKeyboardDismissMode
                var maximumZoomScale: CGFloat
                var minimumZoomScale: CGFloat
                var panGestureRecognizer: UIPanGestureRecognizer { get }
                var pinchGestureRecognizer: UIPinchGestureRecognizer? { get }
                var refreshControl: UIRefreshControl?
                var scrollIndicatorInsets: UIEdgeInsets
                var scrollsToTop: Bool
                var showsHorizontalScrollIndicator: Bool
                var showsVerticalScrollIndicator: Bool
                var zoomScale: CGFloat
                weak var delegate: UIScrollViewDelegate?
                
                func adjustedContentInsetDidChange()
                func flashScrollIndicators()
                func scrollRectToVisible(_ rect: CGRect, animated: Bool)
                func setContentOffset(_ contentOffset: CGPoint, animated: Bool)
                func setZoomScale(_ scale: CGFloat, animated: Bool)
                func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool
                func touchesShouldCancel(in view: UIView) -> Bool
                func zoom(to rect: CGRect, animated: Bool)
            }
            """)
    }
    
    func testDefinedUITableView() {
        assertDefined(typeName: "UITableView", signature: """
            class UITableView: UIScrollView {
                var allowsMultipleSelection: Bool
                var allowsMultipleSelectionDuringEditing: Bool
                var allowsSelection: Bool
                var allowsSelectionDuringEditing: Bool
                var backgroundView: UIView?
                var cellLayoutMarginsFollowReadableWidth: Bool
                var dragInteractionEnabled: Bool
                var estimatedRowHeight: CGFloat
                var estimatedSectionFooterHeight: CGFloat
                var estimatedSectionHeaderHeight: CGFloat
                var hasActiveDrag: Bool { get }
                var hasActiveDrop: Bool { get }
                var hasUncommittedUpdates: Bool { get }
                var indexPathForSelectedRow: IndexPath? { get }
                var indexPathsForSelectedRows: [IndexPath]? { get }
                var indexPathsForVisibleRows: [IndexPath]? { get }
                var insetsContentViewsToSafeArea: Bool
                var isEditing: Bool
                var numberOfSections: Int { get }
                var remembersLastFocusedIndexPath: Bool
                var rowHeight: CGFloat
                var sectionFooterHeight: CGFloat
                var sectionHeaderHeight: CGFloat
                var sectionIndexBackgroundColor: UIColor?
                var sectionIndexColor: UIColor?
                var sectionIndexMinimumDisplayRowCount: Int
                var sectionIndexTrackingBackgroundColor: UIColor?
                var separatorColor: UIColor?
                var separatorEffect: UIVisualEffect?
                var separatorInset: UIEdgeInsets
                var separatorInsetReference: UITableViewSeparatorInsetReference
                var separatorStyle: UITableViewCellSeparatorStyle
                var style: UITableViewStyle { get }
                var tableFooterView: UIView?
                var tableHeaderView: UIView?
                var visibleCells: [UITableViewCell] { get }
                weak var dataSource: UITableViewDataSource?
                weak var delegate: UITableViewDelegate?
                weak var dragDelegate: UITableViewDragDelegate?
                weak var dropDelegate: UITableViewDropDelegate?
                weak var prefetchDataSource: UITableViewDataSourcePrefetching?
                
                init(frame: CGRect, style: UITableViewStyle)
                func beginUpdates()
                func cellForRow(at indexPath: IndexPath) -> UITableViewCell?
                func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
                func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
                func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell
                func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell?
                func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView?
                func deselectRow(at indexPath: IndexPath, animated: Bool)
                func endUpdates()
                func footerView(forSection section: Int) -> UITableViewHeaderFooterView?
                func headerView(forSection section: Int) -> UITableViewHeaderFooterView?
                func indexPath(for cell: UITableViewCell) -> IndexPath?
                func indexPathForRow(at point: CGPoint) -> IndexPath?
                func indexPathsForRows(in rect: CGRect) -> [IndexPath]?
                func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
                func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
                func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath)
                func moveSection(_ section: Int, toSection newSection: Int)
                func numberOfRows(inSection section: Int) -> Int
                func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)
                func rect(forSection section: Int) -> CGRect
                func rectForFooter(inSection section: Int) -> CGRect
                func rectForHeader(inSection section: Int) -> CGRect
                func rectForRow(at indexPath: IndexPath) -> CGRect
                func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String)
                func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String)
                func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
                func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String)
                func reloadData()
                func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
                func reloadSectionIndexTitles()
                func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
                func scrollToNearestSelectedRow(at scrollPosition: UITableViewScrollPosition, animated: Bool)
                func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableViewScrollPosition, animated: Bool)
                func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableViewScrollPosition)
                func setEditing(_ editing: Bool, animated: Bool)
            }
            """)
    }
}
