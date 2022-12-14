import Intentions
import GrammarModelBase
import ObjcGrammarModels
import SwiftAST

// MARK: - SerializableMetadata extensions
private let _originalObjcTypeKey = "originalObjcType"

public extension SerializableMetadata {
    var originalObjcType: ObjcType? {
        get {
            return self.getValue(forKey: _originalObjcTypeKey)
        }
        set {
            if let newValue = newValue {
                self.updateValue(newValue, type: SerializableMetadataEntry.type_objcType, forKey: _originalObjcTypeKey)
            } else {
                self.removeValue(forKey: _originalObjcTypeKey)
            }
        }
    }
}

public extension SerializableMetadataEntry {
    static var type_objcType: String = "ObjcType"
}

// MARK: - Intention extensions

public extension TypealiasIntention {
    var originalObjcType: ObjcType? {
        get {
            return metadata.originalObjcType
        }
        set {
            metadata.originalObjcType = newValue
        }
    }

    convenience init(
        originalObjcType: ObjcType,
        fromType: SwiftType,
        named: String,
        accessLevel: AccessLevel = .internal,
        source: ASTNode? = nil
    ) {
        self.init(fromType: fromType, named: named, accessLevel: accessLevel, source: source)

        self.originalObjcType = originalObjcType
    }
}
