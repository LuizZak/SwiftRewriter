import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParserTests: XCTestCase {
    static var allTests = [
        ("testInit", testInit),
    ]
    
    func testInit() {
        _=ObjcParser(string: "abc")
    }
    
    func testParseComments() {
        let source = """
            // Test comment
            /*
                Test multi-line comment
            */
            """
        _=parserTest(source)
    }
    
    func testParseDeclarationAfterComments() {
        let source = """
            // Test comment
            /*
                Test multi-line comment
            */
            @interface MyClass
            @end
            """
        _=parserTest(source)
    }
    
    func testParserMaintainsOriginalRuleContext() {
        let source = """
            #import "abc.h"
            NS_ASSUME_NONNULL_BEGIN
            
            @interface MyClass : Superclass <Prot1, Prot2>
            {
                NSInteger myInt;
            }
            @property (nonatomic, getter=isValue) BOOL value;
            - (void)myMethod:(NSString*)param1;
            @end
            
            @interface MyClass (MyCategory)
            + (void)classMethod:(NSArray<NSObject*>*)anyArray;
            @end

            @implementation MyClass
            - (void)myMethod:(NSString*)param1 {
                for(int i = 0; i < 10; i++) {
                    NSLog(@"%@", i);
                }
            }
            + (void)classMethod:(NSArray<NSObject*>*)anyArray {
            }
            @end
            """
        
        let node = parserTest(source)
        
        let visitor = AnyASTVisitor(visit: { node in
            if node is InvalidNode {
                return
            }
            
            XCTAssertNotNil(node.sourceRuleContext, "\(node)")
        })
        
        let traverser = ASTTraverser(node: node, visitor: visitor)
        traverser.traverse()
    }
    
    private func parserTest(_ source: String) -> GlobalContextNode {
        let sut = ObjcParser(string: source)
        
        return _parseTestGlobalContextNode(source: source, parser: sut)
    }
    
    private func _parseTestGlobalContextNode(source: String, parser: ObjcParser, file: String = #file, line: Int = #line) -> GlobalContextNode {
        do {
            try parser.parse()
            return parser.rootNode
        } catch {
            recordFailure(withDescription: "Failed to parse test '\(source)': \(error)", inFile: #file, atLine: line, expected: false)
            fatalError()
        }
    }
}
