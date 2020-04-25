import SwiftAST
import KnownType
import Intentions

/// Specifies a definition for a global function or variable, or a local variable
/// of a function.
public class CodeDefinition {
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
            return signature.swiftClosureType
        }
    }
    
    /// Attempts to return the value of this code definition as a function signature,
    /// if it can be implicitly interpreted as one.
    public var asFunctionSignature: FunctionSignature? {
        switch kind {
        case .function(let signature):
            return signature
            
        case .variable:
            return nil
        }
    }
    
    fileprivate convenience init(variableNamed name: String, type: SwiftType) {
        self.init(variableNamed: name,
                  storage: ValueStorage(type: type,
                                        ownership: .strong,
                                        isConstant: false))
    }
    
    fileprivate convenience init(constantNamed name: String, type: SwiftType) {
        self.init(variableNamed: name,
                  storage: ValueStorage(type: type,
                                        ownership: .strong,
                                        isConstant: true))
    }
    
    fileprivate init(variableNamed name: String, storage: ValueStorage) {
        kind = .variable(name: name, storage: storage)
    }
    
    fileprivate init(functionSignature: FunctionSignature) {
        kind = .function(signature: functionSignature)
    }
    
    public enum Kind: Hashable {
        case variable(name: String, storage: ValueStorage)
        case function(signature: FunctionSignature)
        
        public var name: String {
            switch self {
            case .variable(let name, _):
                return name
                
            case .function(let signature):
                return signature.name
            }
        }
    }
}

public extension CodeDefinition {
    /// Creates a set of code definitions that correspond to the parameters of a
    /// given function signature
    static func forParameters(inSignature signature: FunctionSignature) -> [CodeDefinition] {
        forParameters(signature.parameters)
    }
    
    /// Creates a set of code definitions that correspond to the given set of
    /// parameters
    static func forParameters(_ parameters: [ParameterSignature]) -> [CodeDefinition] {
        parameters.enumerated().map { (i, param) in
            LocalCodeDefinition(variableNamed: param.name,
                                type: param.type,
                                location: .parameter(index: i))
        }
    }
    
    /// Creates a set of code definitions that correspond to the given set of
    /// block parameters
    static func forParameters(_ parameters: [BlockParameter]) -> [CodeDefinition] {
        parameters.enumerated().map { (i, param) in
            LocalCodeDefinition(variableNamed: param.name,
                                type: param.type,
                                location: .parameter(index: i))
        }
    }
    
    /// Creates a code definition that matches the instance or static type of
    /// `type`.
    /// Used for creating self intrinsics for member bodies.
    static func forSelf(type: SwiftType, isStatic: Bool) -> CodeDefinition {
        LocalCodeDefinition(constantNamed: "self",
                            type: isStatic ? .metatype(for: type) : type,
                            location: isStatic ? .staticSelf : .instanceSelf)
    }
    
    /// Creates a code definition that matches the instance or static type of
    /// `super`.
    /// Used for creating self intrinsics for member bodies.
    static func forSuper(type: SwiftType, isStatic: Bool) -> CodeDefinition {
        LocalCodeDefinition(constantNamed: "super",
                            type: isStatic ? .metatype(for: type) : type,
                            location: isStatic ? .staticSelf : .instanceSelf)
    }
    
    /// Creates a code definition for the setter of a setter method body.
    static func forSetterValue(named name: String, type: SwiftType) -> CodeDefinition {
        LocalCodeDefinition(constantNamed: name,
                            type: type,
                            location: .setterValue)
    }
    
    /// Creates a code definition for a local identifier
    static func forLocalIdentifier(_ identifier: String,
                                   type: SwiftType,
                                   ownership: Ownership = .strong,
                                   isConstant: Bool,
                                   location: LocalCodeDefinition.DefinitionLocation) -> LocalCodeDefinition {
        
        if isConstant {
            return LocalCodeDefinition(constantNamed: identifier,
                                       type: type,
                                       ownership: ownership,
                                       location: location)
        }
        
        return LocalCodeDefinition(variableNamed: identifier,
                                   type: type,
                                   ownership: ownership,
                                   location: location)
    }
    
    static func forVarDeclStatement(_ stmt: VariableDeclarationsStatement) -> [LocalCodeDefinition] {
        stmt.decl.enumerated().map { (i, decl) in
            CodeDefinition
                .forLocalIdentifier(
                    decl.identifier,
                    type: decl.type,
                    ownership: decl.ownership,
                    isConstant: decl.isConstant,
                    location: .variableDeclaration(stmt, index: i)
                )
        }
    }
    
    static func forGlobalFunction(_ function: GlobalFunctionGenerationIntention) -> CodeDefinition {
        GlobalIntentionCodeDefinition(intention: function)
    }
    
    static func forGlobalVariable(_ variable: GlobalVariableGenerationIntention) -> CodeDefinition {
        GlobalIntentionCodeDefinition(intention: variable)
    }
    
    static func forGlobalFunction(signature: FunctionSignature) -> CodeDefinition {
        GlobalCodeDefinition(functionSignature: signature)
    }
    
