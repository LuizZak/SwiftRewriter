/// An anonymous intention visitor that reports visits to `Intention` objects to
/// an external listener closure.
public final class AnonymousIntentionVisitor: IntentionVisitor {
    public typealias Result = Void
    
    public let listener: (Intention) -> Void
    
    public init(listener: @escaping (Intention) -> Void) {
        self.listener = listener
    }

    private func notifyAndVisit(_ intention: Intention) {
        listener(intention)

        intention.children.forEach(visitIntention)
    }

    // MARK: -

    public func visitIntention(_ intention: Intention) {
        intention.accept(self)
    }

    public func visitClassExtension(_ intention: ClassExtensionGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitClass(_ intention: ClassGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitDeinit(_ intention: DeinitGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitEnumCase(_ intention: EnumCaseGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitEnum(_ intention: EnumGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitFile(_ intention: FileGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitFunctionBody(_ intention: FunctionBodyIntention) {
        notifyAndVisit(intention)
    }

    public func visitGlobalFunction(_ intention: GlobalFunctionGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitGlobalVariable(_ intention: GlobalVariableGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitGlobalVariableInitialValue(_ intention: GlobalVariableInitialValueIntention) {
        notifyAndVisit(intention)
    }

    public func visitInit(_ intention: InitGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitInstanceVariable(_ intention: InstanceVariableGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitMethod(_ intention: MethodGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitProperty(_ intention: PropertyGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitPropertyInitialValue(_ intention: PropertyInitialValueGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitPropertySynthesization(_ intention: PropertySynthesizationIntention) {
        notifyAndVisit(intention)
    }

    public func visitProtocol(_ intention: ProtocolGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitProtocolInheritance(_ intention: ProtocolInheritanceIntention) {
        notifyAndVisit(intention)
    }

    public func visitProtocolMethod(_ intention: ProtocolMethodGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitProtocolProperty(_ intention: ProtocolPropertyGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitStruct(_ intention: StructGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitSubscript(_ intention: SubscriptGenerationIntention) {
        notifyAndVisit(intention)
    }

    public func visitTypealias(_ intention: TypealiasIntention) {
        notifyAndVisit(intention)
    }
}
