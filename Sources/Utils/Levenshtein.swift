/**
 * Levenshtein edit distance calculator
 *
 * Inspired by https://gist.github.com/bgreenlee/52d93a1d8fa1b8c1f38b
 * Improved with http://stackoverflow.com/questions/26990394/slow-swift-arrays-and-strings-performance
 */

public class Levenshtein {
    
    public static func distanceBetween(_ aStr: String, and bStr: String) -> Int {
        let a = Array(aStr.utf16)
        let b = Array(bStr.utf16)
        
        var dist = Array2D(cols: a.count + 1, rows: b.count + 1)
        
        for i in 1...a.count {
            dist[i, 0] = i
        }
        
        for j in 1...b.count {
            dist[0, j] = j
        }
        
        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i, j] = dist[i-1, j-1]  // noop
                } else {
                    dist[i, j] = minimum(
                        dist[i-1, j] + 1,  // deletion
                        dist[i, j-1] + 1,  // insertion
                        dist[i-1, j-1] + 1 // substitution
                    )
                }
            }
        }
        
        return dist[a.count, b.count]
    }
    
    private class func minimum(_ numbers: Int...) -> Int {
        return numbers.reduce(numbers[0]) { $0 < $1 ? $0 : $1 }
    }
    
    struct Array2D {
        var cols: Int, rows: Int
        var matrix: [Int]
        
        init(cols: Int, rows: Int) {
            self.cols = cols
            self.rows = rows
            matrix = Array(repeating: 0, count: cols * rows)
        }
        
        subscript(col: Int, row: Int) -> Int {
            get {
                return matrix[cols * row + col]
            }
            set {
                matrix[cols * row + col] = newValue
            }
        }
        
        func colCount() -> Int {
            return cols
        }
        
        func rowCount() -> Int {
            return rows
        }
    }
}
