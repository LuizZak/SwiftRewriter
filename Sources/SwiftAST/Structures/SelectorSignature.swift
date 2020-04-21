/// Represents an Objective-C selector signature, e.g. `[functionWithA:b::]`.
public struct SelectorSignature: Hashable, Codable {
    public var isStatic: Bool
    public var keywords: [String?]
    
    public init(isStatic: Bool, keywords: [String?]) {
        self.isStatic = isStatic
        self.keywords = keywords
    }
}

public extension FunctionCallPostfix {
    
    /// Generates an Objective-C selector from this function call united with
    /// a given method name.
    func selectorWith(methodName: String) -> SelectorSignature {
        let selectors: [String?]
            = [methodName] + arguments.map(\.label)
        
        return SelectorSignature(isStatic: false, keywords: selectors)
    }
}
