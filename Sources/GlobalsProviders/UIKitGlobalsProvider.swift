import SwiftAST
import SwiftRewriterLib
import Commons

public class UIKitGlobalsProvider: GlobalsProvider {
    private static var provider = InnerUIKitGlobalsProvider()
    
    public init() {
        
    }
    
    public func knownTypeProvider() -> KnownTypeProvider {
        return CollectionKnownTypeProvider(knownTypes: UIKitGlobalsProvider.provider.types)
    }
    
    public func typealiasProvider() -> TypealiasProvider {
        return CollectionTypealiasProvider(aliases: UIKitGlobalsProvider.provider.typealiases)
    }
    
    public func definitionsSource() -> DefinitionsSource {
        return UIKitGlobalsProvider.provider.definitions
    }
}

// swiftlint:disable line_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length
/// Globals provider for `UIKit` framework
private class InnerUIKitGlobalsProvider: BaseGlobalsProvider {
    
    var definitions: ArrayDefinitionsSource = ArrayDefinitionsSource(definitions: [])
    
    public override init() {
        
    }
    
    override func createTypes() {
        createUIResponder()
        createUIViewController()
        createUILayoutConstraintAxis()
        createUIView()
        createUIWindow()
        createUITableViewCell()
        createUIScrollView()
        createUITableView()
    }
    
    override func createDefinitions() {
        add(function(name: "UIGraphicsGetCurrentContext", paramTypes: [],
                     returnType: .optional(.typeName("CGContext"))))
        
        add(CodeDefinition(variableNamed: "UIViewNoIntrinsicMetric",
                           storage: ValueStorage.constant(ofType: .cgFloat)))
        add(CodeDefinition(variableNamed: "UILayoutFittingCompressedSize",
                           storage: ValueStorage.constant(ofType: "CGSize")))
        add(CodeDefinition(variableNamed: "UILayoutFittingExpandedSize",
                           storage: ValueStorage.constant(ofType: "CGSize")))
        
        definitions = ArrayDefinitionsSource(definitions: globals)
    }
    
    func createUIResponder() {
        let type = UIResponderCompoundType.create()
        types.append(type)
    }
    
