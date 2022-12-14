import KnownType

/// Describes an intention that is a carrier of a function body or a top-level
/// expression.
public enum FunctionBodyCarryingIntention: Hashable {
    // TODO: Add enum case constant value generation intention entry in this enum
    
    case method(MethodGenerationIntention)
    case initializer(InitGenerationIntention)
    case `deinit`(DeinitGenerationIntention)
    case global(GlobalFunctionGenerationIntention)
    case propertyGetter(PropertyGenerationIntention, FunctionBodyIntention)
    case propertySetter(PropertyGenerationIntention, PropertyGenerationIntention.Setter)
    case subscriptGetter(SubscriptGenerationIntention, FunctionBodyIntention)
    case subscriptSetter(SubscriptGenerationIntention, SubscriptGenerationIntention.Setter)
    case propertyInitializer(PropertyGenerationIntention, PropertyInitialValueGenerationIntention)
    case globalVariable(GlobalVariableGenerationIntention, GlobalVariableInitialValueIntention)

    public var functionBody: FunctionBodyIntention? {
        switch self {
        case .method(let intention):
            return intention.functionBody
        case .initializer(let intention):
            return intention.functionBody
        case .deinit(let intention):
            return intention.functionBody
        case .global(let intention):
            return intention.functionBody
        case .propertyGetter(_, let intention):
            return intention
        case .propertySetter(_, let setter):
            return setter.body
        case .subscriptGetter(_, let intention):
            return intention
        case .subscriptSetter(_, let setter):
            return setter.body
        case .propertyInitializer:
            return nil
        case .globalVariable(_, _):
            return nil
        }
    }

    /// If this function body carrying reference is a parameterized function
    /// intention, returns its type-erased value, otherwise returns `nil`.
    public var parameterizedFunction: ParameterizedFunctionIntention? {
        switch self {
        case .method(let intention):
            return intention
        case .initializer(let intention):
            return intention
        case .deinit:
            return nil
        case .global(let intention):
            return intention
        case .propertyGetter:
            return nil
        case .propertySetter:
            return nil
        case .subscriptGetter:
            return nil
        case .subscriptSetter:
            return nil
        case .propertyInitializer:
            return nil
        case .globalVariable:
            return nil
        }
    }

    /// Gets the statement container associated with this `FunctionBodyCarryingIntention`,
    /// or `nil`, in case none is present.
    public var statementContainer: StatementContainer? {
        switch self {
        case .method(let intention):
            return intention.functionBody.map(StatementContainer.function)
        case .initializer(let intention):
            return intention.functionBody.map(StatementContainer.function)
        case .deinit(let intention):
            return intention.functionBody.map(StatementContainer.function)
        case .global(let intention):
            return intention.functionBody.map(StatementContainer.function)
        case .propertyGetter(_, let intention):
            return .function(intention)
        case .propertySetter(_, let setter):
            return .function(setter.body)
        case .subscriptGetter(_, let intention):
            return .function(intention)
        case .subscriptSetter(_, let setter):
            return .function(setter.body)
        case .propertyInitializer(_, let initializer):
            return .expression(initializer.expression)
        case .globalVariable(_, let initializer):
            return .expression(initializer.expression)
        }
    }

    /// Gets the file that owns the underlying symbol referenced by this
    /// `FunctionBodyCarryingIntention`.
    public var ownerFile: KnownFile? {
        switch self {
        case .method(let decl):
            return decl.file

        case .initializer(let decl):
            return decl.file

        case .deinit(let decl):
            return decl.file

        case .propertyGetter(_, let decl):
            return decl.file

        case .propertySetter(_, let decl):
            return decl.body.file

        case .subscriptGetter(_, let decl):
            return decl.file

        case .subscriptSetter(_, let decl):
            return decl.body.file

        case .propertyInitializer(_, let decl):
            return decl.file

        case .global(let decl):
            return decl.file
        
        case .globalVariable(_, let decl):
            return decl.file
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .method(let intention):
            hasher.combine(ObjectIdentifier(intention))

        case .initializer(let intention):
            hasher.combine(ObjectIdentifier(intention))

        case .deinit(let intention):
            hasher.combine(ObjectIdentifier(intention))

        case .global(let intention):
            hasher.combine(ObjectIdentifier(intention))

        case .propertyGetter(_, let intention):
            hasher.combine(ObjectIdentifier(intention))

        case .propertySetter(_, let setter):
            hasher.combine(ObjectIdentifier(setter.body))
            
        case .subscriptGetter(_, let intention):
            hasher.combine(ObjectIdentifier(intention))

        case .subscriptSetter(_, let setter):
            hasher.combine(ObjectIdentifier(setter.body))

        case .propertyInitializer(_, let initializer):
            hasher.combine(ObjectIdentifier(initializer))

        case .globalVariable(_, let initializer):
            hasher.combine(ObjectIdentifier(initializer))
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.method(let lhs), .method(let rhs)):
            return lhs === rhs

        case (.initializer(let lhs), .initializer(let rhs)):
            return lhs === rhs

        case (.deinit(let lhs), .deinit(let rhs)):
            return lhs === rhs

        case (.global(let lhs), .global(let rhs)):
            return lhs === rhs

        case (.propertyGetter(let lhs, let lhsBody), .propertyGetter(let rhs, let rhsBody)):
            return lhs === rhs && lhsBody === rhsBody

        case (.propertySetter(let lhs, let lhsBody), .propertySetter(let rhs, let rhsBody)):
            return lhs === rhs && lhsBody.body === rhsBody.body
            
        case (.subscriptGetter(let lhs, let lhsBody), .subscriptGetter(let rhs, let rhsBody)):
            return lhs === rhs && lhsBody === rhsBody

        case (.subscriptSetter(let lhs, let lhsBody), .subscriptSetter(let rhs, let rhsBody)):
            return lhs === rhs && lhsBody.body === rhsBody.body

        case (.propertyInitializer(let lhs, let lhsBody), .propertyInitializer(let rhs, let rhsBody)):
            return lhs === rhs && lhsBody === rhsBody

        case (.globalVariable(let lhs, let lhsBody), .globalVariable(let rhs, let rhsBody)):
            return lhs === rhs && lhsBody === rhsBody
        
        default:
            return false
        }
    }
}
