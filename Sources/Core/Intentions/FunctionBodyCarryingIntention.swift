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
}
