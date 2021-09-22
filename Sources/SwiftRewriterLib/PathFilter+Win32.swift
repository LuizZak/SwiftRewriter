#if os(Windows)

import Foundation
import WinSDK

/// Filters a file using a given include and exclude pattern.
///
/// - Parameters:
///   - path: File path to filter
///   - includePattern: An optional pattern that when specified only includes
/// (full) file patterns that match a specified pattern.
///   - excludePattern: An optional pattern that when specified omits files
/// matching the pattern. Takes priority over `includePattern`.
/// - Returns: Whether the given file URL matches the given include/exclude pattern.
public func fileMatchesFilter(path: String, includePattern: String?, excludePattern: String?) -> Bool {
    // Inclusions
    if let includePattern = includePattern {
        if !PathMatchSpecA(path, includePattern) {
            return false
        }
    }
    // Exclusions
    if let excludePattern = excludePattern {
        if PathMatchSpecA(path, excludePattern) {
            return false
        }
    }

    return true
}

#endif