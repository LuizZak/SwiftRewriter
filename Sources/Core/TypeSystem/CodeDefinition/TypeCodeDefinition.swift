/// A code definition that refers to a type of matching name
public class TypeCodeDefinition: CodeDefinition {
    public override func isEqual(to other: CodeDefinition) -> Bool {
        switch other {
        case let other as TypeCodeDefinition:
            return isEqual(to: other)
        default:
            return super.isEqual(to: other)
        }
    }

    public func isEqual(to other: TypeCodeDefinition) -> Bool {
        name == other.name
    }
}

public extension CodeDefinition {
    static func forType(named name: String) -> TypeCodeDefinition {
        TypeCodeDefinition(
            constantNamed: name,
            type: .metatype(for: .typeName(name))
        )
    }
}
