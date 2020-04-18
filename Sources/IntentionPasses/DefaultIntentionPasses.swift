public struct DefaultIntentionPasses: IntentionPassSource {
    public var intentionPasses: [IntentionPass] = [
        FileTypeMergingIntentionPass(),
        SubscriptDeclarationPass(),
        PromoteProtocolPropertyConformanceIntentionPass(),
        ProtocolNullabilityPropagationToConformersIntentionPass(),
        PropertyMergeIntentionPass(),
        StoredPropertyToNominalTypesIntentionPass(),
        SwiftifyMethodSignaturesIntentionPass(),
        InitAnalysisIntentionPass(),
        ImportDirectiveIntentionPass(),
        UIKitCorrectorIntentionPass(),
        ProtocolNullabilityPropagationToConformersIntentionPass(),
        DetectNonnullReturnsIntentionPass()
    ]
    
    public init() {
        
    }
}
