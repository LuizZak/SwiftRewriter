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
        XCTAssertTrue(file.globalFunctionIntentions.first?.source is JsFunctionDeclarationNode)
    }

    func testCollectFunctionDefinitionBody() throws {
        try withExtendedLifetime(JsParser(string: "function global() { stmt(); }")) { parser in
            try parser.parse()
            let rootNode = parser.rootNode

            sut.collectIntentions(rootNode)

            XCTAssertEqual(file.globalFunctionIntentions.count, 1)
            XCTAssertEqual(delegate.reportedForLazyParsing.count, 1)
            let function = try XCTUnwrap(file.globalFunctionIntentions.first)
            let body = try XCTUnwrap(function.functionBody)
            XCTAssert(
                delegate.reportedForLazyParsing.first == .globalFunction(body, function)
            )
        }
    }

    func testCollectGlobalVariable() throws {
        let parserState = JsParserState()

        try withExtendedLifetime(parserState.makeMainParser(input: "1")) { parser in
            //// Arrange
            let root = JsGlobalContextNode()

            let node = JsVariableDeclarationListNode(varModifier: .var)

            // a;
            node.addChild({ 
                let decl = JsVariableDeclarationNode()
                decl.addChild(JsIdentifierNode(name: "a"))
                return decl
            }())
            // b = 1;
            try node.addChild({ 
                let decl = JsVariableDeclarationNode()
                decl.addChild(JsIdentifierNode(name: "b"))

                try decl.addChild({
                    let node = JsExpressionNode()
                    node.expression = try parser.parser.singleExpression()
                    return node
                }())

                return decl
            }())

            root.addChild(node)

            //// Act
            sut.collectIntentions(root)

            //// Assert
            XCTAssertEqual(file.globalVariableIntentions.count, 2)
            // a;
            try XCTAssertEqual(file.globalVariableIntentions[try: 0].name, "a")
            try XCTAssertEqual(
                file.globalVariableIntentions[try: 0].storage,
                ValueStorage(
                    type: .any,
                    ownership: .strong,
                    isConstant: false
                )
            )
            try XCTAssertNil(file.globalVariableIntentions[try: 0].initialValueIntention)
            try XCTAssertTrue(file.globalVariableIntentions[try: 0].source is JsVariableDeclarationNode)
            // b = 1;
            try XCTAssertEqual(file.globalVariableIntentions[try: 1].name, "b")
            try XCTAssertEqual(
                file.globalVariableIntentions[try: 1].storage,
                ValueStorage(
                    type: .any,
                    ownership: .strong,
                    isConstant: false
                )
            )
            try XCTAssertEqual(file.globalVariableIntentions[try: 1].initialValueIntention?.typedSource?.expression?.getText(), "1")
            try XCTAssertTrue(file.globalVariableIntentions[try: 1].source is JsVariableDeclarationNode)
        }
    }

    func testCollectClass() throws {
        // Arrange
        let root = JsGlobalContextNode()

        let classNode = JsClassNode()
        classNode.addChild(JsIdentifierNode(name: "A"))
        
        root.addChild(classNode)

        // Act
        sut.collectIntentions(root)

        // Assert
        XCTAssertEqual(file.classIntentions.count, 1)
        XCTAssertEqual(
            file.classIntentions.first?.typeName,
            "A"
        )
        XCTAssertTrue(file.classIntentions.first?.source is JsClassNode)
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
        XCTAssertTrue(file.classIntentions.first?.properties.first?.source is JsClassPropertyNode)
    }

    func testCollectStaticMethod() throws {
        // Arrange
        let root = JsGlobalContextNode()

        let classNode = JsClassNode()
        classNode.addChild(JsIdentifierNode(name: "AClass"))
        
        let methodNode = JsMethodDefinitionNode()
        methodNode.addChild(JsIdentifierNode(name: "method"))
        methodNode.signature = JsFunctionSignature()
        methodNode.isStatic = true

        classNode.addChild(methodNode)
        root.addChild(classNode)

        // Act
        sut.collectIntentions(root)

        // Assert
        XCTAssertTrue(try file.classIntentions[try: 0].methods[try: 0].isStatic)
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

    func testCollectGlobalVariableComments() throws {
        testCommentCollection(
            """
            // A comment
            // Another comment
            var a = 0;
            """,
            \FileGenerationIntention.globalVariableIntentions[0]
        )
    }

    func testCollectGlobalVariableComments_prependCommentsToFirstVariableDeclarationOnly() throws {
        //// Arrange
        let root = JsGlobalContextNode()

        let node = JsVariableDeclarationListNode(varModifier: .var)

        node.precedingComments =
            JsParser.parseComments(input: """
            // A comment
            // Another comment
            """)

        // a;
        node.addChild({ 
            let decl = JsVariableDeclarationNode()
            decl.addChild(JsIdentifierNode(name: "a"))
            return decl
        }())
        // b;
        node.addChild({ 
            let decl = JsVariableDeclarationNode()
            decl.addChild(JsIdentifierNode(name: "b"))
            return decl
        }())

        root.addChild(node)

        //// Act
        sut.collectIntentions(root)

        //// Assert
        // a;
        try XCTAssertEqual(
            file.globalVariableIntentions[try: 0].precedingComments, [
                "// A comment",
                "// Another comment",
            ]
        )
        // b = 1;
        try XCTAssertTrue(file.globalVariableIntentions[try: 1].precedingComments.isEmpty)
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

    var reportedForLazyParsing: [JavaScriptLazyParseItem] = []

    init(file: FileGenerationIntention) {
        context = JavaScriptIntentionCollector.Context()
        intentions = IntentionCollection()
        intentions.addIntention(file)

        context.pushContext(file)
    }

    // MARK: -

    func reportForLazyParsing(_ item: JavaScriptLazyParseItem) {
        reportedForLazyParsing.append(item)
    }
}

extension JavaScriptLazyParseItem: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case (.globalFunction(let lb, let li), .globalFunction(let rb, let ri)):
                return lb === rb && li === ri
            case (.method(let lb, let li), .method(let rb, let ri)):
                return lb === rb && li === ri
            case (.globalVar(let lb, let li), .globalVar(let rb, let ri)):
                return lb === rb && li === ri
            case (.classProperty(let lb, let li), .classProperty(let rb, let ri)):
                return lb === rb && li === ri
            default:
                return false
        }
    }
}
