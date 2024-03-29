import SwiftAST
import Intentions
import KnownType
import GrammarModelBase

public class MemberBuilder<T: MemberGenerationIntention>: DeclarationBuilder<T> {
    var targetMember: T {
        get {
            declaration
        }
        set {
            declaration = newValue
        }
    }
    
    public init(targetMember: T) {
        super.init(declaration: targetMember)
    }

    @discardableResult
    public func setSource(_ source: ASTNode) -> MemberBuilder {
        targetMember.source = source

        return self
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
    
    @discardableResult
    public func addComment(_ comment: SwiftComment) -> MemberBuilder {
        targetMember.precedingComments.append(comment)
        return self
    }
    
    @discardableResult
    public func addComments(_ comments: [SwiftComment]) -> MemberBuilder {
        targetMember.precedingComments.append(
            contentsOf: comments
        )
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

    @discardableResult
    func setIsFallible(_ isFallible: Bool) -> MemberBuilder {
        targetMember.isFallible = isFallible
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
    func setAsReadOnly() -> MemberBuilder {
        if !targetMember.isReadOnly {
            targetMember.objcAttributes.append(.attribute("readonly"))
        }

        return self
    }

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
    func setAsGetterSetter(
        getter: CompoundStatement,
        setter: PropertyGenerationIntention.Setter
    ) -> MemberBuilder {
        
        targetMember.mode = .property(
            get: FunctionBodyIntention(body: getter),
            set: setter
        )
        
        return self
    }
    
    @discardableResult
    func setComputedValue(expression: Expression?) -> MemberBuilder {
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

    @discardableResult
    func setInitialExpression(_ expression: Expression) -> MemberBuilder {
        targetMember.initialValue = expression

        return self
    }
}

public extension MemberBuilder where T: SubscriptGenerationIntention {
    @discardableResult
    func setAsGetterOnly(body: CompoundStatement) -> MemberBuilder {
        targetMember.mode = .getter(FunctionBodyIntention(body: body))
        
        return self
    }
    
    @discardableResult
    func setAsGetterSetter(
        getter: CompoundStatement,
        setter: SubscriptGenerationIntention.Setter
    ) -> MemberBuilder {
        
        targetMember.mode = .getterAndSetter(
            get: FunctionBodyIntention(body: getter),
            set: setter
        )
        
        return self
    }
}

public extension MemberBuilder where T: ProtocolPropertyGenerationIntention {
    @discardableResult
    func setIsOptional(_ isOptional: Bool) -> MemberBuilder {
        targetMember.isOptional = isOptional

        return self
    }
}

public extension MemberBuilder where T: ProtocolMethodGenerationIntention {
    @discardableResult
    func setIsOptional(_ isOptional: Bool) -> MemberBuilder {
        targetMember.isOptional = isOptional

        return self
    }
}

// MARK: - Typealiases
public typealias PropertyBuilder = MemberBuilder<PropertyGenerationIntention>
public typealias ProtocolPropertyBuilder = MemberBuilder<ProtocolPropertyGenerationIntention>
public typealias InstanceVarBuilder = MemberBuilder<InstanceVariableGenerationIntention>
public typealias MethodBuilder = MemberBuilder<MethodGenerationIntention>
public typealias ProtocolMethodBuilder = MemberBuilder<ProtocolMethodGenerationIntention>
public typealias InitializerBuilder = MemberBuilder<InitGenerationIntention>
public typealias SubscriptBuilder = MemberBuilder<SubscriptGenerationIntention>
public typealias DeinitBuilder = MemberBuilder<DeinitGenerationIntention>

public extension MemberBuilder where T == PropertyGenerationIntention {
    convenience init(name: String, type: SwiftType) {
        let prop = PropertyGenerationIntention(name: name, type: type, objcAttributes: [])
        
        self.init(targetMember: prop)
    }
}

public extension PropertyGenerationIntention {
    convenience init(name: String, type: SwiftType, builder: (PropertyBuilder) -> Void) {
        self.init(name: name, type: type, objcAttributes: [])
        
        builder(PropertyBuilder(targetMember: self))
    }
}

public extension ProtocolPropertyGenerationIntention {
    convenience init(name: String, type: SwiftType, builder: (ProtocolPropertyBuilder) -> Void) {
        self.init(name: name, type: type, objcAttributes: [])
        
        builder(ProtocolPropertyBuilder(targetMember: self))
    }
}

public extension MethodGenerationIntention {
    convenience init(name: String, builder: (MethodBuilder) -> Void) {
        self.init(signature: FunctionSignature(name: name), builder: builder)
    }
    
    convenience init(signature: FunctionSignature, builder: (MethodBuilder) -> Void) {
        self.init(signature: signature)
        
        builder(MethodBuilder(targetMember: self))
    }
}

public extension ProtocolMethodGenerationIntention {
    convenience init(name: String, builder: (ProtocolMethodBuilder) -> Void) {
        self.init(signature: FunctionSignature(name: name), builder: builder)
    }
    
    convenience init(signature: FunctionSignature, builder: (ProtocolMethodBuilder) -> Void) {
        self.init(signature: signature)
        
        builder(ProtocolMethodBuilder(targetMember: self))
    }
}

public extension InitGenerationIntention {
    convenience init(
        parameters: [ParameterSignature],
        builder: (InitializerBuilder) -> Void
    ) {
        self.init(
            parameters: parameters,
            functionBody: FunctionBodyIntention(body: [])
        )
        
        builder(InitializerBuilder(targetMember: self))
    }
    
    convenience init(builder: (InitializerBuilder) -> Void) {
        self.init(parameters: [])
        
        builder(InitializerBuilder(targetMember: self))
    }
}

public extension SubscriptGenerationIntention {
    convenience init(
        parameters: [ParameterSignature],
        returnType: SwiftType,
        mode: SubscriptGenerationIntention.Mode,
        builder: (SubscriptBuilder) -> Void
    ) {
        
        self.init(parameters: parameters, returnType: returnType, mode: mode)
        
        builder(SubscriptBuilder(targetMember: self))
    }
}

public extension DeinitGenerationIntention {
    convenience init(builder: (DeinitBuilder) -> Void) {
        self.init(functionBody: FunctionBodyIntention(body: []))
        
        builder(DeinitBuilder(targetMember: self))
    }
}
