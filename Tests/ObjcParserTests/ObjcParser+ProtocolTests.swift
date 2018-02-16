import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParser_ProtocolTests: XCTestCase {
    
    func testParseEmptyProtocol() throws {
        let source = """
            @protocol MyProtocol
            @end
            """
        let sut = ObjcParser(string: source)
        
        let prot = _parseTestProtocolNode(source: source, parser: sut)
        
        XCTAssertEqual(prot.identifier?.name, "MyProtocol")
        XCTAssertEqual(sut.diagnostics.errors.count, 0, sut.diagnostics.errors.description)
    }
    
    func testParseProtocolWithMethod() throws {
        let source = """
            @protocol MyProtocol
            - (void)aMethod;
            @end
            """
        let sut = ObjcParser(string: source)
        
        let prot = _parseTestProtocolNode(source: source, parser: sut)
        
        XCTAssertEqual(prot.identifier?.name, "MyProtocol")
        XCTAssertEqual(prot.methods[0].methodSelector?.selector.identifier?.name, "aMethod")
        XCTAssertEqual(sut.diagnostics.errors.count, 0, sut.diagnostics.errors.description)
    }
    
    func testParseProtocolWithProtocolList() throws {
        let source = """
            @protocol MyProtocol <MyProtocol1, MyProtocol2>
            @end
            """
        let sut = ObjcParser(string: source)
        
        let result = _parseTestProtocolNode(source: source, parser: sut)
        
        XCTAssertEqual(result.protocolList?.protocols.count, 2)
        XCTAssertEqual(result.protocolList?.protocols[0].name, "MyProtocol1")
        XCTAssertEqual(result.protocolList?.protocols[1].name, "MyProtocol2")
        XCTAssertEqual(sut.diagnostics.errors.count, 0, sut.diagnostics.errors.description)
    }
    
    private func _parseTestProtocolNode(source: String, parser: ObjcParser, file: String = #file, line: Int = #line) -> ProtocolDeclaration {
        do {
            let root: GlobalContextNode =
                try parser.withTemporaryContext {
                    try parser.parseProtocol()
            }
            
            let node: ProtocolDeclaration? = root.firstChild()
            return node!
        } catch {
            recordFailure(withDescription: "Failed to parse test '\(source)': \(error)", inFile: #file, atLine: line, expected: false)
            fatalError()
        }
    }
}
