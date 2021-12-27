import Intentions
import JsGrammarModels
import JsParser
import SwiftAST
import SwiftRewriterLib
import TypeSystem
import XCTest

@testable import JavaScriptFrontend

class JavaScriptIntentionCollectorTests: XCTestCase {
    private var file: FileGenerationIntention!
    private var delegate: TestCollectorDelegate!
    private var sut: JavaScriptIntentionCollector!

    override func setUp() {
        super.setUp()

        file = FileGenerationIntention(sourcePath: "A.js", targetPath: "A.swift")

        let context = JavaScriptIntentionCollector.Context()
        context.pushContext(file)

        delegate = TestCollectorDelegate(file: file)
        sut = JavaScriptIntentionCollector(delegate: delegate, context: context)
    }

    func testCollectFunctionDefinition() {
        // Arrange
        let root = JsGlobalContextNode()

        let function = JsFunctionDeclarationNode()
        root.addChild(function)

        function.addChild(JsIdentifierNode(name: "global"))

        function.signature = JsFunctionSignature(arguments: [.init(identifier: "a", isVariadic: false)])

        // Act
        sut.collectIntentions(root)

        // Assert
        XCTAssertEqual(file.globalFunctionIntentions.count, 1)
        XCTAssertEqual(
            file.globalFunctionIntentions.first?.signature,
            FunctionSignature(
                name: "global",
                parameters: [
                    ParameterSignature(label: nil, name: "a", type: .any)
                ],
                returnType: .any,
                isStatic: false
            )
        )
    }

    func testCollectFunctionDefinitionBody() throws {
        try withExtendedLifetime(JsParser(string: "function global() { stmt(); }")) { parser in
            try parser.parse()
            let rootNode = parser.rootNode

            sut.collectIntentions(rootNode)

            XCTAssertEqual(file.globalFunctionIntentions.count, 1)
            XCTAssertEqual(delegate.reportedForLazyParsing.count, 1)
            XCTAssert(
                delegate.reportedForLazyParsing.first
                    === file.globalFunctionIntentions.first?.functionBody
            )
        }
    }

    func testCollectClassProperty() throws {
        // Arrange
        let parserState = JsParserState()
        let root = JsGlobalContextNode()

        let classNode = JsClassNode()
        classNode.addChild(JsIdentifierNode(name: "A"))
        
        let propertyNode = JsClassPropertyNode()
        propertyNode.addChild(JsIdentifierNode(name: "property"))
        
        let expressionNode = JsExpressionNode()
        expressionNode.expression = try parserState.makeMainParser(input: "0").parser.singleExpression()

        propertyNode.addChild(expressionNode)
        classNode.addChild(propertyNode)
        root.addChild(classNode)

        // Act
        sut.collectIntentions(root)

        // Assert
        XCTAssertEqual(file.classIntentions.count, 1)
        XCTAssertEqual(
            file.classIntentions.first?.properties.first?.name,
            "property"
        )
        XCTAssertEqual(
            file.classIntentions.first?.properties.first?.initialValue,
            .constant(0)
        )
    }
    
    func testCollectClassComments() throws {
        testCommentCollection(
            """
            // A comment
            // Another comment
            class A {
            }
            """,
            \FileGenerationIntention.classIntentions[0]
        )
    }

    func testCollectMethodComments() throws {
        testCommentCollection(
            """
            class A {
                // A comment
                // Another comment
                f() {
                }
            }
            """,
            \FileGenerationIntention.classIntentions[0].methods[0]
        )
    }

    func testCollectPropertyComments() throws {
        testCommentCollection(
            """
            class A {
                // A comment
                // Another comment
                a = 0
            }
            """,
            \FileGenerationIntention.classIntentions[0].properties[0]
        )
    }

    // MARK: - Test internals

    private func testCommentCollection<T: FromSourceIntention>(
        _ code: String,
        _ keyPath: KeyPath<FileGenerationIntention, T>,
        line: UInt = #line
    ) {

        do {
            try withExtendedLifetime(JsParser(string: code)) { parser in
                try parser.parse()
                let rootNode = parser.rootNode

                sut.collectIntentions(rootNode)

                XCTAssertEqual(
                    file[keyPath: keyPath].precedingComments,
                    [
                        "// A comment",
                        "// Another comment",
                    ],
                    line: line
                )
            }
        }
        catch {
            XCTFail("Failed to parse JavaScript source: \(error)", line: line)
        }
    }
}

private class TestCollectorDelegate: JavaScriptIntentionCollectorDelegate {
    var context: JavaScriptIntentionCollector.Context
    var intentions: IntentionCollection

    var reportedForLazyParsing: [Intention] = []

    init(file: FileGenerationIntention) {
        context = JavaScriptIntentionCollector.Context()
        intentions = IntentionCollection()
        intentions.addIntention(file)

        context.pushContext(file)
    }

    // MARK: -

    func reportForLazyParsing(intention: Intention) {
        reportedForLazyParsing.append(intention)
    }
}
