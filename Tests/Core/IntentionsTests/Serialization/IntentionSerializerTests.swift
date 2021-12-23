import KnownType
import SwiftAST
import TestCommons
import XCTest
import ObjcGrammarModels

@testable import Intentions

class IntentionSerializerTests: XCTestCase {

    func testIntentionCollectionSerializationRoundtrip() throws {

        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.swift") { file in
                file.addHeaderComment("#preprocessor")
                    .createClass(withName: "Class") { type in
                        type.createConformance(protocolName: "Protocol")
                            .createConstructor()
                            .createDeinit()
                            .createInstanceVariable(named: "a", type: .int)
                            .createProperty(
                                named: "b",
                                type: .float,
                                objcAttributes: [
                                    .getterName("getterName"),
                                    .readonly,
                                    .attribute("attribute1"),
                                    .setterName("attribute1"),
                                ]
                            )
                            .createProperty(named: "c", type: .int) { prop in
                                prop.setAsComputedProperty(body: [
                                    .return(.constant(0))
                                ])
                            }
                            .createProperty(named: "d", type: .int) { prop in
                                let setterBody: CompoundStatement = [
                                    .expression(
                                        Expression
                                            .identifier("print")
                                            .call([.identifier("newValue")])
                                    )
                                ]

                                prop.setAsGetterSetter(
                                    getter: [.return(.constant(0))],
                                    setter: .init(
                                        valueIdentifier: "newValue",
                                        body: setterBody
                                    )
                                )
                            }
                            .createSubscript("(index: Int)", returnType: .int)
                            .createSubscript("(index: String)", returnType: .string) { sub in
                                let setterBody: CompoundStatement = [
                                    .expression(
                                        Expression
                                            .identifier("print")
                                            .call([.identifier("newValue")])
                                    )
                                ]

                                sub.setAsGetterSetter(
                                    getter: [.return(.constant(0))],
                                    setter: .init(
                                        valueIdentifier: "newValue",
                                        body: setterBody
                                    )
                                )
                            }
                            .createMethod("method(_ a: Int, b: Float)") { method in
                                method
                                    .addHistory(tag: "Test", description: "A test history")
                                    .addSemantics(Semantics.collectionMutator)
                                    .addAttributes([KnownAttribute(name: "attr", parameters: nil)])
                                    .addAnnotations(["annotation"])
                                    .setBody([
                                        Statement.expression(
                                            Expression
                                                .identifier("hello")
                                                .dot("world").call()
                                        )
                                    ])
                            }
                            .inherit(from: "BaseClass")
                    }
                    .beginNonnulContext()
                    .createProtocol(withName: "Protocol") { type in
                        type.createMethod(named: "test")
                            .createProperty(named: "property", type: .int)
                    }
                    .endNonnullContext()
            }
            .createFile(named: "B.swift") { file in
                file.createStruct(withName: "Struct")
                    .createTypealias(withName: "Typealias", type: .struct("NSInteger"))
                    .createEnum(withName: "Enum", rawValue: .int) { type in
                        type.createCase(name: "first")
                        type.createCase(
                            name: "second",
                            expression: .identifier("test")
                        )
                    }
                    .createExtension(forClassNamed: "Class", categoryName: "Test") { type in
                        type.createSynthesize(propertyName: "b", variableName: "_b")
                    }
            }
            .createFile(named: "C.swift") { file in
                file.createGlobalFunction(withName: "test")
                    .createGlobalVariable(
                        withName: "globalVar",
                        type: .int,
                        initialExpression: Expression.constant(0)
                    )
            }
            .build()

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let metadataSerializer = DefaultMetadataSerializer()

        let data = try IntentionSerializer.encode(intentions: intentions, metadataSerializer: metadataSerializer, encoder: encoder)

        XCTAssertNoThrow(
            try IntentionSerializer.decodeIntentions(decoder: JSONDecoder(), metadataSerializer: metadataSerializer, data: data)
        )
    }

    func testSerializeMetadata() throws {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "file.h") { file in
                file.addMetadata(forKey: "key", value: 123, type: "Int")
            }
            .build()

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let metadataSerializer = DefaultMetadataSerializer()

        let data = try IntentionSerializer.encode(intentions: intentions, metadataSerializer: metadataSerializer, encoder: encoder)
        let decoded = try IntentionSerializer.decodeIntentions(decoder: JSONDecoder(), metadataSerializer: metadataSerializer, data: data)

        XCTAssertEqual(decoded.fileIntentions()[0].metadata.getValue(forKey: "key"), 123)
    }
}

private class DefaultMetadataSerializer: SerializableMetadataSerializerType {
    func serialize(type: String, value: Any, encoder: Encoder) throws {
        switch (type, value) {
        case ("ObjcType", let value as ObjcType):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case ("Int", let value as Int):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        default:
            throw Error.mismatchedType
        }
    }

    func deserialize(type: String, decoder: Decoder) throws -> Any {
        if type == "Int" {
            return try decoder.singleValueContainer().decode(Int.self)
        }
        if type == "ObjcType" {
            return try decoder.singleValueContainer().decode(ObjcType.self)
        }

        throw Error.unknownType(type)
    }

    enum Error: Swift.Error {
        case mismatchedType
        case unknownType(String)
    }
}
