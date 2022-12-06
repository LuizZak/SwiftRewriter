import XCTest
import Antlr4
import ObjcParserAntlr
import GrammarModels

@testable import ObjcParser

class AntlrDeclarationParserTests: XCTestCase {

    func testTypeName() {
        let test = self.prepareParser(
            ObjectiveCParser.typeName,
            AntlrDeclarationParser.typeName(_:)
        )

        assertEqual(
            test("unsigned long long int"),
            .init(
                declarationSpecifiers: [
                    .typeSpecifier("unsigned"),
                    .typeSpecifier("long"),
                    .typeSpecifier("long"),
                    .typeSpecifier("int"),
                ]
            )
        )
        assertEqual(
            test("int *"),
            .init(
                declarationSpecifiers: [
                    .typeSpecifier("int"),
                ],
                abstractDeclarator: .pointer([.init()])
            )
        )
        assertEqual(
            test("static const NSString *_Nullable"),
            .init(
                declarationSpecifiers: [
                    .storage(.static()),
                    .typeQualifier(.const()),
                    .typeSpecifier("NSString"),
                ],
                abstractDeclarator: .pointer([
                    .init(nullabilitySpecifier: .nullable()),
                ])
            )
        )
    }

    func testDeclaration() {
        let test = self.prepareParser(
            ObjectiveCParser.declaration,
            AntlrDeclarationParser.declaration(_:)
        )

        assertEqual(
            test("int a;"),
            .init(
                declarationSpecifiers: [
                    .typeSpecifier("int"),
                    .typeSpecifier("a"),
                ]
            )
        )
        assertEqual(
            test("int a, *b;"),
            .init(
                declarationSpecifiers: [
                    .typeSpecifier("int"),
                ],
                initDeclaratorList: [
                    .init(declarator: "a"),
                    .init(
                        declarator: .init(pointer: [.init()], directDeclarator: "b")
                    )
                ]
            )
        )
        assertEqual(
            test("int a, *b = nullptr, c[];"),
            .init(
                declarationSpecifiers: [
                    .typeSpecifier("int"),
                ],
                initDeclaratorList: [
                    .init(declarator: "a"),
                    .init(
                        declarator: .init(pointer: [.init()], directDeclarator: "b"),
                        initializer: "nullptr"
                    ),
                    .init(
                        declarator: .init(directDeclarator: .arrayDeclarator(
                            .init(directDeclarator: "c")
                        ))
                    ),
                ]
            )
        )
    }

    func testFieldDeclaration() {
        let test = self.prepareParser(
            ObjectiveCParser.fieldDeclaration,
            AntlrDeclarationParser.fieldDeclaration(_:)
        )

        assertEqual(
            test("int field;"),
            .init(
                declarationSpecifiers: [
                    .typeSpecifier("int"),
                ],
                fieldDeclaratorList: [
                    .declarator(
                        .init(directDeclarator: "field")
                    ),
                ]
            )
        )
        assertEqual(
            test("int *field;"),
            .init(
                declarationSpecifiers: [
                    .typeSpecifier("int"),
                ],
                fieldDeclaratorList: [
                    .declarator(
                        .init(
                            pointer: .init(pointerEntries: [
                                .init(),
                            ]),
                            directDeclarator: "field"
                        )
                    ),
                ]
            )
        )
        assertEqual(
            test("int : 1;"),
            .init(
                declarationSpecifiers: [
                    .typeSpecifier("int"),
                ],
                fieldDeclaratorList: [
                    .declaratorConstantExpression(
                        nil,
                        "1"
                    )
                ]
            )
        )
    }

    func testInitDeclaratorList() {
        let test = self.prepareParser(
            ObjectiveCParser.initDeclaratorList,
            AntlrDeclarationParser.initDeclaratorList(_:)
        )

        assertEqual(test("a"), [.init(declarator: "a")])
        assertEqual(test("a, b"), [.init(declarator: "a"), .init(declarator: "b")])
        assertEqual(
            test("a, *b = nullptr, c[]"), [
                .init(declarator: "a"),
                .init(
                    declarator: .init(pointer: [.init()], directDeclarator: "b"),
                    initializer: "nullptr"
                ),
                .init(
                    declarator: .init(directDeclarator: .arrayDeclarator(
                        .init(directDeclarator: "c")
                    ))
                ),
            ]
        )
    }

    func testInitDeclarator() {
        let test = self.prepareParser(
            ObjectiveCParser.initDeclarator,
            AntlrDeclarationParser.initDeclarator(_:)
        )

        assertEqual(test("a"), .init(declarator: "a"))
        assertEqual(test("a = 0"), .init(declarator: "a", initializer: "0"))
    }

    func testInitializer() {
        let result = self.runParser(
            "1 + 2",
            ObjectiveCParser.initializer,
            AntlrDeclarationParser.initializer(_:)
        )

        assertEqual(result, "1 + 2")
    }

    func testDirectDeclarator_identifier() {
        let test = self.prepareParser(
            ObjectiveCParser.directDeclarator,
            AntlrDeclarationParser.directDeclarator(_:)
        )

        assertEqual(
            test("a"),
            .identifier("a")
        )
    }

    func testDirectDeclarator_declarator() {
        let test = self.prepareParser(
            ObjectiveCParser.directDeclarator,
            AntlrDeclarationParser.directDeclarator(_:)
        )

        assertEqual(
            test("(*a)"),
            .declarator(
                .init(
                    pointer: [.init()],
                    directDeclarator: "a"
                )
            )
        )
    }

