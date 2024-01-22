import SwiftAST

class SwiftTypeStringProducer {
    var buffer: String
    var typeDepth: Int = -1

    init() {
        buffer = ""
    }
    
    func convert(_ type: SwiftType) -> String {
        buffer = ""

        visit(type)

        return buffer
    }

    private func emit(_ text: String...) {
        buffer += text.joined()
    }

    private func emitSeparated<T>(
        _ elements: any Sequence<T>,
        separator: String,
        _ emitter: (T) -> Void
    ) {

        var didEmit = false
        for element in elements {
            defer { didEmit = true }
            if didEmit {
                emit(separator)
            }

            emitter(element)
        }
    }

    private func visitParenthesizing(_ type: SwiftType) {
        if type.requiresSurroundingParens {
            emit("(")
        }

        visit(type)

        if type.requiresSurroundingParens {
            emit(")")
        }
    }

    private func visit(_ type: SwiftType) {
        typeDepth += 1
        defer { typeDepth -= 1 }

        switch type {
        case .nested(let inner):
            visit(inner)

        case .nominal(let inner):
            visit(inner)

        case .protocolComposition(let inner):
            visit(inner)

        case .tuple(let inner):
            visit(inner)

        case .block(let inner):
            visit(inner)

        case .metatype(let inner):
            visit(metatype: inner)

        case .optional(let inner):
            visit(optional: inner)

        case .implicitUnwrappedOptional(let inner):
            visit(implicitUnwrappedOptional: inner)

        case .nullabilityUnspecified(let inner):
            visit(nullabilityUnspecified: inner)

        case .array(let inner):
            visit(array: inner)

        case .dictionary(let key, let value):
            visit(dictionaryWithKey: key, value: value)
        }
    }

    private func visit(_ type: NominalSwiftType) {
        switch type {
        case .typeName(let name):
            emit(name)

        case .generic(let name, let parameters):
            emit(name, "<")
            emitSeparated(parameters, separator: ", ", visit(_:))
            emit(">")
        }
    }

    private func visit(_ type: NestedSwiftType) {
        emitSeparated(type, separator: ".", visit(_:))
    }

    private func visit(_ type: ProtocolCompositionSwiftType) {
        emitSeparated(type, separator: " & ", visit(_:))
    }

    private func visit(_ type: ProtocolCompositionComponent) {
        switch type {
        case .nominal(let inner):
            visit(inner)

        case .nested(let inner):
            visit(inner)
        }
    }

    private func visit(_ type: TupleSwiftType) {
        switch type {
        case .empty:
            emit("Void")

        case .types(let inner):
            emit("(")
            emitSeparated(inner, separator: ", ", visit(_:))
            emit(")")
        }
    }

    private func visit(_ type: BlockSwiftType) {
        let attributes = type.attributes.sorted(by: { $0.description < $1.description })

        for attribute in attributes {
            emit(attribute.description, " ")
        }

        emit("(")
        emitSeparated(type.parameters, separator: ", ", visit(_:))
        emit(") -> ")

        visit(type.returnType)
    }

    private func visit(metatype type: SwiftType) {
        visitParenthesizing(type)
        emit(".Type")
    }

    private func visit(optional type: SwiftType) {
        visitParenthesizing(type)
        emit("?")
    }

    private func visit(implicitUnwrappedOptional type: SwiftType) {
        visitParenthesizing(type)
        emit("!")
    }

    private func visit(nullabilityUnspecified type: SwiftType) {
        if typeDepth > 0 {
            return visit(optional: type)
        }

        visit(implicitUnwrappedOptional: type)
    }

    private func visit(array type: SwiftType) {
        emit("[")
        visit(type)
        emit("]")
    }

    private func visit(dictionaryWithKey key: SwiftType, value: SwiftType) {
        emit("[")
        visit(key)
        emit(": ")
        visit(value)
        emit("]")
    }
}
