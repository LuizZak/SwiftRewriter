import SwiftAST

// TODO: Implement a better pattern structure that allows deriving whether patterns bind as `let` or `var`s.

/// Matches capturing patterns to type structures in a type resolution context.
class PatternMatcher {
    var typeSystem: TypeSystem

    init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
    }

    /// Attempts to match a specified pattern into a given Swift type.
    /// Result is an array of binding operations.
    func match(
        pattern: Pattern,
        to type: SwiftType,
        context: PatternBindingContext
    ) -> [Result] {

        return _matchRecursive(
            pattern: pattern,
            to: type,
            context: context
        )
    }

    private func _matchRecursive(
        pattern: Pattern,
        to type: SwiftType,
        context: PatternBindingContext
    ) -> [Result] {

        switch pattern {
        case .tuple(let patterns):
            // Tuple patterns can only match with equal-length tuple patterns.
            switch type {
            case .tuple(let values) where values.count == patterns.count:
                let inner: [Result] = patterns.enumerated().flatMap { (index, pattern) in
                    let results = _matchRecursive(
                        pattern: pattern,
                        to: values[index],
                        context: context
                    )

                    // Update the pattern location to account for this tuple.
                    return results.withPatternLocation { location in
                        .tuple(index: index, pattern: location)
                    }
                }

                return inner
            default:
                break
            }

        case .identifier(let name):
            let resultType: SwiftType
            if context.contains(.optionalBinding) {
                resultType = type.unwrapped
            } else {
                resultType = type
            }

            return [
                .init(
                    identifier: name,
                    type: resultType,
                    patternLocation: .`self`,
                    isConstant: context.contains(.constant)
                )
            ]

        case .valueBindingPattern(let isConstant, let pattern):
            var context = context
            context.insert(.declaration)

            if isConstant {
                context.insert(.constant)
            }

            let inner = _matchRecursive(
                pattern: pattern,
                to: type,
                context: context
            )

            return inner.withPatternLocation(modifiedBy: {
                .valueBindingPattern(pattern: $0)
            })

        case .asType(let pattern, let patternType):
            let inner = _matchRecursive(
                pattern: pattern,
                to: patternType,
                context: context
            )

            return inner.withPatternLocation(modifiedBy: {
                .asType(pattern: $0)
            })

        case .expression, .wildcard:
            break
        }

        return []
    }

    /// The context of a pattern binding operation.
    struct PatternBindingContext: OptionSet {
        var rawValue: Int

        /// A declaration binding for declaring identifiers.
        static let declaration: Self = .init(rawValue: 1 << 0)

        /// A modifier of declaration contexts that indicate that declarations
        /// should be constant.
        static let constant: Self = .init(rawValue: 1 << 1)

        /// A context where optional values are unwrapped.
        static let optionalBinding: Self = .init(rawValue: 1 << 2)
    }

    /// An entry for the result of a pattern matching operation.
    struct Result: Hashable {
        /// Identifier for a binding pattern matching operation.
        var identifier: String

        /// The type for the bounded variable.
        var type: SwiftType

        /// The location at which the pattern was bound.
        var patternLocation: PatternLocation

        /// Whether the bound value is constant or not.
        var isConstant: Bool = true

        /// For accumulating pattern locations while recursively traversing
        /// through a pattern.
        fileprivate func withPatternLocation(
            modifiedBy modifier: (PatternLocation) -> PatternLocation
        ) -> Self {

            var copy = self
            copy.patternLocation = modifier(patternLocation)
            return copy
        }
    }
}

fileprivate extension Sequence where Element == PatternMatcher.Result {
    /// For accumulating pattern locations while recursively traversing
    /// through a pattern, applying a modifier to all results within this sequence.
    func withPatternLocation(
        modifiedBy modifier: (PatternLocation) -> PatternLocation
    ) -> [Element] {

        map({ $0.withPatternLocation(modifiedBy: modifier) })
    }
}