    func testDirectDeclarator_block() {
        let test = self.prepareParser(
            ObjectiveCParser.directDeclarator,
            AntlrDeclarationParser.directDeclarator(_:)
        )

        assertEqual(
            test("(^a)()"),
            .blockDeclarator(.init(
                directDeclarator: "a",
                parameterList: []
            ))
        )
        assertEqual(
            test("(^__weak __block a)()"),
            .blockDeclarator(.init(
                blockDeclarationSpecifiers: [
                    .arcBehaviour(.weakQualifier()),
                    .typePrefix(.block()),
                ],
                directDeclarator: "a",
                parameterList: []
            ))
        )
        assertEqual(
            test("(^a)(int b)"),
            .blockDeclarator(.init(
                directDeclarator: "a",
                parameterList: [
                    .declarator(
                        [.typeSpecifier("int")],
                        "b"
                    ),
                ]
            ))
        )
        assertEqual(
            test("(^a)(int b, void*)"),
            .blockDeclarator(.init(
                directDeclarator: "a",
                parameterList: [
                    .declarator(
                        [.typeSpecifier("int")],
                        "b"
                    ),
                    .abstractDeclarator(
                        [.typeSpecifier("void")],
                        .pointer([.init()])
                    ),
                ]
            ))
        )
    }

    func testDirectDeclarator_function() {
        let test = self.prepareParser(
            ObjectiveCParser.directDeclarator,
            AntlrDeclarationParser.directDeclarator(_:)
        )

        assertEqual(
            test("a()"),
            .functionDeclarator(.init(
                directDeclarator: "a"
            ))
        )
        assertEqual(
            test("a(int b)"),
            .functionDeclarator(.init(
                directDeclarator: "a",
                parameterTypeList: [
                    .declarator(
                        [.typeSpecifier("int")],
                        "b"
                    ),
                ]
            ))
        )
        assertEqual(
            test("a(int b, void*, ...)"),
            .functionDeclarator(.init(
                directDeclarator: "a",
                parameterTypeList: .init(
                    parameterList: [
                        .declarator(
                            [.typeSpecifier("int")],
                            "b"
                        ),
                        .abstractDeclarator(
                            [.typeSpecifier("void")],
                            .pointer([.init()])
                        ),
                    ],
                    isVariadic: true
                )
            ))
        )
        assertEqual(
            test("a[3](int a)"),
            .functionDeclarator(.init(
                directDeclarator: .arrayDeclarator(
                    .init(
                        directDeclarator: "a",
                        length: "3"
                    )
                ),
                parameterTypeList: [
                    .declarator(
                        [.typeSpecifier("int")],
                        "a"
                    ),
                ]
            ))
        )
    }

    func testDirectDeclarator_array() {
        let test = self.prepareParser(
            ObjectiveCParser.directDeclarator,
            AntlrDeclarationParser.directDeclarator(_:)
        )

        assertEqual(
            test("a[]"),
            .arrayDeclarator(.init(directDeclarator: "a"))
        )
        assertEqual(
            test("a[5]"),
            .arrayDeclarator(.init(directDeclarator: "a", length: "5"))
        )
        assertEqual(
            test("a[const 5]"),
            .arrayDeclarator(.init(
                directDeclarator: "a",
                typeQualifiers: [
                    .const(),
                ],
                length: "5"
            ))
        )
        assertEqual(
            test("a[const]"),
            .arrayDeclarator(.init(
                directDeclarator: "a",
                typeQualifiers: [
                    .const(),
                ]
            ))
        )
        assertEqual(
            test("a[3][]"),
            .arrayDeclarator(.init(
                directDeclarator: .arrayDeclarator(
                    .init(
                        directDeclarator: "a",
                        length: "3"
                    )
                )
            ))
        )
    }

    func testAbstractDeclarator() {
        let test = self.prepareParser(
            ObjectiveCParser.abstractDeclarator,
            AntlrDeclarationParser.abstractDeclarator(_:)
        )

        assertEqual(test("*"), .pointer([.init()]))
        assertEqual(
            test("(*)()"),
            .directAbstractDeclarator(
                nil,
                .functionDeclarator(
                    .init(
                        directAbstractDeclarator: .abstractDeclarator(
                            .pointer([.init()]
                        ))
                    )
                )
            )
        )
    }

    func testDirectAbstractDeclarator_abstractDeclarator() {
        let test = self.prepareParser(
            ObjectiveCParser.directAbstractDeclarator,
            AntlrDeclarationParser.directAbstractDeclarator(_:)
        )

        assertEqual(
            test("(*)"),
            .abstractDeclarator(
                .pointer([.init()])
            )
        )
    }

    func testDirectAbstractDeclarator_block() {
        let test = self.prepareParser(
            ObjectiveCParser.directAbstractDeclarator,
            AntlrDeclarationParser.directAbstractDeclarator(_:)
        )

        assertEqual(
            test("(^)()"),
            .blockDeclarator(.init(parameterList: []))
        )
        assertEqual(
            test("(^__weak __block)()"),
            .blockDeclarator(.init(
                blockDeclarationSpecifiers: [
                    .arcBehaviour(.weakQualifier()),
                    .typePrefix(.block()),
                ],
                parameterList: []
            ))
        )
        assertEqual(
            test("(^)(int a)"),
            .blockDeclarator(.init(
                parameterList: [
                    .declarator(
                        [.typeSpecifier("int")],
                        "a"
                    ),
                ]
            ))
        )
        assertEqual(
            test("(^)(int a, void*)"),
            .blockDeclarator(.init(
                parameterList: [
                    .declarator(
                        [.typeSpecifier("int")],
                        "a"
                    ),
                    .abstractDeclarator(
                        [.typeSpecifier("void")],
                        .pointer([.init()])
                    ),
                ]
            ))
        )
    }

    func testDirectAbstractDeclarator_function() {
        let test = self.prepareParser(
            ObjectiveCParser.directAbstractDeclarator,
            AntlrDeclarationParser.directAbstractDeclarator(_:)
        )

        assertEqual(
            test("()"),
            .functionDeclarator(.init())
        )
        assertEqual(
            test("(int a)"),
            .functionDeclarator(.init(
                parameterTypeList: [
                    .declarator(
                        [.typeSpecifier("int")],
                        "a"
                    ),
                ]
            ))
        )
        assertEqual(
            test("(int a, void*, ...)"),
            .functionDeclarator(.init(
                parameterTypeList: .init(
                    parameterList: [
                        .declarator(
                            [.typeSpecifier("int")],
                            "a"
                        ),
                        .abstractDeclarator(
                            [.typeSpecifier("void")],
                            .pointer([.init()])
                        ),
                    ],
                    isVariadic: true
                )
            ))
        )
        assertEqual(
            test("[3](int a)"),
            .functionDeclarator(.init(
                directAbstractDeclarator: .arrayDeclarator(
                    .init(length: "3")
                ),
                parameterTypeList: [
                    .declarator(
                        [.typeSpecifier("int")],
                        "a"
                    ),
                ]
            ))
        )
    }

