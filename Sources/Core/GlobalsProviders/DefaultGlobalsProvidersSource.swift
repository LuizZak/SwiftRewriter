/// Default global providers source
public class DefaultGlobalsProvidersSource: GlobalsProvidersSource {
    public var globalsProviders: [GlobalsProvider] = [
        CLibGlobalsProviders(),
        UIKitGlobalsProvider(),
        OpenGLESGlobalsProvider(),
        CompoundedMappingTypesGlobalsProvider()
    ]
    
    public init() {
        
    }
}
