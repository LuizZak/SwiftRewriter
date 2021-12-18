import SwiftSyntaxSupport

public class DefaultSyntaxPassProvider: SwiftSyntaxRewriterPassProvider {
    public let passes: [SwiftSyntaxRewriterPass] = [
        StatementSpacingSyntaxPass()
    ]
    
    public init() {
        
    }
}