    func testDirectAbstractDeclarator_array() {
        let test = self.prepareParser(
            ObjectiveCParser.directAbstractDeclarator,
            AntlrDeclarationParser.directAbstractDeclarator(_:)
        )

        assertEqual(
            test("[]"),
            .arrayDeclarator(.init())
        )
        assertEqual(
            test("[5]"),
            .arrayDeclarator(.init(length: "5"))
        )
        assertEqual(
            test("[const 5]"),
            .arrayDeclarator(.init(
                typeQualifiers: [
                    .const(),
                ],
                length: "5"
            ))
        )
        assertEqual(
            test("[const]"),
            .arrayDeclarator(.init(
                typeQualifiers: [
                    .const(),
                ]
            ))
        )
        assertEqual(
            test("[3][]"),
            .arrayDeclarator(.init(
                directAbstractDeclarator: .arrayDeclarator(
                    .init(length: "3")
                )
            ))
        )
    }

    func testBlockDeclarationSpecifier() {
        let test = self.prepareParser(
            ObjectiveCParser.blockDeclarationSpecifier,
            AntlrDeclarationParser.blockDeclarationSpecifier(_:)
        )

        // Type qualifier
        assertEqual(test("const"), .typeQualifier(.const()))
        // Type prefix
        assertEqual(test("__block int"), .typePrefix(.block()))
        // ARC behaviour specifier
        assertEqual(test("__weak"), .arcBehaviour(.weakQualifier()))
        // Nullability specifier
        assertEqual(test("_Nonnull"), .nullability(.nonnull()))
    }

    func testDeclarationSpecifiers() {
        let test = self.prepareParser(
            ObjectiveCParser.declarationSpecifiers,
            AntlrDeclarationParser.declarationSpecifiers(_:)
        )

        assertEqual(
            test("unsigned int"),
            .init(declarationSpecifier: [
                .typeSpecifier("unsigned"),
                .typeSpecifier("int"),
            ])
        )
        // Type prefix
        assertEqual(
            test("__block int"),
            .init(typePrefix: .block(), declarationSpecifier: [
                .typeSpecifier("int"),
            ])
        )
    }

    func testDeclarationSpecifier() {
        let test = self.prepareParser(
            ObjectiveCParser.declarationSpecifier,
            AntlrDeclarationParser.declarationSpecifier(_:)
        )

        // Storage
        assertEqual(test("static"), .storage(.static()))
        // Type specifier
        assertEqual(test("int"), .typeSpecifier("int"))
        // Type qualifier
        assertEqual(test("const"), .typeQualifier(.const()))
        // Function specifier
        assertEqual(test("inline"), .functionSpecifier(.inline()))
        // Alignment specifier
        assertEqual(test("_Alignas(int)"), .alignment(.typeName("int")))
        // ARC behaviour specifier
        assertEqual(test("__weak"), .arcBehaviour(.weakQualifier()))
        // Nullability specifier
        assertEqual(test("_Nonnull"), .nullability(.nonnull()))
        // IBOutlet qualifier
        assertEqual(
            test("IBOutletCollection(ident)"),
            .ibOutlet(.ibOutletCollection(.invalid, "ident"))
        )
    }

    func testTypeSpecifier() {
        let test = self.prepareParser(
            ObjectiveCParser.typeSpecifier,
            AntlrDeclarationParser.typeSpecifier(_:)
        )

        // Scalar type
        assertEqual(test("void"), .scalar(.void()))
        // Type identifier
        assertEqual(test("ident"), .typeIdentifier("ident"))
        // Generic type
        assertEqual(
            test("ident<NSString*>"),
            .genericTypeIdentifier(
                .init(
                    identifier: "ident",
                    genericTypeParameters: [
                        .init(
                            typeName: .init(
                                declarationSpecifiers: [
                                    .typeSpecifier("NSString")
                                ],
                                abstractDeclarator: .pointer([.init()])
                            )
                        ),
                    ]
                )
            )
        )
        // Typeof specifier
        assertEqual(
            test("__typeof__(expression)"),
            .typeof(expression: "expression")
        )
        // Struct/union
        assertEqual(
            test("struct AStruct { int field; }"),
            .structOrUnion(
                .init(
                    structOrUnion: .struct(),
                    declaration: .declared("AStruct", [
                        .init(specifierQualifierList: [
                            .typeSpecifier("int"),
                        ], fieldDeclaratorList: [
                            .declarator(.init(directDeclarator: "field")),
                        ]),
                    ])
                )
            )
        )
        // Enum
        assertEqual(
            test("enum AnEnum { CASE0 }"),
            .enum(
                .cEnum(
                    "AnEnum",
                    nil,
                    .declared("AnEnum", [
                        .init(enumeratorIdentifier: "CASE0"),
                    ])
                )
            )
        )
    }

