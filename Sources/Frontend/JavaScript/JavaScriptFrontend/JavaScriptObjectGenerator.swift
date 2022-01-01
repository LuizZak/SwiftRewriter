import Intentions
import SwiftAST

/// Class that emits `JavaScriptObject` declarations.
public final class JavaScriptObjectGenerator {
    /// Generates the intention for a `JavaScriptObject` declaration.
    public func generateTypeIntention() -> ClassGenerationIntention {
        // TODO: Move TestCommons.IntentionBuilder to Intentions target and
        // TODO: use it here

        let type = ClassGenerationIntention(typeName: "JavaScriptObject")
        type.isFinal = true
        type.addProtocol("ExpressibleByDictionaryLiteral")
        type.addAttribute("dynamicMemberLookup")

        // Backing property
        type.addInstanceVariable(
            .init(
                name: "values",
                storage: .variable(ofType: .dictionary(key: .string, value: .any)),
                accessLevel: .private
            )
        )

        // Subscription
        type.addSubscript({
            let body = FunctionBodyIntention(
                body: [
                    .return(.identifier("values").sub(.identifier("member")))
                ]
            )

            let intention = SubscriptGenerationIntention(
                parameters: [
                    .init(
                        label: "dynamicMember", 
                        name: "member",
                        type: .string
                    )
                ],
                returnType: .optional(.any),
                mode: .getter(body)
            )

            return intention
        }())

        // Initializers
        type.addConstructor({
            let intention = InitGenerationIntention(parameters: [])
            intention.functionBody = FunctionBodyIntention(
                body: [
                    .expression(.identifier("self").dot("values").assignment(op: .assign, rhs: .dictionaryLiteral([:])))
                ]
            )

            return intention
        }())

        type.addConstructor({
            let intention = InitGenerationIntention(parameters: [
                ParameterSignature(
                    label: "dictionaryLiteral",
                    name: "elements",
                    type: .tuple(.types([.string, .any])),
                    isVariadic: true
                )
            ])
            intention.functionBody = FunctionBodyIntention(
                body: [
                    .for(
                        Pattern.tuple([.identifier("key"), .identifier("value")]),
                        .identifier("elements"),
                        body: [
                            .expression(
                                .identifier("self")
                                .dot("values")
                                .sub(.identifier("key"))
                                .assignment(
                                    op: .assign,
                                    rhs: .identifier("value")
                                )
                            )
                        ]
                    )
                ]
            )

            return intention
        }())

        return type
    }
}
