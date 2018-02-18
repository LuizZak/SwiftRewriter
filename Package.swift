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
        .package(url: "https://cs-luiz-silva@bitbucket.org/cs-luiz-silva/antlr4-swift.git", from: "4.0.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "GrammarModels",
            dependencies: ["ObjcParserAntlr"]),
        .target(
            name: "SwiftRewriterLib",
            dependencies: ["GrammarModels", "ObjcParser"]),
        .target(
            name: "ObjcParserAntlr",
            dependencies: ["Antlr4"]),
        .target(
            name: "ObjcParser",
            dependencies: ["ObjcParserAntlr", "Antlr4", "GrammarModels", "MiniLexer", "TypeLexing"]),
        .target(
            name: "SwiftRewriter",
            dependencies: ["SwiftRewriterLib", "ObjcParser", "GrammarModels", "Utility", "ExpressionPasses"]),
        .target(
            name: "ExpressionPasses",
            dependencies: ["SwiftRewriterLib"]),
        .testTarget(
            name: "ObjcParserTests",
            dependencies: ["GrammarModels", "ObjcParser"]),
        .testTarget(
            name: "GrammarModelsTests",
            dependencies: ["GrammarModels"]),
        .testTarget(
            name: "SwiftRewriterLibTests",
            dependencies: ["SwiftRewriterLib", "GrammarModels", "ObjcParser"]),
        .testTarget(
            name: "ExpressionPassesTests",
            dependencies: ["ExpressionPasses", "SwiftRewriterLib", "Antlr4", "ObjcParser", "ObjcParserAntlr"])
    ]
)