    func testGenericTypeSpecifier() {
        let test = self.prepareParser(
            ObjectiveCParser.genericTypeSpecifier,
            AntlrDeclarationParser.genericTypeSpecifier(_:)
        )

        assertEqual(
            test("AType<NSString*>"),
            .init(
                identifier: "AType",
                genericTypeParameters: [
                    .init(
                        typeName: .init(
                            declarationSpecifiers: [
                                .typeSpecifier("NSString"),
                            ],
                            abstractDeclarator: .pointer([.init()])
                        )
                    )
                ]
            )
        )
        assertEqual(
            test("AType<NSString*, __covariant NSObject*>"),
            .init(
                identifier: "AType",
                genericTypeParameters: [
                    .init(
                        typeName: .init(
                            declarationSpecifiers: [
                                .typeSpecifier("NSString"),
                            ],
                            abstractDeclarator: .pointer([.init()])
                        )
                    ),
                    .init(
                        variance: .covariant(),
                        typeName: .init(
                            declarationSpecifiers: [
                                .typeSpecifier("NSObject"),
                            ],
                            abstractDeclarator: .pointer([.init()])
                        )
                    ),
                ]
            )
        )
    }

    func testGenericTypeParameter() {
        let test = self.prepareParser(
            ObjectiveCParser.genericTypeParameter,
            AntlrDeclarationParser.genericTypeParameter(_:)
        )

        assertEqual(
            test("NSString*"),
            .init(
                typeName: .init(
                    declarationSpecifiers: [
                        .typeSpecifier("NSString"),
                    ],
                    abstractDeclarator: .pointer([.init()])
                )
            )
        )
        assertEqual(
            test("__covariant NSString*"),
            .init(
                variance: .covariant(),
                typeName: .init(
                    declarationSpecifiers: [
                        .typeSpecifier("NSString"),
                    ],
                    abstractDeclarator: .pointer([.init()])
                )
            )
        )
        assertEqual(
            test("__contravariant NSString*"),
            .init(
                variance: .contravariant(),
                typeName: .init(
                    declarationSpecifiers: [
                        .typeSpecifier("NSString"),
                    ],
                    abstractDeclarator: .pointer([.init()])
                )
            )
        )
    }

    func testPointer() {
        let test = self.prepareParser(
            ObjectiveCParser.pointer,
            AntlrDeclarationParser.pointer(_:)
        )

        assertEqual(test("*"), [.init()])
        assertEqual(test("*const"), [.init(typeQualifiers: [.const()])])
        assertEqual(
            test("*const *_Nullable"),
            [
                .init(typeQualifiers: [.const()]),
                .init(nullabilitySpecifier: .nullable()),
            ]
        )
    }

    func testPointerEntry() {
        let test = self.prepareParser(
            ObjectiveCParser.pointerEntry,
            AntlrDeclarationParser.pointerEntry(_:)
        )

        assertEqual(test("*"), .init())
        assertEqual(test("*const"), .init(typeQualifiers: [.const()]))
        assertEqual(
            test("*const _Nullable"),
            .init(
                typeQualifiers: [.const()],
                nullabilitySpecifier: .nullable()
            )
        )
    }

    func testTypeQualifierList() {
        let test = self.prepareParser(
            ObjectiveCParser.typeQualifierList,
            AntlrDeclarationParser.typeQualifierList(_:)
        )

        assertEqual(test("const volatile in"), [
            .const(),
            .volatile(),
            .protocolQualifier(.in())
        ])
    }

    func testTypeQualifier() {
        let test = self.prepareParser(
            ObjectiveCParser.typeQualifier,
            AntlrDeclarationParser.typeQualifier(_:)
        )

        assertEqual(test("const"), .const())
        assertEqual(test("volatile"), .volatile())
        assertEqual(test("restrict"), .restrict())
        assertEqual(test("_Atomic"), .atomic())
        // Protocol qualifier
        assertEqual(test("in"), .protocolQualifier(.in()))
    }

    func testSpecifierQualifierList() {
        let test = self.prepareParser(
            ObjectiveCParser.specifierQualifierList,
            AntlrDeclarationParser.specifierQualifierList(_:)
        )

        assertEqual(
            test("const int"),
            [
                .typeQualifier(.const()),
                .typeSpecifier("int"),
            ]
        )
        assertEqual(
            test("const unsigned long int"),
            [
                .typeQualifier(.const()),
                .typeSpecifier("unsigned"),
                .typeSpecifier("long"),
                .typeSpecifier("int"),
            ]
        )
    }

    func testIBOutletQualifier() {
        let test = self.prepareParser(
            ObjectiveCParser.ibOutletQualifier,
            AntlrDeclarationParser.ibOutletQualifier(_:)
        )

        assertEqual(test("IBOutlet"), .ibOutlet())
        assertEqual(test("IBOutletCollection(ident)"), .ibOutletCollection(.invalid, "ident"))
    }

    func testFunctionSpecifier() {
        let test = self.prepareParser(
            ObjectiveCParser.functionSpecifier,
            AntlrDeclarationParser.functionSpecifier(_:)
        )

        assertEqual(test("inline"), .inline())
        assertEqual(test("_Noreturn"), .noreturn())
        assertEqual(test("__inline__"), .gccInline())
        assertEqual(test("__stdcall"), .stdcall())
        assertEqual(test("__declspec(ident)"), .declspec(.invalid, "ident"))
    }

    func testAlignmentSpecifier() {
        let test = self.prepareParser(
            ObjectiveCParser.alignmentSpecifier,
            AntlrDeclarationParser.alignmentSpecifier(_:)
        )

        assertEqual(
            test("_Alignas(int)"),
            .typeName(
                "int"
            )
        )
        assertEqual(
            test("_Alignas(1)"),
            .expression(constantExpression: "1")
        )
    }

    func testParameterTypeList() {
        let result = runParser(
            """
            int param, int *, void
            """,
            ObjectiveCParser.parameterTypeList,
            AntlrDeclarationParser.parameterTypeList
        )

        assertEqual(
            result,
            .init(
                parameterList: [
                    .declarator(
                        [.typeSpecifier("int")],
                        .init(directDeclarator: "param")
                    ),
                    .abstractDeclarator(
                        [.typeSpecifier("int")],
                        .pointer(
                            .init(pointerEntries: [.init()])
                        )
                    ),
                    .declarationSpecifiers(
                        [.typeSpecifier("void")]
                    )
                ],
                isVariadic: false
            )
        )
    }

