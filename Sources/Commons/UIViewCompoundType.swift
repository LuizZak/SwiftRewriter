import SwiftAST
import SwiftRewriterLib

// swiftlint:disable line_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length
public enum UIViewCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let annotations: AnnotationsSink = AnnotationsSink()
        var type = KnownTypeBuilder(typeName: "UIView", supertype: "UIResponder")
        let transformations = TransformationsSink(typeName: type.typeName)
        
        type.useSwiftSignatureMatching = true
        
        type = type
            // Protocol conformances
            .protocolConformances(protocolNames: [
                "NSCoding", "UIAppearance", "UIAppearanceContainer",
                "UIDynamicItem", "UITraitEnvironment", "UICoordinateSpace",
                "UIFocusItem", "CALayerDelegate"
            ])
        
        type = type
            // Static properties
            .property(named: "areAnimationsEnabled", type: .bool, isStatic: true, accessor: .getter)
            .property(named: "inheritedAnimationDuration", type: "TimeInterval", isStatic: true, accessor: .getter)
            .property(named: "layerClass", type: "AnyClass", isStatic: true, accessor: .getter)
            .property(named: "requiresConstraintBasedLayout", type: .bool, isStatic: true, accessor: .getter)
        
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
            ._createPropertyRename(from: "focused", in: transformations)
            .property(named: "isHidden", type: .bool)
            ._createPropertyRename(from: "hidden", in: transformations)
            .property(named: "isMultipleTouchEnabled", type: .bool)
            .property(named: "isOpaque", type: .bool)
            ._createPropertyRename(from: "opaque", in: transformations)
            .property(named: "isUserInteractionEnabled", type: .bool)
            ._createPropertyRename(from: "userInteractionEnabled", in: transformations)
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
            // Static methods
            .method(withSignature:
                FunctionSignature(
                    name: "addKeyframe",
                    parameters: [
                        ParameterSignature(label: "withRelativeStartTime", name: "frameStartTime", type: .double),
                        ParameterSignature(label: "relativeDuration", name: "frameDuration", type: .double),
                        ParameterSignature(name: "animations", type: .swiftBlock(returnType: .void, parameters: []))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "animate",
                    parameters: [
                        ParameterSignature(label: "withDuration", name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "animations", type: .swiftBlock(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.swiftBlock(returnType: .void, parameters: [.bool])))
                    ],
                    isStatic: true
                ).makeSignatureMapping(
                    fromMethodNamed: "animateWithDuration",
                    parameters: [
                        ParameterSignature(label: nil, name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "animations", type: .swiftBlock(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.swiftBlock(returnType: .void, parameters: [.bool])))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
            )
            .method(withSignature:
                FunctionSignature(
                    name: "animate",
                    parameters: [
                        ParameterSignature(label: "withDuration", name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "animations", type: .swiftBlock(returnType: .void, parameters: []))
                    ],
                    isStatic: true
                ).makeSignatureMapping(
                    fromMethodNamed: "animateWithDuration",
                    parameters: [
                        ParameterSignature(label: nil, name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "animations", type: .swiftBlock(returnType: .void, parameters: []))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
            )
            .method(withSignature:
                FunctionSignature(
                    name: "animate",
                    parameters: [
                        ParameterSignature(label: "withDuration", name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "delay", type: "TimeInterval"),
                        ParameterSignature(name: "options", type: "UIViewAnimationOptions"),
                        ParameterSignature(name: "animations", type: .swiftBlock(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.swiftBlock(returnType: .void, parameters: [.bool])))
                    ],
                    isStatic: true
                ).makeSignatureMapping(
                    fromMethodNamed: "animateWithDuration",
                    parameters: [
                        ParameterSignature(label: nil, name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "delay", type: "TimeInterval"),
                        ParameterSignature(name: "options", type: "UIViewAnimationOptions"),
                        ParameterSignature(name: "animations", type: .swiftBlock(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.swiftBlock(returnType: .void, parameters: [.bool])))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
            )
            .method(withSignature:
                FunctionSignature(
                    name: "animate",
                    parameters: [
                        ParameterSignature(label: "withDuration", name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "delay", type: "TimeInterval"),
                        ParameterSignature(label: "usingSpringWithDamping", name: "dampingRatio", type: .cgFloat),
                        ParameterSignature(label: "initialSpringVelocity", name: "velocity", type: .cgFloat),
                        ParameterSignature(name: "options", type: "UIViewAnimationOptions"),
                        ParameterSignature(name: "animations", type: .swiftBlock(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.swiftBlock(returnType: .void, parameters: [.bool])))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "animateKeyframes",
                    parameters: [
                        ParameterSignature(label: "withDuration", name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "delay", type: "TimeInterval"),
                        ParameterSignature(name: "options", type: "UIViewKeyframeAnimationOptions"),
                        ParameterSignature(name: "animations", type: .swiftBlock(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.swiftBlock(returnType: .void, parameters: [.bool])))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "beginAnimations",
                    parameters: [
                        ParameterSignature(label: nil, name: "animationID", type: .optional(.string)),
                        ParameterSignature(name: "context", type: .optional("UnsafeMutableRawPointer"))
                    ],
                    isStatic: true
                )
            )
            .method(named: "commitAnimations", isStatic: true)
            .method(withSignature:
                FunctionSignature(
                    name: "perform",
                    parameters: [
                        ParameterSignature(label: nil, name: "animation", type: "UISystemAnimation"),
                        ParameterSignature(label: "on", name: "views", type: .array("UIView")),
                        ParameterSignature(name: "options", type: "UIViewAnimationOptions"),
                        ParameterSignature(label: "animations", name: "parallelAnimations", type: .optional(.swiftBlock(returnType: .void, parameters: []))),
                        ParameterSignature(name: "completion", type: .optional(.swiftBlock(returnType: .void, parameters: [.bool])))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "performWithoutAnimation",
                    parameters: [
                        ParameterSignature(label: nil, name: "actionsWithoutAnimation", type: .swiftBlock(returnType: .void, parameters: []))
                    ],
                    isStatic: true
                )
            )
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationBeginsFromCurrentState",
                    parameters: [
                        ParameterSignature(label: nil, name: "fromCurrentState", type: .bool)
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationCurve",
                    parameters: [
                        ParameterSignature(label: nil, name: "curve", type: "UIViewAnimationCurve")
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationDelay",
                    parameters: [
                        ParameterSignature(label: nil, name: "delay", type: "TimeInterval")
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationDelegate",
                    parameters: [
                        ParameterSignature(label: nil, name: "delegate", type: .optional(.any))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationDidStop",
                    parameters: [
                        ParameterSignature(label: nil, name: "selector", type: .optional("Selector"))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationDuration",
                    parameters: [
                        ParameterSignature(label: nil, name: "duration", type: "TimeInterval")
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationRepeatAutoreverses",
                    parameters: [
                        ParameterSignature(label: nil, name: "repeatAutoreverses", type: .bool)
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationRepeatCount",
                    parameters: [
                        ParameterSignature(label: nil, name: "repeatCount", type: .float)
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationsEnabled",
                    parameters: [
                        ParameterSignature(label: nil, name: "enabled", type: .bool)
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationStart",
                    parameters: [
                        ParameterSignature(label: nil, name: "startDate", type: "Date")
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationTransition",
                    parameters: [
                        ParameterSignature(label: nil, name: "transition", type: "UIViewAnimationTransition"),
                        ParameterSignature(label: "for", name: "view", type: "UIView"),
                        ParameterSignature(name: "cache", type: .bool)
                    ],
                    isStatic: true
                )
            )
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    name: "setAnimationWillStart",
                    parameters: [
                        ParameterSignature(label: nil, name: "selector", type: .optional("Selector"))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "transition",
                    parameters: [
                        ParameterSignature(label: "from", name: "fromView", type: "UIView"),
                        ParameterSignature(label: "to", name: "toView", type: "UIView"),
                        ParameterSignature(name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "options", type: "UIViewAnimationOptions"),
                        ParameterSignature(name: "completion", type: .optional(.swiftBlock(returnType: .void, parameters: [.bool])))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "transition",
                    parameters: [
                        ParameterSignature(label: "with", name: "view", type: "UIView"),
                        ParameterSignature(name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "options", type: "UIViewAnimationOptions"),
                        ParameterSignature(name: "animations", type: .optional(.swiftBlock(returnType: .void, parameters: []))),
                        ParameterSignature(name: "completion", type: .optional(.swiftBlock(returnType: .void, parameters: [.bool])))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "userInterfaceLayoutDirection",
                    parameters: [
                        ParameterSignature(label: "for", name: "attribute", type: "UISemanticContentAttribute")
                    ],
                    returnType: "UIUserInterfaceLayoutDirection",
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "userInterfaceLayoutDirection",
                    parameters: [
                        ParameterSignature(label: "for", name: "semanticContentAttribute", type: "UISemanticContentAttribute"),
                        ParameterSignature(label: "relativeTo", name: "layoutDirection", type: "UIUserInterfaceLayoutDirection")
                    ],
                    returnType: "UIUserInterfaceLayoutDirection",
                    isStatic: true
                )
            )
        
        type = type
            // Methods
            .method(withSignature:
                FunctionSignature(signatureString:
                    "addConstraint(_ constraint: NSLayoutConstraint)"
                )
            )
            .method(withSignature:
                FunctionSignature(signatureString:
                    "addConstraints(_ constraints: [NSLayoutConstraint])"
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "addGestureRecognizer",
                    parameters: [
                        ParameterSignature(label: nil, name: "gestureRecognizer", type: "UIGestureRecognizer")
                    ]
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "addLayoutGuide",
                    parameters: [
                        ParameterSignature(label: nil, name: "layoutGuide", type: "UILayoutGuide")
                    ]
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "addMotionEffect",
                    parameters: [
                        ParameterSignature(label: nil, name: "effect", type: "UIMotionEffect")
                    ]
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "addSubview",
                    parameters: [
                        ParameterSignature(label: nil, name: "view", type: "UIView")
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
                FunctionSignature(signatureString:
                    "bringSubview(toFront view: UIView)"
                ).makeSignatureMapping(
                    fromSignature: "bringSubviewToFront(_ view: UIView)",
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
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
                FunctionSignature(signatureString:
                    "convert(_ point: CGPoint, from view: UIView?) -> CGPoint"
                ).makeSignatureMapping(
                    fromSignature:
                    "convertPoint(_ point: CGPoint, fromView view: UIView?) -> CGPoint",
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
            )
            .method(withSignature:
                FunctionSignature(signatureString:
                    "convert(_ point: CGPoint, to view: UIView?) -> CGPoint"
                ).makeSignatureMapping(
                    fromSignature:
                    "convertPoint(_ point: CGPoint, toView view: UIView?) -> CGPoint",
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
            )
            .method(withSignature:
                FunctionSignature(signatureString:
                    "convert(_ rect: CGRect, from view: UIView?) -> CGRect"
                ).makeSignatureMapping(
                    fromSignature:
                    "convertRect(_ rect: CGRect, fromView view: UIView?) -> CGRect",
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
            )
            .method(withSignature:
                FunctionSignature(signatureString:
                    "convert(_ rect: CGRect, to view: UIView?) -> CGRect"
                ).makeSignatureMapping(
                    fromSignature:
                    "convertRect(_ rect: CGRect, toView view: UIView?) -> CGRect",
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
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
                        ParameterSignature(label: nil, name: "subview", type: "UIView")
                    ]
                )
            )
            .method(named: "didMoveToSuperview")
            .method(named: "didMoveToWindow")
            .method(withSignature:
                FunctionSignature(signatureString:
                    "draw(_ rect: CGRect)"
                ).makeSignatureMapping(
                    fromMethodNamed: "drawRect",
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
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
                        ParameterSignature(label: nil, name: "gestureRecognizer", type: "UIGestureRecognizer")
                    ],
                    returnType: .bool
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "hitTest",
                    parameters: [
                        ParameterSignature(label: nil, name: "point", type: "CGPoint"),
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
                        ParameterSignature(label: nil, name: "view", type: "UIView"),
                        ParameterSignature(label: "aboveSubview", name: "siblingSubview", type: "UIView")
                    ]
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "insertSubview",
                    parameters: [
                        ParameterSignature(label: nil, name: "view", type: "UIView"),
                        ParameterSignature(label: "at", name: "index", type: .int)
                    ]
                ).makeSignatureMapping(fromMethodNamed: "insertSubview",
                    parameters: [
                        ParameterSignature(label: nil, name: "view", type: "UIView"),
                        ParameterSignature(label: "atIndex", name: "index", type: .int)
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
            )
            .method(withSignature:
                FunctionSignature(
                    name: "insertSubview",
                    parameters: [
                        ParameterSignature(label: nil, name: "view", type: "UIView"),
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
                        ParameterSignature(label: nil, name: "constraint", type: "NSLayoutConstraint")
                    ]
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "removeConstraints",
                    parameters: [
                        ParameterSignature(label: nil, name: "constraints", type: .array("NSLayoutConstraint"))
                    ]
                )
            )
            .method(named: "removeFromSuperview")
            .method(withSignature:
                FunctionSignature(
                    name: "removeGestureRecognizer",
                    parameters: [
                        ParameterSignature(label: nil, name: "gestureRecognizer", type: "UIGestureRecognizer")
                    ]
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "removeLayoutGuide",
                    parameters: [
                        ParameterSignature(label: nil, name: "layoutGuide", type: "UILayoutGuide")
                    ]
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "removeMotionEffect",
                    parameters: [
                        ParameterSignature(label: nil, name: "effect", type: "UIMotionEffect")
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
                        ParameterSignature(label: nil, name: "priority", type: "UILayoutPriority"),
                        ParameterSignature(label: "for", name: "axis", type: "UILayoutConstraintAxis")
                    ]
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setContentHuggingPriority",
                    parameters: [
                        ParameterSignature(label: nil, name: "priority", type: "UILayoutPriority"),
                        ParameterSignature(label: "for", name: "axis", type: "UILayoutConstraintAxis")
                    ]
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "setNeedsDisplay",
                    parameters: [
                        ParameterSignature(label: nil, name: "rect", type: "CGRect")
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
                        ParameterSignature(label: nil, name: "size", type: "CGSize")
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
                        ParameterSignature(label: nil, name: "targetSize", type: "CGSize"),
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
                        ParameterSignature(label: nil, name: "targetSize", type: "CGSize")
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
                        ParameterSignature(label: nil, name: "tag", type: .int)
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
                        ParameterSignature(label: nil, name: "subview", type: "UIView")
                    ]
                )
            )
        
        return
            CompoundedMappingType(knownType: type.build(),
                                  transformations: transformations.transformations)
    }
    
    func typeString() -> String {
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
                
                @_swiftrewriter(mapFrom: animateWithDuration(_:animations:completion:))
                static func animate(withDuration duration: TimeInterval, animations: () -> Void, completion: ((Bool) -> Void)?)
                
                @_swiftrewriter(mapFrom: animateWithDuration(_:animations:))
                static func animate(withDuration duration: TimeInterval, animations: () -> Void)
                
                @_swiftrewriter(mapFrom: animateWithDuration(_:delay:options:animations:completion:))
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
                
                // Convert from bringSubviewToFront(_ view: UIView)
                func bringSubview(toFront view: UIView)
                func constraintsAffectingLayout(for axis: UILayoutConstraintAxis) -> [NSLayoutConstraint]
                func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority
                func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority
                
                // Convert from convertPoint(_ point: CGPoint, fromView view: UIView?) -> CGPoint
                func convert(_ point: CGPoint, from view: UIView?) -> CGPoint
                
                // Convert from convertPoint(_ point: CGPoint, toView view: UIView?) -> CGPoint
                func convert(_ point: CGPoint, to view: UIView?) -> CGPoint
                
                // Convert from convertRect(_ rect: CGRect, fromView view: UIView?) -> CGRect
                func convert(_ rect: CGRect, from view: UIView?) -> CGRect
                
                // Convert from convertRect(_ rect: CGRect, toView view: UIView?) -> CGRect
                func convert(_ rect: CGRect, to view: UIView?) -> CGRect
                func decodeRestorableState(with coder: NSCoder)
                func didAddSubview(_ subview: UIView)
                func didMoveToSuperview()
                func didMoveToWindow()
                
                // Convert from drawRect(_ rect: CGRect)
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
                
                // Convert from insertSubview(_ view: UIView, atIndex index: Int)
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
            """
        
        return string
    }
}

extension FunctionSignature {
    
    func toBinaryOperation(op: SwiftOperator,
                           in transformsSink: TransformationsSink,
                           annotations: AnnotationsSink) -> FunctionSignature {
        
        let typeName = transformsSink.typeName
        
        assert(parameters.count == 1, """
            Trying to create a binary operator mapping with a function call that \
            does not have exactly one parameter?
            Binary operation mapping requires two parameters (the base type
            """)
        
        let transformer = ValueTransformer<PostfixExpression, Expression> { $0 }
            // Flatten expressions (breaks postfix expressions into sub-expressions)
            .decompose()
            .validate { $0.count == 2 }
            // Verify first expression is a member access to the type we expect
            .transformIndex(
                index: 0,
                transformer: ValueTransformer()
                    .validate(matcher: ValueMatcher()
                        .keyPath(\.asPostfix, .isMemberAccess(forMember: name))
                        .keyPath(\.resolvedType, equals: swiftClosureType)
                    )
                    .removingMemberAccess()
                    .validate(matcher: ValueMatcher()
                        .isTyped(.typeName(typeName), ignoringNullability: true)
                    )
            )
            // Re-shape it into a binary expression
            .asBinaryExpression(operator: .equals)
        
        transformsSink.addValueTransformer(transformer)
        
        let attributeParam =
            SwiftClassInterfaceParser.SwiftRewriterAttribute.Content.mapToBinaryOperator(op)
        
        let attribute =
            KnownAttribute(name: SwiftClassInterfaceParser.SwiftRewriterAttribute.name,
                           parameters: attributeParam.asString)
        
        annotations.addAttribute(attribute, newTag: AnyEquatable(self))
        
        return self
    }
    
    func makeSignatureMapping(fromMethodNamed name: String,
                              in transformsSink: TransformationsSink,
                              annotations: AnnotationsSink) -> FunctionSignature {
        
        let signature =
            FunctionSignature(name: name,
                              parameters: parameters,
                              returnType: returnType,
                              isStatic: isStatic)
        
        return makeSignatureMapping(from: signature,
                                    in: transformsSink,
                                    annotations: annotations)
        
    }
    
    func makeSignatureMapping(fromMethodNamed name: String,
                              parameters: String,
                              returnType: SwiftType = .void,
                              in transformsSink: TransformationsSink,
                              annotations: AnnotationsSink) -> FunctionSignature {
        
        let params = try! FunctionSignatureParser.parseParameters(from: parameters)
        
        let signature =
            FunctionSignature(name: name,
                              parameters: params,
                              returnType: returnType,
                              isStatic: isStatic)
        
        return makeSignatureMapping(from: signature,
                                    in: transformsSink,
                                    annotations: annotations)
    }
    
    func makeSignatureMapping(fromSignature signature: String,
                              in transformsSink: TransformationsSink,
                              annotations: AnnotationsSink) -> FunctionSignature {
        
        var signature = try! FunctionSignatureParser.parseSignature(from: signature)
        signature.isStatic = isStatic
        
        return makeSignatureMapping(from: signature,
                                    in: transformsSink,
                                    annotations: annotations)
    }
    
    func makeSignatureMapping(fromMethodNamed name: String,
                              parameters: [ParameterSignature],
                              returnType: SwiftType? = nil,
                              in transformsSink: TransformationsSink,
                              annotations: AnnotationsSink) -> FunctionSignature {
        
        let signature =
            FunctionSignature(name: name,
                              parameters: parameters,
                              returnType: returnType ?? self.returnType,
                              isStatic: isStatic)
        
        return makeSignatureMapping(from: signature,
                                    in: transformsSink,
                                    annotations: annotations)
    }
    
    func makeSignatureMapping(from signature: FunctionSignature,
                              in transformsSink: TransformationsSink,
                              annotations: AnnotationsSink) -> FunctionSignature {
        
        let builder = MethodInvocationRewriterBuilder()
        
        builder.renaming(to: name)
        builder.returnType(returnType)
        
        for param in parameters {
            if let label = param.label {
                builder.addingArgument(strategy: .labeled(label, .asIs),
                                       type: param.type)
            } else {
                builder.addingArgument(strategy: .asIs,
                                       type: param.type)
            }
        }
        
        transformsSink.addMethodTransform(identifier: signature.asIdentifier,
                                          isStatic: signature.isStatic,
                                          transformer: builder.build())
        
        let attributeParam =
            SwiftClassInterfaceParser.SwiftRewriterAttribute.Content.mapFrom(signature).asString
        
        let attribute =
            KnownAttribute(name: SwiftClassInterfaceParser.SwiftRewriterAttribute.name,
                           parameters: attributeParam)
        
        annotations.addAttribute(attribute, newTag: AnyEquatable(self))
        
        return self
    }
    
    func makeSignatureMapping(from signature: FunctionSignature,
                              arguments: [ArgumentRewritingStrategy],
                              in transformsSink: TransformationsSink,
                              annotations: AnnotationsSink) -> FunctionSignature {
        
        let builder = MethodInvocationRewriterBuilder()
        
        builder.renaming(to: name)
        builder.returnType(returnType)
        
        for (param, type) in zip(arguments, parameters.map { $0.type }) {
            builder.addingArgument(strategy: param, type: type)
        }
        
        transformsSink.addMethodTransform(identifier: signature.asIdentifier,
                                          isStatic: signature.isStatic,
                                          transformer: builder.build())
        
        let attributeParam =
            SwiftClassInterfaceParser.SwiftRewriterAttribute.Content.mapFrom(signature).asString
        
        let attribute =
            KnownAttribute(name: SwiftClassInterfaceParser.SwiftRewriterAttribute.name,
                           parameters: attributeParam)
        
        annotations.addAttribute(attribute, newTag: AnyEquatable(self))
        
        return self
    }
}

struct AnyEquatable: Equatable {
    var object: Any
    var equate: (Any) -> Bool
    
    init<E: Equatable>(_ object: E) {
        self.object = object
        equate = {
            $0 as? E == object
        }
    }
    
    static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.equate(rhs.object)
    }
}

class AnnotationsSink {
    /// Tag used to detect when to flush and reset annotations.
    var tag: AnyEquatable?
    var attributes: [KnownAttribute] = []
    private var annotations: [String] = []
    
    private func _verifyTag(_ newTag: AnyEquatable) {
        if tag != newTag {
            tag = newTag
            attributes.removeAll()
            annotations.removeAll()
        }
    }
    
    func addAttribute(_ attribute: KnownAttribute, newTag: AnyEquatable) {
        _verifyTag(newTag)
        
        attributes.append(attribute)
    }
    
    func addAnnotation(_ annotation: String, newTag: AnyEquatable) {
        _verifyTag(newTag)
        
        annotations.append(annotation)
    }
}

/// Collects expression transformations created during type creation
class TransformationsSink {
    var typeName: String
    
    private var propertyRenames: [(old: String, new: String)] = []
    private var mappings: [MethodInvocationTransformerMatcher] = []
    private var postfixTransformations: [PostfixTransformation] = []
    private var valueTransformers: [ValueTransformer<PostfixExpression, Expression>] = []
    
    var transformations: [PostfixTransformation] {
        return
            propertyRenames.map(PostfixTransformation.property)
                + mappings.map(PostfixTransformation.method)
                + postfixTransformations
                + valueTransformers.map(PostfixTransformation.valueTransformer)
    }
    
    init(typeName: String) {
        self.typeName = typeName
    }
    
    func addPropertyRenaming(old: String, new: String) {
        propertyRenames.append((old, new))
    }
    
    func addInitTransform(from old: [ParameterSignature], to new: [ParameterSignature]) {
        postfixTransformations.append(.initializer(old: old, new: new))
    }
    
    func addMethodTransform(identifier: FunctionIdentifier,
                            isStatic: Bool,
                            transformer: MethodInvocationRewriter) {
        
        let matcher =
            MethodInvocationTransformerMatcher(
                identifier: identifier,
                isStatic: isStatic,
                transformer: transformer)
        
        mappings.append(matcher)
    }
    
    func addPropertyFromMethods(property: String,
                                getter: String,
                                setter: String?,
                                propertyType: SwiftType,
                                isStatic: Bool) {
        
        postfixTransformations.append(
            .propertyFromMethods(property: property,
                                 getterName: getter,
                                 setterName: setter,
                                 resultType: propertyType,
                                 isStatic: isStatic)
        )
    }
    
    func addValueTransformer<T: Expression>(_ transformer: ValueTransformer<PostfixExpression, T>) {
        valueTransformers.append(transformer.anyExpression())
    }
}

extension FunctionSignature {
    init(isStatic: Bool = false, signatureString: String) {
        self = try! FunctionSignatureParser.parseSignature(from: signatureString)
        self.isStatic = isStatic
    }
}

extension Array where Element == ParameterSignature {
    init(parsingParameters parametersString: String) {
        self = try! FunctionSignatureParser.parseParameters(from: parametersString)
    }
}
