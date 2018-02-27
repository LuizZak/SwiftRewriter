import GrammarModels
import Foundation
import Utils
import SwiftRewriterLib

public struct DefaultIntentionPasses: IntentionPassSource {
    public var intentionPasses: [IntentionPass] = [
        FileTypeMergingIntentionPass(),
        RemoveDuplicatedTypeIntentIntentionPass(),
        StoredPropertyToNominalTypesIntentionPass(),
        ProtocolNullabilityPropagationToConformersIntentionPass(),
        PropertyMergeIntentionPass(),
        SwiftifyMethodSignaturesIntentionPass()
    ]
    
    public init() {
        
    }
}
