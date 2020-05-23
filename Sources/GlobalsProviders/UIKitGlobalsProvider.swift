import SwiftAST
import KnownType
import TypeSystem
import Commons

public class UIKitGlobalsProvider: GlobalsProvider {
    private static var provider = InnerUIKitGlobalsProvider()
    
    public init() {
        
    }
    
    public func knownTypeProvider() -> KnownTypeProvider {
        CollectionKnownTypeProvider(knownTypes: UIKitGlobalsProvider.provider.types)
    }
    
    public func typealiasProvider() -> TypealiasProvider {
        CollectionTypealiasProvider(aliases: UIKitGlobalsProvider.provider.typealiases)
    }
    
    public func definitionsSource() -> DefinitionsSource {
        UIKitGlobalsProvider.provider.definitions
    }
}

// swiftlint:disable line_length
// swiftlint:disable function_body_length
/// Globals provider for `UIKit` framework
private class InnerUIKitGlobalsProvider: BaseGlobalsProvider {
    
    var definitions: ArrayDefinitionsSource = ArrayDefinitionsSource(definitions: [])
    
    public override init() {
        
    }
    
    override func createTypes() {
        createUIViewController()
        createUILayoutConstraintAxis()
        createUIWindow()
        createUITableViewCell()
        createUIScrollView()
        createUITableView()
    }
    
    override func createDefinitions() {
        add(function(name: "UIGraphicsGetCurrentContext",
                     paramTypes: [],
                     returnType: .optional("CGContext")))
        
        add(constant(name: "UIViewNoIntrinsicMetric",
                     type: .cgFloat))
        add(constant(name: "UILayoutFittingCompressedSize",
                     type: "CGSize"))
        add(constant(name: "UILayoutFittingExpandedSize",
                     type: "CGSize"))
        add(constant(name: "UITableViewAutomaticDimension",
                     type: .cgFloat))
        
        definitions = ArrayDefinitionsSource(definitions: globals)
    }
    
    func createUIViewController() {
        let type = UIViewControllerCompoundType.create()
        add(type)
    }
    
    func createUILayoutConstraintAxis() {
        makeType(named: "UILayoutConstraintAxis", kind: .enum) { type -> KnownType in
            type
                .settingEnumRawValue(type: .int)
                .enumCase(named: "horizontal", rawValue: .constant(0))
                .enumCase(named: "vertical", rawValue: .constant(1))
                .build()
        }
    }
    