    func testParameterTypeList_variadic() {
        let result = runParser(
            """
            int param, ...
            """,
            ObjectiveCParser.parameterTypeList,
            AntlrDeclarationParser.parameterTypeList
        )

        assertEqual(
            result,
            .init(
                parameterList: [
                    .declarator(
                        [.typeSpecifier("int")],
                        .init(directDeclarator: "param")
                    )
                ],
                isVariadic: true
            )
        )
    }

    func testParameterDeclaration_declarator() {
        let test = self.prepareParser(
            ObjectiveCParser.parameterDeclaration,
            AntlrDeclarationParser.parameterDeclaration(_:)
        )

        assertEqual(
            test("int param"),
            .declarator(
                [.typeSpecifier("int")],
                .init(directDeclarator: "param")
            )
        )
    }

    func testParameterDeclaration_abstractDeclarator() {
        let test = self.prepareParser(
            ObjectiveCParser.parameterDeclaration,
            AntlrDeclarationParser.parameterDeclaration(_:)
        )

        assertEqual(
            test("int *"),
            .abstractDeclarator(
                [.typeSpecifier("int")],
                .pointer(
                    .init(pointerEntries: [.init()])
                )
            )
        )
    }

    func testParameterDeclaration_declarationSpecifiers() {
        let test = self.prepareParser(
            ObjectiveCParser.parameterDeclaration,
            AntlrDeclarationParser.parameterDeclaration(_:)
        )

        assertEqual(
            test("int"),
            .declarationSpecifiers(
                [.typeSpecifier("int")]
            )
        )
    }

    func testFieldDeclarator() {
        let test = self.prepareParser(
            ObjectiveCParser.fieldDeclarator,
            AntlrDeclarationParser.fieldDeclarator(_:)
        )

        assertEqual(
            test("field"),
            .declarator(
                .init(directDeclarator: "field")
            )
        )
        assertEqual(
            test("*field"),
            .declarator(
                .init(
                    pointer: .init(pointerEntries: [
                        .init(),
                    ]),
                    directDeclarator: "field"
                )
            )
        )
        assertEqual(
            test(" : 1"),
            .declaratorConstantExpression(
                nil,
                "1"
            )
        )
    }

    // MARK: Struct/union syntax

    func testStructOrUnionSpecifier_union_named() {
        let result = runParser(
            """
            union AnUnion {
                int field0;
            }
            """,
            ObjectiveCParser.structOrUnionSpecifier,
            AntlrDeclarationParser.structOrUnionSpecifier
        )

        assertEqual(
            result,
            .init(
                structOrUnion: .union(),
                declaration: .declared(
                    "AnUnion",
                    .init(structDeclaration: [
                        .init(
                            specifierQualifierList: [
                                .typeSpecifier("int"),
                            ],
                            fieldDeclaratorList: [
                                .declarator(.init(directDeclarator: "field0")),
                            ]
                        ),
                    ])
                )
            )
        )
    }

    func testStructOrUnionSpecifier_struct_named() {
        let result = runParser(
            """
            struct AStruct {
                int field0;
            }
            """,
            ObjectiveCParser.structOrUnionSpecifier,
            AntlrDeclarationParser.structOrUnionSpecifier
        )

        assertEqual(
            result,
            .init(
                structOrUnion: .struct(),
                declaration: .declared(
                    "AStruct",
                    .init(structDeclaration: [
                        .init(
                            specifierQualifierList: [
                                .typeSpecifier("int"),
                            ],
                            fieldDeclaratorList: [
                                .declarator(.init(directDeclarator: "field0")),
                            ]
                        ),
                    ])
                )
            )
        )
    }

    func testStructOrUnionSpecifier_struct_anonymous() {
        let result = runParser(
            """
            struct {
                int field0;
            }
            """,
            ObjectiveCParser.structOrUnionSpecifier,
            AntlrDeclarationParser.structOrUnionSpecifier
        )

        assertEqual(
            result,
            .init(
                structOrUnion: .struct(),
                declaration: .declared(
                    nil,
                    .init(structDeclaration: [
                        .init(
                            specifierQualifierList: [
                                .typeSpecifier("int"),
                            ],
                            fieldDeclaratorList: [
                                .declarator(.init(directDeclarator: "field0")),
                            ]
                        ),
                    ])
                )
            )
        )
    }

    func testStructOrUnionSpecifier_struct_opaque() {
        let result = runParser(
            """
            struct AStruct
            """,
            ObjectiveCParser.structOrUnionSpecifier,
            AntlrDeclarationParser.structOrUnionSpecifier
        )

        assertEqual(
            result,
            .init(
                structOrUnion: .struct(),
                declaration: .opaque(
                    "AStruct"
                )
            )
        )
    }

    func testStructDeclarationList() {
        let result = runParser(
            """
            int field0;
            bool *field1;
            void : 1;
            """,
            ObjectiveCParser.structDeclarationList,
            AntlrDeclarationParser.structDeclarationList
        )

        assertEqual(
            result,
            .init(structDeclaration: [
                .init(
                    specifierQualifierList: [
                        .typeSpecifier("int"),
                    ],
                    fieldDeclaratorList: [
                        .declarator(.init(directDeclarator: "field0")),
                    ]
                ),
                .init(
                    specifierQualifierList: [
                        .typeSpecifier("bool"),
                    ],
                    fieldDeclaratorList: [
                        .declarator(
                            .init(
                                pointer: .init(pointerEntries: [
                                    .init(),
                                ]),
                                directDeclarator: "field1"
                            )
                        ),
                    ]
                ),
                .init(
                    specifierQualifierList: [
                        .typeSpecifier("void"),
                    ],
                    fieldDeclaratorList: [
                        .declaratorConstantExpression(
                            nil,
                            "1"
                        ),
                    ]
                ),
            ])
        )
    }

