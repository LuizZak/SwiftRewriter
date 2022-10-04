import SwiftAST
import Analysis
import Intentions

/**
Detects properties of types by checking for assignments on `self`:

```swift
class A {
    init() {
        self._prop = 0
    }

    func method() {
        self.count = 0
    }
}
```

Is detected and converted to:

```swift
class A {
    var _prop: Any
    var count: Any

    init() {
        self._prop = 0
    }

    func method() {
        self.count = 0
    }
}
```
*/
public class DetectTypePropertiesBySelfAssignmentIntentionPass: TypeVisitingIntentionPass {
    
    /// Textual tag this intention pass applies to history tracking entries.
    private var historyTag: String {
        "\(DetectTypePropertiesBySelfAssignmentIntentionPass.self)"
    }

    public override init() {
        super.init()
    }
    
    override func applyOnType(_ type: TypeGenerationIntention) {
        super.applyOnType(type)

        // TODO: Support detection in extension methods, defining properties in
        // TODO: the main class declaration site, then.
        guard let type = type as? ClassGenerationIntention else {
            return
        }

        let analyzer = Analyzer(type: type, context: context)
        analyzer.analyze()

        for suggestion in analyzer.suggestions {
            let property = PropertyGenerationIntention(
                name: suggestion.name,
                type: suggestion.type ?? .any,
                objcAttributes: suggestion.isStatic ? [.attribute("class")] : [] // TODO: Refactor way static properties are detected to avoid this Objective-C-specific pattern.
            )

            property.history.recordCreation(description: """
                Detected from usage located at \
                \(suggestion.usage.intention.map(TypeFormatter.asString) ?? "<unknown>")
                """
            )

            type.addProperty(property)
        }
    }

    private class Analyzer {
        var type: TypeGenerationIntention
        var context: IntentionPassContext
        var suggestions: [PropertySuggestion] = []

        init(type: TypeGenerationIntention, context: IntentionPassContext) {
            self.type = type
            self.context = context
        }

        func analyze() {
            let queue = FunctionBodyQueue.fromType(type: type, delegate: EmptyFunctionBodyQueueDelegate())

            var collected: [PropertySuggestion] = []

            for item in queue.items {
                if let intention = item.intention {
                    collected.append(contentsOf: analyze(intention))
                }
            }

            suggestions.removeAll()

            for next in collected {
                guard let index = suggestions.firstIndex(where: { $0.name == next.name && $0.isStatic == next.isStatic }) else {
                    suggestions.append(next)
                    continue
                }

                let existing = suggestions[index]

                // If a collision was found, decide based on the usage that has
                // the most specific type.
                switch (next.type, existing.type) {
                case (nil, _?):
                    break

                case (_?, nil):
                    suggestions[index] = next
                
                case (let nextType?, let existingType?) where nextType != existingType:
                    // If a read usage conflicts with a write usage, prefer the
                    // write usage's type, instead.
                    if next.isWrite && !existing.isWrite {
                        suggestions[index] = next
                        break
                    }
                    if !next.isWrite && existing.isWrite {
                        break
                    }

                    if context.typeSystem.isType(existingType, assignableTo: nextType) {
                        suggestions[index] = next
                    }
                default:
                    break
                }
            }
        }

        private func analyze(_ item: FunctionBodyCarryingIntention) -> [PropertySuggestion] {
            guard let body = item.functionBody else {
                return []
            }

            return analyze(body: body, item: item, isStatic: false) + analyze(body: body, item: item, isStatic: true)
        }

        private func analyze(body: FunctionBodyIntention, item: FunctionBodyCarryingIntention, isStatic: Bool) -> [PropertySuggestion] {
            let definitionAnalyzer = LocalUsageAnalyzer(typeSystem: context.typeSystem)
            let usages = definitionAnalyzer.findUsagesOf(
                definition: .forSelf(type: type, isStatic: isStatic),
                in: .function(body),
                intention: item
            )

            return usages.compactMap { usage in
                analyze(usage: usage, isStatic: isStatic)
            }
        }

        private func analyze(usage: DefinitionUsage, isStatic: Bool) -> PropertySuggestion? {
            guard case .identifier(let identifier) = usage.expression else {
                return nil
            }
            guard let postfixExp = identifier.parentExpression?.asPostfix else {
                return nil
            }
            guard postfixExp.exp == identifier else {
                return nil
            }
            guard let member = postfixExp.op.asMember else {
                return nil
            }

            // Ignore member accesses that are known to the type system.
            guard member.definition == nil else {
                return nil
            }

            var type = detectType(expression: postfixExp)
            if type == .errorType {
                type = nil
            }

            let suggestion = PropertySuggestion(
                name: member.name,
                isStatic: isStatic,
                type: type,
                usageExpression: postfixExp,
                isWrite: isWriteUsage(postfixExp, usage: usage),
                usage: usage
            )

            return suggestion
        }

        private func detectType(expression: PostfixExpression) -> SwiftType? {
            if let assignment = expression.parentExpression?.asAssignment, assignment.lhs == expression {
                return assignment.rhs.resolvedType
            }

            return expression.expectedType
        }

        private func isWriteUsage(_ expression: PostfixExpression, usage: DefinitionUsage) -> Bool {
            if !usage.isReadOnlyUsage {
                return true
            }

            guard let assignment = expression.parentExpression?.asAssignment else {
                return false
            }

            return assignment.lhs == expression
        }

        struct PropertySuggestion {
            var name: String
            var isStatic: Bool
            var type: SwiftType?
            var usageExpression: PostfixExpression
            var isWrite: Bool
            var usage: DefinitionUsage
        }
    }
}
