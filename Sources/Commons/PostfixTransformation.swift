/// Represents a transformation of a postfix invocation for types or instances of
/// a type.
public enum PostfixTransformation {
    case method(SignatureMapper)
    case property(old: String, new: String)
    
    public var signatureMapping: SignatureMapper? {
        switch self {
        case .method(let mapper):
            return mapper
        default:
            return nil
        }
    }
    
    public var propertyMapping: (old: String, new: String)? {
        switch self {
        case .property(let tuple):
            return tuple
        default:
            return nil
        }
    }
}
