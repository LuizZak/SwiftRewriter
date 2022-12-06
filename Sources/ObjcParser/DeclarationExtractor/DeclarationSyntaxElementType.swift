import GrammarModels

/// A protocol for types used as input syntactical elements that are provided to
/// a `DeclarationExtractor` as an abstraction atop of AST parsers.
///
/// The syntax structure is based on the C programming language standard
/// ref: https://www.open-std.org/JTC1/SC22/WG14/www/docs/n3054.pdf#section.6.7
public protocol DeclarationSyntaxElementType {
    /// Children elements within this syntax element type.
    var children: [DeclarationSyntaxElementType] { get }

    /// Gets the source range of this declaration syntax element on a source file
    /// or string, including the entire range of its children.
    /// May be `.invalid`.
    var sourceRange: SourceRange { get }
}

public extension DeclarationSyntaxElementType {
    var sourceRange: SourceRange {
        .init(union: children.map(\.sourceRange))
    }
}

internal func toChildrenList(_ list: DeclarationSyntaxElementType?...) -> [DeclarationSyntaxElementType] {
    list.compactMap { $0 }
}
