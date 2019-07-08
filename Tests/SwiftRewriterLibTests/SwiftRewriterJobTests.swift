import XCTest
import SwiftAST
import Intentions
import IntentionPasses
import ExpressionPasses
import SourcePreprocessors
import GlobalsProviders
import SwiftRewriterLib
import TypeSystem
import WriterTargetOutput
import ObjcParser
import Utils

class SwiftRewriterJobTests: XCTestCase {
    func testTranspile() {
        let expectedSwift = """
            class BaseClass: NSObject {
            }
            class PreprocessedClass: NSObject {
            }
            // End of file Input.swift
            class Class {
                func method() {
                    hello.world()
                }
            }
            // End of file Source.swift
            """
        let job =
            SwiftRewriterJob(input: MockInputSourcesProvider(),
                             intentionPassesSource: MockIntentionPassSource(),
                             astRewriterPassSources: MockExpressionPassesSource(),
                             globalsProvidersSource: MockGlobalsProvidersSource(),
                             preprocessors: [MockSourcePreprocessor()],
                             settings: .default,
                             swiftSyntaxOptions: .default)
        let output = MockWriterOutput()
        
        let result = job.execute(output: output)
        
        let buffer = output.resultString()
        XCTAssert(result.succeeded)
        XCTAssertEqual(
            buffer,
            expectedSwift,
            """
            
            Diff:
            
            \(expectedSwift.makeDifferenceMarkString(against: buffer))
            """)
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
        return files
            .sorted { $0.filepath < $1.filepath }
            .map { $0.buffer }
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
            @interface BaseClass : NSObject
            @end
            """,
            path: "Input.m")
    ]
    
    func sources() -> [InputSource] {
        return inputs
    }
}

private struct MockInputSource: InputSource {
    var source: String
    var path: String
    
    func loadSource() throws -> CodeSource {
        return StringCodeSource(source: source, fileName: path)
    }
    
    func sourceName() -> String {
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
        let file = FileGenerationIntention(sourcePath: "Source.m", targetPath: "Source.swift")
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
        if context.filePath == "Input.m" {
            return source +
            """
            
            @interface PreprocessedClass : NSObject
            @end
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
