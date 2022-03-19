import Intentions

class TestIntentionVisitor: IntentionVisitor {
    typealias Result = Void

    var singleVisit: Bool
    var allVisits: [Intention] = []

    init(singleVisit: Bool = false) {
        self.singleVisit = singleVisit
    }

    private func recordAndVisit(_ intention: Intention) {
        allVisits.append(intention)

        if !singleVisit {
            intention.children.forEach(visitIntention)
        }
    }

    // MARK: -

    func visitIntention(_ intention: Intention) {
        intention.accept(self)
    }

    func visitClassExtension(_ intention: ClassExtensionGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitClass(_ intention: ClassGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitDeinit(_ intention: DeinitGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitEnumCase(_ intention: EnumCaseGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitEnum(_ intention: EnumGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitFile(_ intention: FileGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitFunctionBody(_ intention: FunctionBodyIntention) {
        recordAndVisit(intention)
    }

    func visitGlobalFunction(_ intention: GlobalFunctionGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitGlobalVariable(_ intention: GlobalVariableGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitGlobalVariableInitialValue(_ intention: GlobalVariableInitialValueIntention) {
        recordAndVisit(intention)
    }

    func visitInit(_ intention: InitGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitInstanceVariable(_ intention: InstanceVariableGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitMethod(_ intention: MethodGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitProperty(_ intention: PropertyGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitPropertyInitialValue(_ intention: PropertyInitialValueGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitPropertySynthesization(_ intention: PropertySynthesizationIntention) {
        recordAndVisit(intention)
    }

    func visitProtocol(_ intention: ProtocolGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitProtocolInheritance(_ intention: ProtocolInheritanceIntention) {
        recordAndVisit(intention)
    }

    func visitProtocolMethod(_ intention: ProtocolMethodGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitProtocolProperty(_ intention: ProtocolPropertyGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitStruct(_ intention: StructGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitSubscript(_ intention: SubscriptGenerationIntention) {
        recordAndVisit(intention)
    }

    func visitTypealias(_ intention: TypealiasIntention) {
        recordAndVisit(intention)
    }
}
