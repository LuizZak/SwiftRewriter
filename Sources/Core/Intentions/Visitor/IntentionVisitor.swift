/// Protocol for intention visitors.
public protocol IntentionVisitor {
    /// The result of visits with this visitor
    associatedtype Result

    /// Visits an intention object.
    func visitIntention(_ intention: Intention) -> Result
    
    /// Visits a class extension intention.
    ///
    /// - Parameter: intention: A `ClassExtensionGenerationIntention` to visit.
    /// - Returns: The result of visiting the class extension intention.
    func visitClassExtension(_ intention: ClassExtensionGenerationIntention) -> Result

    /// Visits a class intention.
    ///
    /// - Parameter: intention: A `ClassGenerationIntention` to visit.
    /// - Returns: The result of visiting the class intention.
    func visitClass(_ intention: ClassGenerationIntention) -> Result

    /// Visits a deinit intention.
    ///
    /// - Parameter: intention: A `DeinitGenerationIntention` to visit.
    /// - Returns: The result of visiting the deinit intention.
    func visitDeinit(_ intention: DeinitGenerationIntention) -> Result

    /// Visits a enum case intention.
    ///
    /// - Parameter: intention: A `EnumCaseGenerationIntention` to visit.
    /// - Returns: The result of visiting the enum case intention.
    func visitEnumCase(_ intention: EnumCaseGenerationIntention) -> Result

    /// Visits a enum intention.
    ///
    /// - Parameter: intention: A `EnumGenerationIntention` to visit.
    /// - Returns: The result of visiting the enum intention.
    func visitEnum(_ intention: EnumGenerationIntention) -> Result

    /// Visits a file intention.
    ///
    /// - Parameter: intention: A `FileGenerationIntention` to visit.
    /// - Returns: The result of visiting the file intention.
    func visitFile(_ intention: FileGenerationIntention) -> Result

    /// Visits a function body intention.
    ///
    /// - Parameter: intention: A `FunctionBodyIntention` to visit.
    /// - Returns: The result of visiting the function body intention.
    func visitFunctionBody(_ intention: FunctionBodyIntention) -> Result

    /// Visits a global function intention.
    ///
    /// - Parameter: intention: A `GlobalFunctionGenerationIntention` to visit.
    /// - Returns: The result of visiting the global function intention.
    func visitGlobalFunction(_ intention: GlobalFunctionGenerationIntention) -> Result

    /// Visits a global variable intention.
    ///
    /// - Parameter: intention: A `GlobalVariableGenerationIntention` to visit.
    /// - Returns: The result of visiting the global variable intention.
    func visitGlobalVariable(_ intention: GlobalVariableGenerationIntention) -> Result

    /// Visits a global variable initial value intention.
    ///
    /// - Parameter: intention: A `GlobalVariableInitialValueIntention` to visit.
    /// - Returns: The result of visiting the global variable initial value intention.
    func visitGlobalVariableInitialValue(_ intention: GlobalVariableInitialValueIntention) -> Result

    /// Visits an init intention.
    ///
    /// - Parameter: intention: An `InitGenerationIntention` to visit.
    /// - Returns: The result of visiting the init intention.
    func visitInit(_ intention: InitGenerationIntention) -> Result

    /// Visits a instance intention.
    ///
    /// - Parameter: intention: A `InstanceVariableGenerationIntention` to visit.
    /// - Returns: The result of visiting the instance intention.
    func visitInstanceVariable(_ intention: InstanceVariableGenerationIntention) -> Result

    /// Visits a method intention.
    ///
    /// - Parameter: intention: A `MethodGenerationIntention` to visit.
    /// - Returns: The result of visiting the method intention.
    func visitMethod(_ intention: MethodGenerationIntention) -> Result

    /// Visits a property intention.
    ///
    /// - Parameter: intention: A `PropertyGenerationIntention` to visit.
    /// - Returns: The result of visiting the property intention.
    func visitProperty(_ intention: PropertyGenerationIntention) -> Result

    /// Visits a property initial value intention.
    ///
    /// - Parameter: intention: A `PropertyInitialValueGenerationIntention` to visit.
    /// - Returns: The result of visiting the property initial value intention.
    func visitPropertyInitialValue(_ intention: PropertyInitialValueGenerationIntention) -> Result

    /// Visits a property synthesization intention.
    ///
    /// - Parameter: intention: A `PropertySynthesizationIntention` to visit.
    /// - Returns: The result of visiting the property synthesization intention.
    func visitPropertySynthesization(_ intention: PropertySynthesizationIntention) -> Result

    /// Visits a protocol intention.
    ///
    /// - Parameter: intention: A `ProtocolGenerationIntention` to visit.
    /// - Returns: The result of visiting the protocol intention.
    func visitProtocol(_ intention: ProtocolGenerationIntention) -> Result

    /// Visits a protocol inheritance intention.
    ///
    /// - Parameter: intention: A `ProtocolInheritanceIntention` to visit.
    /// - Returns: The result of visiting the protocol inheritance intention.
    func visitProtocolInheritance(_ intention: ProtocolInheritanceIntention) -> Result

    /// Visits a protocol method intention.
    ///
    /// - Parameter: intention: A `ProtocolMethodGenerationIntention` to visit.
    /// - Returns: The result of visiting the protocol method intention.
    func visitProtocolMethod(_ intention: ProtocolMethodGenerationIntention) -> Result

    /// Visits a protocol property intention.
    ///
    /// - Parameter: intention: A `ProtocolPropertyGenerationIntention` to visit.
    /// - Returns: The result of visiting the protocol property intention.
    func visitProtocolProperty(_ intention: ProtocolPropertyGenerationIntention) -> Result

    /// Visits a struct intention.
    ///
    /// - Parameter: intention: A `StructGenerationIntention` to visit.
    /// - Returns: The result of visiting the struct intention.
    func visitStruct(_ intention: StructGenerationIntention) -> Result

    /// Visits a subscript intention.
    ///
    /// - Parameter: intention: A `SubscriptGenerationIntention` to visit.
    /// - Returns: The result of visiting the subscript intention.
    func visitSubscript(_ intention: SubscriptGenerationIntention) -> Result

    /// Visits a typealias intention.
    ///
    /// - Parameter: intention: A `TypealiasIntention` to visit.
    /// - Returns: The result of visiting the typealias intention.
    func visitTypealias(_ intention: TypealiasIntention) -> Result
}
