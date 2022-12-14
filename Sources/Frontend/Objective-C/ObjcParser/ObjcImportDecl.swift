import Foundation

public struct ObjcImportDecl {
    public var path: String
    /// If `true`, indicates `#import` is of `#import <system_header>` variant,
    /// as opposed to `#import "local_file"` variant.
    public var isSystemImport: Bool
    
    public var pathComponents: [String] {
        (path as NSString).pathComponents
    }
}
