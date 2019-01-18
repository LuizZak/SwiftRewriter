import XCTest
import SwiftSyntax
@testable import SwiftSyntaxSupport
import Intentions
import TestCommons
import Utils

class SwiftSyntaxProducerTests: XCTestCase {
    
    func testGenerateEmptyFile() {
        let file = FileGenerationIntention(sourcePath: "", targetPath: "")
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(result, matches: "")
    }
    
}

// MARK: - Global function generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithGlobalFunction() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "a") { builder in
                    builder.setBody([])
                    builder.createSignature(name: "a") { builder in
                        builder.addParameter(name: "test", type: .int)
                    }
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            func a(test: Int) {
            }
            """)
    }
}

// MARK: - Class Generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithEmptyClass() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            class A {
            }
            """)
    }
    
    func testGenerateFileWithEmptyClasses() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A")
                builder.createClass(withName: "B")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            class A {
            }
            class B {
            }
            """)
    }
    
    func testGenerateFileWithClassWithInheritance() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.inherit(from: "Supertype")
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            class A: Supertype {
            }
            """)
    }
    
    func testGenerateFileWithClassWithProtocolConformances() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createConformance(protocolName: "ProtocolA")
                    builder.createConformance(protocolName: "ProtocolB")
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            class A: ProtocolA, ProtocolB {
            }
            """)
    }
    
    func testGenerateFileWithClassWithProperty() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createProperty(named: "property", type: .int)
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            class A {
                var property: Int
            }
            """)
    }
    
    func testGenerateFileWithClassWithField() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createInstanceVariable(named: "ivarA", type: .int)
                }
        }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            class A {
                var ivarA: Int
            }
            """)
    }
    
    func testGenerateFileWithClassWithFieldAndProperty() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder
                        .createProperty(named: "propertyA", type: .int)
                        .createInstanceVariable(named: "ivarA", type: .int)
                }
        }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            class A {
                var ivarA: Int
            
                var propertyA: Int
            }
            """)
    }
    
    func testGenerateFileWithClassWithInit() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createConstructor()
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            class A {
                init()
            }
            """)
    }
    
}

// MARK: - Struct Generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithStruct() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createStruct(withName: "A")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            struct A {
            }
            """)
    }
}

// MARK: - Protocol Generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithProtocol() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createProtocol(withName: "A")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assertSwiftSyntax(
            result,
            matches: """
            protocol A {
            }
            """)
    }
}

extension SwiftSyntaxProducerTests {
    func assertSwiftSyntax(_ node: Syntax, matches expected: String, line: Int = #line) {
        if node.description != expected {
            let diff = node.description.makeDifferenceMarkString(against: expected)
            
            recordFailure(
                withDescription: """
                Expected to produce file matching:
                
                \(expected)
                
                But found:
                
                \(node.description)
                
                Diff:
                
                \(diff)
                """,
                inFile: #file,
                atLine: line,
                expected: true
            )
        }
    }
}
