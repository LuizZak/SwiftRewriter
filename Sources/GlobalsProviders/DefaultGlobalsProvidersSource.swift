import SwiftRewriterLib

/// Default global providers source
public class DefaultGlobalsProvidersSource: GlobalsProvidersSource {
    public var globalsProviders: [GlobalsProvider] = [
        CLibGlobalsProviders()
    ]
    
    public init() {
        
    }
}
