/// Returns `true` if two files match in name, types, import directives and globals.
func areEquivalent(_ file1: KnownFile, _ file2: KnownFile) -> Bool {
    if file1.fileName != file2.fileName || file1.importDirectives != file2.importDirectives {
        return false
    }
    
    if !compare(file1.globals, file2.globals, areEquivalent) {
        return false
    }
    if !compare(file1.types, file2.types, areEquivalent) {
        return false
    }
    
    return true
}

/// Returns `true` if two functions match in signature and semantics.
func areEquivalent(_ f1: KnownGlobalFunction, _ f2: KnownGlobalFunction) -> Bool {
    return f1.signature == f2.signature && f1.semantics == f2.semantics
}

/// Returns `true` if two variables match in name, storage, and semantics.
func areEquivalent(_ v1: KnownGlobalVariable, _ v2: KnownGlobalVariable) -> Bool {
    return v1.name == v2.name && v1.storage == v2.storage && v1.semantics == v2.semantics
}

/// Returns `true` if two globals represent the same declaration
func areEquivalent(_ g1: KnownGlobal, _ g2: KnownGlobal) -> Bool {
    switch (g1, g2) {
    case let (f1 as KnownGlobalFunction, f2 as KnownGlobalFunction):
        return areEquivalent(f1, f2)
    case let (v1 as KnownGlobalVariable, v2 as KnownGlobalVariable):
        return areEquivalent(v1, v2)
        
    default:
        return false
    }
}
