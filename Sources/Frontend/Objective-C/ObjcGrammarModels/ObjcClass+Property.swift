import Utils
import GrammarModelBase

public class ObjcPropertyDefinitionNode: ObjcASTNode, ObjcInitializableNode, CommentedASTNodeType {
    /// Type identifier
    public var type: ObjcTypeNameNode? {
        firstChild()
    }
    
    public var attributesList: ObjcPropertyAttributesListNode? {
        firstChild()
    }

    /// Identifier for this property
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }

    // For use in protocol methods only
    public var isOptionalProperty: Bool = false

    public var hasIbOutletSpecifier: Bool = false
    public var hasIbInspectableSpecifier: Bool = false

    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcPropertyAttributesListNode: ObjcASTNode, ObjcInitializableNode {
    public var attributes: [ObjcPropertyAttributeNode] {
        childrenMatching()
    }

    public var keywordAttributes: [String] {
        attributes.compactMap { mod in
            switch mod.attribute {
            case .keyword(let kw):
                return kw
            default:
                return nil
            }
        }
    }

    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcPropertyAttributeNode: ObjcASTNode {
    public var attribute: Attribute

    public convenience init(
        name: String,
        isInNonnullContext: Bool,
        location: SourceLocation = .invalid,
        length: SourceLength = .zero
    ) {

        self.init(
            modifier: .keyword(name),
            isInNonnullContext: isInNonnullContext,
            location: location,
            length: length
        )
    }

    public convenience init(
        getter: String,
        isInNonnullContext: Bool,
        location: SourceLocation = .invalid,
        length: SourceLength = .zero
    ) {

        self.init(
            modifier: .getter(getter),
            isInNonnullContext: isInNonnullContext,
            location: location,
            length: length
        )
    }

    public convenience init(
        setter: String,
        isInNonnullContext: Bool,
        location: SourceLocation = .invalid,
        length: SourceLength = .zero
    ) {

        self.init(
            modifier: .setter(setter),
            isInNonnullContext: isInNonnullContext,
            location: location,
            length: length
        )
    }

    public init(
        modifier: Attribute,
        isInNonnullContext: Bool,
        location: SourceLocation = .invalid,
        length: SourceLength = .zero
    ) {

        self.attribute = modifier
        super.init(
            isInNonnullContext: isInNonnullContext,
            location: location,
            length: length
        )
    }

    public enum Attribute: Hashable {
        case keyword(String)
        case getter(String)
        case setter(String)
    }
}
