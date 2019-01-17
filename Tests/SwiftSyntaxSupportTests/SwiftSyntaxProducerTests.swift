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
