// swift-tools-version:5.9
import PackageDescription
import CompilerPluginSupport
import Foundation

var extraAntlrTargetSettings: [SwiftSetting] = []

if ProcessInfo.processInfo.environment["SWIFT_REWRITER_BUILD_ANTLR_OPTIMIZED"] != nil {
    extraAntlrTargetSettings = [
        .unsafeFlags([
            "-O",
        ])
    ]
}

// MARK: - Core

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
        name: "KnownType",
        dependencies: [
            .product(name: "SwiftAST", package: "SwiftAST"),
            "WriterTargetOutput",
        ],
        path: "Sources/Core/KnownType"
    ),
    .target(
        name: "Intentions",
        dependencies: [
            .product(name: "SwiftAST", package: "SwiftAST"),
            "GrammarModelBase", "KnownType",
        ],
        path: "Sources/Core/Intentions"
    ),
    .target(
        name: "SwiftSyntaxSupport",
        dependencies: [
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            .product(name: "SwiftAST", package: "SwiftAST"),
            "KnownType", "Intentions",
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
            .product(name: "SwiftAST", package: "SwiftAST"),
            "ObjcParser", "TypeDefinitions", "Utils",
            "Intentions", "KnownType", "ObjcGrammarModels",
        ],
        path: "Sources/Core/TypeSystem"
    ),
    .target(
        name: "Commons",
        dependencies: [
            .product(name: "SwiftAST", package: "SwiftAST"),
            "Utils", "TypeSystem", "KnownType",
        ],
        path: "Sources/Core/Commons"
    ),
    .target(
        name: "Analysis",
        dependencies: [
            .product(name: "SwiftAST", package: "SwiftAST"),
            .product(name: "SwiftCFG", package: "SwiftAST"),
            .product(name: "MiniGraphviz", package: "MiniGraphviz"),
            .product(name: "MiniDigraph", package: "MiniDigraph"),
            "KnownType", "Commons", "Utils",
            "Intentions", "TypeSystem",
        ],
        path: "Sources/Core/Analysis"
    ),
    .target(
        name: "IntentionPasses",
        dependencies: [
            .product(name: "SwiftAST", package: "SwiftAST"),
            "Commons", "Utils", "MiniLexer",
            "Intentions", "ObjcGrammarModels", "Analysis",
        ],
        path: "Sources/Core/IntentionPasses"
    ),
    .target(
        name: "ExpressionPasses",
        dependencies: [
            .product(name: "SwiftAST", package: "SwiftAST"),
            "Commons", "Utils", "Analysis",
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

let coreTests: [Target] = [
    /* Tests */
    .testTarget(
        name: "WriterTargetOutputTests",
        dependencies: [
            "WriterTargetOutput",
            .product(name: "SwiftParser", package: "swift-syntax"),
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
        name: "IntentionsTests",
        dependencies: [
            .product(name: "SwiftAST", package: "SwiftAST"),
            "Intentions",
            "TestCommons",
        ],
        path: "Tests/Core/IntentionsTests"
    ),
    .testTarget(
        name: "KnownTypeTests",
        dependencies: [
            .product(name: "SwiftAST", package: "SwiftAST"),
            "KnownType",
            "TestCommons", "WriterTargetOutput",
        ],
        path: "Tests/Core/KnownTypeTests"
    ),
    .testTarget(
        name: "SwiftSyntaxSupportTests",
        dependencies: [
            "SwiftSyntaxSupport",
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftParser", package: "swift-syntax"),
            .product(name: "SwiftAST", package: "SwiftAST"),
            "KnownType", "Intentions", "TestCommons",
            "SwiftRewriterLib",
        ],
        path: "Tests/Core/SwiftSyntaxSupportTests"
    ),
    .testTarget(
        name: "TypeSystemTests",
        dependencies: [
            "TypeSystem",
            .product(name: "SwiftAST", package: "SwiftAST"),
            "ObjcParser", "TypeDefinitions", "Utils",
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
            .product(name: "SwiftParser", package: "swift-syntax"),
            "SwiftSyntaxSupport", "TestCommons",
        ],
        path: "Tests/Core/SwiftSyntaxRewriterPassesTests"
    ),
    .testTarget(
        name: "CommonsTests",
        dependencies: [
            "Commons",
            .product(name: "SwiftAST", package: "SwiftAST"),
            "KnownType", "SwiftRewriterLib", "TypeSystem",
        ],
        path: "Tests/Core/CommonsTests"
    ),
    .testTarget(
        name: "ExpressionPassesTests",
        dependencies: [
            "ExpressionPasses",
            .product(name: "Antlr4", package: "antlr4-swift"),
            .product(name: "SwiftAST", package: "SwiftAST"),
            "ObjectiveCFrontend",
            "SwiftRewriterLib", "ObjcParser",
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
            .product(name: "SwiftAST", package: "SwiftAST"),
            "ObjectiveCFrontend", "ObjcGrammarModels", "SwiftRewriterLib",
            "TestCommons", "GlobalsProviders", "TypeSystem",
        ],
        path: "Tests/Core/IntentionPassesTests"
    ),
    .testTarget(
        name: "AnalysisTests",
        dependencies: [
            "Analysis",
            .product(name: "SwiftParser", package: "swift-syntax"),
            .product(name: "SwiftAST", package: "SwiftAST"),
            .product(name: "MiniGraphviz", package: "MiniGraphviz"),
            "SwiftRewriterLib", "GlobalsProviders",
            "TestCommons", "TypeSystem",
        ],
        path: "Tests/Core/AnalysisTests"
    ),
]

// MARK: - Main SwiftRewriter frontend

var swiftRewriterTarget: Target = .executableTarget(
    name: "SwiftRewriter",
    dependencies: [
        .product(name: "Console", package: "console"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
        .product(name: "SwiftAST", package: "SwiftAST"),
        "SwiftRewriterCLI", "SwiftRewriterLib",
        "ExpressionPasses", "Utils", "SourcePreprocessors",
        "IntentionPasses", "MiniLexer", "Commons",
    ],
    path: "Sources/SwiftRewriter"
)

var frontendTargets: [Target] = []
var frontendTestTargets: [Target] = []

// MARK: - Objective-C frontend

let objcFrontend: [Target] = [
    .target(
        name: "ObjcParserAntlr",
        dependencies: [
            .product(name: "Antlr4", package: "antlr4-swift"),
            "AntlrCommons",
        ],
        path: "Sources/Frontend/Objective-C/ObjcParserAntlr",
        swiftSettings: extraAntlrTargetSettings
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
            .product(name: "SwiftAST", package: "SwiftAST"),
            "Commons", "TypeSystem",
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

let objcFrontendTests: [Target] = [
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
            .product(name: "SwiftAST", package: "SwiftAST"),
            "SwiftRewriterLib", "TestCommons", "TypeSystem",
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

// Attach Objective-C frontend to SwiftRewriter
swiftRewriterTarget.dependencies.append(contentsOf: [
    // Objective-C frontend
    "ObjectiveCFrontend",
    "ObjcParser",
    "ObjcGrammarModels",
    "GlobalsProviders",
])

frontendTargets.append(contentsOf: objcFrontend)
frontendTestTargets.append(contentsOf: objcFrontendTests)

//
let aggregateTargets: [Target] =
    core + coreTests +
    frontendTargets + frontendTestTargets

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
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        .package(url: "https://github.com/LuizZak/antlr4-swift.git", exact: "4.1.2"),
        .package(url: "https://github.com/LuizZak/console.git", exact:  "0.8.2"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.0"),
        .package(url: "https://github.com/apple/swift-format.git", from: "510.0.0"),
        //
        .package(url: "https://github.com/LuizZak/MiniLexer.git", exact: "0.10.0"),
        .package(url: "https://github.com/LuizZak/MiniGraphviz.git", exact: "0.1.0"),
        .package(url: "https://github.com/LuizZak/MiniDigraph.git", exact: "0.2.1"),
        .package(url: "https://github.com/LuizZak/SwiftAST.git", exact: "0.2.0"),
    ],
    targets: aggregateTargets + [
        swiftRewriterTarget,
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
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftIDEUtils", package: "swift-syntax"),
                .product(name: "SwiftAST", package: "SwiftAST"),
                .product(name: "SwiftCFG", package: "SwiftAST"),
                "Analysis", "TypeDefinitions", "Utils", "Intentions",
                "TypeSystem", "IntentionPasses", "KnownType",
                "WriterTargetOutput", "SwiftSyntaxSupport", "GlobalsProviders",
                "ExpressionPasses", "SourcePreprocessors",
                "SwiftSyntaxRewriterPasses",
            ],
            path: "Sources/SwiftRewriterLib"
        ),
        .target(
            name: "SwiftRewriterCLI",
            dependencies: [
                .product(name: "Console", package: "console"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftAST", package: "SwiftAST"),
                "SwiftRewriterLib",
                "ExpressionPasses", "Utils", "SourcePreprocessors",
                "IntentionPasses", "MiniLexer", "Commons",
            ],
            path: "Sources/SwiftRewriterCLI"
        ),
        .target(
            name: "TestCommons",
            dependencies: [
                .product(name: "Antlr4", package: "antlr4-swift"),
                .product(name: "SwiftAST", package: "SwiftAST"),
                "SwiftSyntaxSupport", "SwiftRewriterLib", "Intentions",
                "KnownType", "ObjcGrammarModels", "Utils", "TypeSystem",
                "ObjectiveCFrontend", "MiniLexer",
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
            name: "SwiftRewriterLibTests",
            dependencies: [
                "SwiftRewriterLib",
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftAST", package: "SwiftAST"),
                "ObjcGrammarModels", "ObjcParser", "ExpressionPasses",
                "IntentionPasses", "TestCommons", "GlobalsProviders",
                "Intentions", "TypeSystem", "WriterTargetOutput",
                "SwiftSyntaxSupport", "SwiftSyntaxRewriterPasses",
            ],
            path: "Tests/SwiftRewriterLibTests"
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
