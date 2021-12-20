// swift-tools-version:5.5
import PackageDescription

let core: [Target] = [
    .target(
        name: "WriterTargetOutput",
        dependencies: [
            "Utils",
        ],
        path: "Sources/Core/WriterTargetOutput"
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
            "SwiftAST", "GrammarModels", "KnownType",
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
            "Intentions", "KnownType", "GrammarModels",
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
            "Intentions", "GrammarModels",
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
        ],
        path: "Sources/Frontend/Objective-C/ObjcParserAntlr"
    ),
    .target(
        name: "GrammarModels",
        dependencies: [
            "ObjcParserAntlr", "Utils",
        ],
        path: "Sources/Frontend/Objective-C/GrammarModels"
    ),
    .target(
        name: "ObjcParser",
        dependencies: [
            .product(name: "Antlr4", package: "antlr4-swift"),
            .product(name: "TypeLexing", package: "MiniLexer"),
            "ObjcParserAntlr", "GrammarModels", "MiniLexer",
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
        .package(url: "https://github.com/LuizZak/antlr4-swift.git", from: "4.0.34"),
        .package(url: "https://github.com/LuizZak/console.git", .exact("0.8.0")),
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50500.0")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .exact("0.3.1")),
    ],
    targets: core + objcFrontend + [
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
                "GrammarModels", "SwiftAST", "ObjcParser",
                "Analysis", "TypeDefinitions", "Utils", "Intentions",
                "TypeSystem", "IntentionPasses", "KnownType",
                "WriterTargetOutput", "SwiftSyntaxSupport",
                "GlobalsProviders", "ExpressionPasses",
                "SourcePreprocessors", "SwiftSyntaxRewriterPasses",
            ],
            path: "Sources/SwiftRewriterLib"
        ),
        .executableTarget(
            name: "SwiftRewriter",
            dependencies: [
                .product(name: "Console", package: "console"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ObjectiveCFrontend", "SwiftRewriterLib", "ObjcParser", "GrammarModels",
                "ExpressionPasses", "Utils", "SourcePreprocessors", "SwiftAST",
                "IntentionPasses", "MiniLexer", "GlobalsProviders", "Commons",
            ],
            path: "Sources/SwiftRewriter"
        ),
        .target(
            name: "TestCommons",
            dependencies: [
                "SwiftAST", "SwiftSyntaxSupport", "SwiftRewriterLib", "Intentions",
                "KnownType", "GrammarModels", "Utils", "TypeSystem",
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
                "GrammarModels",
                "ObjcParser",
            ],
            path: "Tests/Frontend/Objective-C/ObjcParserTests"
        ),
        .testTarget(
            name: "GrammarModelsTests",
            dependencies: [
                "GrammarModels",
            ],
            path: "Tests/Frontend/Objective-C/GrammarModelsTests"
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
                "Intentions", "GrammarModels", "KnownType", "TestCommons",
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
                "SwiftAST", "GrammarModels", "ObjcParser", "ExpressionPasses",
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
                "SwiftAST", "GrammarModels", "SwiftRewriterLib",
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
            name: "SwiftRewriterTests",
            dependencies: [
                "SwiftRewriter",
            ],
            path: "Tests/SwiftRewriterTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
