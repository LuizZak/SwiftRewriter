#if os(macOS) || os(Linux)

#if os(Linux)
import Glibc
#endif

import Foundation

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
    let fnflags: Int32
    #if os(macOS)
    fnflags = FNM_CASEFOLD
    #else
    fnflags = 0
    #endif

    // Inclusions
    if let includePattern = includePattern {
        if fnmatch(includePattern, path, fnflags) != 0 {
            return false
        }
    }
    // Exclusions
    if let excludePattern = excludePattern {
        if fnmatch(excludePattern, path, fnflags) == 0 {
            return false
        }
    }

    return true
}

#endif
