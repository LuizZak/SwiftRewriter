import XCTest
import SwiftAST
import KnownType
import GlobalsProviders
import TypeSystem

let cInt = SwiftType.typeName("CInt")
let cFloat = SwiftType.typeName("CFloat")
let cDouble = SwiftType.typeName("CDouble")

class BaseGlobalsProviderTestCase: XCTestCase {
    var sut: GlobalsProvider!
    var globals: DefinitionsSource!
    var types: KnownTypeProvider!
    var typealiases: TypealiasProvider!

    override func setUp() {
        super.setUp()

        types = nil
        typealiases = nil
    }

    func assertDefined(
        typealiasFrom typealiasName: String,
        to type: SwiftType,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        guard let actual = typealiases.unalias(typealiasName) else {
            XCTFail(
                "Expected to find typealias with name \(typealiasName)",
                file: file,
                line: line
            )
            return
        }

        if actual != type {
            XCTFail(
                "Expected typealias to be of type \(type), but found \(actual) instead.",
                file: file,
                line: line
            )
        }
    }

    func assertDefined(
        variable: String,
        type: SwiftType,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        guard let definition = globals.firstDefinition(named: variable) else {
            XCTFail(
                "Expected to find definition \(variable)",
                file: file,
                line: line
            )
            return
        }

        guard case let .variable(_, storage) = definition.kind else {
            XCTFail(
                "Expected to find a variable defined, but found \(definition.kind) instead",
                file: file,
                line: line
            )
            return
        }

        if storage.type != type {
            XCTFail(
                "Expected variable to be of type \(type), but found \(storage.type) instead.",
                file: file,
                line: line
            )
        }
    }

    func assertDefined(
        function: String,
        paramTypes: [SwiftType],
        returnType: SwiftType,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let asSignature =
            FunctionSignature(
                name: function,
                parameters: paramTypes.map { ParameterSignature(label: nil, name: "v", type: $0) },
                returnType: returnType
            )

        assertDefined(
            functionSignature: TypeFormatter.asString(signature: asSignature, includeName: true),
            file: file,
            line: line
        )

    }

    func assertDefined(
        functionSignature: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let asSignature = try! FunctionSignature(signatureString: functionSignature)

        let signatures: [FunctionSignature] =
            globals
            .functionDefinitions(matching: asSignature.asIdentifier)
            .compactMap {
                guard case let .function(signature) = $0.kind else {
                    return nil
                }

                return signature
            }

        guard !signatures.isEmpty else {
            XCTFail(
                "Expected to find definition for \(functionSignature)",
                file: file,
                line: line
            )
            return
        }

        if !signatures.contains(where: { asSignature.asIdentifier == $0.asIdentifier }) {
            XCTFail(
                """
                Failed to find function definition \(functionSignature).

                Function signatures found:

                \(signatures.map { TypeFormatter.asString(signature: $0, includeName: true) }.joined(separator: "\n -"))
                """,
                file: file,
                line: line
            )
        }
    }

    func assertDefined(
        typeName: String,
        supertype: String? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let type = types.knownType(withName: typeName) else {
            XCTFail(
                "Expected to find type \(typeName)",
                file: file,
                line: line
            )
            return
        }

        if let supertype = supertype, type.supertype?.asTypeName != supertype {
            XCTFail(
                "Expected supertype \(supertype), but found \(type.supertype?.asTypeName ?? "<nil>")",
                file: file,
                line: line
            )
        }
    }

    func assertDefined(
        typeName: String,
        supertype: String? = nil,
        signature: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        guard let type = types.knownType(withName: typeName) else {
            XCTFail(
                "Expected to find type \(typeName)",
                file: file,
                line: line
            )
            return
        }

        if let supertype = supertype, type.supertype?.asTypeName != supertype {
            XCTFail(
                "Expected supertype \(supertype), but found \(type.supertype?.asTypeName ?? "<nil>")",
                file: file,
                line: line
            )
        }

        let typeString = TypeFormatter.asString(knownType: type)

        if typeString != signature {
            XCTFail(
                """
                Expected type signature of type \(typeName) to match

                \(signature)

                but found signature

                \(signature.makeDifferenceMarkString(against: typeString))
                """,
                file: file,
                line: line
            )
        }
    }

    func assertDefined(
        canonicalTypeName: String,
        forNonCanon nonCanon: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        guard let canonName = types.canonicalName(for: nonCanon) else {
            XCTFail(
                "Expected to find canonical type mapping for \(nonCanon)",
                file: file,
                line: line
            )
            return
        }

        if canonName != canonicalTypeName {
            XCTFail(
                """
                Expected canonical type '\(nonCanon)' to map to \(canonicalTypeName), \
                but it maps to \(canonName)
                """,
                file: file,
                line: line
            )
        }
    }
}