    static func forGlobalVariable(name: String, isConstant: Bool, type: SwiftType) -> CodeDefinition {
        if isConstant {
            return GlobalCodeDefinition(constantNamed: name, type: type)
        }
        
        return GlobalCodeDefinition(variableNamed: name, type: type)
    }
    
    static func forKnownMember(_ knownMember: KnownMember) -> CodeDefinition {
        KnownMemberCodeDefinition(knownMember: knownMember)
    }
    
    static func forType(named name: String) -> TypeCodeDefinition {
        TypeCodeDefinition(constantNamed: name,
                           type: .metatype(for: .typeName(name)))
    }
}

/// A code definition derived from a `KnownMember` instance
public class KnownMemberCodeDefinition: CodeDefinition {
    
    fileprivate init(knownMember: KnownMember) {
        switch knownMember {
        case let prop as KnownProperty:
            super.init(variableNamed: prop.name,
                       storage: prop.storage)
            
        case let method as KnownMethod:
            super.init(functionSignature: method.signature)
            
        default:
            fatalError("Attempting to create a \(KnownMemberCodeDefinition.self) from unkown \(KnownMember.self)-type \(Swift.type(of: knownMember))")
        }
    }
}

/// A code definition that refers to a type of matching name
public class TypeCodeDefinition: CodeDefinition {
    
}
extension TypeCodeDefinition: Equatable {
    public static func == (lhs: TypeCodeDefinition, rhs: TypeCodeDefinition) -> Bool {
        lhs.name == rhs.name
    }
}

public class GlobalCodeDefinition: CodeDefinition {
    fileprivate func isEqual(to other: GlobalCodeDefinition) -> Bool {
        kind == other.kind
    }
}
extension GlobalCodeDefinition: Equatable {
    public static func == (lhs: GlobalCodeDefinition, rhs: GlobalCodeDefinition) -> Bool {
        lhs.isEqual(to: rhs)
    }
}

public class GlobalIntentionCodeDefinition: GlobalCodeDefinition {
    public let intention: Intention
    
    fileprivate init(intention: Intention) {
        self.intention = intention
        
        switch intention {
        case let intention as GlobalVariableGenerationIntention:
            super.init(variableNamed: intention.name,
                       storage: intention.storage)
            
        case let intention as GlobalFunctionGenerationIntention:
            super.init(functionSignature: intention.signature)
            
        default:
            fatalError("Attempting to create global code definition for non-definition intention type \(Swift.type(of: intention))")
        }
    }
    
    fileprivate override func isEqual(to other: GlobalCodeDefinition) -> Bool {
        if let other = other as? GlobalIntentionCodeDefinition {
            return intention === other.intention
        }
        
        return super.isEqual(to: other)
    }
}

public class LocalCodeDefinition: CodeDefinition {
    public var location: DefinitionLocation
    
    fileprivate convenience init(variableNamed name: String,
                                 type: SwiftType,
                                 ownership: Ownership = .strong,
                                 location: DefinitionLocation) {
        
        self.init(variableNamed: name,
                  storage: ValueStorage(type: type,
                                        ownership: ownership,
                                        isConstant: false),
                  location: location)
    }
    
    fileprivate convenience init(constantNamed name: String,
                                 type: SwiftType,
                                 ownership: Ownership = .strong,
                                 location: DefinitionLocation) {
        
        self.init(variableNamed: name,
                  storage: ValueStorage(type: type,
                                        ownership: ownership,
                                        isConstant: true),
                  location: location)
    }
    
    fileprivate init(variableNamed name: String, storage: ValueStorage, location: DefinitionLocation) {
        self.location = location
        
        super.init(variableNamed: name, storage: storage)
    }
    
    fileprivate init(functionSignature: FunctionSignature, location: DefinitionLocation) {
        self.location = location
        
        super.init(functionSignature: functionSignature)
    }
    
    public enum DefinitionLocation: Hashable {
        case instanceSelf
        case staticSelf
        case setterValue
        case parameter(index: Int)
        case variableDeclaration(VariableDeclarationsStatement, index: Int)
        case forLoop(ForStatement, PatternLocation)
        case ifLet(IfStatement, PatternLocation)
        
        public func hash(into hasher: inout Hasher) {
            switch self {
            case .instanceSelf:
                hasher.combine(1)
                
            case .staticSelf:
                hasher.combine(2)
                
            case .setterValue:
                hasher.combine(3)
                
            case .parameter(let index):
                hasher.combine(4)
                hasher.combine(index)
                
            case let .variableDeclaration(stmt, index):
                hasher.combine(5)
                hasher.combine(ObjectIdentifier(stmt))
                hasher.combine(index)
                
            case let .forLoop(stmt, loc):
                hasher.combine(6)
                hasher.combine(ObjectIdentifier(stmt))
                hasher.combine(loc)
                
            case let .ifLet(stmt, loc):
                hasher.combine(7)
                hasher.combine(ObjectIdentifier(stmt))
                hasher.combine(loc)
            }
        }
    }
}

extension LocalCodeDefinition: Equatable {
    public static func == (lhs: LocalCodeDefinition, rhs: LocalCodeDefinition) -> Bool {
        lhs === rhs || (lhs.kind == rhs.kind && lhs.location == rhs.location)
    }
}
extension LocalCodeDefinition: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
        hasher.combine(location)
    }
}
