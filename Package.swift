// swift-tools-version:5.5
import PackageDescription

let core: [Target] = [
    .target(
        name: "GraphvizLib",
        dependencies: [

        ],
        path: "Sources/Core/GraphvizLib"
    ),
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
        name: "Analysis",
        dependencies: [
            "SwiftAST", "KnownType", "Commons", "Utils",
            "Intentions", "TypeSystem", "GraphvizLib",
        ],
        path: "Sources/Core/Analysis"
    ),
    .target(
        name: "IntentionPasses",
        dependencies: [
            "SwiftAST", "Commons", "Utils", "MiniLexer",
            "Intentions", "ObjcGrammarModels", "Analysis",
        ],
        path: "Sources/Core/IntentionPasses"
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
    .testTarget(
        name: "ObjcParserTests",
        dependencies: [
            "ObjcGrammarModels",
            "ObjcParser",
            "TestCommons",
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
        name: "GlobalsProvidersTests",
        dependencies: [
            "GlobalsProviders",
            "SwiftAST", "SwiftRewriterLib", "TestCommons", "TypeSystem",
        ],
        path: "Tests/Frontend/Objective-C/GlobalsProvidersTests"
    ),
    .testTarget(
        name: "ObjectiveCFrontendTests",
        dependencies: [
            "ObjectiveCFrontend",
            "TestCommons",
        ],
        path: "Tests/Frontend/Objective-C/ObjectiveCFrontendTests"
    ),
]

//

let package = Package(
    name: "SwiftRewriter",
    platforms: [
        .macOS(.v10_15),
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
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/LuizZak/antlr4-swift.git", .exact("4.1.2")),
        .package(url: "https://github.com/LuizZak/console.git", .exact("0.8.2")),
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50700.1")),
        .package(url: "https://github.com/apple/swift-format.git", .exact("0.50700.1")),
    ],
    targets: core
        + objcFrontend
        + [
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
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                // Objective-C
                "ObjcGrammarModels", "ObjcParser",
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
                "SwiftRewriterCLI", "SwiftRewriterLib",
                "ExpressionPasses", "Utils", "SourcePreprocessors", "SwiftAST",
                "IntentionPasses", "MiniLexer", "GlobalsProviders", "Commons",
                // Objective-C frontend
                "ObjectiveCFrontend", "ObjcParser", "ObjcGrammarModels",
            ],
            path: "Sources/SwiftRewriter"
        ),
        .target(
            name: "TestCommons",
            dependencies: [
                .product(name: "Antlr4", package: "antlr4-swift"), "SwiftAST",
                "SwiftSyntaxSupport", "SwiftRewriterLib", "Intentions",
                "KnownType", "ObjcGrammarModels", "Utils", "TypeSystem",
                "ObjectiveCFrontend", "MiniLexer",
            ],
            path: "Sources/TestCommons"
        ),
        /* Tests */
        .testTarget(
            name: "GraphvizLibTests",
            dependencies: [
                "GraphvizLib",
                "TestCommons",
            ],
            path: "Tests/Core/GraphvizLibTests"
        ),
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
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                "TestCommons",
            ],
            path: "Tests/Core/WriterTargetOutputTests"
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
                "SwiftSyntaxSupport",
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
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                "KnownType", "Intentions", "SwiftAST", "TestCommons",
                "SwiftRewriterLib",
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
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                "SwiftSyntaxSupport", "TestCommons",
            ],
            path: "Tests/Core/SwiftSyntaxRewriterPassesTests"
        ),
        .testTarget(
            name: "SwiftRewriterLibTests",
            dependencies: [
                "SwiftRewriterLib",
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
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
            name: "AnalysisTests",
            dependencies: [
                "Analysis",
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                "SwiftAST", "SwiftRewriterLib", "GlobalsProviders",
                "TestCommons", "TypeSystem", "GraphvizLib",
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
            name: "SwiftRewriterTests",
            dependencies: [
                "SwiftRewriter",
            ],
            path: "Tests/SwiftRewriterTests"
        ),
    ],
    swiftLanguageVersions: [
        .v5,
    ]
)
