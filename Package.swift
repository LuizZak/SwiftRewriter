// swift-tools-version:5.5
import PackageDescription

let core: [Target] = [
    .target(
        name: "AntlrCommons",
        dependencies: [
            .product(name: "Antlr4", package: "antlr4-swift"),
            "Utils",
        ],
        path: "Sources/Core/AntlrCommons"
    ),
    .target(
        name: "WriterTargetOutput",
        dependencies: [
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            "Utils",
        ],
        path: "Sources/Core/WriterTargetOutput"
    ),
    .target(
        name: "GrammarModelBase",
        dependencies: [
            .product(name: "Antlr4", package: "antlr4-swift"),
            "Utils",
        ],
        path: "Sources/Core/GrammarModelBase"
    ),
    .target(
        name: "SwiftAST",
        dependencies: [
            "MiniLexer", "Utils", "WriterTargetOutput",
        ],
        path: "Sources/Core/SwiftAST"
    ),
    .target(
        name: "KnownType",
        dependencies: [
            "SwiftAST", "WriterTargetOutput",
        ],
        path: "Sources/Core/KnownType"
    ),
    .target(
        name: "Intentions",
        dependencies: [
            "SwiftAST", "GrammarModelBase", "KnownType",
        ],
        path: "Sources/Core/Intentions"
    ),
    .target(
        name: "SwiftSyntaxSupport",
        dependencies: [
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            "KnownType", "Intentions", "SwiftAST",
        ],
        path: "Sources/Core/SwiftSyntaxSupport"
    ),
    .target(
        name: "SwiftSyntaxRewriterPasses",
        dependencies: [
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            "SwiftSyntaxSupport", "Utils", "MiniLexer",
        ],
        path: "Sources/Core/SwiftSyntaxRewriterPasses"
    ),
    .target(
        name: "TypeSystem",
        dependencies: [
            "SwiftAST", "ObjcParser", "TypeDefinitions", "Utils",
            "Intentions", "KnownType", "ObjcGrammarModels",
        ],
        path: "Sources/Core/TypeSystem"
    ),
    .target(
        name: "Commons",
        dependencies: [
            "SwiftAST", "Utils", "TypeSystem", "KnownType",
        ],
        path: "Sources/Core/Commons"
    ),
    .target(
        name: "IntentionPasses",
        dependencies: [
            "SwiftAST", "Commons", "Utils", "MiniLexer",
            "Intentions", "ObjcGrammarModels",
        ],
        path: "Sources/Core/IntentionPasses"
    ),
    .target(
        name: "Analysis",
        dependencies: [
            "SwiftAST", "KnownType", "Commons", "Utils",
            "Intentions", "TypeSystem",
        ],
        path: "Sources/Core/Analysis"
    ),
    .target(
        name: "ExpressionPasses",
        dependencies: [
            "SwiftAST", "Commons", "Utils", "Analysis",
            "Intentions", "TypeSystem", "MiniLexer",
        ],
        path: "Sources/Core/ExpressionPasses"
    ),
    .target(
        name: "SourcePreprocessors",
        dependencies: [
            "Utils", "MiniLexer",
        ],
        path: "Sources/Core/SourcePreprocessors"
    ),
]

let objcFrontend: [Target] = [
    .target(
        name: "ObjcParserAntlr",
        dependencies: [
            .product(name: "Antlr4", package: "antlr4-swift"),
            "AntlrCommons",
        ],
        path: "Sources/Frontend/Objective-C/ObjcParserAntlr"
    ),
    .target(
        name: "ObjcGrammarModels",
        dependencies: [
            "ObjcParserAntlr", "GrammarModelBase", "Utils",
        ],
        path: "Sources/Frontend/Objective-C/ObjcGrammarModels"
    ),
    .target(
        name: "ObjcParser",
        dependencies: [
            .product(name: "Antlr4", package: "antlr4-swift"),
            .product(name: "TypeLexing", package: "MiniLexer"),
            "ObjcParserAntlr", "AntlrCommons", "ObjcGrammarModels", "MiniLexer",
            "Utils",
        ],
        path: "Sources/Frontend/Objective-C/ObjcParser"
    ),
    .target(
        name: "TypeDefinitions",
        path: "Sources/Frontend/Objective-C/TypeDefinitions",
        resources: [
            .copy("ios-framework-classes.json"),
            .copy("ios-framework-protocols.json"),
        ]
    ),
    .target(
        name: "GlobalsProviders",
        dependencies: [
            "SwiftAST", "Commons", "TypeSystem",
        ],
        path: "Sources/Frontend/Objective-C/GlobalsProviders"
    ),
    .target(
        name: "ObjectiveCFrontend",
        dependencies: [
            "SwiftRewriterLib",
        ],
        path: "Sources/Frontend/Objective-C/ObjectiveCFrontend"
    ),
]

