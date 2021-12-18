public struct SwiftRewriterAttribute {
    public static let name = "_swiftrewriter"
    
    public var content: Content
    
    public init(content: Content) {
        self.content = content
    }
    
    public enum Content {
        case mapFrom(FunctionSignature)
        case mapFromIdentifier(FunctionIdentifier)
        case initFromFunction(FunctionIdentifier)
        case mapToBinaryOperator(SwiftOperator)
        case renameFrom(String)
        
        public var asString: String {
            switch self {
            case .mapFrom(let signature):
                return
                    "mapFrom: " +
                        TypeFormatter.asString(signature: signature,
                                               includeName: true,
                                               includeFuncKeyword: false,
                                               includeStatic: false)
                
            case .mapFromIdentifier(let identifier):
                return "mapFrom: \(identifier.description)"
                
            case .mapToBinaryOperator(let op):
                return "mapToBinary: \(op)"
                
            case .initFromFunction(let identifier):
                return "initFromFunction: \(identifier.description)"
                
            case .renameFrom(let name):
                return "renameFrom: \(name)"
            }
        }
    }
}
