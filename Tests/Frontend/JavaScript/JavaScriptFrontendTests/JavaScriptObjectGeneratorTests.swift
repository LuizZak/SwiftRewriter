import XCTest
import Intentions
import SwiftSyntaxSupport
import TestCommons

@testable import JavaScriptFrontend

class JavaScriptObjectGeneratorTests: XCTestCase {
    func testGenerateTypeIntention() {
        let sut = makeSut()

        let result = sut.generateTypeIntention()

        assertIntention(
            result,
            matches: """
            @dynamicMemberLookup
            final class JavaScriptObject: ExpressibleByDictionaryLiteral {
                private var values: [String: Any]

                subscript(dynamicMember member: String) -> Any? {
                    return values[member]
                }

                init() {
                    self.values = [:]
                }
                init(dictionaryLiteral elements: (String, Any)...) {
                    for (key, value) in elements {
                        self.values[key] = value
                    }
                }
                init(_ values: [String: Any]) {
                    self.values = values
                }
            }
            """
        )
    }

    // MARK: - Test internals

    private func makeSut() -> JavaScriptObjectGenerator {
        JavaScriptObjectGenerator()
    }

    private func assertIntention(
        _ intention: ClassGenerationIntention,
        matches string: String,
        line: UInt = #line
    ) {
        let file = FileGenerationIntention(sourcePath: "A.source", targetPath: "A.swift")
        file.addType(intention)

        let producer = SwiftSyntaxProducer()
        let syntax = producer.generateFile(file)

        diffTest(expected: string, line: line + 2)
            .diff(syntax.description, line: line)

        file.removeTypes(where: { $0 === intention })
    }
}
