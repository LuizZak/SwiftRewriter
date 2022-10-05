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
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

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

    /// Test that property merging checks for typealiases while checking if accessor
    /// types match.
    func testMergeGetterAndSetterWithTypeAliases() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "Aliases") { type in
                type.createTypealias(withName: "AliasedInt", type: .struct("NSInteger"))
                    .createTypealias(withName: "OtherAliasedInt", type: .struct("NSInteger"))
            }
            .createFileWithClass(named: "A") { type in
                type.createProperty(named: "a", type: .int)
                    .createMethod(named: "a", returnType: .typeName("AliasedInt"))
                    .createMethod(
                        named: "setA",
                        parameters: [
                            ParameterSignature(
                                label: nil,
                                name: "a",
                                type: .typeName("OtherAliasedInt")
                            )
                        ]
                    )
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

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

    /// Tests that when merging property accessors we check that the accessor
    /// typing matches the property's before merging
    func testDontMergeGetterAndSetterWithDifferentTypes() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createProperty(named: "a", type: .int)
                    .createMethod(named: "a", returnType: .string)
                    .createMethod(named: "setA", returnType: .cgFloat)
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.methods.count, 2)
        XCTAssertEqual(cls.properties.count, 1)
        switch cls.properties[0].mode {
        case .asField:
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
                builder.ext_makePropertyWithSetter(named: "a", type: .int)
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

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
    }

    /// Make sure when merging properties we respect the getter and setter bodies,
    /// in case of readonly properties which feature candidate getter and setters.
    func testMergeReadonlyRespectsCustomizedGetterWithNonRelatedSetter() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { builder in
                builder
                    .createInstanceVariable(named: "innerA", type: .int)
                    .createProperty(
                        named: "a",
                        type: .int,
                        objcAttributes: [.attribute("readonly")]
                    )
                    .createMethod(named: "a", returnType: .int) { method in
                        method.setBody([
                            .return(.identifier("innerA"))
                        ])
                    }.createMethod(
                        named: "setA",
                        parameters: [
                            ParameterSignature(label: nil, name: "a", type: .int)
                        ]
                    ) { method in
                        method.setBody([
                            .expression(
                                Expression
                                    .identifier("innerA")
                                    .assignment(op: .assign, rhs: .identifier("a"))
                            )
                        ])
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        switch cls.properties[0].mode {
        case let .property(getter, setter):
            XCTAssertEqual(getter.body, [.return(.identifier("innerA"))])
            XCTAssertEqual(
                setter.body.body,
                [
                    .expression(
                        Expression
                            .identifier("innerA")
                            .assignment(op: .assign, rhs: .identifier("a"))
                    )
                ]
            )

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
                file.createClass(withName: "A")
                    .createExtension(forClassNamed: "A") { builder in
                        builder
                            .ext_makeReadonlyPropertyWithGetter(named: "a")
                    }
            }.build()
        let cls = intentions.extensionIntentions()[0]
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
    }

    // Checks if ObjectiveCPropertyMergeIntentionPass properly records history entries on
    // the merged properties and the types the properties are contained within.
    func testHistoryTrackingMergingGetterSetterMethods() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { (builder) in
                builder.ext_makePropertyWithGetterSetter(named: "a")
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(
            cls.history.summary,
            """
            [ObjectiveCPropertyMergeIntentionPass:1] Removed method A.a() -> Int since deduced it is a getter for property A.a: Int
            [ObjectiveCPropertyMergeIntentionPass:1] Removed method A.setA(_ a: Int) since deduced it is a setter for property A.a: Int
            """
        )
        XCTAssertEqual(
            cls.properties[0].history.summary,
            "[ObjectiveCPropertyMergeIntentionPass:1] Merged A.a() -> Int and A.setA(_ a: Int) into property A.a: Int"
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
                            .expression(
                                .assignment(lhs: .identifier("_a"), op: .assign, rhs: .constant(1))
                            )
                        ])
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.instanceVariables.count, 1)
        XCTAssertEqual(cls.instanceVariables[0].name, "_a")
        XCTAssertEqual(cls.properties.count, 1)

        switch cls.properties[0].mode {
        case let .property(get, set):
            XCTAssertEqual(get.body, [.return(Expression.identifier("self").dot("_a"))])
            XCTAssertEqual(set.valueIdentifier, "newValue")
            XCTAssertEqual(
                set.body.body,
                [
                    .expression(
                        .assignment(
                            lhs: Expression.identifier("self").dot("_a"),
                            op: .assign,
                            rhs: .identifier("newValue")
                        )
                    )
                ]
            )
        default:
            XCTFail("Expected to synthesize getter/setter with backing field.")
        }

        XCTAssertEqual(
            cls.history.summary,
            """
            [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
            that the backing field of A.a: Int (_a) was being used in A.b().
            """
        )
        XCTAssertEqual(
            cls.properties[0].history.summary,
            """
            [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
            that the backing field of A.a: Int (_a) was being used in A.b().
            """
        )
    }

    func testSynthesizeBackingFieldWhenUsageOfBackingFieldIsDetectedInDeinit() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { (builder) in
                builder
                    .createProperty(named: "a", type: .int)
                    .createDeinit { method in
                        method.setBody([
                            .expression(
                                .assignment(lhs: .identifier("_a"), op: .assign, rhs: .constant(1))
                            )
                        ])
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.instanceVariables.count, 1)
        XCTAssertEqual(cls.instanceVariables[0].name, "_a")
        XCTAssertEqual(cls.properties.count, 1)

        switch cls.properties[0].mode {
        case let .property(get, set):
            XCTAssertEqual(get.body, [.return(Expression.identifier("self").dot("_a"))])
            XCTAssertEqual(set.valueIdentifier, "newValue")
            XCTAssertEqual(
                set.body.body,
                [
                    .expression(
                        .assignment(
                            lhs: Expression.identifier("self").dot("_a"),
                            op: .assign,
                            rhs: .identifier("newValue")
                        )
                    )
                ]
            )
        default:
            XCTFail("Expected to synthesize getter/setter with backing field.")
        }

        XCTAssertEqual(
            cls.history.summary,
            """
            [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
            that the backing field of A.a: Int (_a) was being used in A.deinit.
            """
        )
        XCTAssertEqual(
            cls.properties[0].history.summary,
            """
            [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
            that the backing field of A.a: Int (_a) was being used in A.deinit.
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
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

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
            [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
            that the backing field of A.a: Int (_a) was being used in A.b().
            """
        )
        XCTAssertEqual(
            cls.properties[0].history.summary,
            """
            [ObjectiveCPropertyMergeIntentionPass:1] Created field A._a: Int as it was detected \
            that the backing field of A.a: Int (_a) was being used in A.b().
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
                    .createProperty(
                        named: "a",
                        type: .int,
                        objcAttributes: [.attribute("readonly")]
                    )
                    .createVoidMethod(named: "b") { method in
                        method.setBody([
                            .variableDeclarations([
                                StatementVariableDeclaration(
                                    identifier: "sSelf",
                                    type: .typeName("A")
                                )
                            ]
                            ),
                            .expression(
                                .assignment(
                                    lhs: sSelf.dot("_a"),
                                    op: .assign,
                                    rhs: .constant(1)
                                )
                            ),
                        ])
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

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
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.instanceVariables.count, 1)
        XCTAssertEqual(cls.instanceVariables[0].name, "_a")
        XCTAssertEqual(cls.properties.count, 1)

        switch cls.properties[0].mode {
        case let .property(get, set):
            XCTAssertEqual(get.body, [.return(.postfix(.identifier("self"), .member("_a")))])
            XCTAssertEqual(set.valueIdentifier, "newValue")
            XCTAssertEqual(
                set.body.body,
                [
                    .expression(
                        .assignment(
                            lhs: .postfix(.identifier("self"), .member("_a")),
                            op: .assign,
                            rhs: .identifier("newValue")
                        )
                    )
                ]
            )
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
                            .expression(
                                .assignment(lhs: .identifier("_a"), op: .assign, rhs: .constant(1))
                            ),
                        ])
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()
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
                        ],
                        isStatic: true
                    )
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

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

        switch cls.properties[1].mode {
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
                        .createMethod(
                            named: "setA",
                            parameters: [
                                ParameterSignature(label: nil, name: "a", type: .int)
                            ]
                        )
                }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

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
                        .createMethod(
                            named: "setA",
                            parameters: [
                                ParameterSignature(label: nil, name: "a", type: .int)
                            ]
                        )
                }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

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
                        .createMethod(
                            named: "setA",
                            parameters: [ParameterSignature(label: nil, name: "a", type: .int)]
                        ) { member in
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
        let sut = ObjectiveCPropertyMergeIntentionPass()

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

    /// If a property is declared along with `@synthesize`'s and accessor methods,
    /// ensure that we don't get confused and overwrite implementations accidentally.
    func testPropertyMergingRespectsExistingPropertySynthesization() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createClass(withName: "A") { type in
                    type.createInstanceVariable(named: "backing", type: .int)
                        .createProperty(named: "a", type: .int)
                        .createMethod(
                            named: "setA",
                            parameters: [ParameterSignature(label: nil, name: "a", type: .int)]
                        ) { method in
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
        let type = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(type.instanceVariables.count, 1)  // Shouldn't synthesize backing field since we already provide a backing field to use
        let property = type.properties[0]
        switch property.mode {
        case let .property(get, set):
            XCTAssertEqual(
                get.body,
                [
                    // return backing
                    .return(Expression.identifier("backing"))
                ]
            )

            XCTAssertEqual(
                set.body.body,
                [
                    // self.backing = a
                    .expression(
                        Expression
                            .identifier("self").dot("backing")
                            .assignment(op: .assign, rhs: .identifier("a"))
                    )
                ]
            )

            // Success
            break
        default:
            XCTFail("Unexpected property mode \(property.mode)")
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
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.instanceVariables.count, 1)
        XCTAssertEqual(cls.instanceVariables.first?.name, "b")
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
                    type.createMethod(
                        named: "setA",
                        parameters: [ParameterSignature(label: nil, name: "a", type: .int)]
                    ) { method in
                        method.setBody([
                            .expression(
                                Expression
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
        let cls = intentions.classIntentions()[0]
        let ext = intentions.extensionIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(ext.instanceVariables.count, 0)
        XCTAssertEqual(cls.instanceVariables.count, 1)
        XCTAssertEqual(cls.instanceVariables.first?.name, "b")
        XCTAssertEqual(cls.instanceVariables.first?.type, .int)
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
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.instanceVariables.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        XCTAssertEqual(cls.properties.first?.setterAccessLevel, .private)
        switch cls.properties.first?.mode {
        case .asField?:
            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties.first?.mode as Any)")
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
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.instanceVariables.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        XCTAssertNil(cls.properties.first?.setterAccessLevel)
        switch cls.properties.first?.mode {
        case .asField?:
            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties.first?.mode as Any)")
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

        let cls = intentions.classIntentions()[0]
        XCTAssertEqual(intentions.extensionIntentions()[0].properties.count, 0)
        XCTAssertEqual(intentions.classIntentions()[0].properties.count, 1)
        switch cls.properties.first?.mode {
        case let .property(getter, setter)?:

            XCTAssertEqual(getter.body, [.return(Expression.identifier("self").dot("b"))])
            XCTAssertEqual(setter.valueIdentifier, "a")
            XCTAssertEqual(
                setter.body.body,
                [
                    .expression(
                        Expression.identifier("self").dot("b").assignment(
                            op: .assign,
                            rhs: .identifier("a")
                        )
                    )
                ]
            )

            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties.first?.mode as Any)")
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

        let cls = intentions.classIntentions()[0]
        XCTAssertEqual(intentions.extensionIntentions()[0].properties.count, 0)
        XCTAssertEqual(intentions.classIntentions()[0].properties.count, 1)
        switch cls.properties.first?.mode {
        case let .property(getter, setter)?:

            XCTAssertEqual(getter.body, [.return(Expression.identifier("self").dot("b"))])
            XCTAssertEqual(setter.valueIdentifier, "a")
            XCTAssertEqual(
                setter.body.body,
                [
                    .expression(
                        Expression.identifier("self").dot("b").assignment(
                            op: .assign,
                            rhs: .identifier("a")
                        )
                    )
                ]
            )

            // Success
            break
        default:
            XCTFail("Unexpected property mode \(cls.properties.first?.mode as Any)")
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

        let file = intentions.intentionFor(fileNamed: "A.m")!
        let type = file.extensionIntentions[0]
        XCTAssertEqual(type.methods.count, 0)
        XCTAssertEqual(type.properties.count, 1)
        XCTAssertEqual(type.properties[0].getter?.body, [.return(.constant(0))])
    }

    func testMergeKeepsComments() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { builder in
                builder
                    .createProperty(
                        named: "a",
                        type: .int,
                        objcAttributes: [.attribute("readonly")]
                    ) { prop in
                        prop.addComment("// Property comment")
                    }
                    .createMethod(named: "a", returnType: .int) { m in
                        m.addComment("// Getter comment")
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(
            cls.properties[0].precedingComments,
            [
                "// Property comment",
                "// Getter comment",
            ]
        )
    }

    func testMergeKeepsCommentsGetterAndSetter() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { builder in
                builder
                    .createProperty(
                        named: "a",
                        type: .int,
                        objcAttributes: [.attribute("readonly")]
                    ) { prop in
                        prop.addComment("// Property comment")
                    }
                    .createMethod(named: "a", returnType: .int) { m in
                        m.addComment("// Getter comment")
                    }
                    .createMethod("setA(_ a: Int)") { m in
                        m.addComment("// Setter comment")
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(
            cls.properties[0].precedingComments,
            [
                "// Property comment",
                "// Getter comment",
                "// Setter comment",
            ]
        )
    }

    func testMergeKeepsCommentsSetterOnly() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { builder in
                builder
                    .createProperty(
                        named: "a",
                        type: .int,
                        objcAttributes: [.attribute("readonly")]
                    ) { prop in
                        prop.addComment("// Property comment")
                    }
                    .createMethod("setA(_ a: Int)") { m in
                        m.addComment("// Setter comment")
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = ObjectiveCPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(
            cls.properties[0].precedingComments,
            [
                "// Property comment",
                "// Setter comment",
            ]
        )
    }
}

// MARK: - Private test setup shortcuts

extension TypeBuilder {
    @discardableResult
    fileprivate func ext_makeReadonlyPropertyWithGetter(named name: String, type: SwiftType = .int)
        -> TypeBuilder<T>
    {
        return
            self.createProperty(named: name, type: .int, objcAttributes: [.attribute("readonly")])
            .createMethod(named: name, returnType: .int)
    }

    @discardableResult
    fileprivate func ext_makePropertyWithGetterSetter(named name: String, type: SwiftType = .int)
        -> TypeBuilder<T>
    {
        return
            self.createProperty(named: name, type: type)
            .createMethod(
                named: "set\(name.uppercasedFirstLetter)",
                parameters: [ParameterSignature(label: nil, name: name, type: type)]
            )
            .createMethod(named: name, returnType: type)
    }

    @discardableResult
    fileprivate func ext_makePropertyWithSetter(named name: String, type: SwiftType = .int)
        -> TypeBuilder<T>
    {
        return
            self.createProperty(named: name, type: type)
            .createMethod(
                named: "set\(name.uppercasedFirstLetter)",
                parameters: [ParameterSignature(label: nil, name: name, type: type)]
            )
    }
}
