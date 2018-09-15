import SwiftAST
import SwiftRewriterLib

// swiftlint:disable line_length
// s wiftlint:disable type_body_length
// s wiftlint:disable function_body_length
public enum UIViewCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let string = typeString()
        
        do {
            let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: string)
            let type = try incomplete.toCompoundedKnownType()
            
            return type
        } catch {
            fatalError(
                "Found error while parsing UIView class interface: \(error)"
            )
        }
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
            Binary operation mapping requires two parameters (the base type and
            first argument type)
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
            .asBinaryExpression(operator: op)
        
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
        
        let builder = MethodInvocationRewriterBuilder(mappingTo: self)
        
        transformsSink.addMethodTransform(identifier: signature.asIdentifier,
                                          isStatic: signature.isStatic,
                                          transformer: builder.build())
        
        let attributeParam: SwiftClassInterfaceParser.SwiftRewriterAttribute.Content
        
        if signature.returnType == returnType
            && signature.parameters.map({ $0.type }) == parameters.map({ $0.type }) {
            
            attributeParam = .mapFromIdentifier(signature.asIdentifier)
        } else {
            attributeParam = .mapFrom(signature)
        }
        
        let attribute =
            KnownAttribute(name: SwiftClassInterfaceParser.SwiftRewriterAttribute.name,
                           parameters: attributeParam.asString)
        
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
        
        let attributeParam: SwiftClassInterfaceParser.SwiftRewriterAttribute.Content
        
        if signature.returnType == returnType
            && signature.parameters.map({ $0.type }) == parameters.map({ $0.type }) {
            
            attributeParam = .mapFromIdentifier(signature.asIdentifier)
        } else {
            attributeParam = .mapFrom(signature)
        }
        
        let attribute =
            KnownAttribute(name: SwiftClassInterfaceParser.SwiftRewriterAttribute.name,
                           parameters: attributeParam.asString)
        
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
        postfixTransformations.append(.initializer(old: old.argumentLabels(),
                                                   new: new.argumentLabels()))
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
