import Intentions

/// Base class for builders for types, members and global variables and functions.
public class DeclarationBuilder<T> {
   var declaration: T

   init(declaration: T) {
       self.declaration = declaration
   }
}

extension DeclarationBuilder where T: Intention {
    public func addMetadata(forKey key: String, value: Any, type: String) {
        declaration.metadata.updateValue(value, type: type, forKey: key)
    }
}
