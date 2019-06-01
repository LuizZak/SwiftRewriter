#if os(macOS)
import Darwin.C
#elseif os(Linux)
import Glibc
#endif

func expandTildes(path: String) -> String {
    var expResult = wordexp_t()
    
    path.withCString { pointer -> Void in
        wordexp(pointer, &expResult, 0)
    }
    defer {
        wordfree(&expResult)
    }
    
    if let word = expResult.we_wordv[0] {
        return String(cString: word)
    }
    
    return path
}