    func createUITableViewCell() {
        makeType(named: "UITableViewCell", supertype: "UIView") { type -> KnownType in
            type
                // Protocol conformances
                .protocolConformance(protocolName: "UIGestureRecognizerDelegate")
                // Properties
                .property(named: "accessoryType", type: "UITableViewCellAccessoryType")
                .property(named: "accessoryView", type: .optional("UIView"))
                .property(named: "backgroundView", type: .optional("UIView"))
                .property(named: "contentView", type: "UIView", accessor: .getter)
                .property(named: "detailTextLabel", type: .optional("UILabel"), accessor: .getter)
                .property(named: "editingAccessoryType", type: "UITableViewCellAccessoryType")
                .property(named: "editingAccessoryView", type: .optional("UIView"))
                .property(named: "editingStyle", type: "UITableViewCellEditingStyle", accessor: .getter)
                .property(named: "focusStyle", type: "UITableViewCellFocusStyle")
                .property(named: "imageView", type: .optional("UIImageView"), accessor: .getter)
                .property(named: "indentationLevel", type: .int)
                .property(named: "indentationWidth", type: .cgFloat)
                .property(named: "isEditing", type: .bool)
                .property(named: "isHighlighted", type: .bool)
                .property(named: "isSelected", type: .bool)
                .property(named: "multipleSelectionBackgroundView", type: .optional("UIView"))
                .property(named: "reuseIdentifier", type: .optional("String"), accessor: .getter)
                .property(named: "selectedBackgroundView", type: .optional("UIView"))
                .property(named: "selectionStyle", type: "UITableViewCellSelectionStyle")
                .property(named: "separatorInset", type: "UIEdgeInsets")
                .property(named: "shouldIndentWhileEditing", type: .bool)
                .property(named: "showingDeleteConfirmation", type: .bool, accessor: .getter)
                .property(named: "showsReorderControl", type: .bool)
                .property(named: "textLabel", type: .optional("UILabel"), accessor: .getter)
                .property(named: "userInteractionEnabledWhileDragging", type: .bool)
                // Constructors
                .constructor(shortParameters: [("style", "UITableViewCellStyle"),
                                               ("reuseIdentifier", .optional(.string))])
                .method(withSignature:
                    FunctionSignature(
                        name: "didTransition",
                        parameters: [
                            ParameterSignature(label: "to", name: "state", type: "UITableViewCellStateMask")
                        ])
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "dragStateDidChange",
                        parameters: [
                            ParameterSignature(label: nil, name: "dragState", type: "UITableViewCellDragState")
                        ])
                )
                .method(named: "prepareForReuse")
                .method(withSignature:
                    FunctionSignature(
                        name: "setEditing",
                        parameters: [
                            ParameterSignature(label: nil, name: "editing", type: "Bool"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ])
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setHighlighted",
                        parameters: [
                            ParameterSignature(label: nil, name: "highlighted", type: "Bool"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ])
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setSelected",
                        parameters: [
                            ParameterSignature(label: nil, name: "selected", type: "Bool"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ])
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "willTransition",
                        parameters: [
                            ParameterSignature(label: "to", name: "state", type: "UITableViewCellStateMask")
                        ])
                )
                .build()
        }
    }
    
    func createUIWindow() {
        makeType(named: "UIWindow", supertype: "UIView")
    }
    
    func createUIScrollView() {
        makeType(named: "UIScrollView", supertype: "UIView") { type -> KnownType in
            type
                // Properties
                .property(named: "adjustedContentInset", type: "UIEdgeInsets", accessor: .getter)
                .property(named: "alwaysBounceHorizontal", type: .bool)
                .property(named: "alwaysBounceVertical", type: .bool)
                .property(named: "bounces", type: .bool)
                .property(named: "bouncesZoom", type: .bool)
                .property(named: "canCancelContentTouches", type: .bool)
                .property(named: "contentInset", type: "UIEdgeInsets")
                .property(named: "contentInsetAdjustmentBehavior", type: "UIScrollViewContentInsetAdjustmentBehavior")
                .property(named: "contentLayoutGuide", type: "UILayoutGuide", accessor: .getter)
                .property(named: "contentOffset", type: "CGPoint")
                .property(named: "contentSize", type: "CGSize")
                .property(named: "decelerationRate", type: .cgFloat)
                .property(named: "delaysContentTouches", type: .bool)
                .property(named: "directionalPressGestureRecognizer", type: "UIGestureRecognizer", accessor: .getter)
                .property(named: "frameLayoutGuide", type: "UILayoutGuide", accessor: .getter)
                .property(named: "indexDisplayMode", type: "UIScrollViewIndexDisplayMode")
                .property(named: "indicatorStyle", type: "UIScrollViewIndicatorStyle")
                .property(named: "isDecelerating", type: .bool, accessor: .getter)
                .property(named: "isDirectionalLockEnabled", type: .bool)
                .property(named: "isDragging", type: .bool, accessor: .getter)
                .property(named: "isPagingEnabled", type: .bool)
                .property(named: "isScrollEnabled", type: .bool)
                .property(named: "isTracking", type: .bool, accessor: .getter)
                .property(named: "isZoomBouncing", type: .bool, accessor: .getter)
                .property(named: "isZooming", type: .bool, accessor: .getter)
                .property(named: "keyboardDismissMode", type: "UIScrollViewKeyboardDismissMode")
                .property(named: "maximumZoomScale", type: .cgFloat)
                .property(named: "minimumZoomScale", type: .cgFloat)
                .property(named: "panGestureRecognizer", type: "UIPanGestureRecognizer", accessor: .getter)
                .property(named: "pinchGestureRecognizer", type: .optional("UIPinchGestureRecognizer"), accessor: .getter)
                .property(named: "refreshControl", type: .optional("UIRefreshControl"))
                .property(named: "scrollIndicatorInsets", type: "UIEdgeInsets")
                .property(named: "scrollsToTop", type: .bool)
                .property(named: "showsHorizontalScrollIndicator", type: .bool)
                .property(named: "showsVerticalScrollIndicator", type: .bool)
                .property(named: "zoomScale", type: .cgFloat)
                .property(named: "delegate", type: .optional("UIScrollViewDelegate"),
                          ownership: .weak)
                // Methods
                .method(named: "adjustedContentInsetDidChange")
                .method(named: "flashScrollIndicators")
                .method(withSignature:
                    FunctionSignature(
                        name: "scrollRectToVisible", parameters: [
                            ParameterSignature(label: nil, name: "rect", type: "CGRect"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setContentOffset", parameters: [
                            ParameterSignature(label: nil, name: "contentOffset", type: "CGPoint"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setZoomScale", parameters: [
                            ParameterSignature(label: nil, name: "scale", type: "CGFloat"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "touchesShouldBegin",
                        parameters: [
                            ParameterSignature(label: nil, name: "touches",
                                               type: .generic("Set", parameters: ["UITouch"])),
                            ParameterSignature(label: "with", name: "event",
                                               type: .optional("UIEvent")),
                            ParameterSignature(label: "in", name: "view",
                                               type: "UIView")
                        ],
                        returnType: .bool
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "touchesShouldCancel", parameters: [
                            ParameterSignature(label: "in", name: "view", type: "UIView")
                        ],
                        returnType: .bool
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "zoom", parameters: [
                            ParameterSignature(label: "to", name: "rect", type: "CGRect"),
                            ParameterSignature(name: "animated", type: .bool)
                        ]
                    )
                )
                .build()
        }
    }
    
    func createUITableView() {
        let typeString = """
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
        
        let result = SwiftSyntaxTypeParser(source: typeString)
        let incomplete = result.parseTypes()[0]
        
        let type = incomplete.complete(typeSystem: TypeSystem())
        
        add(type)
    }
}