let jsFrontend: [Target] = [
    .target(
        name: "JsParserAntlr",
        dependencies: [
            .product(name: "Antlr4", package: "antlr4-swift"),
            "AntlrCommons",
        ],
        path: "Sources/Frontend/JavaScript/JsParserAntlr"
    ),
    .target(
        name: "JsGrammarModels",
        dependencies: [
            "JsParserAntlr", "GrammarModelBase", "Utils"
        ],
        path: "Sources/Frontend/JavaScript/JsGrammarModels"
    ),
    .target(
        name: "JsParser",
        dependencies: [
            .product(name: "Antlr4", package: "antlr4-swift"),
            .product(name: "TypeLexing", package: "MiniLexer"),
            "JsParserAntlr",
            "JsGrammarModels",
            "AntlrCommons",
            "MiniLexer",
            "Utils",
        ],
        path: "Sources/Frontend/JavaScript/JsParser"
    ),
    .target(
        name: "JavaScriptFrontend",
        dependencies: [
            "SwiftRewriterLib",
        ],
        path: "Sources/Frontend/JavaScript/JavaScriptFrontend"
    ),
]

//

let package = Package(
    name: "SwiftRewriter",
    platforms: [
        .macOS(.v10_12),
    ],
    products: [
        .library(
            name: "SwiftRewriterLib",
            targets: ["SwiftRewriterLib"]),
        .library(
            name: "ObjcParser",
            targets: ["ObjcParser"]),
        .executable(
            name: "SwiftRewriter",
            targets: ["SwiftRewriter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/LuizZak/MiniLexer.git", .exact("0.10.0")),
        .package(url: "https://github.com/LuizZak/antlr4-swift.git", .exact("4.1.1")),
        .package(url: "https://github.com/LuizZak/console.git", .exact("0.8.2")),
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50500.0")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-format.git", .exact("0.50500.0")),
    ],
    targets: core + objcFrontend + jsFrontend + [
        .target(
            name: "Utils",
            dependencies: [],
            path: "Sources/Utils"
        ),
        .target(
            name: "SwiftRewriterLib",
            dependencies: [
                .product(name: "Antlr4", package: "antlr4-swift"),
                .product(name: "Console", package: "console"),
                .product(name: "SwiftFormat", package: "swift-format"),
                .product(name: "SwiftFormatConfiguration", package: "swift-format"),
                // Objective-C
                "ObjcGrammarModels", "ObjcParser",
                // JavaScript
                "JsGrammarModels", "JsParser",
                "SwiftAST",
                "Analysis", "TypeDefinitions", "Utils", "Intentions",
                "TypeSystem", "IntentionPasses", "KnownType",
                "WriterTargetOutput", "SwiftSyntaxSupport",
                "GlobalsProviders", "ExpressionPasses",
                "SourcePreprocessors", "SwiftSyntaxRewriterPasses",
            ],
            path: "Sources/SwiftRewriterLib"
        ),
        .target(
            name: "SwiftRewriterCLI",
            dependencies: [
                .product(name: "Console", package: "console"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "SwiftRewriterLib",
                "ExpressionPasses", "Utils", "SourcePreprocessors", "SwiftAST",
                "IntentionPasses", "MiniLexer", "Commons",
            ],
            path: "Sources/SwiftRewriterCLI"
        ),
        .executableTarget(
            name: "SwiftRewriter",
            dependencies: [
                .product(name: "Console", package: "console"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftFormatConfiguration", package: "swift-format"),
                "SwiftRewriterCLI",
                "ObjectiveCFrontend", "SwiftRewriterLib", "ObjcParser", "ObjcGrammarModels",
                "JavaScriptFrontend",
                "ExpressionPasses", "Utils", "SourcePreprocessors", "SwiftAST",
                "IntentionPasses", "MiniLexer", "GlobalsProviders", "Commons",
            ],
            path: "Sources/SwiftRewriter"
        ),
        .target(
            name: "TestCommons",
            dependencies: [
                "SwiftAST", "SwiftSyntaxSupport", "SwiftRewriterLib", "Intentions",
                "KnownType", "ObjcGrammarModels", "Utils", "TypeSystem",
                "ObjectiveCFrontend",
            ],
            path: "Sources/TestCommons"
        ),
        /* Tests */
        .testTarget(
            name: "UtilsTests",
            dependencies: [
                "Utils",
            ],
            path: "Tests/UtilsTests"
        ),
        .testTarget(
            name: "WriterTargetOutputTests",
            dependencies: [
                "WriterTargetOutput",
                "TestCommons",
            ],
            path: "Tests/Core/WriterTargetOutputTests"
        ),
        .testTarget(
            name: "ObjcParserTests",
            dependencies: [
                "ObjcGrammarModels",
                "ObjcParser",
            ],
            path: "Tests/Frontend/Objective-C/ObjcParserTests"
        ),
        .testTarget(
            name: "ObjcGrammarModelsTests",
            dependencies: [
                "ObjcGrammarModels",
            ],
            path: "Tests/Frontend/Objective-C/ObjcGrammarModelsTests"
        ),
        .testTarget(
            name: "GrammarModelBaseTests",
            dependencies: [
                "GrammarModelBase",
            ],
            path: "Tests/Core/GrammarModelBaseTests"
        ),
        .testTarget(
            name: "SwiftASTTests",
            dependencies: [
                "SwiftAST",
                "TestCommons",
            ],
            path: "Tests/Core/SwiftASTTests"
        ),
        .testTarget(
            name: "IntentionsTests",
            dependencies: [
                "Intentions",
                "TestCommons", "SwiftAST",
            ],
            path: "Tests/Core/IntentionsTests"
        ),
        .testTarget(
            name: "KnownTypeTests",
            dependencies: [
                "KnownType",
                "TestCommons", "SwiftAST", "WriterTargetOutput",
            ],
            path: "Tests/Core/KnownTypeTests"
        ),
        .testTarget(
            name: "SwiftSyntaxSupportTests",
            dependencies: [
                "SwiftSyntaxSupport",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                "KnownType", "Intentions", "SwiftAST",
                "TestCommons", "SwiftRewriterLib",
            ],
            path: "Tests/Core/SwiftSyntaxSupportTests"
        ),
        .testTarget(
            name: "TypeSystemTests",
            dependencies: [
                "TypeSystem",
                "SwiftAST", "ObjcParser", "TypeDefinitions", "Utils",
                "Intentions", "ObjcGrammarModels", "KnownType", "TestCommons",
                "GlobalsProviders",
            ],
            path: "Tests/Core/TypeSystemTests"
        ),
        .testTarget(
            name: "SwiftSyntaxRewriterPassesTests",
            dependencies: [
                "SwiftSyntaxRewriterPasses",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                "SwiftSyntaxSupport", "TestCommons",
            ],
            path: "Tests/Core/SwiftSyntaxRewriterPassesTests"
        ),
        .testTarget(
            name: "SwiftRewriterLibTests",
            dependencies: [
                "SwiftRewriterLib",
                "SwiftAST", "ObjcGrammarModels", "ObjcParser", "ExpressionPasses",
                "IntentionPasses", "TestCommons", "GlobalsProviders",
                "Intentions", "TypeSystem", "WriterTargetOutput",
                "SwiftSyntaxSupport", "SwiftSyntaxRewriterPasses",
            ],
            path: "Tests/SwiftRewriterLibTests"
        ),
        .testTarget(
            name: "CommonsTests",
            dependencies: [
                "Commons",
                "SwiftAST", "KnownType", "SwiftRewriterLib",
                "TypeSystem",
            ],
            path: "Tests/Core/CommonsTests"
        ),
        .testTarget(
            name: "ExpressionPassesTests",
            dependencies: [
                "ExpressionPasses",
                .product(name: "Antlr4", package: "antlr4-swift"),
                "ObjectiveCFrontend",
                "SwiftAST", "SwiftRewriterLib", "ObjcParser",
                "ObjcParserAntlr", "IntentionPasses", "GlobalsProviders",
                "TypeSystem", "TestCommons",
            ],
            path: "Tests/Core/ExpressionPassesTests"
        ),
        .testTarget(
            name: "SourcePreprocessorsTests",
            dependencies: [
                "SourcePreprocessors",
                "Utils", "SwiftRewriterLib", "IntentionPasses",
                "GlobalsProviders",
            ],
            path: "Tests/Core/SourcePreprocessorsTests"
        ),
        .testTarget(
            name: "IntentionPassesTests",
            dependencies: [
                "IntentionPasses",
                "ObjectiveCFrontend",
                "SwiftAST", "ObjcGrammarModels", "SwiftRewriterLib",
                "TestCommons", "GlobalsProviders", "TypeSystem",
            ],
            path: "Tests/Core/IntentionPassesTests"
        ),
        .testTarget(
            name: "GlobalsProvidersTests",
            dependencies: [
                "GlobalsProviders",
                "SwiftAST", "SwiftRewriterLib", "TestCommons", "TypeSystem",
            ],
            path: "Tests/Frontend/Objective-C/GlobalsProvidersTests"
        ),
        .testTarget(
            name: "AnalysisTests",
            dependencies: [
                "Analysis",
                "SwiftAST", "SwiftRewriterLib", "GlobalsProviders",
                "TestCommons", "TypeSystem",
            ],
            path: "Tests/Core/AnalysisTests"
        ),
        .testTarget(
            name: "TestCommonsTests",
            dependencies: [
                "TestCommons",
                "Utils", "TypeSystem",
            ],
            path: "Tests/TestCommonsTests"
        ),
        .testTarget(
            name: "ObjectiveCFrontendTests",
            dependencies: [
                "ObjectiveCFrontend",
                "TestCommons",
            ],
            path: "Tests/Frontend/Objective-C/ObjectiveCFrontendTests"
        ),
        .testTarget(
            name: "JsParserTests",
            dependencies: [
                "JsParser", "TestCommons",
            ],
            path: "Tests/Frontend/JavaScript/JsParserTests",
            resources: [
                .copy("Fixtures/bezier.js"),
                .copy("Fixtures/utils.js"),
                .copy("Fixtures/EnhancedRegularExpression.js"),
                .copy("Fixtures/Function.js"),
                .copy("Fixtures/TemplateStrings.js"),
                .copy("Fixtures/Classes.js"),
                .copy("Fixtures/Stage3.js"),
                .copy("Fixtures/ClassInNonGlobalStrict.js"),
                .copy("Fixtures/ObjectInitializer.js"),
                .copy("Fixtures/DestructuringAssignment.js"),
                .copy("Fixtures/SymbolType.js"),
                .copy("Fixtures/Generators.js"),
                .copy("Fixtures/LetAndAsync.js"),
                .copy("Fixtures/Iterators.js"),
                .copy("Fixtures/Issue2178NewExpression.js"),
                .copy("Fixtures/EnhancedObjectProperties.js"),
                .copy("Fixtures/Modules.js"),
                .copy("Fixtures/TypedArrays.js"),
                .copy("Fixtures/MapSetAndWeakMapWeakSet.js"),
                .copy("Fixtures/TemplateLiterals.js"),
                .copy("Fixtures/ExtendedLiterals.js"),
                .copy("Fixtures/Constants.js"),
                .copy("Fixtures/Promises.js"),
                .copy("Fixtures/Outdated.js"),
                .copy("Fixtures/Misc.js"),
                .copy("Fixtures/ExtendedParameterHandling.js"),
                .copy("Fixtures/Scoping.js"),
                .copy("Fixtures/NewBuildInMethods.js"),
                .copy("Fixtures/StrictGlobal.js"),
                .copy("Fixtures/ArrowFunctions.js"),
                .copy("Fixtures/AsyncAwait.js"),
                .copy("Fixtures/StrictFunctions.js"),
                .copy("Fixtures/Meta-Programming.js"),
                .copy("Fixtures/InternationalizationAndLocalization.js"),
            ]
        ),
        .testTarget(
            name: "JavaScriptFrontendTests",
            dependencies: [
                "JavaScriptFrontend",
                "TestCommons",
            ],
            path: "Tests/Frontend/JavaScript/JavaScriptFrontendTests"
        ),
        .testTarget(
            name: "SwiftRewriterTests",
            dependencies: [
                "SwiftRewriter",
            ],
            path: "Tests/SwiftRewriterTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
