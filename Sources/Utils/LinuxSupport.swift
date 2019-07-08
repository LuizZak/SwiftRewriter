#if !canImport(ObjectiveC)
public func autoreleasepool<T>(_ closure: () throws -> T) rethrows -> T {
    return try closure()
}
#endif
