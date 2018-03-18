import SwiftAST
import SwiftRewriterLib

/// Globals provider for `UIKit` framework
public class UIKitGlobalsProvider: BaseGlobalsProvider {
    public override init() {
        
    }
    
    override func createTypes() {
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
                           storage: ValueStorage.constant(ofType: .cgFloat),
                           intention: nil))
        add(CodeDefinition(variableNamed: "UILayoutFittingCompressedSize",
                           storage: ValueStorage.constant(ofType: "CGSize"),
                           intention: nil))
        add(CodeDefinition(variableNamed: "UILayoutFittingExpandedSize",
                           storage: ValueStorage.constant(ofType: "CGSize"),
                           intention: nil))
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
                .property(named: "view", type: .implicitUnwrappedOptional("UIView"))
                // Initializers
                .constructor(withParameters: [
                    ParameterSignature(label: "nibName", name: "nibNameOrNil", type: .optional(.string)),
                    ParameterSignature(label: "bundle", name: "nibBundleOrNil", type: .optional("Bundle"))
                ])
                // Methods
                .method(withSignature:
                    FunctionSignature(
                        name: "viewWillAppear",
                        parameters: [
                            ParameterSignature(label: "_", name: "animated", type: .bool)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "viewDidAppear",
                        parameters: [
                            ParameterSignature(label: "_", name: "animated", type: .bool)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "viewWillDisappear",
                        parameters: [
                            ParameterSignature(label: "_", name: "animated", type: .bool)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "viewDidDisappear",
                        parameters: [
                            ParameterSignature(label: "_", name: "animated", type: .bool)
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
        makeType(named: "UIView", supertype: "UIResponder") { type -> KnownType in
            var type = type
            
            type.useSwiftSignatureMatching = true
            
            type = type
                // Protocol conformances
                .protocolConformances(protocolNames: [
                    "NSCoding", "UIAppearance", "UIAppearanceContainer",
                    "UIDynamicItem", "UITraitEnvironment", "UICoordinateSpace",
                    "UIFocusItem", "CALayerDelegate"
                ])
            
            type = type
                // Properties
                .property(named: "alignmentRectInsets", type: "UIEdgeInsets", accessor: .getter)
                .property(named: "alpha", type: .cgFloat)
                .property(named: "autoresizesSubviews", type: .bool)
                .property(named: "autoresizingMask", type: "UIViewAutoresizing")
                .property(named: "backgroundColor", type: .optional("UIColor"))
                .property(named: "bottomAnchor", type: "NSLayoutYAxisAnchor", accessor: .getter)
                .property(named: "bounds", type: "CGRect")
                .property(named: "canBecomeFocused", type: .bool, accessor: .getter)
                .property(named: "center", type: "CGPoint")
                .property(named: "centerXAnchor", type: "NSLayoutXAxisAnchor", accessor: .getter)
                .property(named: "centerYAnchor", type: "NSLayoutYAxisAnchor", accessor: .getter)
                .property(named: "clearsContextBeforeDrawing", type: .bool)
                .property(named: "clipsToBounds", type: .bool)
                .property(named: "constraints", type: .array("NSLayoutConstraint"), accessor: .getter)
                .property(named: "contentMode", type: "UIViewContentMode")
                .property(named: "contentScaleFactor", type: .cgFloat)
                .property(named: "directionalLayoutMargins", type: "NSDirectionalEdgeInsets")
                .property(named: "effectiveUserInterfaceLayoutDirection", type: "UIUserInterfaceLayoutDirection", accessor: .getter)
                .property(named: "firstBaselineAnchor", type: "NSLayoutYAxisAnchor", accessor: .getter)
                .property(named: "forFirstBaselineLayout", type: "UIView", accessor: .getter)
                .property(named: "forLastBaselineLayout", type: "UIView", accessor: .getter)
                .property(named: "frame", type: "CGRect")
                .property(named: "gestureRecognizers", type: .optional(.array("UIGestureRecognizer")))
                .property(named: "hasAmbiguousLayout", type: .bool, accessor: .getter)
                .property(named: "heightAnchor", type: "NSLayoutDimension", accessor: .getter)
                .property(named: "insetsLayoutMarginsFromSafeArea", type: .bool)
                .property(named: "intrinsicContentSize", type: "CGSize", accessor: .getter)
                .property(named: "isExclusiveTouch", type: .bool)
                .property(named: "isFocused", type: .bool, accessor: .getter)
                .property(named: "isHidden", type: .bool)
                .property(named: "isMultipleTouchEnabled", type: .bool)
                .property(named: "isOpaque", type: .bool)
                .property(named: "isUserInteractionEnabled", type: .bool)
                .property(named: "lastBaselineAnchor", type: "NSLayoutYAxisAnchor", accessor: .getter)
                .property(named: "layer", type: "CALayer", accessor: .getter)
                .property(named: "layoutGuides", type: .array("UILayoutGuide"), accessor: .getter)
                .property(named: "layoutMargins", type: "UIEdgeInsets")
                .property(named: "layoutMarginsGuide", type: "UILayoutGuide", accessor: .getter)
                .property(named: "leadingAnchor", type: "NSLayoutXAxisAnchor", accessor: .getter)
                .property(named: "leftAnchor", type: "NSLayoutXAxisAnchor", accessor: .getter)
                .property(named: "mask", type: .optional("UIView"))
                .property(named: "motionEffects", type: .array("UIMotionEffect"))
                .property(named: "preservesSuperviewLayoutMargins", type: .bool)
                .property(named: "readableContentGuide", type: "UILayoutGuide", accessor: .getter)
                .property(named: "restorationIdentifier", type: .optional("String"))
                .property(named: "rightAnchor", type: "NSLayoutXAxisAnchor", accessor: .getter)
                .property(named: "safeAreaInsets", type: "UIEdgeInsets", accessor: .getter)
                .property(named: "safeAreaLayoutGuide", type: "UILayoutGuide", accessor: .getter)
                .property(named: "semanticContentAttribute", type: "UISemanticContentAttribute")
                .property(named: "subviews", type: .array("UIView"), accessor: .getter)
                .property(named: "superview", type: .optional("UIView"), accessor: .getter)
                .property(named: "tag", type: .int)
                .property(named: "tintAdjustmentMode", type: "UIViewTintAdjustmentMode")
                .property(named: "tintColor", type: .implicitUnwrappedOptional("UIColor"))
                .property(named: "topAnchor", type: "NSLayoutYAxisAnchor", accessor: .getter)
                .property(named: "trailingAnchor", type: "NSLayoutXAxisAnchor", accessor: .getter)
                .property(named: "transform", type: "CGAffineTransform")
                .property(named: "translatesAutoresizingMaskIntoConstraints", type: .bool)
                .property(named: "widthAnchor", type: "NSLayoutDimension", accessor: .getter)
                .property(named: "window", type: .optional("UIWindow"), accessor: .getter)
                
            type = type
                // Constructors
                .constructor(shortParameters: [("frame", .typeName("CGRect"))])
            
            type = type
                // Methods
                .method(withSignature:
                    FunctionSignature(
                        name: "addConstraint",
                        parameters: [
                            ParameterSignature(label: "_", name: "constraint", type: "NSLayoutConstraint")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "addConstraints",
                        parameters: [
                            ParameterSignature(label: "_", name: "constraints", type: .array("NSLayoutConstraint"))
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "addGestureRecognizer",
                        parameters: [
                            ParameterSignature(label: "_", name: "gestureRecognizer", type: "UIGestureRecognizer")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "addLayoutGuide",
                        parameters: [
                            ParameterSignature(label: "_", name: "layoutGuide", type: "UILayoutGuide")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "addMotionEffect",
                        parameters: [
                            ParameterSignature(label: "_", name: "effect", type: "UIMotionEffect")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "addSubview",
                        parameters: [
                            ParameterSignature(label: "_", name: "view", type: "UIView")
                        ]
                    )
                )

            type = type
                .method(withSignature:
                    FunctionSignature(
                        name: "alignmentRect",
                        parameters: [
                            ParameterSignature(label: "forFrame", name: "frame", type: "CGRect")
                        ],
                        returnType: "CGRect"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "bringSubview",
                        parameters: [
                            ParameterSignature(label: "toFront", name: "view", type: "UIView")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "constraintsAffectingLayout",
                        parameters: [
                            ParameterSignature(label: "for", name: "axis", type: "UILayoutConstraintAxis")
                        ],
                        returnType: "[NSLayoutConstraint]"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "contentCompressionResistancePriority",
                        parameters: [
                            ParameterSignature(label: "for", name: "axis", type: "UILayoutConstraintAxis")
                        ],
                        returnType: "UILayoutPriority"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "contentHuggingPriority",
                        parameters: [
                            ParameterSignature(label: "for", name: "axis", type: "UILayoutConstraintAxis")
                        ],
                        returnType: "UILayoutPriority"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "convert",
                        parameters: [
                            ParameterSignature(label: "_", name: "point", type: "CGPoint"),
                            ParameterSignature(label: "from", name: "view", type: .optional("UIView"))
                        ],
                        returnType: "CGPoint"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "convert",
                        parameters: [
                            ParameterSignature(label: "_", name: "point", type: "CGPoint"),
                            ParameterSignature(label: "to", name: "view", type: .optional("UIView"))
                        ],
                        returnType: "CGPoint"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "convert",
                        parameters: [
                            ParameterSignature(label: "_", name: "rect", type: "CGRect"),
                            ParameterSignature(label: "from", name: "view", type: .optional("UIView"))
                        ],
                        returnType: "CGRect"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "convert",
                        parameters: [
                            ParameterSignature(label: "_", name: "rect", type: "CGRect"),
                            ParameterSignature(label: "to", name: "view", type: .optional("UIView"))
                        ],
                        returnType: "CGRect"
                    )
                )

            type = type
                .method(withSignature:
                    FunctionSignature(
                        name: "decodeRestorableState",
                        parameters: [
                            ParameterSignature(label: "with", name: "coder", type: "NSCoder")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "didAddSubview",
                        parameters: [
                            ParameterSignature(label: "_", name: "subview", type: "UIView")
                        ]
                    )
                )
                .method(named: "didMoveToSuperview")
                .method(named: "didMoveToWindow")
                .method(withSignature:
                    FunctionSignature(
                        name: "draw",
                        parameters: [
                            ParameterSignature(label: "_", name: "rect", type: "CGRect")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "drawHierarchy",
                        parameters: [
                            ParameterSignature(label: "in", name: "rect", type: "CGRect"),
                            ParameterSignature(label: "afterScreenUpdates", name: "afterUpdates", type: .bool)
                        ],
                        returnType: .bool
                    )
                )

            type = type
                .method(withSignature:
                    FunctionSignature(
                        name: "encodeRestorableState",
                        parameters: [
                            ParameterSignature(label: "with", name: "coder", type: "NSCoder")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "exchangeSubview",
                        parameters: [
                            ParameterSignature(label: "at", name: "index1", type: .int),
                            ParameterSignature(label: "withSubviewAt", name: "index2", type: .int)
                        ]
                    )
                )
                .method(named: "exerciseAmbiguityInLayout")
                .method(named: "forBaselineLayout", returning: "UIView")
                .method(withSignature:
                    FunctionSignature(
                        name: "frame",
                        parameters: [
                            ParameterSignature(label: "forAlignmentRect", name: "alignmentRect", type: "CGRect")
                        ],
                        returnType: "CGRect"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "gestureRecognizerShouldBegin",
                        parameters: [
                            ParameterSignature(label: "_", name: "gestureRecognizer", type: "UIGestureRecognizer")
                        ],
                        returnType: .bool
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "hitTest",
                        parameters: [
                            ParameterSignature(label: "_", name: "point", type: "CGPoint"),
                            ParameterSignature(label: "with", name: "event", type: .optional("UIEvent"))
                        ],
                        returnType: .optional("UIView")
                    )
                )

            type = type
                .method(withSignature:
                    FunctionSignature(
                        name: "insertSubview",
                        parameters: [
                            ParameterSignature(label: "_", name: "view", type: "UIView"),
                            ParameterSignature(label: "aboveSubview", name: "siblingSubview", type: "UIView")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "insertSubview",
                        parameters: [
                            ParameterSignature(label: "_", name: "view", type: "UIView"),
                            ParameterSignature(label: "at", name: "index", type: .int)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "insertSubview",
                        parameters: [
                            ParameterSignature(label: "_", name: "view", type: "UIView"),
                            ParameterSignature(label: "belowSubview", name: "siblingSubview", type: "UIView")
                        ]
                    )
                )
                .method(named: "invalidateIntrinsicContentSize")
                .method(withSignature:
                    FunctionSignature(
                        name: "isDescendant",
                        parameters: [
                            ParameterSignature(label: "of", name: "view", type: "UIView")
                        ],
                        returnType: .bool
                    )
                )
                .method(named: "layoutIfNeeded")
                .method(named: "layoutMarginsDidChange")
                .method(named: "layoutSubviews")
                .method(named: "needsUpdateConstraints", returning: .bool)
                .method(withSignature:
                    FunctionSignature(
                        name: "point",
                        parameters: [
                            ParameterSignature(label: "inside", name: "point", type: "CGPoint"),
                            ParameterSignature(label: "with", name: "event", type: .optional("UIEvent"))
                        ],
                        returnType: .bool
                    )
                )

            type = type
                .method(withSignature:
                    FunctionSignature(
                        name: "removeConstraint",
                        parameters: [
                            ParameterSignature(label: "_", name: "constraint", type: "NSLayoutConstraint")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "removeConstraints",
                        parameters: [
                            ParameterSignature(label: "_", name: "constraints", type: .array("NSLayoutConstraint"))
                        ]
                    )
                )
                .method(named: "removeFromSuperview")
                .method(withSignature:
                    FunctionSignature(
                        name: "removeGestureRecognizer",
                        parameters: [
                            ParameterSignature(label: "_", name: "gestureRecognizer", type: "UIGestureRecognizer")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "removeLayoutGuide",
                        parameters: [
                            ParameterSignature(label: "_", name: "layoutGuide", type: "UILayoutGuide")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "removeMotionEffect",
                        parameters: [
                            ParameterSignature(label: "_", name: "effect", type: "UIMotionEffect")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "resizableSnapshotView",
                        parameters: [
                            ParameterSignature(label: "from", name: "rect", type: "CGRect"),
                            ParameterSignature(label: "afterScreenUpdates", name: "afterUpdates", type: .bool),
                            ParameterSignature(label: "withCapInsets", name: "capInsets", type: "UIEdgeInsets")
                        ],
                        returnType: .optional("UIView")
                    )
                )

            type = type
                .method(named: "safeAreaInsetsDidChange")
                .method(withSignature:
                    FunctionSignature(
                        name: "sendSubview",
                        parameters: [
                            ParameterSignature(label: "toBack", name: "view", type: "UIView")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setContentCompressionResistancePriority",
                        parameters: [
                            ParameterSignature(label: "_", name: "priority", type: "UILayoutPriority"),
                            ParameterSignature(label: "for", name: "axis", type: "UILayoutConstraintAxis")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setContentHuggingPriority",
                        parameters: [
                            ParameterSignature(label: "_", name: "priority", type: "UILayoutPriority"),
                            ParameterSignature(label: "for", name: "axis", type: "UILayoutConstraintAxis")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setNeedsDisplay",
                        parameters: [
                            ParameterSignature(label: "_", name: "rect", type: "CGRect")
                        ]
                    )
                )
                .method(named: "setNeedsDisplay")
                .method(named: "setNeedsLayout")
                .method(named: "setNeedsUpdateConstraints")
                .method(withSignature:
                    FunctionSignature(
                        name: "sizeThatFits",
                        parameters: [
                            ParameterSignature(label: "_", name: "size", type: "CGSize")
                        ],
                        returnType: "CGSize"
                    )
                )
                .method(named: "sizeToFit")
                .method(withSignature:
                    FunctionSignature(
                        name: "snapshotView",
                        parameters: [
                            ParameterSignature(label: "afterScreenUpdates", name: "afterUpdates", type: .bool)
                        ],
                        returnType: .optional("UIView")
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "systemLayoutSizeFitting",
                        parameters: [
                            ParameterSignature(label: "_", name: "targetSize", type: "CGSize"),
                            ParameterSignature(label: "withHorizontalFittingPriority", name: "horizontalFittingPriority", type: "UILayoutPriority"),
                            ParameterSignature(name: "verticalFittingPriority", type: "UILayoutPriority")
                        ],
                        returnType: "CGSize"
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "systemLayoutSizeFitting",
                        parameters: [
                            ParameterSignature(label: "_", name: "targetSize", type: "CGSize")
                        ],
                        returnType: "CGSize"
                    )
                )

            type = type
                .method(named: "tintColorDidChange")
                .method(named: "updateConstraints")
                .method(named: "updateConstraintsIfNeeded")
                .method(withSignature:
                    FunctionSignature(
                        name: "viewWithTag",
                        parameters: [
                            ParameterSignature(label: "_", name: "tag", type: .int)
                        ],
                        returnType: .optional("UIView")
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "willMove",
                        parameters: [
                            ParameterSignature(label: "toSuperview", name: "newSuperview", type: .optional("UIView"))
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "willMove",
                        parameters: [
                            ParameterSignature(label: "toWindow", name: "newWindow", type: .optional("UIWindow"))
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "willRemoveSubview",
                        parameters: [
                            ParameterSignature(label: "_", name: "subview", type: "UIView")
                        ]
                    )
                )
            
            return type.build()
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
                            ParameterSignature(label: "_", name: "dragState", type: "UITableViewCellDragState")
                        ])
                )
                .method(named: "prepareForReuse")
                .method(withSignature:
                    FunctionSignature(
                        name: "setEditing",
                        parameters: [
                            ParameterSignature(label: "_", name: "editing", type: "Bool"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ])
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setHighlighted",
                        parameters: [
                            ParameterSignature(label: "_", name: "highlighted", type: "Bool"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ])
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setSelected",
                        parameters: [
                            ParameterSignature(label: "_", name: "selected", type: "Bool"),
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
                            ParameterSignature(label: "_", name: "rect", type: "CGRect"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setContentOffset", parameters: [
                            ParameterSignature(label: "_", name: "contentOffset", type: "CGPoint"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "setZoomScale", parameters: [
                            ParameterSignature(label: "_", name: "scale", type: "CGFloat"),
                            ParameterSignature(name: "animated", type: "Bool")
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "touchesShouldBegin",
                        parameters: [
                            ParameterSignature(label: "_", name: "touches",
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
                            ParameterSignature(label: "_", name: "sections", type: "IndexSet"),
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
                            ParameterSignature(label: "_", name: "sections", type: "IndexSet"),
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
                            ParameterSignature(label: "_", name: "section", type: .int),
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
                            ParameterSignature(label: "_", name: "updates", type: .optional(.block(returnType: .void, parameters: []))),
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
                            ParameterSignature(label: "_", name: "aClass", type: .optional("AnyClass")),
                            ParameterSignature(label: "forHeaderFooterViewReuseIdentifier",
                                               name: "identifier", type: .string)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "register", parameters: [
                            ParameterSignature(label: "_", name: "cellClass", type: .optional("AnyClass")),
                            ParameterSignature(label: "forCellReuseIdentifier",
                                               name: "identifier", type: .string)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "register", parameters: [
                            ParameterSignature(label: "_", name: "nib", type: .optional("UINib")),
                            ParameterSignature(label: "forCellReuseIdentifier",
                                               name: "identifier", type: .string)
                        ]
                    )
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "register", parameters: [
                            ParameterSignature(label: "_", name: "nib", type: .optional("UINib")),
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
                            ParameterSignature(label: "_", name: "sections", type: "IndexSet"),
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
                            ParameterSignature(label: "_", name: "editing", type: .bool),
                            ParameterSignature(name: "animated", type: .bool)
                        ]
                    )
                )
                
            return type.build()
        }
    }
}
