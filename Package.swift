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
        .package(url: "https://github.com/LuizZak/MiniLexer.git", from: "0.5.1"),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "GrammarModels",
            dependencies: []),
        .target(
            name: "SwiftRewriterLib",
            dependencies: ["GrammarModels", "ObjcParser"]),
        .target(
            name: "ObjcParser",
            dependencies: ["GrammarModels", "MiniLexer", "TypeLexing"]),
        .target(
            name: "SwiftRewriter",
            dependencies: ["SwiftRewriterLib", "ObjcParser", "GrammarModels", "Utility"]),
        .testTarget(
            name: "ObjcParserTests",
            dependencies: ["GrammarModels", "ObjcParser"]),
        .testTarget(
            name: "GrammarModelsTests",
            dependencies: ["GrammarModels"]),
        .testTarget(
            name: "SwiftRewriterLibTests",
            dependencies: ["SwiftRewriterLib", "GrammarModels", "ObjcParser"]),
    ]
)
