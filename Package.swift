// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to
// build this package.

import PackageDescription

let package = Package(
    name: "SwiftRewriter",
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
        .package(url: "https://github.com/LuizZak/MiniLexer.git", ._branchItem("swift4.2")),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
        .package(url: "https://github.com/LuizZak/antlr4-swift.git", ._branchItem("swift4.2")),
        .package(url: "https://github.com/LuizZak/console.git", from: "0.1.0")
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
            name: "SwiftAST",
            dependencies: ["GrammarModels", "MiniLexer"]),
        .target(
            name: "SwiftRewriterLib",
            dependencies: ["GrammarModels", "SwiftAST", "ObjcParser",
                           "TypeDefinitions", "Utils"]),
        .target(
            name: "Commons",
            dependencies: ["SwiftAST", "SwiftRewriterLib", "Utils"]),
        .target(
            name: "IntentionPasses",
            dependencies: ["SwiftRewriterLib", "SwiftAST", "Commons", "Utils",
                           "MiniLexer"]),
        .target(
            name: "GlobalsProviders",
            dependencies: ["SwiftRewriterLib", "SwiftAST", "Commons"]),
        .target(
            name: "ExpressionPasses",
            dependencies: ["SwiftRewriterLib", "SwiftAST", "Commons", "Utils"]),
        .target(
            name: "SourcePreprocessors",
            dependencies: ["SwiftRewriterLib", "Utils", "MiniLexer"]),
        .target(
            name: "SwiftRewriter",
            dependencies: [
                "SwiftRewriterLib", "ObjcParser", "GrammarModels", "Utility",
                "ExpressionPasses", "Utils", "Console", "SourcePreprocessors",
                "SwiftAST", "IntentionPasses", "MiniLexer", "GlobalsProviders",
                "Commons"
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
            dependencies: ["SwiftAST", "TestCommons"]),
        .testTarget(
            name: "SwiftRewriterLibTests",
            dependencies: ["SwiftRewriterLib", "SwiftAST", "GrammarModels",
                           "ObjcParser", "ExpressionPasses", "IntentionPasses",
                           "TestCommons", "GlobalsProviders"]),
        .testTarget(
            name: "CommonsTests",
            dependencies: ["Commons", "SwiftAST", "SwiftRewriterLib"]),
        .testTarget(
            name: "ExpressionPassesTests",
            dependencies: ["ExpressionPasses", "SwiftAST", "SwiftRewriterLib",
                           "Antlr4", "ObjcParser", "ObjcParserAntlr",
                           "IntentionPasses", "GlobalsProviders"]),
        .testTarget(
            name: "SourcePreprocessorsTests",
            dependencies: ["SourcePreprocessors", "Utils", "SwiftRewriterLib",
                           "IntentionPasses", "GlobalsProviders"]),
        .testTarget(
            name: "IntentionPassesTests",
            dependencies: ["SwiftAST", "GrammarModels", "SwiftRewriterLib",
                           "IntentionPasses", "TestCommons", "GlobalsProviders"]),
        .testTarget(
            name: "GlobalsProvidersTests",
            dependencies: ["SwiftAST", "SwiftRewriterLib", "GlobalsProviders",
                           "TestCommons"])
    ],
    swiftLanguageVersions: [.v4_2]
)
