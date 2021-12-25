import Foundation

public struct JsImportDecl {
    /// List of symbols that the import directive is declaring.
    public var symbols: [String]
    public var path: String
    public var isSystemImport: Bool
    
    public var pathComponents: [String] {
        (path as NSString).pathComponents
    }
}