    func createUIViewController() {
        makeType(named: "UIViewController", supertype: "UIResponder") { type -> KnownType in
            type
                // Protocol conformances
                .protocolConformances(protocolNames: [
                    "NSCoding", "UIAppearanceContainer", "UITraitEnvironment",
                    "UIContentContainer", "UIFocusEnvironment"
                ])
                // Properties
                .property(named: "view", type: "UIView")
                // Initializers
                .constructor(withParameters: [
                    ParameterSignature(label: "nibName", name: "nibNameOrNil", type: .optional(.string)),
                    ParameterSignature(label: "bundle", name: "nibBundleOrNil", type: .optional("Bundle"))
                ])
                // Methods
                .method(named: "viewDidLoad")
                .method(withSignature:
                    FunctionSignature(
                        name: "viewWillAppear",
                        parameters: [
                            ParameterSignature(label: nil, name: "animated", type: .bool)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "viewDidAppear",
                        parameters: [
                            ParameterSignature(label: nil, name: "animated", type: .bool)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "viewWillDisappear",
                        parameters: [
                            ParameterSignature(label: nil, name: "animated", type: .bool)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "viewDidDisappear",
                        parameters: [
                            ParameterSignature(label: nil, name: "animated", type: .bool)
                        ]
                    )
                )
                .method(named: "viewWillLayoutSubviews")
                .method(named: "viewDidLayoutSubviews")
                .build()
        }
    }
    
    func createUILayoutConstraintAxis() {
        makeType(named: "UILayoutConstraintAxis", kind: .enum) { type -> KnownType in
            type
                .enumRawValue(type: .int)
                .enumCase(named: "horizontal", rawValue: .constant(0))
                .enumCase(named: "vertical", rawValue: .constant(1))
                .build()
        }
    }
    
    func createUIView() {
        let type = UIViewCompoundType.create()
        types.append(type)
    }
    
    func createUIGestureRecognizer() {
        let type = UIGestureRecognizerCompoundType.create()
        types.append(type)
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
        makeType(named: "UITableView", supertype: "UIScrollView") { type -> KnownType in
            var type = type
            
            type.useSwiftSignatureMatching = true
            
            type = type
                // Properties
                .property(named: "allowsMultipleSelection", type: .bool)
                .property(named: "allowsMultipleSelectionDuringEditing", type: .bool)
                .property(named: "allowsSelection", type: .bool)
                .property(named: "allowsSelectionDuringEditing", type: .bool)
                .property(named: "backgroundView", type: .optional("UIView"))
                .property(named: "cellLayoutMarginsFollowReadableWidth", type: .bool)
                .property(named: "dragInteractionEnabled", type: .bool)
                .property(named: "estimatedRowHeight", type: .cgFloat)
                .property(named: "estimatedSectionFooterHeight", type: .cgFloat)
                .property(named: "estimatedSectionHeaderHeight", type: .cgFloat)
                .property(named: "hasActiveDrag", type: .bool, accessor: .getter)
                .property(named: "hasActiveDrop", type: .bool, accessor: .getter)
                .property(named: "hasUncommittedUpdates", type: .bool, accessor: .getter)
                .property(named: "indexPathForSelectedRow", type: .optional("IndexPath"), accessor: .getter)
                .property(named: "indexPathsForSelectedRows", type: .optional(.array("IndexPath")), accessor: .getter)
                .property(named: "indexPathsForVisibleRows", type: .optional(.array("IndexPath")), accessor: .getter)
                .property(named: "insetsContentViewsToSafeArea", type: .bool)
                .property(named: "isEditing", type: .bool)
                .property(named: "numberOfSections", type: .int, accessor: .getter)
                .property(named: "remembersLastFocusedIndexPath", type: .bool)
                .property(named: "rowHeight", type: .cgFloat)
                .property(named: "sectionFooterHeight", type: .cgFloat)
                .property(named: "sectionHeaderHeight", type: .cgFloat)
                .property(named: "sectionIndexBackgroundColor", type: .optional("UIColor"))
                .property(named: "sectionIndexColor", type: .optional("UIColor"))
                .property(named: "sectionIndexMinimumDisplayRowCount", type: .int)
                .property(named: "sectionIndexTrackingBackgroundColor", type: .optional("UIColor"))
                .property(named: "separatorColor", type: .optional("UIColor"))
                .property(named: "separatorEffect", type: .optional("UIVisualEffect"))
                .property(named: "separatorInset", type: "UIEdgeInsets")
                .property(named: "separatorInsetReference", type: "UITableViewSeparatorInsetReference")
                .property(named: "separatorStyle", type: "UITableViewCellSeparatorStyle")
                .property(named: "style", type: "UITableViewStyle", accessor: .getter)
                .property(named: "tableFooterView", type: .optional("UIView"))
                .property(named: "tableHeaderView", type: .optional("UIView"))
                .property(named: "visibleCells", type: .array("UITableViewCell"), accessor: .getter)
                .property(named: "dataSource", type: .optional("UITableViewDataSource"), ownership: .weak)
                .property(named: "delegate", type: .optional("UITableViewDelegate"), ownership: .weak)
                .property(named: "dragDelegate", type: .optional("UITableViewDragDelegate"), ownership: .weak)
                .property(named: "dropDelegate", type: .optional("UITableViewDropDelegate"), ownership: .weak)
                .property(named: "prefetchDataSource", type: .optional("UITableViewDataSourcePrefetching"), ownership: .weak)
                // Initializers
                .constructor(shortParameters: [("frame", "CGRect"), ("style", "UITableViewStyle")])
                
            type = type
                // Methods
                .method(named: "beginUpdates")
                .method(withSignature:
                    FunctionSignature(
                        name: "cellForRow", parameters: [
                            ParameterSignature(label: "at", name: "indexPath", type: "IndexPath")
                        ],
                        returnType: .optional("UITableViewCell")
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "deleteRows", parameters: [
                            ParameterSignature(label: "at", name: "indexPaths", type: .array("IndexPath")),
                            ParameterSignature(label: "with", name: "animation", type: "UITableViewRowAnimation")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "deleteSections", parameters: [
                            ParameterSignature(label: nil, name: "sections", type: "IndexSet"),
                            ParameterSignature(label: "with", name: "animation", type: "UITableViewRowAnimation")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "dequeueReusableCell", parameters: [
                            ParameterSignature(label: "withIdentifier", name: "identifier", type: .string),
                            ParameterSignature(label: "for", name: "indexPath", type: "IndexPath")
                        ],
                        returnType: "UITableViewCell"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "dequeueReusableCell", parameters: [
                            ParameterSignature(label: "withIdentifier", name: "identifier", type: .string)
                        ],
                        returnType: .optional("UITableViewCell")
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "dequeueReusableHeaderFooterView", parameters: [
                            ParameterSignature(label: "withIdentifier", name: "identifier", type: .string)
                        ],
                        returnType: .optional("UITableViewHeaderFooterView")
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "deselectRow", parameters: [
                            ParameterSignature(label: "at", name: "indexPath", type: "IndexPath"),
                            ParameterSignature(name: "animated", type: .bool)
                        ]
                    )
                )
                .method(named: "endUpdates")
                .method(withSignature:
                    FunctionSignature(
                        name: "footerView", parameters: [
                            ParameterSignature(label: "forSection", name: "section", type: "Int")
                        ],
                        returnType: .optional("UITableViewHeaderFooterView")
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "headerView", parameters: [
                            ParameterSignature(label: "forSection", name: "section", type: "Int")
                        ],
                        returnType: .optional("UITableViewHeaderFooterView")
                    )
                )
                
            type = type
                .method(withSignature:
                    FunctionSignature(
                        name: "indexPath", parameters: [
                            ParameterSignature(label: "for", name: "cell", type: "UITableViewCell")
                        ],
                        returnType: .optional("IndexPath")
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "indexPathForRow", parameters: [
                            ParameterSignature(label: "at", name: "point", type: "CGPoint")
                        ],
                        returnType: .optional("IndexPath")
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "indexPathsForRows", parameters: [
                            ParameterSignature(label: "in", name: "rect", type: "CGRect")
                        ],
                        returnType: .optional(.array("IndexPath"))
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "insertRows", parameters: [
                            ParameterSignature(label: "at", name: "indexPaths", type: .array("IndexPath")),
                            ParameterSignature(label: "with", name: "animation", type: "UITableViewRowAnimation")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "insertSections", parameters: [
                            ParameterSignature(label: nil, name: "sections", type: "IndexSet"),
                            ParameterSignature(label: "with", name: "animation", type: "UITableViewRowAnimation")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "moveRow", parameters: [
                            ParameterSignature(label: "at", name: "indexPath", type: "IndexPath"),
                            ParameterSignature(label: "to", name: "newIndexPath", type: "IndexPath")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "moveSection", parameters: [
                            ParameterSignature(label: nil, name: "section", type: .int),
                            ParameterSignature(label: "toSection", name: "newSection", type: .int)
                        ]
                    )
                )
            
            type = type
                .method(withSignature:
                    FunctionSignature(
                        name: "numberOfRows", parameters: [
                            ParameterSignature(label: "inSection", name: "section", type: .int)
                        ],
                        returnType: .int
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "performBatchUpdates", parameters: [
                            ParameterSignature(label: nil, name: "updates", type: .optional(.block(returnType: .void, parameters: []))),
                            ParameterSignature(name: "completion", type: .optional(.block(returnType: .void, parameters: [.bool])))
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "rect", parameters: [
                            ParameterSignature(label: "forSection", name: "section", type: "Int")
                        ],
                        returnType: "CGRect"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "rectForFooter", parameters: [
                            ParameterSignature(label: "inSection", name: "section", type: .int)
                        ],
                        returnType: "CGRect"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "rectForHeader", parameters: [
                            ParameterSignature(label: "inSection", name: "section", type: .int)
                        ],
                        returnType: "CGRect"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "rectForRow", parameters: [
                            ParameterSignature(label: "at", name: "indexPath", type: "IndexPath")
                        ],
                        returnType: "CGRect"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "register", parameters: [
                            ParameterSignature(label: nil, name: "aClass", type: .optional("AnyClass")),
                            ParameterSignature(label: "forHeaderFooterViewReuseIdentifier",
                                               name: "identifier", type: .string)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "register", parameters: [
                            ParameterSignature(label: nil, name: "cellClass", type: .optional("AnyClass")),
                            ParameterSignature(label: "forCellReuseIdentifier",
                                               name: "identifier", type: .string)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "register", parameters: [
                            ParameterSignature(label: nil, name: "nib", type: .optional("UINib")),
                            ParameterSignature(label: "forCellReuseIdentifier",
                                               name: "identifier", type: .string)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "register", parameters: [
                            ParameterSignature(label: nil, name: "nib", type: .optional("UINib")),
                            ParameterSignature(label: "forHeaderFooterViewReuseIdentifier",
                                               name: "identifier", type: .string)
                        ]
                    )
                )
                .method(named: "reloadData")
                .method(withSignature:
                    FunctionSignature(
                        name: "reloadRows", parameters: [
                            ParameterSignature(label: "at", name: "indexPaths", type: .array("IndexPath")),
                            ParameterSignature(label: "with",
                                               name: "animation", type: "UITableViewRowAnimation")
                        ]
                    )
                )
                .method(named: "reloadSectionIndexTitles")
                .method(withSignature:
                    FunctionSignature(
                        name: "reloadSections", parameters: [
                            ParameterSignature(label: nil, name: "sections", type: "IndexSet"),
                            ParameterSignature(label: "with",
                                               name: "animation", type: "UITableViewRowAnimation")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "scrollToNearestSelectedRow", parameters: [
                            ParameterSignature(label: "at", name: "scrollPosition",
                                               type: "UITableViewScrollPosition"),
                            ParameterSignature(name: "animated", type: .bool)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "scrollToRow", parameters: [
                            ParameterSignature(label: "at", name: "indexPath", type: "IndexPath"),
                            ParameterSignature(label: "at", name: "scrollPosition",
                                               type: "UITableViewScrollPosition"),
                            ParameterSignature(name: "animated", type: .bool)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "selectRow", parameters: [
                            ParameterSignature(label: "at", name: "indexPath", type: .optional("IndexPath")),
                            ParameterSignature(name: "animated", type: .bool),
                            ParameterSignature(name: "scrollPosition", type: "UITableViewScrollPosition")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setEditing", parameters: [
                            ParameterSignature(label: nil, name: "editing", type: .bool),
                            ParameterSignature(name: "animated", type: .bool)
                        ]
                    )
                )
                
            return type.build()
        }
    }
}
