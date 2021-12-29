public extension Array {
    subscript(try index: Int) -> Element {
        get throws {
            if index >= 0 && index < count {
                return self[index]
            }

            throw ArrayError.indexNotFound(index: index)
        }
    }
}

public enum ArrayError: Error {
    case indexNotFound(index: Int)
}
