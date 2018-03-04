// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRewriter",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
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
        .package(url: "https://github.com/LuizZak/MiniLexer.git", .branch("swift4.1-experiments")),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
        .package(url: "https://bitbucket.org/cs-luiz-silva/antlr4-swift.git", from: "4.0.12"),
        .package(url: "https://bitbucket.org/cs-luiz-silva/console.git", from: "0.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "TypeDefinitions",
            dependencies: []),
        .target(
            name: "Utils",
            dependencies: []),
        .target(
            name: "ObjcParserAntlr",
            dependencies: ["Antlr4"]),
        .target(
            name: "GrammarModels",
            dependencies: ["ObjcParserAntlr"]),
        .target(
            name: "ObjcParser",
            dependencies: ["ObjcParserAntlr", "Antlr4", "GrammarModels", "MiniLexer", "TypeLexing"]),
        .target(
            name: "SwiftAST",
            dependencies: ["GrammarModels"]),
        .target(
            name: "SwiftRewriterLib",
            dependencies: ["GrammarModels", "SwiftAST", "ObjcParser", "TypeDefinitions", "Utils"]),
        .target(
            name: "IntentionPasses",
            dependencies: ["SwiftRewriterLib", "SwiftAST", "ExpressionPasses", "Utils"]),
        .target(
            name: "ExpressionPasses",
            dependencies: ["SwiftRewriterLib", "SwiftAST", "Utils"]),
        .target(
            name: "SourcePreprocessors",
            dependencies: ["SwiftRewriterLib", "Utils", "MiniLexer"]),
        .target(
            name: "SwiftRewriter",
            dependencies: [
                "SwiftRewriterLib", "ObjcParser", "GrammarModels", "Utility",
                "ExpressionPasses", "Utils", "Console", "SourcePreprocessors",
                "SwiftAST", "IntentionPasses", "MiniLexer"
            ]),
        .target(
            name: "TestCommons",
            dependencies: [
                "SwiftAST", "SwiftRewriterLib"
            ])
        
    ] + /* Tests */ [
        .testTarget(
            name: "UtilsTests",
            dependencies: ["Utils"]),
        .testTarget(
            name: "ObjcParserTests",
            dependencies: ["GrammarModels", "ObjcParser"]),
        .testTarget(
            name: "GrammarModelsTests",
            dependencies: ["GrammarModels"]),
        .testTarget(
            name: "SwiftASTTests",
            dependencies: ["SwiftAST"]),
        .testTarget(
            name: "SwiftRewriterLibTests",
            dependencies: ["SwiftRewriterLib", "SwiftAST", "GrammarModels",
                           "ObjcParser", "ExpressionPasses", "IntentionPasses",
                           "TestCommons"]),
        .testTarget(
            name: "ExpressionPassesTests",
            dependencies: ["ExpressionPasses", "SwiftAST", "SwiftRewriterLib",
                           "Antlr4", "ObjcParser", "ObjcParserAntlr",
                           "IntentionPasses", "IntentionPasses", "TestCommons"]),
        .testTarget(
            name: "SourcePreprocessorsTests",
            dependencies: ["SourcePreprocessors", "Utils", "SwiftRewriterLib",
                           "IntentionPasses"]),
        .testTarget(
            name: "IntentionPassesTests",
            dependencies: ["GrammarModels", "SwiftRewriterLib", "IntentionPasses",
                           "TestCommons"])
    ]
)
