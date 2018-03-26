import Foundation

// MARK: - Helper global extensions to String with common functionality.
public extension StringProtocol {
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
            return String(self)
        }
        
        return prefix(1).lowercased() + dropFirst()
    }
    
    /// Returns a copy of `self` with the first letter uppercased.
    public var uppercasedFirstLetter: String {
        if isEmpty {
            return String(self)
        }
        
        return prefix(1).uppercased() + dropFirst()
    }
}

public extension String {
    /// Produces a diff-like string with a marking on the first character
    /// that differs between `self` and a target string.
    public func makeDifferenceMarkString(against string: String) -> String {
        if self == string {
            return self + "\n ~ Strings are equal."
        }
        
        if first != string.first {
            return self + "\n ~ Difference at start of string."
        }
        
        // Find first character differing across both strings
        let _offset =
            zip(indices, zip(self, string))
                .first { (_, chars) -> Bool in
                    return chars.0 != chars.1
                }?.0 // <result>.0: offset
        
        let offset = _offset ?? endIndex
        
        let column = columnOffset(at: offset)
        let line = lineNumber(at: offset)
        
        let marker = String(repeating: "~", count: column - 1) + "^ Difference starts here"
        
        return insertingStringLine(marker, after: line)
    }
    
    private func insertingStringLine(_ string: String, after line: Int) -> String {
        let offset = offsetForStartOfLine(line + 1)
        
        var copy = self
        if offset == endIndex {
            return copy + "\n" + string
        }
        
        copy.insert(contentsOf: string + "\n", at: offset)
        return copy
    }
    
    private func offsetForStartOfLine(_ line: Int) -> String.Index {
        var lineCount = 1
        for (i, char) in zip(indices, self) {
            if lineCount >= line {
                return i
            }
            
            if char == "\n" {
                lineCount += 1
            }
        }
        
        return endIndex
    }
    
    /// Gets the line number for the given index in this string
    public func lineNumber(at index: String.Index) -> Int {
        let line =
            self[..<index].reduce(0) {
                $0 + ($1 == "\n" ? 1 : 0)
            }
        
        return line + 1 // lines start at one
    }
    
    /// Gets the column offset number for the given index in this string.
    /// The column offset counts how many characters there are to the left to
    /// either the nearest newline or the beginning of the string.
    public func columnOffset(at index: String.Index) -> Int {
        // Figure out start of line at the given index
        let lineStart =
            zip(self[..<index], indices)
                .reversed()
                .first { $0.0 == "\n" }?.1
        
        let lineStartOffset =
            lineStart.map(index(after:)) ?? startIndex
        
        return distance(from: lineStartOffset, to: index) + 1 // columns start at one
    }
}

public extension String {
    /// Returns a range of sections of this string that represent single and mult-lined
    /// comments.
    func rangesOfCommentSections() -> [Range<Index>] {
        if self.count < 2 {
            return []
        }
        
        let unicodes = unicodeScalars
        
        enum State {
            case normal
            case singleLine(begin: Index)
            case multiLine(begin: Index)
        }
        
        var state = State.normal
        
        // Search for single-lined comments
        var ranges: [Range<Index>] = []
        
        var index = unicodes.startIndex
        while index < unicodes.index(before: unicodes.endIndex) {
            defer {
                unicodes.formIndex(after: &index)
            }
            
            switch state {
            case .normal:
                // Ignore anything other than '/' since it doesn't form comments.
                if unicodes[index] != "/" {
                    continue
                }
                
                let next = unicodes[unicodes.index(after: index)]
                
                // Single-line
                if next == "/" {
                    state = .singleLine(begin: index)
                // Multi-line
                } else if next == "*" {
                    state = .multiLine(begin: index)
                }
            case .singleLine(let begin):
                // End of single-line
                if self[index] == "\n" {
                    ranges.append(begin..<unicodes.index(after: index))
                    state = .normal
                }
            case .multiLine(let begin):
                // End of multi-line
                if self[index] == "*" && unicodes[unicodes.index(after: index)] == "/" {
                    ranges.append(begin..<unicodes.index(index, offsetBy: 2))
                    state = .normal
                }
            }
        }
        
        // Finish any open commentary ranges
        switch state {
        case .normal:
            break
        case .singleLine(let begin), .multiLine(let begin):
            ranges.append(begin..<endIndex)
        }
        
        return ranges
    }
}
