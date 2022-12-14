import SwiftAST
import SwiftRewriterLib
import TestCommons
import XCTest
import IntentionPasses

@testable import ObjectiveCFrontend

class ObjectiveCObjectiveCPropertyMergeIntentionPassTests: XCTestCase {
    func testMergeGetterAndSetter() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.ext_makePropertyWithGetterSetter(named: "a")
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertIsEmpty()
            type[\.properties].assertCount(1)
            type[\.properties][0]?.assertIsPropertyMode()
        }
    }

    /// Test that property merging checks for typealiases while checking if accessor
    /// types match.
    func testMergeGetterAndSetterWithTypeAliases() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "Aliases") { type in
                    type.createTypealias(withName: "AliasedInt", type: .typeName("NSInteger"))
                        .createTypealias(withName: "OtherAliasedInt", type: .typeName("NSInteger"))
                }
                .createFileWithClass(named: "A") { type in
                    type.createProperty(named:  "a", type: .int)
                        .createMethod(named: "a", returnType: .typeName("AliasedInt"))
                        .createMethod(named: "setA", parameters: [ParameterSignature(label: nil, name: "a", type: .typeName("OtherAliasedInt"))])
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertIsEmpty()
            type[\.properties].assertCount(1)
            type[\.properties][0]?.assertIsPropertyMode()
        }
    }

    /// Tests that when merging property accessors we check that the accessor
    /// typing matches the property's before merging
    func testDontMergeGetterAndSetterWithDifferentTypes() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createProperty(named:  "a", type: .int)
                        .createMethod(named: "a", returnType: .string)
                        .createMethod(named: "setA", returnType: .cgFloat)
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(2)
            type[\.properties].assertCount(1)
            type[\.properties][0]?.assertIsStoredFieldMode()
        }
    }

    // When merging a property with a setter (w/ no getter found), merge, but
    // produce a backing field to allow properly overriding the setter on the
    // type, and produce a default getter returning the backing field, as well.
    func testMergeSetterOverrideProducesBackingField() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.ext_makePropertyWithSetter(named: "a", type: .int)
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(0)
            type[\.instanceVariables].assertCount(1)
            type[\.instanceVariables][0]?.assert(name: "_a")
            type[\.instanceVariables][0]?.assert(type: .int)
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsPropertyMode()?
                .assert(getterBody: [
                    .return(.identifier("_a"))
                ])
        }
    }

    func testMergeReadonlyWithGetter() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { builder in
                builder.ext_makeReadonlyPropertyWithGetter(named: "a")
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

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

        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?.assertIsComputedMode()
        }
    }
    
    /// Make sure when merging properties we respect the getter and setter bodies,
    /// in case of readonly properties which feature candidate getter and setters.
    func testMergeReadonlyRespectsCustomizedGetterWithNonRelatedSetter() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder
                        .createInstanceVariable(named: "innerA", type: .int)
                        .createProperty(named: "a", type: .int,
                                        objcAttributes: [.attribute("readonly")])
                        .createMethod(named: "a", returnType: .int) { method in
                            method.setBody([
                                .return(.identifier("innerA"))
                            ])
                        }.createMethod(named: "setA",
                                       parameters: [
                                        ParameterSignature(label: nil, name: "a", type: .int)]) { method in
                            method.setBody([
                                .expression(
                                    Expression
                                        .identifier("innerA")
                                        .assignment(op: .assign, rhs: .identifier("a")))
                                ])
                        }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsPropertyMode()?
                .assert(getterBody: [
                    .return(.identifier("innerA"))
                ])?
                .assert(setterBody: [
                    .expression(
                        .identifier("innerA")
                        .assignment(op: .assign, rhs: .identifier("a"))
                    )
                ])
        }
    }

    func testMergeInCategories() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A")
                        .createExtension(forClassNamed: "A") { builder in
                            builder
                                .ext_makeReadonlyPropertyWithGetter(named: "a")
                        }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassExtensionNamed: "A") { type in
            type[\.methods].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?.assertIsComputedMode()
        }
    }

    // Checks if ObjectiveCPropertyMergeIntentionPass properly records history entries on
    // the merged properties and the types the properties are contained within.
    func testHistoryTrackingMergingGetterSetterMethods() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { (builder) in
                    builder.ext_makePropertyWithGetterSetter(named: "a")
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assert(historySummary:
                """
                [ObjectiveCPropertyMergeIntentionPass:1] Removed method A.a() -> Int since deduced it is a getter for property A.a: Int
                [ObjectiveCPropertyMergeIntentionPass:1] Removed method A.setA(_ a: Int) since deduced it is a setter for property A.a: Int
                """
            )
            type[\.properties].assertCount(1)
            type[\.properties][0]?.assert(historySummary:
                "[ObjectiveCPropertyMergeIntentionPass:1] Merged A.a() -> Int and A.setA(_ a: Int) into property A.a: Int"
            )
        }
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
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assert(historySummary:
                """
                [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
                that the backing field of A.a: Int (_a) was being used in A.b().
                """
            )
            type[\.methods].assertCount(1)
            type[\.instanceVariables].assertCount(1)
            type[\.instanceVariables][0]?.assert(name: "_a")
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assert(getterBody: [
                    .return(.identifier("self").dot("_a"))
                ])?
                .assert(setterValueIdentifier: "newValue")?
                .assert(setterBody: [
                    .expression(
                        .identifier("self").dot("_a").assignment(
                            op: .assign,
                            rhs: .identifier("newValue")
                        )
                    )
                ])?
                .assert(historySummary:
                    """
                    [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
                    that the backing field of A.a: Int (_a) was being used in A.b().
                    """
                )
        }
    }
    
    func testSynthesizeBackingFieldWhenUsageOfBackingFieldIsDetectedInDeinit() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { (builder) in
                    builder
                        .createProperty(named: "a", type: .int)
                        .createDeinit { method in
                            method.setBody([
                                .expression(.assignment(lhs: .identifier("_a"), op: .assign, rhs: .constant(1)))
                            ])
                        }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assert(historySummary:
                """
                [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
                that the backing field of A.a: Int (_a) was being used in A.deinit.
                """
            )
            type[\.instanceVariables].assertCount(1)
            type[\.instanceVariables][0]?.assert(name: "_a")
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assert(getterBody: [
                    .return(.identifier("self").dot("_a"))
                ])?
                .assert(setterValueIdentifier: "newValue")?
                .assert(setterBody: [
                    .expression(
                        .identifier("self").dot("_a").assignment(
                            op: .assign,
                            rhs: .identifier("newValue")
                        )
                    )
                ])?
                .assert(historySummary:
                    """
                    [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
                    that the backing field of A.a: Int (_a) was being used in A.deinit.
                    """
                )
        }
    }
    
    /// If a property is marked as `readonly` in Objective-C, don't synthesize
    /// a setter during backing-field search
    func testSynthesizesReadOnlyBackingFieldIfPropertyIsReadOnly() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { (builder) in
                builder
                    .createProperty(
                        named: "a",
                        type: .int,
                        objcAttributes: [.attribute("readonly")]
                    )
                    .createVoidMethod(named: "b") { method in
                        method.setBody([
                            .expression(
                                .assignment(
                                    lhs: .identifier("_a"),
                                    op: .assign,
                                    rhs: .constant(1)
                                )
                            )
                        ])
                    }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assert(historySummary:
                """
                [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
                that the backing field of A.a: Int (_a) was being used in A.b().
                """
            )
            type[\.instanceVariables].assertCount(1)
            type[\.instanceVariables][0]?.assert(name: "_a")
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsComputedMode()?
                .assert(getterBody: [
                    .return(.identifier("self").dot("_a"))
                ])?
                .assert(historySummary:
                    """
                    [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
                    that the backing field of A.a: Int (_a) was being used in A.b().
                    """
                )
        }
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
                                        objcAttributes: [.attribute("readonly")])
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
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assert(historySummary:
                """
                [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
                that the backing field of A.a: Int (_a) was being used in A.b().
                """
            )
            type[\.instanceVariables].assertCount(1)
            type[\.instanceVariables][0]?.assert(name: "_a")
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsComputedMode()?
                .assert(getterBody: [
                    .return(.identifier("self").dot("_a"))
                ])?
                .assert(historySummary:
                    """
                    [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
                    that the backing field of A.a: Int (_a) was being used in A.b().
                    """
                )
        }
    }

    /// Tests that usage of backing field in category extensions are properly
    /// detected and managed
    func testSynthesizeBackingFieldInCategoryExtensions() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createClass(withName: "A") { type in
                            type.createProperty(named: "a", type: .int)
                        }.createExtension(forClassNamed: "A") { type in
                            type.createMethod(named: "method") { method in
                                method.setBody([
                                    .expression(Expression.identifier("self").dot("_a"))
                                ])
                            }
                        }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assert(historySummary:
                """
                [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
                that the backing field of A.a: Int (_a) was being used in A.method().
                """
            )
            type[\.instanceVariables].assertCount(1)
            type[\.instanceVariables][0]?.assert(name: "_a")
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsPropertyMode()?
                .assert(getterBody: [
                    .return(.identifier("self").dot("_a"))
                ])?
                .assert(setterBody: [
                    .expression(
                        .postfix(.identifier("self"), .member("_a")).assignment(
                            op: .assign,
                            rhs: .identifier("newValue")
                        )
                    )
                ])?
                .assert(historySummary:
                    """
                    [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
                    that the backing field of A.a: Int (_a) was being used in A.method().
                    """
                )
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
                            .expression(
                                .assignment(lhs: .identifier("_a"), op: .assign, rhs: .constant(1))
                            ),
                        ])
                    }
                }.build()
        
        let sut = ObjectiveCPropertyMergeIntentionPass()
        let context = makeContext(intentions: intentions)
        context.typeResolverInvoker.resolveAllExpressionTypes(in: intentions, force: true)

        sut.apply(on: intentions, context: context)
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assertIsHistoryEmpty()

            type[\.instanceVariables].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsStoredFieldMode()?
                .assertIsHistoryEmpty()
        }
    }

    /// Test that we don't perform type merging when properties and methods don't
    /// match statically-wise (i.e. property is class type, method is instance type,
    /// etc.)
    func testDontMergeInstancePropertyWithClassGetterSetterLikesAndViceVersa() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { builder in
                builder
                    .createProperty(named: "a", type: .int, objcAttributes: [.attribute("class")])
                    .createMethod(named: "a", returnType: .int)
                    .createMethod(
                        named: "setA",
                        parameters: [
                            ParameterSignature(label: nil, name: "a", type: .int)
                        ]
                    )
                    .createProperty(named: "b", type: .int)
                    .createMethod(named: "b", returnType: .int, isStatic: true)
                    .createMethod(
                        named: "setB",
                        parameters: [
                            ParameterSignature(label: nil, name: "a", type: .int)
                        ], isStatic: true)
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assertIsHistoryEmpty()

            type[\.methods].assertCount(4)
            type[\.instanceVariables].assertCount(0)
            type[\.properties].assertCount(2)
            type[\.properties][0]?
                .assertIsStoredFieldMode()?
                .assertIsHistoryEmpty()
            type[\.properties][1]?
                .assertIsStoredFieldMode()?
                .assertIsHistoryEmpty()
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
                                    ParameterSignature(label: nil, name: "a", type: .int)
                                ])
                        }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assertIsHistoryEmpty()

            type[\.methods].assertCount(0)
            type[\.instanceVariables].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsPropertyMode()?
                .assert(historySummary:
                    "[ObjectiveCPropertyMergeIntentionPass:1] Merged A.a() -> Int and A.setA(_ a: Int) into property A.a: Int"
                )
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
                        .createMethod(
                            named: "setA",
                            parameters: [
                                ParameterSignature(label: nil, name: "a", type: .int)
                            ])
                    }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assertIsHistoryEmpty()

            type[\.methods].assertCount(0)
            type[\.instanceVariables].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsPropertyMode()?
                .assert(historySummary:
                    "[ObjectiveCPropertyMergeIntentionPass:1] Merged A.a() -> Int and A.setA(_ a: Int) into property A.a: Int"
                )
        }
    }

    /// Tests a bug where the existence of a type extension would trigger the
    /// analysis twice for the same type, resulting in overwriting of previous
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
                                          parameters: [ParameterSignature(label: nil, name: "a", type: .int)]) { member in
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
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assert(historySummary:
                """
                [ObjectiveCPropertyMergeIntentionPass:1] Removed method A.a() -> Int since deduced it is a getter for property A.a: Int
                [ObjectiveCPropertyMergeIntentionPass:1] Removed method A.setA(_ a: Int) since deduced it is a setter for property A.a: Int
                """
            )

            type[\.methods].assertCount(0)
            type[\.instanceVariables].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsPropertyMode()?
                .assert(getterBody: [
                    .expression(.identifier("test"))
                ])?
                .assert(setterBody: [
                    .expression(.identifier("test"))
                ])?
                .assert(historySummary:
                    "[ObjectiveCPropertyMergeIntentionPass:1] Merged A.a() -> Int and A.setA(_ a: Int) into property A.a: Int"
                )
        }
    }

    /// If a property is declared along with `@synthesize`'s and accessor methods,
    /// ensure that we don't get confused and overwrite implementations accidentally.
    func testPropertyMergingRespectsExistingPropertySynthesization() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createClass(withName: "A") { type in
                        type.createInstanceVariable(named: "backing", type: .int)
                            .createProperty(named: "a", type: .int)
                            .createMethod(named: "setA", parameters: [ParameterSignature(label: nil, name: "a", type: .int)]) { method in
                                method.setBody([
                                    // self.backing = a
                                    .expression(
                                        Expression
                                            .identifier("self").dot("backing")
                                            .assignment(op: .assign, rhs: .identifier("a"))
                                    )
                                ])
                            }.createSynthesize(propertyName: "a", variableName: "backing")
                    }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assert(historySummary:
                "[ObjectiveCPropertyMergeIntentionPass:1] Merged found setter method A.setA(_ a: Int) into property A.a: Int and creating a getter body returning existing backing field backing"
            )

            type[\.methods].assertCount(0)
            type[\.instanceVariables].assertCount(1) // Shouldn't synthesize backing field since we already provide a backing field to use
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsPropertyMode()?
                .assert(getterBody: [
                    // return backing
                    .return(.identifier("backing"))
                ])?
                .assert(setterBody: [
                    // self.backing = a
                    .expression(
                        .identifier("self").dot("backing")
                            .assignment(
                                op: .assign,
                                rhs: .identifier("a")
                            )
                    )
                ])?
                .assert(historySummary:
                    "[ObjectiveCPropertyMergeIntentionPass:1] Merged found setter method A.setA(_ a: Int) into property A.a: Int and creating a getter body returning existing backing field backing"
                )
        }
    }

    /// Tests that when examining method bodies for backing field usages we take
    /// into account any existing `@synthesize` declarations for the property and
    /// use the resulting name for the usage lookup.
    func testCreateBackingFieldIfUsageIsFoundTakingIntoAccountSynthesizationDeclarations() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createProperty(named: "a", type: .int)
                    .createSynthesize(propertyName: "a", variableName: "b")
                    .createMethod(named: "method") { method in
                        method.setBody([
                            .expression(Expression.identifier("self").dot("b"))
                        ])
                    }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assert(historySummary:
                "[ObjectiveCPropertyMergeIntentionPass:1] Created field A.b: Int as it was detected that the backing field of A.a: Int (b) was being used in A.method()."
            )

            type[\.methods].assertCount(1)
            type[\.instanceVariables].assertCount(1)
            type[\.properties].assertCount(1)
            type[\.properties][0]?
                .assertIsPropertyMode()?
                .assert(getterBody: [
                    .return(.identifier("self").dot("b"))
                ])?
                .assert(setterBody: [
                    .expression(
                        .identifier("self").dot("b")
                            .assignment(
                                op: .assign,
                                rhs: .identifier("newValue")
                            )
                    )
                ])?
                .assert(historySummary:
                    "[ObjectiveCPropertyMergeIntentionPass:1] Created field A.b: Int as it was detected that the backing field of A.a: Int (b) was being used in A.method()."
                )
        }
    }
    
    /// Tests that when examining method bodies for backing field usages we take
    /// into account any existing `@synthesize` declarations for the property and
    /// use the resulting name for the usage lookup (take 2; avoiding creating
    /// backing fields for mistaken backing field lookups).
    func testDontCreateBackingFieldIfExplicitSynthesizeDeclarationNamesAnotherBackingField() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createProperty(named: "a", type: .int)
                    .createSynthesize(propertyName: "a", variableName: "b")
                    .createMethod(named: "method") { method in
                        method.setBody([
                            .expression(Expression.identifier("self").dot("_a"))
                        ])
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.instanceVariables.count, 0)
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type.assertIsHistoryEmpty()

            type[\.methods].assertCount(1)
            type[\.instanceVariables].assertCount(0)
        }
    }
    
    /// Tests that when examining method bodies for backing field usages we take
    /// into account any existing `@synthesize` declarations for the property and
    /// use the resulting name for the usage lookup (take 3; avoiding creating
    /// backing fields for mistaken backing field lookups in category extensions
    /// when the category is found before the original nominal type declaration).
    func
        testDontCreateBackingFieldIfExplicitSynthesizeDeclarationNamesAnotherBackingField_AcrossCategories()
    {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createExtension(forClassNamed: "A") { type in
                        type.createMethod(named: "setA", parameters: [ParameterSignature(label: nil, name: "a", type: .int)]) { method in
                            method.setBody([
                                .expression(Expression
                                    .identifier("self")
                                    .dot("b")
                                    .assignment(op: .assign, rhs: .identifier("a"))
                                )
                            ])
                        }
                    }.createClass(withName: "A") { type in
                        type.createProperty(named: "a", type: .int)
                            .createSynthesize(propertyName: "a", variableName: "b")
                    }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions)
            .asserter(forClassExtensionNamed: "A") { type in
                type[\.instanceVariables].assertCount(0)
            }?
            .asserter(forClassNamed: "A") { type in
                type[\.instanceVariables].assertCount(1)
                type[\.instanceVariables][0]?
                    .assert(name: "b")?
                    .assert(type: .int)
            }
    }
    
    /// Tests that when looking for explicit usages of backing fields for properties
    /// we ignore any property that has a backing field matching the property's
    /// name on a `@synthesize` declaration.
    func
        testDontCreateBackingFieldIfExplicitSynthesizeDeclarationPointsInstanceVariableWithSameNameAsProperty()
    {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createProperty(named: "a", type: .int, objcAttributes: [.readonly])
                    .createSynthesize(propertyName: "a", variableName: "a")
                    .createMethod(named: "method") { method in
                        method.setBody([
                            .expression(Expression.identifier("self").dot("a"))
                        ])
                    }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions) .asserter(forClassNamed: "A") { type in
            type[\.instanceVariables].assertCount(0)
            type[\.properties][0]?
                .assert(setterAccessLevel: .private)?
                .assertIsStoredFieldMode()
        }
    }

    /// When detecting a `@synthesize` for a (settable) property with the same
    /// name as the property, the setter access level must be erased to its default
    /// value.
    func testErasesAccessLevelWhenDealingWithSettableSynthesizedProperty() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createProperty(named: "a", type: .int)
                    .createSynthesize(propertyName: "a", variableName: "a")
                    .createMethod(named: "method") { method in
                        method.setBody([
                            .expression(Expression.identifier("self").dot("a"))
                        ])
                    }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions) .asserter(forClassNamed: "A") { type in
            type[\.instanceVariables].assertCount(0)
            type[\.properties][0]?
                .assert(setterAccessLevel: nil)?
                .assertIsStoredFieldMode()
        }
    }

    /// Tests that when we merge properties which have setters in a separate
    /// category, that we don't accidentally create a duplicated variable
    func testMergePropertyWithSetterInCategory() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A+Ext.m") { file in
                file.createExtension(forClassNamed: "A") { type in
                    type.createMethod(
                        named: "setA",
                        parameters: [ParameterSignature(label: nil, name: "a", type: .int)]
                    ) { method in
                        method.setBody([
                            .expression(
                                Expression.identifier("self").dot("b").assignment(
                                    op: .assign,
                                    rhs: .identifier("a")
                                )
                            )
                        ])
                    }
                }
            }.createFile(named: "A.m") { file in
                file.createClass(withName: "A") { type in
                    type.createSynthesize(propertyName: "a", variableName: "b")
                        .createProperty(named: "a", type: .int)
                        .createMethod(named: "a", returnType: .int) { method in
                            method.setBody([.return(Expression.identifier("self").dot("b"))])
                        }
                }
            }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions)
            .asserter(forClassExtensionNamed: "A") { type in
                type[\.properties].assertCount(0)
            }?
            .asserter(forClassNamed: "A") { type in
                type[\.instanceVariables].assertCount(0)
                type[\.properties][0]?
                    .assertIsPropertyMode()?
                    .assert(setterValueIdentifier: "a")?
                    .assert(getterBody: [
                        .return(.identifier("self").dot("b"))
                    ])?
                    .assert(setterBody: [
                        .expression(
                            .identifier("self").dot("b")
                                .assignment(
                                    op: .assign,
                                    rhs: .identifier("a")
                                )
                        )
                    ])
            }
    }

    /// Tests that property merging ignores nullability across accessor types
    func testMergePropertiesWithDifferentNullabilitySignatures() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A+Ext.m") { file in
                file.createExtension(forClassNamed: "A") { type in
                    type.createMethod(
                        named: "setA",
                        parameters: [
                            ParameterSignature(
                                label: nil,
                                name: "a",
                                type: .nullabilityUnspecified(.string)
                            )
                        ]
                    ) { method in
                        method.setBody([
                            .expression(
                                Expression.identifier("self").dot("b").assignment(
                                    op: .assign,
                                    rhs: .identifier("a")
                                )
                            )
                        ])
                    }
                }
            }.createFile(named: "A.m") { file in
                file.createClass(withName: "A") { type in
                    type.createSynthesize(propertyName: "a", variableName: "b")
                        .createProperty(named: "a", type: .string)
                        .createMethod(named: "a", returnType: .implicitUnwrappedOptional(.string)) {
                            method in
                            method.setBody([.return(Expression.identifier("self").dot("b"))])
                        }
                }
            }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions)
            .asserter(forClassExtensionNamed: "A") { type in
                type[\.properties].assertCount(0)
            }?
            .asserter(forClassNamed: "A") { type in
                type[\.instanceVariables].assertCount(0)
                type[\.properties][0]?
                    .assertIsPropertyMode()?
                    .assert(setterValueIdentifier: "a")?
                    .assert(getterBody: [
                        .return(.identifier("self").dot("b"))
                    ])?
                    .assert(setterBody: [
                        .expression(
                            .identifier("self").dot("b")
                                .assignment(
                                    op: .assign,
                                    rhs: .identifier("a")
                                )
                        )
                    ])
            }
    }

    func testMergePropertyFromExtension() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.m") { file in
                file.createExtension(forClassNamed: "A", categoryName: "Ext") { ext in
                    ext.setAsCategoryImplementation(categoryName: "Ext")
                        .createProperty(named: "a", type: .int, objcAttributes: [.readonly])
                        .createMethod(named: "a", returnType: .int) { method in
                            method.setBody([.return(.constant(0))])
                        }
                }
            }
            .build()
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassExtensionNamed: "A") { type in
            type[\.methods].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?.assert(getterBody: [
                .return(.constant(0))
            ])
        }
    }
    
    func testMergeKeepsComments() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder
                        .createProperty(named: "a", type: .int, objcAttributes: [.attribute("readonly")]) { prop in
                            prop.addComment("// Property comment")
                        }
                        .createMethod(named: "a", returnType: .int) { m in
                            m.addComment("// Getter comment")
                        }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?.assert(precedingComments: [
                "// Property comment",
                "// Getter comment",
            ])
        }
    }
    
    func testMergeKeepsCommentsGetterAndSetter() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder
                        .createProperty(named: "a", type: .int, objcAttributes: [.attribute("readonly")]) { prop in
                            prop.addComment("// Property comment")
                        }
                        .createMethod(named: "a", returnType: .int) { m in
                            m.addComment("// Getter comment")
                        }
                        .createMethod("setA(_ a: Int)") { m in
                            m.addComment("// Setter comment")
                        }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?.assert(precedingComments: [
                "// Property comment",
                "// Getter comment",
                "// Setter comment",
            ])
        }
    }
    
    func testMergeKeepsCommentsSetterOnly() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder
                        .createProperty(named: "a", type: .int, objcAttributes: [.attribute("readonly")]) { prop in
                            prop.addComment("// Property comment")
                        }
                        .createMethod("setA(_ a: Int)") { m in
                            m.addComment("// Setter comment")
                        }
                }.build()
        let sut = ObjectiveCPropertyMergeIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(0)
            type[\.properties].assertCount(1)
            type[\.properties][0]?.assert(precedingComments: [
                "// Property comment",
                "// Setter comment",
            ])
        }
    }
}

// MARK: - Private test setup shortcuts

extension TypeBuilder {
    @discardableResult
    func ext_makeReadonlyPropertyWithGetter(named name: String, type: SwiftType = .int) -> TypeBuilder<T> {
        return self
            .createProperty(
                named: name,
                type: .int,
                objcAttributes: [.attribute("readonly")]
            )
            .createMethod(named: name, returnType: .int)
    }

    @discardableResult
    func ext_makePropertyWithGetterSetter(named name: String, type: SwiftType = .int) -> TypeBuilder<T> {
        return self
            .createProperty(named: name, type: type)
            .createMethod(
                named: "set\(name.uppercasedFirstLetter)",
                parameters: [
                    .init(label: nil, name: name, type: type)
                ]
            )
            .createMethod(named: name, returnType: type)
    }

    @discardableResult
    func ext_makePropertyWithSetter(named name: String, type: SwiftType = .int) -> TypeBuilder<T> {
        return self
            .createProperty(named: name, type: type)
            .createMethod(
                named: "set\(name.uppercasedFirstLetter)",
                parameters: [
                    .init(label: nil, name: name, type: type)
                ]
            )
    }
}
