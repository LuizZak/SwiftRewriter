import SwiftAST
import KnownType
import Intentions

/// Specifies a definition for a global function or variable, or a local variable
/// of a function, or a type initializer.
public class CodeDefinition: Equatable {
    /// Gets the name of this definition.
    ///
    /// If this code definition is a function, the name is the identifier from
    /// the function's signature, and if it is a initializer, the name is always
    /// `init`.
    public var name: String {
        kind.name
    }
    
    public var kind: Kind
    
    /// Gets the type signature for this definition.
    /// In case this is a function definition, the type represents the closure
    /// signature of the function.
    public var type: SwiftType {
        switch kind {
        case .variable(_, let storage):
            return storage.type

        case .function(let signature):
            return .block(signature.swiftClosureType)
        
        case .subscript(let signature):
            return signature.swiftClosureType

        case .initializer(let typeName, let parameters):
            return .block(
                returnType: typeName.asSwiftType,
                parameters: parameters.map(\.type)
            )
        }
    }

    /// Gets the ownership of this definition.
    ///
    /// In case this is a function definition, the ownership is always `strong`.
    public var ownership: Ownership {
        switch kind {
        case .variable(_, let storage):
            return storage.ownership
        case .function, .initializer, .subscript:
            return .strong
        }
    }
    
    /// Attempts to return the value of this code definition as a function signature,
    /// if it can be implicitly interpreted as one.
    public var asFunctionSignature: FunctionSignature? {
        switch kind {
        case .function(let signature):
            return signature
        
        case .initializer, .variable, .subscript:
            return nil
        }
    }
    
    /// Attempts to return the value of this code definition as a subscript signature,
    /// if it can be implicitly interpreted as one.
    public var asSubscriptSignature: SubscriptSignature? {
        switch kind {
        case .subscript(let signature):
            return signature
        
        case .initializer, .variable, .function:
            return nil
        }
    }
    
    convenience init(variableNamed name: String, type: SwiftType) {
        self.init(
            variableNamed: name,
            storage: ValueStorage(
                type: type,
                ownership: .strong,
                isConstant: false
            )
        )
    }
    
    convenience init(constantNamed name: String, type: SwiftType) {
        self.init(
            variableNamed: name,
            storage: ValueStorage(
                type: type,
                ownership: .strong,
                isConstant: true
            )
        )
    }
    
    init(variableNamed name: String, storage: ValueStorage) {
        kind = .variable(name: name, storage: storage)
    }
    
    init(functionSignature: FunctionSignature) {
        kind = .function(signature: functionSignature)
    }
    
    init(subscriptSignature: SubscriptSignature) {
        kind = .subscript(signature: subscriptSignature)
    }
    
    init(typeInitializer type: KnownTypeReference, parameters: [ParameterSignature]) {
        kind = .initializer(type, parameters: parameters)
    }

    /// Returns `true` if `self` and `other` reference the same definition.
    public func isEqual(to other: CodeDefinition) -> Bool {
        self === other
    }

    /// Returns `true` if both code definitions reference the same definition.
    public static func == (lhs: CodeDefinition, rhs: CodeDefinition) -> Bool {
        lhs.isEqual(to: rhs)
    }
    
    public enum Kind: Hashable {
        case variable(name: String, storage: ValueStorage)
        case function(signature: FunctionSignature)
        case `subscript`(signature: SubscriptSignature)
        case initializer(KnownTypeReference, parameters: [ParameterSignature])
        
        public var name: String {
            switch self {
            case .variable(let name, _):
                return name
                
            case .function(let signature):
                return signature.name
            
            case .subscript(let signature):
                return signature.description

            case .initializer(let typeName, _):
                return typeName.asSwiftType.description
            }
        }
    }
}
