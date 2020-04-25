import XCTest
import Intentions
import TypeSystem
import ObjcParser
import SwiftSyntaxSupport
import SwiftAST
import KnownType
@testable import SwiftRewriterLib

class SwiftSyntaxWriterTests: XCTestCase {
    var sut: SwiftSyntaxWriter!
    var output: WriterOutput!
    var typeSystem: TypeSystem!
    
    override func setUp() {
        super.setUp()
        
        output = TestWriterOutput()
        typeSystem = TypeSystem()
        let provider = ArraySwiftSyntaxRewriterPassProvider(passes: [])
        let passApplier = SwiftSyntaxRewriterPassApplier(provider: provider)
        sut = SwiftSyntaxWriter(options: .default,
                                diagnostics: Diagnostics(),
                                output: output,
                                typeSystem: typeSystem,
                                syntaxRewriterApplier: passApplier)
    }
    
    func testShouldEmitTypeSignatureForOptionalInitializedVar() {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        let producer = SwiftSyntaxProducer()
        let storage = ValueStorage(type: .optional("A"),
                                   ownership: .strong,
                                   isConstant: false)
        
        let result =
            sut.swiftSyntaxProducer(producer,
                                    shouldEmitTypeFor: storage,
                                    intention: nil,
                                    initialValue: Expression.identifier("a").typed("A"))
        
        XCTAssertTrue(result)
    }
    
    func testShouldEmitTypeSignatureForWeakInitializedVar() {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        let producer = SwiftSyntaxProducer()
        let storage = ValueStorage(type: .optional("A"),
                                   ownership: .weak,
                                   isConstant: false)
        
        let result =
            sut.swiftSyntaxProducer(producer,
                                    shouldEmitTypeFor: storage,
                                    intention: nil,
                                    initialValue: Expression.identifier("a").typed("A"))
        
        XCTAssertFalse(result)
    }
    
    func testShouldEmitTypeSignatureForWeakInitializedVarOfBaseType() {
        let typeA = KnownTypeBuilder(typeName: "A").build()
        let typeB = KnownTypeBuilder(typeName: "B").settingSupertype(typeA).build()
        typeSystem.addType(typeA)
        typeSystem.addType(typeB)
        let producer = SwiftSyntaxProducer()
        let storage = ValueStorage(type: .optional("A"),
                                   ownership: .weak,
                                   isConstant: false)
        
        let result =
            sut.swiftSyntaxProducer(producer,
                                    shouldEmitTypeFor: storage,
                                    intention: nil,
                                    initialValue: Expression.identifier("b").typed("B"))
        
        XCTAssertTrue(result)
    }
}
