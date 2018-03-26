import XCTest
import SwiftRewriterLib
import IntentionPasses

class SwiftRewriter_IntentionPassTests: XCTestCase {
    func testIntentionPassHasExpressionTypesPreResolved() throws {
        class Globals: GlobalsProvider {
            func registerDefinitions(on globals: GlobalDefinitions) {
                
            }
            func registerTypes(in typeSink: KnownTypeSink) {
                let type = KnownTypeBuilder(typeName: "TestType").build()
                typeSink.addType(type)
            }
            func registerTypealiases(in typealiasSink: TypealiasSink) {
                
            }
        }
        class Pass: IntentionPass {
            var isTypeChecked = false
            
            func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
                isTypeChecked =
                    intentionCollection
                        .classIntentions().first!
                        .methods[0].functionBody!.body
                        .statements[0].asExpressions?
                        .expressions[0].resolvedType != nil
            }
        }
        
        let code = """
        @implementation A
        - (void)a {
            [self b];
        }
        - (NSInteger)b {
            return 0;
        }
        @end
        """
        let testInput = TestSingleInputProvider(code: code)
        let testOutput = TestSingleFileWriterOutput()
        
        let pass = Pass()
        
        let rewriter = SwiftRewriter(input: testInput, output: testOutput)
        rewriter.intentionPassesSource =
            ArrayIntentionPassSource(intentionPasses: [pass])
        
        try rewriter.rewrite()
        
        XCTAssert(pass.isTypeChecked)
    }
}
