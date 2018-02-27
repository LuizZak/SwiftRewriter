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

internal extension RangeReplaceableCollection where Index == Int {
    mutating func remove(where predicate: (Element) -> Bool) {
        for (i, item) in enumerated() {
            if predicate(item) {
                remove(at: i)
                return
            }
        }
    }
}
