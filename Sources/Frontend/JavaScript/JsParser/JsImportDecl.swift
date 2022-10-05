import Foundation

// TODO: Support aliases in imported symbols for type resolution purposes.

public struct JsImportDecl: Equatable {
    /// List of symbols that the import directive is declaring.
    /// If no symbols are present, this indicates a full import from a file.
    public var symbols: [String]
    public var path: String
    public var isSystemImport: Bool
    
    public var pathComponents: [String] {
        (path as NSString).pathComponents
    }

    public init(symbols: [String], path: String, isSystemImport: Bool) {
        self.symbols = symbols
        self.path = path
        self.isSystemImport = isSystemImport
    }
}
