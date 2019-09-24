public struct UnknownASTContext: CustomStringConvertible {
    public var description: String {
        context
    }
    
    public var context: String
    
    public init(context: CustomStringConvertible) {
        self.context = context.description
    }
}
