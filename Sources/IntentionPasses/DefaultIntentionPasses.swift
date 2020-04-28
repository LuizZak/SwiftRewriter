public struct DefaultIntentionPasses: IntentionPassSource {
    public var intentionPasses: [IntentionPass] = [
        FileTypeMergingIntentionPass(),
        SubscriptDeclarationIntentionPass(),
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
        RemoveEmptyExtensionsIntentionPass()
    ]
    
    public init() {
        
    }
}
