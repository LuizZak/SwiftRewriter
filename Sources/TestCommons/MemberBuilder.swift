import SwiftAST
import Intentions
import KnownType

public class MemberBuilder<T: MemberGenerationIntention>: DeclarationBuilder<T> {
    var targetMember: T
    
    public init(targetMember: T) {
        self.targetMember = targetMember
    }
    
    @discardableResult
    public func addHistory(tag: String, description: String) -> MemberBuilder {
        targetMember.history.recordChange(tag: tag, description: description)
        
        return self
    }
    
    @discardableResult
    public func setAccessLevel(_ accessLevel: AccessLevel) -> MemberBuilder {
        targetMember.accessLevel = accessLevel
        return self
    }
    
    @discardableResult
    public func addSemantics<S: Sequence>(_ semantics: S) -> MemberBuilder where S.Element == Semantic {
        targetMember.semantics.formUnion(semantics)
        return self
    }
    
    @discardableResult
    public func addAnnotations(_ annotations: [String]) -> MemberBuilder {
        targetMember.annotations.append(contentsOf: annotations)
        return self
    }
    
    @discardableResult
    public func addAttributes(_ attributes: [KnownAttribute]) -> MemberBuilder {
        targetMember.knownAttributes.append(contentsOf: attributes)
        return self
    }
    
    public func build() -> T {
        targetMember
    }
}

public extension MemberBuilder where T: OverridableMemberGenerationIntention {
    @discardableResult
    func setIsOverride(_ isOverride: Bool) -> MemberBuilder {
        targetMember.isOverride = isOverride
        return self
    }
}

public extension MemberBuilder where T: InitGenerationIntention {
    @discardableResult
    func setIsConvenience(_ isConvenience: Bool) -> MemberBuilder {
        targetMember.isConvenience = isConvenience
        return self
    }
}

extension MemberBuilder: _FunctionBuilder where T: FunctionIntention {
    public typealias FunctionType = T
    
    public var target: FunctionType { get { targetMember } set { targetMember = newValue } }
}

public extension MemberBuilder where T: MutableValueStorageIntention {
    @discardableResult
    func setValueStorage(_ storage: ValueStorage) -> MemberBuilder {
        targetMember.storage = storage
        
        return self
    }
    
    @discardableResult
    func setOwnership(_ ownership: Ownership) -> MemberBuilder {
        targetMember.storage.ownership = ownership
        
        return self
    }
    
    @discardableResult
    func setStorageType(_ type: SwiftType) -> MemberBuilder {
        targetMember.storage.type = type
        
        return self
    }
    
    @discardableResult
    func setIsConstant(_ isConstant: Bool) -> MemberBuilder {
        targetMember.storage.isConstant = isConstant
        
        return self
    }
    
    @discardableResult
    func setInitialValue(_ expression: Expression?) -> MemberBuilder {
        targetMember.initialValue = expression
        
        return self
    }
}

public extension MemberBuilder where T: PropertyGenerationIntention {
    @discardableResult
    func setAsField() -> MemberBuilder {
        targetMember.mode = .asField
        
        return self
    }
    
    @discardableResult
    func setSetterAccessLevel(_ accessLevel: AccessLevel?) -> MemberBuilder {
        targetMember.setterAccessLevel = accessLevel
        
        return self
    }
    
    @discardableResult
    func setAsComputedProperty(body: CompoundStatement) -> MemberBuilder {
        targetMember.mode = .computed(FunctionBodyIntention(body: body))
        
        return self
    }
    
    @discardableResult
    func setAsGetterSetter(getter: CompoundStatement,
                                  setter: PropertyGenerationIntention.Setter) -> MemberBuilder {
        
        targetMember.mode = .property(get: FunctionBodyIntention(body: getter),
                                      set: setter)
        
        return self
    }
    
    @discardableResult
    func setInitialValue(expression: Expression?) -> MemberBuilder {
        targetMember.mode = .computed(FunctionBodyIntention(body: []))
        
        return self
    }
    
    @discardableResult
    func setIsStatic(_ isStatic: Bool) -> MemberBuilder {
        if isStatic {
            if !targetMember.objcAttributes.contains(.attribute("class")) {
                targetMember.objcAttributes.append(.attribute("class"))
            }
        } else {
            targetMember.objcAttributes.removeAll(where: { $0 == .attribute("class") })
        }
        
        return self
    }
}

// MARK: - Typealiases
public typealias PropertyBuilder = MemberBuilder<PropertyGenerationIntention>
public typealias InstanceVarBuilder = MemberBuilder<InstanceVariableGenerationIntention>
public typealias MethodBuilder = MemberBuilder<MethodGenerationIntention>
public typealias InitializerBuilder = MemberBuilder<InitGenerationIntention>

public extension MemberBuilder where T == PropertyGenerationIntention {
    convenience init(name: String, type: SwiftType, ownerTypeName: String) {
        let prop = PropertyGenerationIntention(name: name,
                                               type: type,
                                               objcAttributes: [],
                                               ownerTypeName: ownerTypeName)
        
        self.init(targetMember: prop)
    }
}

public extension PropertyGenerationIntention {
    convenience init(name: String, type: SwiftType, ownerTypeName: String, builder: (PropertyBuilder) -> Void) {
        self.init(name: name, type: type, objcAttributes: [], ownerTypeName: ownerTypeName)
        
        builder(PropertyBuilder(targetMember: self))
    }
}

public extension MethodGenerationIntention {
    convenience init(name: String, ownerTypeName: String, builder: (MethodBuilder) -> Void) {
        self.init(signature: FunctionSignature(name: name), ownerTypeName: ownerTypeName)
        
        builder(MethodBuilder(targetMember: self))
    }
}

public extension InitGenerationIntention {
    convenience init(ownerTypeName: String, builder: (InitializerBuilder) -> Void) {
        self.init(parameters: [], ownerTypeName: ownerTypeName)
        
        builder(InitializerBuilder(targetMember: self))
    }
}