    func testStructDeclaration() {
        let test = self.prepareParser(
            ObjectiveCParser.structDeclaration,
            AntlrDeclarationParser.structDeclaration(_:)
        )

        assertEqual(
            test("int field;"),
            .init(
                specifierQualifierList: [
                    .typeSpecifier("int"),
                ],
                fieldDeclaratorList: [
                    .declarator(
                        .init(directDeclarator: "field")
                    ),
                ]
            )
        )
        assertEqual(
            test("int *field;"),
            .init(
                specifierQualifierList: [
                    .typeSpecifier("int"),
                ],
                fieldDeclaratorList: [
                    .declarator(
                        .init(
                            pointer: .init(pointerEntries: [
                                .init(),
                            ]),
                            directDeclarator: "field"
                        )
                    ),
                ]
            )
        )
        assertEqual(
            test("int;"),
            .init(
                specifierQualifierList: [
                    .typeSpecifier("int"),
                ],
                fieldDeclaratorList: []
            )
        )
        assertEqual(
            test("int : 1;"),
            .init(
                specifierQualifierList: [
                    .typeSpecifier("int"),
                ],
                fieldDeclaratorList: [
                    .declaratorConstantExpression(
                        nil,
                        "1"
                    )
                ]
            )
        )
    }

    func testStructOrUnion() {
        let test = self.prepareParser(
            ObjectiveCParser.structOrUnion,
            AntlrDeclarationParser.structOrUnion(_:)
        )

        assertEqual(test("struct"), .struct())
        assertEqual(test("union"), .union())
    }

    // MARK: Enum syntax

    func testEnumSpecifier_enum_noType_noEnumeratorList() {
        let result = runParser(
            """
            enum AnEnum
            """,
            ObjectiveCParser.enumSpecifier,
            AntlrDeclarationParser.enumSpecifier
        )

        assertEqual(
            result,
            .cEnum(
                "AnEnum",
                nil,
                .opaque("AnEnum")
            )
        )
    }

    func testEnumSpecifier_enum_noType_withEnumeratorList() {
        let result = runParser(
            """
            enum AnEnum {
                CASE0,
                CASE1 = 1,
                CASE2,
            }
            """,
            ObjectiveCParser.enumSpecifier,
            AntlrDeclarationParser.enumSpecifier
        )

        assertEqual(
            result,
            .cEnum(
                "AnEnum",
                nil,
                .declared(
                    "AnEnum",
                    .init(enumerators: [
                        .init(
                            enumeratorIdentifier: "CASE0"
                        ),
                        .init(
                            enumeratorIdentifier: "CASE1",
                            expression: "1"
                        ),
                        .init(
                            enumeratorIdentifier: "CASE2"
                        ),
                    ])
                )
            )
        )
    }

    func testEnumSpecifier_enum_withType_withEnumeratorList() {
        let result = runParser(
            """
            enum AnEnum : uint32_t {
                CASE0,
                CASE1 = 1,
                CASE2,
            }
            """,
            ObjectiveCParser.enumSpecifier,
            AntlrDeclarationParser.enumSpecifier
        )

        assertEqual(
            result,
            .cEnum(
                "AnEnum",
                "uint32_t",
                .declared(
                    "AnEnum",
                    .init(enumerators: [
                        .init(
                            enumeratorIdentifier: "CASE0"
                        ),
                        .init(
                            enumeratorIdentifier: "CASE1",
                            expression: "1"
                        ),
                        .init(
                            enumeratorIdentifier: "CASE2"
                        ),
                    ])
                )
            )
        )
    }

    func testEnumSpecifier_nsOptions() {
        let result = runParser(
            """
            NS_OPTIONS(NSInteger, Options) {
                CASE0,
                CASE1 = 1,
                CASE2,
            }
            """,
            ObjectiveCParser.enumSpecifier,
            AntlrDeclarationParser.enumSpecifier
        )

        assertEqual(
            result,
            .nsOptionsOrNSEnum(
                .nsOptions(),
                "NSInteger",
                "Options",
                .init(enumerators: [
                    .init(
                        enumeratorIdentifier: "CASE0"
                    ),
                    .init(
                        enumeratorIdentifier: "CASE1",
                        expression: "1"
                    ),
                    .init(
                        enumeratorIdentifier: "CASE2"
                    ),
                ])
            )
        )
    }

    func testEnumSpecifier_nsEnum() {
        let result = runParser(
            """
            NS_ENUM(NSInteger, Enum) {
                CASE0,
                CASE1 = 1,
                CASE2,
            }
            """,
            ObjectiveCParser.enumSpecifier,
            AntlrDeclarationParser.enumSpecifier
        )

        assertEqual(
            result,
            .nsOptionsOrNSEnum(
                .nsEnum(),
                "NSInteger",
                "Enum",
                .init(enumerators: [
                    .init(
                        enumeratorIdentifier: "CASE0"
                    ),
                    .init(
                        enumeratorIdentifier: "CASE1",
                        expression: "1"
                    ),
                    .init(
                        enumeratorIdentifier: "CASE2"
                    ),
                ])
            )
        )
    }

    func testNSOptionsOrNSEnum() {
        let test = self.prepareParser(
            ObjectiveCParser.enumSpecifier,
            AntlrDeclarationParser.nsOptionsOrNSEnum(_:)
        )
        
        assertEqual(
            test("enum e"),
            nil
        )
        assertEqual(
            test("NS_OPTIONS(int, e) { CASE0 }"),
            .nsOptions()
        )
        assertEqual(
            test("NS_ENUM(int, e) { CASE0 }"),
            .nsEnum()
        )
    }

    func testEnumeratorList() {
        let result = runParser(
            """
            CASE0,
            CASE1 = 1,
            CASE2,
            """,
            ObjectiveCParser.enumeratorList,
            AntlrDeclarationParser.enumeratorList
        )

        assertEqual(
            result,
            .init(enumerators: [
                .init(
                    enumeratorIdentifier: "CASE0"
                ),
                .init(
                    enumeratorIdentifier: "CASE1",
                    expression: "1"
                ),
                .init(
                    enumeratorIdentifier: "CASE2"
                ),
            ])
        )
    }

