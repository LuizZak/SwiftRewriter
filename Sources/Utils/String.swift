import Foundation

// MARK: - Helper global extensions to String with common functionality.
public extension String {
    /// Returns `true` if `self` starts with an uppercase character.
    public var startsUppercased: Bool {
        guard let first = unicodeScalars.first else {
            return false
        }
        
        return CharacterSet.uppercaseLetters.contains(first)
    }
    
    /// Returns a copy of `self` with the first letter lowercased.
    public var lowercasedFirstLetter: String {
        if isEmpty {
            return self
        }
        
        return prefix(1).lowercased() + dropFirst()
    }
    
    /// Returns a copy of `self` with the first letter uppercased.
    public var uppercasedFirstLetter: String {
        if isEmpty {
            return self
        }
        
        return prefix(1).uppercased() + dropFirst()
    }
}
