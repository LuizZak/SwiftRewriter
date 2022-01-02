import ExpressionPasses
import GlobalsProviders
import GrammarModelBase
import IntentionPasses
import Intentions
import JsParser
import SourcePreprocessors
import SwiftAST
import SwiftSyntax
import SwiftSyntaxRewriterPasses
import SwiftSyntaxSupport
import TestCommons
import TypeSystem
import Utils
import WriterTargetOutput
import XCTest

@testable import JavaScriptFrontend

class JavaScript2SwiftRewriterJobTests: XCTestCase {
    func testTranspile() {
        let expectedSwift = """
            var globalVar: Any = 0

            func aFunction() -> Any {
                Hello.world()
            }
            // End of file Input.swift
            class Class {
                func method() {
                    Hello.world()
                }
            }
            // End of file Source.swift
            """
        let job =
            JavaScript2SwiftRewriterJob(
                input: MockInputSourcesProvider(),
                intentionPassesSource: MockIntentionPassSource(),
                astRewriterPassSources: MockExpressionPassesSource(),
                globalsProvidersSource: MockGlobalsProvidersSource(),
                syntaxRewriterPassSource: MockSwiftSyntaxRewriterPassProvider(),
                preprocessors: [MockSourcePreprocessor()],
                settings: .default,
                swiftSyntaxOptions: .default,
                parserCache: nil
            )
        let output = MockWriterOutput()

        let result = job.execute(output: output)

        let buffer = output.resultString()

        XCTAssert(result.succeeded)
        diffTest(expected: expectedSwift, highlightLineInEditor: false)
            .diff(buffer)
    }
}

private class MockWriterOutput: WriterOutput {
    var files: [MockOutput] = []
    let mutex = Mutex()

    func createFile(path: String) throws -> FileOutput {
        let output = MockOutput(filepath: path)
        mutex.locking {
            files.append(output)
        }

        return output
    }

    func resultString() -> String {
        return
            files
            .sorted { $0.filepath < $1.filepath }
            .map(\.buffer)
            .joined(separator: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private class MockOutput: FileOutput {
    var isClosed = false
    var filepath: String
    var buffer: String = ""

    init(filepath: String) {
        self.filepath = filepath
    }

    func close() {
        buffer += "\n// End of file \(filepath)"
        isClosed = true
    }

    func outputTarget() -> RewriterOutputTarget {
        let target = StringRewriterOutput()

        target.onChangeBuffer = { value in
            assert(!self.isClosed, "Tried to output to a closed file")

            self.buffer = value
        }

        return target
    }
}

private class MockInputSourcesProvider: InputSourcesProvider {
    var inputs: [MockInputSource] = [
        MockInputSource(
            source: """
                var globalVar = 0;
                """,
            path: "Input.js",
            isPrimary: true
        )
    ]

    func sources() -> [InputSource] {
        return inputs
    }
}

private struct MockInputSource: InputSource {
    var source: String
    var path: String
    var isPrimary: Bool

    func loadSource() throws -> CodeSource {
        return StringCodeSource(source: source, fileName: path)
    }

    func sourcePath() -> String {
        return path
    }
}

private class MockIntentionPassSource: IntentionPassSource {
    var intentionPasses: [IntentionPass] = [
        MockIntentionPass()
    ]
}

private class MockIntentionPass: IntentionPass {
    func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        let file = FileGenerationIntention(sourcePath: "Source.js", targetPath: "Source.swift")
        let cls = ClassGenerationIntention(typeName: "Class")
        cls.isInterfaceSource = false
        let method = MethodGenerationIntention(signature: FunctionSignature(name: "method"))
        method.functionBody = FunctionBodyIntention(body: [])
        cls.addMethod(method)
        file.addType(cls)

        intentionCollection.addIntention(file)
    }
}

private class MockExpressionPassesSource: ASTRewriterPassSource {
    var syntaxNodePasses: [ASTRewriterPass.Type] = [
        MockExpressionPasses.self
    ]
}

private final class MockExpressionPasses: ASTRewriterPass {
    override func apply(on statement: Statement, context: ASTRewriterPassContext) -> Statement {
        return
            CompoundStatement(statements: [
                Statement.expression(Expression.identifier("hello").dot("world").call())
            ])
    }
}

private class MockSourcePreprocessor: SourcePreprocessor {
    func preprocess(source: String, context: PreprocessingContext) -> String {
        if context.filePath == "Input.js" {
            return source + """

                function aFunction() {

                }
                """
        }

        return source
    }
}

private class MockGlobalsProvidersSource: GlobalsProvidersSource {
    var globalsProviders: [GlobalsProvider] = [
        MockGlobalsProviders()
    ]
}

private class MockGlobalsProviders: GlobalsProvider {

    func definitionsSource() -> DefinitionsSource {
        return ArrayDefinitionsSource(definitions: [])
    }

    func knownTypeProvider() -> KnownTypeProvider {
        return CollectionKnownTypeProvider(knownTypes: [])
    }

    func typealiasProvider() -> TypealiasProvider {
        return CollectionTypealiasProvider(aliases: [:])
    }

}

private class MockSwiftSyntaxRewriterPassProvider: SwiftSyntaxRewriterPassProvider {
    var passes: [SwiftSyntaxRewriterPass] = [
        RewriterPass()
    ]

    private class RewriterPass: SyntaxRewriter, SwiftSyntaxRewriterPass {
        func rewrite(_ file: SourceFileSyntax) -> SourceFileSyntax {
            return SourceFileSyntax(self.visit(file))!
        }

        override func visit(_ node: IdentifierExprSyntax) -> ExprSyntax {
            if node.identifier.text == "hello" {
                return ExprSyntax(
                    node.withIdentifier(node.identifier.withKind(.identifier("Hello")))
                )
            }

            return ExprSyntax(node)
        }
    }
}