    func testEnumerator_noExpression() {
        let result = runParser(
            "AN_IDENTIFIER",
            ObjectiveCParser.enumerator,
            AntlrDeclarationParser.enumerator
        )

        assertEqual(result, .init(enumeratorIdentifier: "AN_IDENTIFIER"))
    }

    func testEnumerator_expression() {
        let result = runParser(
            "AN_IDENTIFIER = 10",
            ObjectiveCParser.enumerator,
            AntlrDeclarationParser.enumerator
        )

        assertEqual(
            result,
            .init(
                enumeratorIdentifier: "AN_IDENTIFIER",
                expression: "10"
            )
        )
    }

    // MARK: Leaf syntax

    func testScalarTypeSpecifier() {
        let test = self.prepareParser(
            ObjectiveCParser.scalarTypeSpecifier,
            AntlrDeclarationParser.scalarTypeSpecifier(_:)
        )

        assertEqual(test("void"), .void())
        assertEqual(test("char"), .char())
        assertEqual(test("short"), .short())
        assertEqual(test("int"), .int())
        assertEqual(test("long"), .long())
        assertEqual(test("float"), .float())
        assertEqual(test("double"), .double())
        assertEqual(test("signed"), .signed())
        assertEqual(test("unsigned"), .unsigned())
        assertEqual(test("_Bool"), ._bool())
        assertEqual(test("bool"), .bool())
        assertEqual(test("_Complex"), .complex())
        assertEqual(test("__m128"), .m128())
        assertEqual(test("__m128d"), .m128d())
        assertEqual(test("__m128i"), .m128i())
    }

    func testProtocolQualifier() {
        let test = self.prepareParser(
            ObjectiveCParser.protocolQualifier,
            AntlrDeclarationParser.protocolQualifier(_:)
        )

        assertEqual(test("in"), .in())
        assertEqual(test("out"), .out())
        assertEqual(test("inout"), .inout())
        assertEqual(test("bycopy"), .bycopy())
        assertEqual(test("byref"), .byref())
        assertEqual(test("oneway"), .oneway())
    }

    func testArcBehaviourSpecifier() {
        let test = self.prepareParser(
            ObjectiveCParser.arcBehaviourSpecifier,
            AntlrDeclarationParser.arcBehaviourSpecifier(_:)
        )

        assertEqual(test("__weak"), .weakQualifier())
        assertEqual(test("__strong"), .strongQualifier())
        assertEqual(test("__autoreleasing"), .autoreleasingQualifier())
        assertEqual(test("__unsafe_unretained"), .unsafeUnretainedQualifier())
    }

    func testStorageClassSpecifier() {
        let test = self.prepareParser(
            ObjectiveCParser.storageClassSpecifier,
            AntlrDeclarationParser.storageClassSpecifier(_:)
        )

        assertEqual(test("auto"), .auto())
        assertEqual(test("constexpr"), .constexpr())
        assertEqual(test("extern"), .extern())
        assertEqual(test("register"), .register())
        assertEqual(test("static"), .static())
        assertEqual(test("thread_local"), .threadLocal())
        assertEqual(test("_Thread_local"), .threadLocal())
        assertEqual(test("typedef"), .typedef())
    }

    func testNullabilitySpecifier() {
        let test = self.prepareParser(
            ObjectiveCParser.nullabilitySpecifier,
            AntlrDeclarationParser.nullabilitySpecifier(_:)
        )

        assertEqual(test("null_unspecified"), .nullUnspecified())
        assertEqual(test("nullable"), .nullable())
        assertEqual(test("nonnull"), .nonnull())
        assertEqual(test("null_resettable"), .nullResettable())
        //
        assertEqual(test("__null_unspecified"), .nullUnspecified())
        assertEqual(test("__nullable"), .nullable())
        assertEqual(test("__nonnull"), .nonnull())
        assertEqual(test("__null_resettable"), .nullResettable())
        //
        assertEqual(test("_Null_unspecified"), .nullUnspecified())
        assertEqual(test("_Nullable"), .nullable())
        assertEqual(test("_Nonnull"), .nonnull())
        assertEqual(test("_Null_resettable"), .nullResettable())
    }

    func testTypePrefix() {
        let test = self.prepareParser(
            ObjectiveCParser.typePrefix,
            AntlrDeclarationParser.typePrefix(_:)
        )

        assertEqual(test("__bridge"), .bridge())
        assertEqual(test("__bridge_transfer"), .bridgeTransfer())
        assertEqual(test("__bridge_retained"), .bridgeRetained())
        assertEqual(test("__block"), .block())
        assertEqual(test("inline"), .inline())
        assertEqual(test("NS_INLINE"), .nsInline())
        assertEqual(test("__kindof"), .kindof())
    }

    func testIdentifier() {
        let result = runParser(
            "anIdentifier",
            ObjectiveCParser.identifier,
            AntlrDeclarationParser.identifier
        )

        assertEqual(result, .init(identifier: "anIdentifier"))
    }

    func testGenericTypeParameterVariance() {
        let test = self.prepareParser(
            ObjectiveCParser.genericTypeParameter,
            AntlrDeclarationParser.genericTypeParameterVariance(_:)
        )

        assertEqual(
            test("__covariant int"),
            .covariant()
        )
        assertEqual(
            test("__contravariant int"),
            .contravariant()
        )
    }

    func testExpression() {
        let result = runParser(
            "1 + 1",
            ObjectiveCParser.expression,
            AntlrDeclarationParser.expression
        )

        assertEqual(result, .init(expressionString: "1 + 1"))
    }

    func testConstantExpression() {
        let result = runParser(
            "1",
            ObjectiveCParser.constantExpression,
            AntlrDeclarationParser.constantExpression
        )

        assertEqual(result, .init(constantExpressionString: "1"))
    }
}

// MARK: - Test utils

private extension AntlrDeclarationParserTests {
    func makeSut(string: String) -> TestAntlrDeclarationParser {
        let source = StringCodeSource(source: string)
        
        return makeSut(source: source)
    }

