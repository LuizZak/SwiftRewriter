/// A class-scoped property declaration.
public class JsClassPropertyNode: JsASTNode, JsInitializableNode {
    /// The identifier for this property.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    /// The initial expression for this property declaration.
    public var expression: JsExpressionNode? {
        firstChild()
    }

    public var attributes: Attributes = Attributes()

    public required init() {
        super.init()
    }

    public struct Attributes: OptionSet {
        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let isPrivate = Attributes(rawValue: 0b000_0001)
    }
}
