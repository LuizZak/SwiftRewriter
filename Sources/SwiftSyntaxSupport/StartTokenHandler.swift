import SwiftSyntax

public protocol StartTokenHandler {
    func makeStartToken(_ builder: (_ leading: Trivia, _ trailing: Trivia) -> TokenSyntax) -> TokenSyntax
    func prepareStartToken(_ token: TokenSyntax) -> TokenSyntax
}

/// A handler for start tokens that adds no spacing to any token requested, acting
/// as a null operation
public class NullStartTokenHandler: StartTokenHandler {
    public init() {
        
    }
    
    public func makeStartToken(_ builder: (Trivia, Trivia) -> TokenSyntax) -> TokenSyntax {
        return builder([], [])
    }
    
    public func prepareStartToken(_ token: TokenSyntax) -> TokenSyntax {
        return token
    }
}
