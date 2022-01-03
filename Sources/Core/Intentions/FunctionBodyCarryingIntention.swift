/// Describes an intention that is a carrier of a function body or a top-level
/// expression.
public enum FunctionBodyCarryingIntention {
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
}
