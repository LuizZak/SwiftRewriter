import SwiftAST
import SwiftRewriterLib

// swiftlint:disable line_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length
public enum UIViewCompoundType {
    private static var singleton: CompoundedMappingType = {
        let typeAndMappings = createType()
        
        return CompoundedMappingType(knownType: typeAndMappings.0,
                                     transformations: typeAndMappings.1)
    }()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> (KnownType, [PostfixTransformation]) {
        let transformations = TransformationsSink()
        let annotations: AnnotationsSink = AnnotationsSink()
        var type = KnownTypeBuilder(typeName: "UIView", supertype: "UIResponder")
        
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
            // Static methods
            .method(withSignature:
                FunctionSignature(
                    name: "addKeyframe",
                    parameters: [
                        ParameterSignature(label: "withRelativeStartTime", name: "frameStartTime", type: .double),
                        ParameterSignature(label: "relativeDuration", name: "frameDuration", type: .double),
                        ParameterSignature(name: "animations", type: .block(returnType: .void, parameters: []))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "animate",
                    parameters: [
                        ParameterSignature(label: "withDuration", name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "animations", type: .block(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.block(returnType: .void, parameters: [.bool])))
                    ],
                    isStatic: true
                ).makeSignatureMapping(
                    fromMethodNamed: "animateWithDuration",
                    parameters: [
                        ParameterSignature(label: nil, name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "animations", type: .block(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.block(returnType: .void, parameters: [.bool])))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
            .method(withSignature:
                FunctionSignature(
                    name: "animate",
                    parameters: [
                        ParameterSignature(label: "withDuration", name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "animations", type: .block(returnType: .void, parameters: []))
                    ],
                    isStatic: true
                ).makeSignatureMapping(
                    fromMethodNamed: "animateWithDuration",
                    parameters: [
                        ParameterSignature(label: nil, name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "animations", type: .block(returnType: .void, parameters: []))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
            .method(withSignature:
                FunctionSignature(
                    name: "animate",
                    parameters: [
                        ParameterSignature(label: "withDuration", name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "delay", type: "TimeInterval"),
                        ParameterSignature(name: "options", type: "UIViewAnimationOptions"),
                        ParameterSignature(name: "animations", type: .block(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.block(returnType: .void, parameters: [.bool])))
                    ],
                    isStatic: true
                ).makeSignatureMapping(
                    fromMethodNamed: "animateWithDuration",
                    parameters: [
                        ParameterSignature(label: nil, name: "duration", type: "TimeInterval"),
                        ParameterSignature(name: "delay", type: "TimeInterval"),
                        ParameterSignature(name: "options", type: "UIViewAnimationOptions"),
                        ParameterSignature(name: "animations", type: .block(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.block(returnType: .void, parameters: [.bool])))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
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
                        ParameterSignature(name: "animations", type: .block(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.block(returnType: .void, parameters: [.bool])))
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
                        ParameterSignature(name: "animations", type: .block(returnType: .void, parameters: [])),
                        ParameterSignature(name: "completion", type: .optional(.block(returnType: .void, parameters: [.bool])))
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
                        ParameterSignature(label: "animations", name: "parallelAnimations", type: .optional(.block(returnType: .void, parameters: []))),
                        ParameterSignature(name: "completion", type: .optional(.block(returnType: .void, parameters: [.bool])))
                    ],
                    isStatic: true
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "performWithoutAnimation",
                    parameters: [
                        ParameterSignature(label: nil, name: "actionsWithoutAnimation", type: .block(returnType: .void, parameters: []))
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
                        ParameterSignature(name: "completion", type: .optional(.block(returnType: .void, parameters: [.bool])))
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
                        ParameterSignature(name: "animations", type: .optional(.block(returnType: .void, parameters: []))),
                        ParameterSignature(name: "completion", type: .optional(.block(returnType: .void, parameters: [.bool])))
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
                FunctionSignature(
                    name: "addConstraint",
                    parameters: [
                        ParameterSignature(label: nil, name: "constraint", type: "NSLayoutConstraint")
                    ]
                )
            )
            .method(withSignature:
                FunctionSignature(
                    name: "addConstraints",
                    parameters: [
                        ParameterSignature(label: nil, name: "constraints", type: .array("NSLayoutConstraint"))
                    ]
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
                FunctionSignature(
                    name: "bringSubview",
                    parameters: [
                        ParameterSignature(label: "toFront", name: "view", type: "UIView")
                    ]
                ).makeSignatureMapping(
                    fromMethodNamed: "bringSubviewToFront",
                    parameters: [
                        ParameterSignature(label: nil, name: "view", type: "UIView")
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
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
                        ParameterSignature(label: nil, name: "point", type: "CGPoint"),
                        ParameterSignature(label: "from", name: "view", type: .optional("UIView"))
                    ],
                    returnType: "CGPoint"
                ).makeSignatureMapping(
                    fromMethodNamed: "convertPoint",
                    parameters: [
                        ParameterSignature(label: nil, name: "point", type: "CGPoint"),
                        ParameterSignature(label: "fromView", name: "view", type: .optional("UIView"))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
            .method(withSignature:
                FunctionSignature(
                    name: "convert",
                    parameters: [
                        ParameterSignature(label: nil, name: "point", type: "CGPoint"),
                        ParameterSignature(label: "to", name: "view", type: .optional("UIView"))
                    ],
                    returnType: "CGPoint"
                ).makeSignatureMapping(
                    fromMethodNamed: "convertPoint",
                    parameters: [
                        ParameterSignature(label: nil, name: "point", type: "CGPoint"),
                        ParameterSignature(label: "toView", name: "view", type: .optional("UIView"))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
            .method(withSignature:
                FunctionSignature(
                    name: "convert",
                    parameters: [
                        ParameterSignature(label: nil, name: "rect", type: "CGRect"),
                        ParameterSignature(label: "from", name: "view", type: .optional("UIView"))
                    ],
                    returnType: "CGRect"
                ).makeSignatureMapping(
                    fromMethodNamed: "convertRect",
                    parameters: [
                        ParameterSignature(label: nil, name: "rect", type: "CGRect"),
                        ParameterSignature(label: "fromView", name: "view", type: .optional("UIView"))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
            .method(withSignature:
                FunctionSignature(
                    name: "convert",
                    parameters: [
                        ParameterSignature(label: nil, name: "rect", type: "CGRect"),
                        ParameterSignature(label: "to", name: "view", type: .optional("UIView"))
                    ],
                    returnType: "CGRect"
                ).makeSignatureMapping(
                    fromMethodNamed: "convertRect",
                    parameters: [
                        ParameterSignature(label: nil, name: "rect", type: "CGRect"),
                        ParameterSignature(label: "toView", name: "view", type: .optional("UIView"))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
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
                FunctionSignature(
                    name: "draw",
                    parameters: [
                        ParameterSignature(label: nil, name: "rect", type: "CGRect")
                    ]
                ).makeSignatureMapping(
                    fromMethodNamed: "drawRect",
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
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
                    annotations: annotations.annotations
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
        
        return (type.build(), transformations.transformations)
    }
}

extension FunctionSignature {
    
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
        
        let params
            = try! FunctionSignatureParser.parseParameters(from: parameters)
        
        let signature =
            FunctionSignature(name: name,
                              parameters: params,
                              returnType: returnType,
                              isStatic: isStatic)
        
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
        
        let annotation =
        "Convert from \(TypeFormatter.asString(signature: signature, includeName: true))"
        
        annotations.addAnnotation(annotation, newTag: AnyEquatable(self))
        
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
        
        let annotation =
            "Convert from \(TypeFormatter.asString(signature: signature, includeName: true))"
        
        annotations.addAnnotation(annotation, newTag: AnyEquatable(self))
        
        return self
    }
    
    func makeSignatureMapping(from signature: FunctionSignature,
                              argumentGenerators: [SignatureMapper.ArgumentGenerator],
                              in transformsSink: TransformationsSink,
                              annotations: AnnotationsSink) -> FunctionSignature {
        
        let builder = MethodInvocationRewriterBuilder()
        
        builder.renaming(to: name)
        builder.returnType(returnType)
        
        for param in argumentGenerators {
            builder.addingArgument(strategy: param.argumentStrategy, type: param.type)
        }
        
        transformsSink.addMethodTransform(identifier: signature.asIdentifier,
                                          isStatic: signature.isStatic,
                                          transformer: builder.build())
        
        let annotation =
            "Convert from \(TypeFormatter.asString(signature: signature, includeName: true))"
        
        annotations.addAnnotation(annotation, newTag: AnyEquatable(self))
        
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
    var annotations: [String] = []
    
    func addAnnotation(_ annotation: String, newTag: AnyEquatable) {
        if tag != newTag {
            tag = newTag
            annotations.removeAll()
        }
        
        annotations.append(annotation)
    }
}

/// Collects expression transformations created during type creation
class TransformationsSink {
    private var propertyRenames: [(old: String, new: String)] = []
    private var mappings: [MethodInvocationTransformerMatcher] = []
    private var postfixTransformations: [PostfixTransformation] = []
    
    var transformations: [PostfixTransformation] {
        return propertyRenames.map { .property(old: $0.old, new: $0.new) }
            + mappings.map { .method($0) } + postfixTransformations
    }
    
    func addPropertyRenaming(old: String, new: String) {
        propertyRenames.append((old, new))
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
    
    func addPropertyFromMethods(property: String, getter: String, setter: String?) {
        postfixTransformations.append(
            .propertyFromMethods(property: property,
                                 getterName: getter,
                                 setterName: setter)
        )
    }
}
