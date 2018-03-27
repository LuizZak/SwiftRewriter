import XCTest
import SwiftRewriterLib
import SwiftAST
import IntentionPasses
import TestCommons

class PropertyMergeIntentionPassTests: XCTestCase {
    func testMergeGetterAndSetter() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder
                        .createProperty(named: "a", type: .int)
                        .createMethod(named: "setA", parameters: [
                            ParameterSignature(label: "_", name: "a", type: .int)
                        ])
                        .createMethod(named: "a", returnType: .int)
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        switch cls.properties[0].mode {
        case .property:
            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
    
    // When merging a property with a setter (w/ no getter found), merge, but
    // produce a backing field to allow properly overriding the setter on the
    // type, and produce a default getter returning the backing field, as well.
    func testMergeSetterOverrideProducesBackingField() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder
                        .createProperty(named: "a", type: .int)
                        .createMethod(named: "setA", parameters: [
                            ParameterSignature(label: "_", name: "a", type: .int)
                        ])
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        XCTAssertEqual(cls.instanceVariables.count, 1)
        XCTAssertEqual(cls.instanceVariables[0].name, "_a")
        XCTAssertEqual(cls.instanceVariables[0].type, .int)
        switch cls.properties[0].mode {
        case let .property(getter, _):
            XCTAssertEqual(getter.body, [.return(.identifier("_a"))])
            
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
    
    func testMergeReadonlyWithGetter() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder
                        .createProperty(named: "a", type: .int,
                                        attributes: [.attribute("readonly")])
                        .createMethod(named: "a", returnType: .int)
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        switch cls.properties[0].mode {
        case .computed:
            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
    
    func testMergeReadonlyRespectsCustomizedGetterWithNonRelatedSetter() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder
                        .createInstanceVariable(named: "innerA", type: .int)
                        .createProperty(named: "a", type: .int,
                                        attributes: [.attribute("readonly")])
                        .createMethod(named: "a", returnType: .int) { method in
                            method.setBody([.return(.identifier("innerA"))])
                        }.createMethod(named: "setA",
                                       parameters: [
                                        ParameterSignature(label: "_", name: "a", type: .int)]) { method in
                                            method.setBody([
                                                .expression(
                                                    Expression
                                                        .identifier("innerA")
                                                        .assignment(op: .assign, rhs: .identifier("a")))
                                                ])
                                        }
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        switch cls.properties[0].mode {
        case let .property(getter, setter):
            XCTAssertEqual(getter.body, [.return(.identifier("innerA"))])
            XCTAssertEqual(setter.body.body, [
                .expression(
                    Expression
                        .identifier("innerA")
                        .assignment(op: .assign, rhs: .identifier("a")))
                ])
            
            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
    
    func testMergeInCategories() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createExtension(forClassNamed: "A") { builder in
                        builder
                            .createProperty(named: "a", type: .int, attributes: [.attribute("readonly")])
                            .createMethod(named: "a", returnType: .int)
                    }
                }.build()
        let cls = intentions.extensionIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        switch cls.properties[0].mode {
        case .computed:
            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
    
    // Checks if PropertyMergeIntentionPass properly records history entries on
    // the merged properties and the types the properties are contained within.
    func testHistoryTrackingMergingGetterSetterMethods() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { (builder) in
                    builder
                        .createProperty(named: "a", type: .int)
                        .createMethod(named: "a", returnType: .int)
                        .createMethod(named: "setA", parameters: [
                            ParameterSignature(label: "_", name: "a", type: .int)
                        ])
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(
            cls.history.summary,
            """
            [PropertyMergeIntentionPass:1] Removed method A.a() -> Int since deduced it is a getter for property A.a: Int
            [PropertyMergeIntentionPass:1] Removed method A.setA(_ a: Int) since deduced it is a setter for property A.a: Int
            """
        )
        XCTAssertEqual(
            cls.properties[0].history.summary,
            "[PropertyMergeIntentionPass:1] Merged A.a() -> Int and A.setA(_ a: Int) into property A.a: Int"
        )
    }
    
    func testSynthesizeBackingFieldWhenUsageOfBackingFieldIsDetected() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { (builder) in
                    builder
                        .createProperty(named: "a", type: .int)
                        .createVoidMethod(named: "b") { method in
                            method.setBody([
                                .expression(.assignment(lhs: .identifier("_a"), op: .assign, rhs: .constant(1)))
                            ])
                        }
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.instanceVariables.count, 1)
        XCTAssertEqual(cls.instanceVariables[0].name, "_a")
        XCTAssertEqual(cls.properties.count, 1)
        
        switch cls.properties[0].mode {
        case let .property(get, set):
            XCTAssertEqual(get.body, [.return(.postfix(.identifier("self"), .member("_a")))])
            XCTAssertEqual(set.valueIdentifier, "newValue")
            XCTAssertEqual(set.body.body, [.expression(.assignment(lhs: .postfix(.identifier("self"), .member("_a")),
                                                                   op: .assign,
                                                                   rhs: .identifier("newValue")))])
        default:
            XCTFail("Expected to synthesize getter/setter with backing field.")
        }
        
        XCTAssertEqual(
            cls.history.summary,
            """
            [PropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
            that the backing field of A.a: Int was being used inside the class.
            """
        )
        XCTAssertEqual(
            cls.properties[0].history.summary,
            """
            [PropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
            that the backing field of A.a: Int was being used inside the class.
            """
        )
    }
    
    /// If a property is marked as `readonly` in Objective-C, don't synthesize
    /// a setter during backing-field search
    func testSynthesizesReadOnlyBackingFieldIfPropertyIsReadOnly() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { (builder) in
                    builder
                        .createProperty(named: "a",
                                        type: .int,
                                        attributes: [.attribute("readonly")])
                        .createVoidMethod(named: "b") { method in
                            method.setBody([
                                .expression(
                                    .assignment(lhs: .identifier("_a"),
                                                op: .assign,
                                                rhs: .constant(1)))
                                ])
                    }
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.instanceVariables.count, 1)
        XCTAssertEqual(cls.instanceVariables.first?.name, "_a")
        XCTAssertEqual(cls.properties.count, 1)
        
        switch cls.properties.first?.mode {
        case .computed(let get)?:
            XCTAssertEqual(get.body, [.return(.postfix(.identifier("self"), .member("_a")))])
        default:
            XCTFail("Expected to synthesize getter/setter with backing field.")
        }
        
        XCTAssertEqual(
            cls.history.summary,
            """
            [PropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
            that the backing field of A.a: Int was being used inside the class.
            """
        )
        XCTAssertEqual(
            cls.properties[0].history.summary,
            """
            [PropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
            that the backing field of A.a: Int was being used inside the class.
            """
        )
    }
    
    /// Test that backing field usage detection can detect indirect references to
    /// the backing field by looking into member lookups for local variables that
    /// are the exact type as self (e.g. `strongSelf->_field`).
    func testSynthesizeBackingFieldOnIndirectReferences() {
        let sSelf = Expression.identifier("sSelf")
        sSelf.resolvedType = .typeName("A")
        
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { (builder) in
                    builder
                        .createProperty(named: "a",
                                        type: .int,
                                        attributes: [.attribute("readonly")])
                        .createVoidMethod(named: "b") { method in
                            method.setBody([
                                .variableDeclarations([
                                    StatementVariableDeclaration(identifier: "sSelf", type: .typeName("A"))]
                                ),
                                .expression(
                                    .assignment(lhs: sSelf.dot("_a"),
                                                op: .assign,
                                                rhs: .constant(1)))
                                ])
                        }
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.instanceVariables.count, 1)
        XCTAssertEqual(cls.instanceVariables.first?.name, "_a")
        XCTAssertEqual(cls.properties.count, 1)
        
        switch cls.properties.first?.mode {
        case .computed(let get)?:
            XCTAssertEqual(get.body, [.return(.postfix(.identifier("self"), .member("_a")))])
        default:
            XCTFail("Expected to synthesize getter/setter with backing field.")
        }
    }
    
    /// Test that local definitions that have the same name than a potential backing
    /// field are not confused with an actual backing field access.
    func testDoesntConfusesLocalVariableWithSynthesizedBackingField() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { (builder) in
                    builder
                        .createProperty(named: "a", type: .int)
                        .createVoidMethod(named: "b") { method in
                            method.setBody([
                                .variableDeclarations([
                                    StatementVariableDeclaration(identifier: "_a", type: .int)
                                ]),
                                .expression(.assignment(lhs: .identifier("_a"), op: .assign, rhs: .constant(1)))
                            ])
                    }
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        let context = makeContext(intentions: intentions)
        context.typeResolverInvoker.resolveAllExpressionTypes(in: intentions, force: true)
        
        sut.apply(on: intentions, context: context)
        
        XCTAssertEqual(cls.instanceVariables.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        
        switch cls.properties[0].mode {
        case .asField:
            // All good
            break
        default:
            XCTFail("Expected to not synthesize getter/setter with backing field.")
        }
        
        XCTAssertEqual(cls.history.summary, "<empty>")
        XCTAssertEqual(cls.properties[0].history.summary, "<empty>")
    }
    
    func testDontMergeInstancePropertyWithClassGetterSetterLikesAndViceVersa() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder
                        .createProperty(named: "a", type: .int, attributes: [.attribute("class")])
                        .createMethod(named: "a", returnType: .int)
                        .createMethod(named: "setA", parameters: [
                            ParameterSignature(label: "_", name: "a", type: .int)
                        ])
                        .createProperty(named: "b", type: .int)
                        .createMethod(named: "b", returnType: .int, isStatic: true)
                        .createMethod(named: "setB", parameters: [
                            ParameterSignature(label: "_", name: "a", type: .int)
                        ], isStatic: true)
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.methods.count, 4)
        XCTAssertEqual(cls.properties.count, 2)
        switch cls.properties[0].mode {
        case .asField:
            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
    
    func testMergesPropertyAndAccessorMethodsBetweenExtensionsWithinFile() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { (file) in
                    file.createClass(withName: "A") { type in
                            type.createProperty(named: "a", type: .int)
                        }.createExtension(forClassNamed: "A") { ext in
                            ext.createMethod(named: "a", returnType: .int)
                                .createMethod(named: "setA", parameters: [
                                    ParameterSignature(label: "_", name: "a", type: .int)
                                ])
                        }
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        switch cls.properties[0].mode {
        case .property:
            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
    
    func testMergesPropertyAndAccessorMethodsBetweenExtensionsAcrossFiles() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { (file) in
                    file.createClass(withName: "A") { type in
                        type.createProperty(named: "a", type: .int)
                    }
                }.createFile(named: "A+Ext.h") { (file) in
                    file.createExtension(forClassNamed: "A") { ext in
                        ext.createMethod(named: "a", returnType: .int)
                            .createMethod(named: "setA", parameters: [
                                ParameterSignature(label: "_", name: "a", type: .int)
                            ])
                    }
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        switch cls.properties[0].mode {
        case .property:
            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
    
    /// Tests a bug where the existence of another type extension would execute
    /// the analysis twice for the same type, resulting in overwriting of previous
    /// work.
    ///
    /// Make sure we analyze a class as a whole a single time only.
    func testDontOverwriteImplementationsWhileVisitingCategoriesOfType() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { (file) in
                    file.createClass(withName: "A") { type in
                        type.createProperty(named: "a", type: .int)
                            .createMethod(named: "a", returnType: .int) { member in
                                member.setBody([.expression(.identifier("test"))])
                            }
                            .createMethod(named: "setA",
                                          parameters: [ParameterSignature(label: "_", name: "a", type: .int)]) { member in
                                            member.setBody([.expression(.identifier("test"))])
                                        }
                        }.createExtension(forClassNamed: "A") { ext in
                            ext.createMethod(named: "work") { work in
                                work.setBody([
                                    .expression(
                                        Expression
                                            .identifier("self")
                                            .dot("_a")
                                    )
                                ])
                            }
                        }
                }.build()
        let cls = intentions.classIntentions()[0]
        let sut = PropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        switch cls.properties[0].mode {
        case let .property(getter, setter):
            
            XCTAssertEqual(getter.body, [.expression(.identifier("test"))])
            XCTAssertEqual(setter.body.body, [.expression(.identifier("test"))])
            
            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
}
