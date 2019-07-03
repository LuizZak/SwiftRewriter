#if !canImport(ObjectiveC)
@inlinable
func autoreleasepool<T>(_ closure: () throws -> T) rethrows -> T {
    try closure()
}
#endif
