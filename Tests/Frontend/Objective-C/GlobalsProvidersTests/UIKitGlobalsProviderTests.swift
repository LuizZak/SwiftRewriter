import GlobalsProviders
import SwiftRewriterLib
import XCTest

class UIKitGlobalsProviderTests: BaseGlobalsProviderTestCase {

    override func setUp() {
        super.setUp()

        sut = UIKitGlobalsProvider()

        globals = sut.definitionsSource()
        types = sut.knownTypeProvider()
        typealiases = sut.typealiasProvider()
    }

    func testDefinedUIGraphicsGetCurrentContext() {
        assertDefined(
            function: "UIGraphicsGetCurrentContext",
            paramTypes: [],
            returnType: .optional(.typeName("CGContext"))
        )
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

    func testDefinedUITableViewAutomaticDimension() {
        assertDefined(variable: "UITableViewAutomaticDimension", type: "CGFloat")
    }

    func testDefinedUIViewController() {
        assertDefined(typeName: "UIViewController")
    }

    func testDefinedUILayoutConstraintAxis() {
        assertDefined(
            typeName: "UILayoutConstraintAxis",
            signature: """
                enum UILayoutConstraintAxis: Int {
                    case horizontal
                    case vertical
                }
                """
        )
    }

    func testDefinedUIWindow() {
        assertDefined(
            typeName: "UIWindow",
            supertype: "UIView",
            signature: """
                class UIWindow: UIView {
                }
                """
        )
    }

    func testDefinedUITableViewCell() {
        assertDefined(
            typeName: "UITableViewCell",
            supertype: "UIView",
            signature: """
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
                """
        )
    }

    func testDefinedUIScrollView() {
        assertDefined(
            typeName: "UIScrollView",
            supertype: "UIView",
            signature: """
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
                """
        )
    }

    func testDefinedUITableView() {
        assertDefined(
            typeName: "UITableView",
            supertype: "UIScrollView",
            signature: """
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
                """
        )
    }
}
