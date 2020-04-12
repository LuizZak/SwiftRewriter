public struct DefaultIntentionPasses: IntentionPassSource {
    public var intentionPasses: [IntentionPass] = [
        FileTypeMergingIntentionPass(),
        PromoteProtocolPropertyConformanceIntentionPass(),
        ProtocolNullabilityPropagationToConformersIntentionPass(),
        PropertyMergeIntentionPass(),
        StoredPropertyToNominalTypesIntentionPass(),
        SwiftifyMethodSignaturesIntentionPass(),
        InitAnalysisIntentionPass(),
        ImportDirectiveIntentionPass(),
        UIKitCorrectorIntentionPass(),
        ProtocolNullabilityPropagationToConformersIntentionPass(),
        DetectNonnullReturnsIntentionPass(),
        PromoteNSMutableArrayIntentionPass()
    ]
    
    public init() {
        
    }
}
