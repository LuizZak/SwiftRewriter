// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to
// build this package.

import PackageDescription
let package = Package(
    name: "SwiftRewriter",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        // Products define the executables and libraries produced by a package,
        // and make them visible to other packages.
        .library(
            name: "SwiftRewriterLib",
            targets: ["SwiftRewriterLib"]),
        .library(
            name: "ObjcParser",
            targets: ["ObjcParser"]),
        .executable(
            name: "SwiftRewriter",
            targets: ["SwiftRewriter"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/LuizZak/MiniLexer.git", .exact("0.10.0")),
        .package(url: "https://github.com/LuizZak/antlr4-swift.git", from: "4.0.32"),
        .package(url: "https://github.com/LuizZak/console.git", .exact("0.8.0")),
        .package(url: "https://github.com/apple/swift-syntax.git", .branch("swift-5.3-DEVELOPMENT-SNAPSHOT-2020-06-24-a")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .exact("0.0.4"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define
        // a module or a test suite.
        // Targets can depend on other targets in this package, and on products
        // in packages which this package depends on.
        .target(
            name: "TypeDefinitions",
            dependencies: []),
        .target(
            name: "Utils",
            dependencies: []),
        .target(
            name: "WriterTargetOutput",
            dependencies: ["Utils"]),
        .target(
            name: "SwiftAST",
            dependencies: ["MiniLexer", "Utils", "WriterTargetOutput"]),
        .target(
            name: "ObjcParserAntlr",
            dependencies: ["Antlr4"]),
        .target(
            name: "GrammarModels",
            dependencies: ["ObjcParserAntlr"]),
        .target(
            name: "ObjcParser",
            dependencies: ["ObjcParserAntlr", "Antlr4", "GrammarModels", "MiniLexer",
                           "TypeLexing", "Utils"]),
        .target(
            name: "KnownType",
            dependencies: ["SwiftAST", "WriterTargetOutput"]),
        .target(
            name: "Intentions",
            dependencies: ["SwiftAST", "GrammarModels", "KnownType", "ObjcParser"]),
        .target(
            name: "SwiftSyntaxSupport",
            dependencies: ["SwiftSyntax", "KnownType", "Intentions", "SwiftAST"]),
        .target(
            name: "SwiftSyntaxRewriterPasses",
            dependencies: ["SwiftSyntax", "SwiftSyntaxSupport", "Utils", "MiniLexer"]),
        .target(
            name: "TypeSystem",
            dependencies: ["SwiftAST", "ObjcParser", "TypeDefinitions", "Utils",
                           "Intentions", "KnownType", "GrammarModels"]),
        .target(
            name: "Commons",
            dependencies: ["SwiftAST", "Utils", "TypeSystem", "KnownType"]),
        .target(
            name: "IntentionPasses",
            dependencies: ["SwiftAST", "Commons", "Utils", "MiniLexer",
                           "Intentions", "GrammarModels"]),
        .target(
            name: "GlobalsProviders",
            dependencies: ["SwiftAST", "Commons", "TypeSystem"]),
        .target(
            name: "Analysis",
            dependencies: ["SwiftAST", "KnownType", "Commons", "Utils",
                           "Intentions", "TypeSystem"]),
        .target(
            name: "ExpressionPasses",
            dependencies: ["SwiftAST", "Commons", "Utils", "Analysis",
                           "Intentions", "TypeSystem", "MiniLexer"]),
        .target(
            name: "SourcePreprocessors",
            dependencies: ["Utils", "MiniLexer"]),
        .target(
            name: "SwiftRewriterLib",
            dependencies: ["Antlr4", "GrammarModels", "SwiftAST", "ObjcParser",
                           "Analysis", "TypeDefinitions", "Utils", "Intentions",
                           "TypeSystem", "IntentionPasses", "KnownType",
                           "WriterTargetOutput", "SwiftSyntaxSupport",
                           "GlobalsProviders", "ExpressionPasses",
                           "SourcePreprocessors", "SwiftSyntaxRewriterPasses"]),
        .target(
            name: "SwiftRewriter",
            dependencies: [
                "SwiftRewriterLib", "ObjcParser", "GrammarModels", "Console",
                "ExpressionPasses", "Utils", "SourcePreprocessors", "SwiftAST",
                "IntentionPasses", "MiniLexer", "GlobalsProviders", "Commons",
                "ArgumentParser"
            ]),
        .target(
            name: "TestCommons",
            dependencies: [
                "SwiftAST", "SwiftSyntaxSupport", "SwiftRewriterLib", "Intentions",
                "KnownType", "GrammarModels", "Utils", "TypeSystem"
            ])
        
    ] + /* Tests */ [
        .testTarget(
            name: "UtilsTests",
            dependencies: ["Utils"]),
        .testTarget(
            name: "WriterTargetOutputTests",
            dependencies: ["WriterTargetOutput", "TestCommons"]),
        .testTarget(
            name: "ObjcParserTests",
            dependencies: ["GrammarModels", "ObjcParser"]),
        .testTarget(
            name: "GrammarModelsTests",
            dependencies: ["GrammarModels"]),
        .testTarget(
            name: "SwiftASTTests",
            dependencies: ["SwiftAST", "TestCommons"]),
        .testTarget(
            name: "IntentionsTests",
            dependencies: ["Intentions",
                           "TestCommons", "SwiftAST"]),
        .testTarget(
            name: "KnownTypeTests",
            dependencies: ["KnownType",
                           "TestCommons", "SwiftAST", "WriterTargetOutput"]),
        .testTarget(
            name: "SwiftSyntaxSupportTests",
            dependencies: ["SwiftSyntaxSupport",
                           "SwiftSyntax", "KnownType", "Intentions", "SwiftAST",
                           "TestCommons", "SwiftRewriterLib"]),
        .testTarget(
            name: "TypeSystemTests",
            dependencies: ["TypeSystem",
                           "SwiftAST", "ObjcParser", "TypeDefinitions", "Utils",
                           "Intentions", "GrammarModels", "KnownType", "TestCommons",
                           "GlobalsProviders"]),
        .testTarget(
            name: "SwiftSyntaxRewriterPassesTests",
            dependencies: ["SwiftSyntaxRewriterPasses", "SwiftSyntax", "SwiftSyntaxSupport",
                           "TestCommons"]),
        .testTarget(
            name: "SwiftRewriterLibTests",
            dependencies: ["SwiftRewriterLib",
                           "SwiftAST", "GrammarModels", "ObjcParser", "ExpressionPasses",
                           "IntentionPasses", "TestCommons", "GlobalsProviders",
                           "Intentions", "TypeSystem", "WriterTargetOutput",
                           "SwiftSyntaxSupport", "SwiftSyntaxRewriterPasses"]),
        .testTarget(
            name: "CommonsTests",
            dependencies: ["Commons",
                           "SwiftAST", "KnownType", "SwiftRewriterLib",
                           "TypeSystem"]),
        .testTarget(
            name: "ExpressionPassesTests",
            dependencies: ["ExpressionPasses",
                           "SwiftAST", "SwiftRewriterLib", "Antlr4", "ObjcParser",
                           "ObjcParserAntlr", "IntentionPasses", "GlobalsProviders",
                           "TypeSystem", "TestCommons"]),
        .testTarget(
            name: "SourcePreprocessorsTests",
            dependencies: ["SourcePreprocessors",
                           "Utils", "SwiftRewriterLib", "IntentionPasses",
                           "GlobalsProviders"]),
        .testTarget(
            name: "IntentionPassesTests",
            dependencies: ["IntentionPasses",
                           "SwiftAST", "GrammarModels", "SwiftRewriterLib",
                           "TestCommons", "GlobalsProviders", "TypeSystem"]),
        .testTarget(
            name: "GlobalsProvidersTests",
            dependencies: ["GlobalsProviders",
                           "SwiftAST", "SwiftRewriterLib", "TestCommons", "TypeSystem"]),
        .testTarget(
            name: "AnalysisTests",
            dependencies: ["Analysis",
                           "SwiftAST", "SwiftRewriterLib", "GlobalsProviders",
                           "TestCommons", "TypeSystem"]),
        .testTarget(
            name: "TestCommonsTests",
            dependencies: ["TestCommons",
                           "Utils", "TypeSystem"]),
        .testTarget(
            name: "SwiftRewriterTests",
            dependencies: ["SwiftRewriter"])
    ],
    swiftLanguageVersions: [.v5]
)
