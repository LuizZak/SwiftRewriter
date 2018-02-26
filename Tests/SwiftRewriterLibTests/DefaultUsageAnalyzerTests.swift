import XCTest
import SwiftRewriterLib
import SwiftAST

class DefaultUsageAnalyzerTests: XCTestCase {
    func testFindMethodUsages() {
        let builder = IntentionCollectionBuilder()
        
        let body: CompoundStatement = [
            // B().b()
            .expression(
                .postfix(
                    .postfix(
                        .postfix(
                            .identifier("B"),
                            .functionCall(arguments: [])
                        ),
                        .member("b")
                    ),
                    .functionCall(arguments: [])
                )
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") {
                            return body
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
        let property = intentions.fileIntentions()[0].typeIntentions[1].methods[0]
        
        let usages = sut.findUsages(of: property)
        
        XCTAssertEqual(usages.count, 1)
    }
    
    func testFindPropertyUsages() {
        let builder = IntentionCollectionBuilder()
        
        let body: CompoundStatement = [
            // B().b()
            .expression(
                .postfix(
                    .postfix(
                        .identifier("B"),
                        .functionCall(arguments: [])
                    ),
                    .member("b")
                )
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") {
                            return body
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
        
        let usages = sut.findUsages(of: property)
        
        XCTAssertEqual(usages.count, 1)
    }
}
