public struct UnknownASTContext: CustomStringConvertible {
    public var description: String {
        return context
    }
    
    public var context: String
    
    public init(context: CustomStringConvertible) {
        self.context = context.description
    }
}
