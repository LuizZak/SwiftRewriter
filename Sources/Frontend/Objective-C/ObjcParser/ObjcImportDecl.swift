import Foundation
import Utils

public struct ObjcImportDecl {
    public var path: String
    public var sourceRange: SourceRange
    
    /// If `true`, indicates `#import` is of `#import <system_header>` variant,
    /// as opposed to `#import "local_file"` variant.
    public var isSystemImport: Bool
    
    public var pathComponents: [String] {
        (path as NSString).pathComponents
    }
}
