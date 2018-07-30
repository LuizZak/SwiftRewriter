//
//  SwiftWriterTests.swift
//  SwiftRewriterLibTests
//
//  Created by Luiz Fernando Silva on 26/07/2018.
//

import XCTest
import ObjcParser
import SwiftAST
@testable import SwiftRewriterLib

class SwiftWriterTests: XCTestCase {
    
    var intentions: IntentionCollection!
    var output: TestSingleFileWriterOutput!
    var typeMapper: TypeMapper!
    var diagnostics: Diagnostics!
    var options: ASTWriterOptions!
    var sut: InternalSwiftWriter!
    var typeSystem: TypeSystem!
    
    override func setUp() {
        super.setUp()
        
        intentions = IntentionCollection()
        output = TestSingleFileWriterOutput()
        typeSystem = DefaultTypeSystem()
        typeMapper = DefaultTypeMapper(typeSystem: typeSystem)
        options = .default
        sut =
            InternalSwiftWriter(
                intentions: intentions,
                options: options,
                diagnostics: Diagnostics(),
                output: output,
                typeMapper: typeMapper,
                typeSystem: typeSystem)
    }

    func testWriteFailableInit() {
        let type = KnownTypeBuilder(typeName: "A").build()
        let initMethod = InitGenerationIntention(parameters: [])
        initMethod.isFailable = true
        initMethod.functionBody = FunctionBodyIntention(body: [])
        
        sut.outputInitMethod(initMethod, selfType: type, target: output.outputTarget())
        
        let expected = """
            @objc
            init?() {
            }
            """
        
        XCTAssertEqual(output.buffer.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
}