    func makeSut(source: Source) -> TestAntlrDeclarationParser {
        TestAntlrDeclarationParser(source: source)
    }

    func assertEqual<T: Equatable & DeclarationSyntaxElementType>(
        _ lhs: T?,
        _ rhs: T?,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        if lhs == rhs {
            return
        }

        var lhsString = ""
        var rhsString = ""
        let maxDepth: Int = 3

        dump(lhs, to: &lhsString, maxDepth: maxDepth)
        dump(rhs, to: &rhsString, maxDepth: maxDepth)

        XCTAssertEqual(
            lhs,
            rhs,
            """
            ---
            \(lhsString)
            --
            \(rhsString)
            ---
            """,
            file: file,
            line: line
        )
    }

    func prepareParser<TRule: ParserRuleContext, TSyntax: DeclarationSyntaxElementType>(
        file: StaticString = #file,
        line: UInt = #line,
        _ rule: @escaping (ObjectiveCParser) -> () throws -> TRule,
        _ parserMethod: @escaping (AntlrDeclarationParser) -> (TRule?) -> TSyntax?
    ) -> (String) -> TSyntax? {

        return { input in
            self.runParser(input, file: file, line: line, rule, parserMethod)
        }
    }

    func runParser<TRule: ParserRuleContext, TSyntax: DeclarationSyntaxElementType>(
        _ string: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ rule: (ObjectiveCParser) -> () throws -> TRule,
        _ parserMethod: (AntlrDeclarationParser) -> (TRule?) -> TSyntax?
    ) -> TSyntax? {
        
        do {
            let fixture = BaseParserTestFixture()
            let parsed = try fixture.parse(string, ruleDeriver: rule)

            let sut = makeSut(string: string)

            return parserMethod(sut)(parsed)
        } catch {
            XCTFail(
                "Error parsing test source '\(string)': \(error)",
                file: file,
                line: line
            )

            return nil
        }
    }
}

/// Test `AntlrDeclarationParser` used that computes `.invalid` source ranges
/// and source locations for nodes and parser rules by default to ensure test
/// assertions can be made using simple equality testing.
private class TestAntlrDeclarationParser: AntlrDeclarationParser {
    var stripSourceRange: Bool = true

    override func range(_ rule: ParserRuleContext) -> SourceRange {
        if stripSourceRange {
            return .invalid
        }
        
        return source.sourceRange(for: rule)
    }

    override func range(_ node: TerminalNode) -> SourceRange {
        if stripSourceRange {
            return .invalid
        }
        
        return source.sourceRange(for: node)
    }

    override func location(_ rule: ParserRuleContext) -> SourceLocation {
        if stripSourceRange {
            return .invalid
        }
        
        return source.sourceRange(for: rule).start ?? .invalid
    }

    override func location(_ node: TerminalNode) -> SourceLocation {
        if stripSourceRange {
            return .invalid
        }
        
        return source.sourceRange(for: node).start ?? .invalid
    }

    override func sourceString(_ rule: ParserRuleContext) -> String {
        let range = super.range(rule)

        if let substring = source.sourceSubstring(range) {
            return String(substring)
        }

        return rule.getText()
    }
}

// MARK: - Test utils extensions

extension IdentifierSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(identifier: value)
    }
}

extension TypeIdentifierSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(identifier: .init(identifier: value))
    }
}

extension TypeSpecifierSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        switch value {
        case "void":
            self = .scalar(.void())
        case "unsigned":
            self = .scalar(.unsigned())
        case "char":
            self = .scalar(.char())
        case "double":
            self = .scalar(.double())
        case "float":
            self = .scalar(.float())
        case "int":
            self = .scalar(.int())
        case "long":
            self = .scalar(.long())
        case "short":
            self = .scalar(.short())
        case "signed":
            self = .scalar(.signed())
        case "_bool":
            self = .scalar(._bool())
        case "bool":
            self = .scalar(.bool())
        case "complex":
            self = .scalar(.complex())
        case "m128":
            self = .scalar(.m128())
        case "m128d":
            self = .scalar(.m128d())
        case "m128i":
            self = .scalar(.m128i())
        default:
            self = .typeIdentifier(.init(identifier: .init(identifier: value)))
        }
    }
}

extension TypeNameSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(declarationSpecifiers: [
            .typeSpecifier(.init(stringLiteral: value))
        ])
    }
}

extension DeclaratorSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(directDeclarator: .init(stringLiteral: value))
    }
}

extension DirectDeclaratorSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .identifier(.init(stringLiteral: value))
    }
}

extension ExpressionSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(expressionString: value)
    }
}

extension ConstantExpressionSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(constantExpressionString: value)
    }
}

extension InitializerSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .expression(.init(expressionString: value))
    }
}

extension InitDeclaratorListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: InitDeclaratorSyntax...) {
        self.init(initDeclarators: elements)
    }
}

extension PointerSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: PointerSyntaxEntry...) {
        self.init(pointerEntries: elements)
    }
}

extension StructDeclarationListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: StructDeclarationSyntax...) {
        self.init(structDeclaration: elements)
    }
}

extension EnumeratorListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: EnumeratorSyntax...) {
        self.init(enumerators: elements)
    }
}

extension SpecifierQualifierListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: TypeSpecifierQualifierSyntax...) {
        self.init(specifierQualifiers: elements)
    }
}

extension TypeQualifierListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: TypeQualifierSyntax...) {
        self.init(typeQualifiers: elements)
    }
}

extension ParameterTypeListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: ParameterDeclarationSyntax...) {
        self.init(
            parameterList: .init(parameterDeclarations: elements),
            isVariadic: false
        )
    }
}

extension ParameterListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: ParameterDeclarationSyntax...) {
        self.init(parameterDeclarations: elements)
    }
}

extension DeclarationSpecifiersSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: DeclarationSpecifierSyntax...) {
        self.init(typePrefix: nil, declarationSpecifier: elements)
    }
}
