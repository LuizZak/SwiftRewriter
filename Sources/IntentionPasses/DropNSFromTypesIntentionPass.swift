import SwiftRewriterLib
import SwiftAST

/// Drops 'NS'-prefix from all type signatures when an available Swift version
/// of the appropriate type is present, e.g. `NSDate` -> `Date`, `NSData` ->
/// `Data`, etc.
public class DropNSFromTypesIntentionPass: IntentionPass {
    private static let _mappings: [String: String] = [
        "NSData": "Data",
        "NSDate": "Date"
    ]
    
    private var context: IntentionPassContext!
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        self.context = context
        
        applyOnIntentions(intentionCollection)
    }
    
    func transform(type: SwiftType) -> SwiftType {
        switch type.deepUnwrapped {
        case .typeName(let typeName):
            if let newName = DropNSFromTypesIntentionPass._mappings[typeName] {
                return .typeName(newName)
            }
            
            return type
        default:
            return type
        }
    }
}

// MARK: - Traversal methods
extension DropNSFromTypesIntentionPass {
    
    func applyOnIntentions(_ intentions: IntentionCollection) {
        for file in intentions.fileIntentions() {
            applyOnFile(file)
        }
    }
    
    func applyOnFile(_ file: FileGenerationIntention) {
        for function in file.globalFunctionIntentions {
            applyOnGlobalFunction(function)
        }
        for globalVar in file.globalVariableIntentions {
            applyOnGlobalVariable(globalVar)
        }
        for type in file.typeIntentions {
            applyOnType(type)
        }
    }
    
    func applyOnType(_ type: TypeGenerationIntention) {
        if let cls = type as? BaseClassIntention {
            for ivar in cls.instanceVariables {
                applyOnInstanceVariable(ivar)
            }
        }
        
        for property in type.properties {
            applyOnProperty(property)
        }
        
        for constructor in type.constructors {
            applyOnInitializer(constructor)
        }
        
        for method in type.methods {
            applyOnMethod(method)
        }
    }
    
    func applyOnProperty(_ property: PropertyGenerationIntention) {
        property.storage.type = transform(type: property.storage.type)
    }
    
    func applyOnInstanceVariable(_ ivar: InstanceVariableGenerationIntention) {
        ivar.storage.type = transform(type: ivar.storage.type)
    }
    
    func applyOnMethod(_ method: MethodGenerationIntention) {
        _applyOnSignature(&method.signature)
    }
    
    func applyOnGlobalFunction(_ function: GlobalFunctionGenerationIntention) {
        _applyOnSignature(&function.signature)
    }
    
    func applyOnInitializer(_ initializer: InitGenerationIntention) {
        for i in 0..<initializer.parameters.count {
            initializer.parameters[i].type = transform(type: initializer.parameters[i].type)
        }
    }
    
    func _applyOnSignature(_ signature: inout FunctionSignature) {
        signature.returnType = transform(type: signature.returnType)
        
        for i in 0..<signature.parameters.count {
            signature.parameters[i].type = transform(type: signature.parameters[i].type)
        }
    }
    
    func applyOnGlobalVariable(_ variable: GlobalVariableGenerationIntention) {
        variable.storage.type = transform(type: variable.storage.type)
    }
}
