import SwiftRewriterLib

/// Default global providers source
public class DefaultGlobalsProvidersSource: GlobalsProvidersSource {
    public var globalsProviders: [GlobalsProvider] = [
        CLibGlobalsProviders(),
        CoreGraphicsGlobalsProvider(),
        UIKitGlobalsProvider(),
        OpenGLESGlobalsProvider(),
        CompoundedMappingTypesGlobalsProvider()
    ]
    
    public init() {
        
    }
}
