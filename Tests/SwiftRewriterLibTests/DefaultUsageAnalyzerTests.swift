import XCTest
import SwiftRewriterLib
import SwiftAST
import TestCommons

class DefaultUsageAnalyzerTests: XCTestCase {
    func testFindMethodUsages() {
        let builder = IntentionCollectionBuilder()
        let body: CompoundStatement = [
            // B().b()
            .expression(
                Expression
                    .identifier("B").call()
                    .dot("b").call()
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") { method in
                            method.setBody(body)
                        }
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .createVoidMethod(named: "b")
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = DefaultUsageAnalyzer(intentions: intentions)
        let method = intentions.fileIntentions()[0].typeIntentions[1].methods[0]
        
        let usages = sut.findUsagesOf(method: method)
        
        XCTAssertEqual(usages[0].expression,
                       Expression
                        .identifier("B").call()
                        .dot("b"))
        
        XCTAssertEqual(usages.count, 1)
    }
    
    func testFindMethodUsagesWithRecursiveCall() {
        let builder = IntentionCollectionBuilder()
        
        let body: CompoundStatement = [
            // B().b().b()
            .expression(
                Expression
                    .identifier("B").call()
                    .dot("b").call()
                    .dot("b").call()
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") {method in
                            method.setBody(body)
                        }
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .createMethod(named: "b", returnType: .typeName("B"),
                                          parameters: [])
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = DefaultUsageAnalyzer(intentions: intentions)
        let method = intentions.fileIntentions()[0].typeIntentions[1].methods[0]
        
        let usages = sut.findUsagesOf(method: method)
        
        XCTAssertEqual(usages.count, 2)
    }
    
    func testFindPropertyUsages() {
        let builder = IntentionCollectionBuilder()
        
        let body: CompoundStatement = [
            // B().b()
            .expression(
                Expression
                    .identifier("B").call()
                    .dot("b").call()
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") {method in
                            method.setBody(body)
                        }
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .createProperty(named: "b", type: .int)
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = DefaultUsageAnalyzer(intentions: intentions)
        let property = intentions.fileIntentions()[0].typeIntentions[1].properties[0]
        
        let usages = sut.findUsagesOf(property: property)
        
        XCTAssertEqual(usages.count, 1)
    }
    
    func testFindEnumMemberUsage() {
        let builder = IntentionCollectionBuilder()
        
        let body: CompoundStatement = [
            // B.B_a
            .expression(
                Expression.identifier("B").dot("B_a")
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") {method in
                            method.setBody(body)
                        }
                    }
                    .createEnum(withName: "B", rawValue: .int) { builder in
                        builder.createCase(name: "B_a")
                    }
            }
        
        let intentions = builder.build(typeChecked: true)
        let sut = DefaultUsageAnalyzer(intentions: intentions)
        let property = intentions.fileIntentions()[0].enumIntentions[0].cases[0]
        
        let usages = sut.findUsagesOf(property: property)
        
        XCTAssertEqual(usages.count, 1)
    }
}
