public struct UnknownASTContext: CustomStringConvertible, Equatable, CustomReflectable {
    public var description: String {
        return context.description
    }
    
    public var context: CustomStringConvertible
    
    public var customMirror: Mirror {
        return Mirror(reflecting: "")
    }
    
    public init(context: CustomStringConvertible) {
        self.context = context
    }
    
    public static func ==(lhs: UnknownASTContext, rhs: UnknownASTContext) -> Bool {
        return true
    }
}
