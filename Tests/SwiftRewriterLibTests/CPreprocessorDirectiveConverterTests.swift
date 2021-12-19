import XCTest
import Intentions
import TypeSystem
import SwiftAST
import SwiftRewriterLib

class CPreprocessorDirectiveConverterTests: XCTestCase {
    var file: FileGenerationIntention!
    var sut: CPreprocessorDirectiveConverter!
    var typeSystem: IntentionCollectionTypeSystem!
    var typeResolverInvoker: DefaultTypeResolverInvoker!
    
    override func setUp() {
        super.setUp()
        
        file = FileGenerationIntention(sourcePath: "A.h", targetPath: "A.swift")
        
        let intentionCollection = IntentionCollection()
        intentionCollection.addIntention(file)
        
        typeSystem = IntentionCollectionTypeSystem(intentions: intentionCollection)
        
        typeResolverInvoker =
            DefaultTypeResolverInvoker(globals: ArrayDefinitionsSource(definitions: []),
                                       typeSystem: typeSystem,
                                       numThreads: 1)
        
        sut = CPreprocessorDirectiveConverter(parserStatePool: ObjcParserStatePool(),
                                             typeSystem: typeSystem,
                                             typeResolverInvoker: typeResolverInvoker)
    }
    
    func testConvertIntConstant() {
        let result = sut.convert(directive: "#define CONSTANT 1", inFile: file)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.type, .int)
        XCTAssertEqual(result?.expression, .constant(1))
    }
    
    func testConvertBoolConstant() {
        let result = sut.convert(directive: "#define CONSTANT true", inFile: file)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.type, .bool)
        XCTAssertEqual(result?.expression, .constant(true))
    }
    
    func testConvertStringConstant() {
        let result = sut.convert(directive: "#define CONSTANT \"A constant\"", inFile: file)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.type, .string)
        XCTAssertEqual(result?.expression, .constant("A constant"))
    }
    
    func testConvertBinaryExpression() {
        let result = sut.convert(directive: "#define CONSTANT 1 + 1", inFile: file)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.type, .int)
        XCTAssertEqual(result?.expression, Expression.constant(1).binary(op: .add, rhs: .constant(1)))
    }
    
    func testConvertScalarTypeCasts() {
        let result = sut.convert(directive: "#define CONSTANT (unsigned int)1", inFile: file)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.type, .optional("CUnsignedInt"))
        XCTAssertEqual(result?.expression, Expression.cast(.constant(1), type: "CUnsignedInt"))
    }
    
    func testConvertSymbolReferencingExistingDeclarations() {
        let v = GlobalVariableGenerationIntention(name: "symbol", type: .int)
        file.addGlobalVariable(v)
        typeResolverInvoker.refreshIntentionGlobals()
        
        let result = sut.convert(directive: "#define CONSTANT symbol", inFile: file)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.type, .int)
        XCTAssertEqual(result?.expression, Expression.identifier("symbol"))
    }
    
    func testConvertSizeofExpressions() {
        let result = sut.convert(directive: "#define CONSTANT sizeof(int)", inFile: file)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.type, "Int")
        XCTAssertEqual(result?.expression, Expression.sizeof(type: "CInt"))
    }
    
    func testConvertNilConstant() {
        let result = sut.convert(directive: "#define CONSTANT nil", inFile: file)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.type, .optional("AnyObject"))
        XCTAssertEqual(result?.expression, .constant(.nil))
    }
    
    func testDontConvertUnevenExpressions() {
        let result = sut.convert(directive: "#define CONSTANT (1", inFile: file)
        
        XCTAssertNil(result)
    }
    
    func testDontConvertExpressionsReferencingUnknownSymbols() {
        let result = sut.convert(directive: "#define CONSTANT SYMBOL", inFile: file)
        
        XCTAssertNil(result)
    }
    
    func testDontConvertInvalidBinaryExpression() {
        let result = sut.convert(directive: "#define CONSTANT \"1\" + 1", inFile: file)
        
        XCTAssertNil(result)
    }
    
    func testDontConvertMacrosWithParameters() {
        let result = sut.convert(directive: "#define MACRO(c) 1", inFile: file)
        
        XCTAssertNil(result)
    }
    
    func testDontConvertNonScalarTypeCasts() {
        let result = sut.convert(directive: "#define MACRO (UnknownType)1", inFile: file)
        
        XCTAssertNil(result)
    }
}
