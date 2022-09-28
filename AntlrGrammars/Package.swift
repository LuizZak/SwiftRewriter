// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "AntlrGrammars",
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", branch: "0.50700.0"),
        .package(url: "https://github.com/apple/swift-format.git", branch: "0.50700.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "AntlrGrammars",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
                .product(name: "SwiftFormat", package: "swift-format"),
                .product(name: "SwiftFormatConfiguration", package: "swift-format"),
            ]
        ),
        .testTarget(
            name: "AntlrGrammarsTests",
            dependencies: ["AntlrGrammars"]
        ),
    ]
)
