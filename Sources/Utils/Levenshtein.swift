/**
 * Levenshtein edit distance calculator
 *
 * Inspired by https://gist.github.com/bgreenlee/52d93a1d8fa1b8c1f38b
 * Improved with http://stackoverflow.com/questions/26990394/slow-swift-arrays-and-strings-performance
 */

public class Levenshtein {
    
    @inlinable
    public static func distanceBetween(_ aStr: String, and bStr: String) -> Int {
        let a = Array(aStr)
        let b = Array(bStr)
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
    
    @inlinable
    static func minimum(_ n1: Int, _ n2: Int, _ n3: Int) -> Int {
        return min(n1, min(n2, n3))
    }
    
    @usableFromInline
    struct Array2D {
        @usableFromInline
        var cols: Int, rows: Int
        @usableFromInline
        var matrix: [Int]
        
        @inlinable
        init(cols: Int, rows: Int) {
            self.cols = cols
            self.rows = rows
            matrix = Array(repeating: 0, count: cols * rows)
        }
        
        @inlinable
        subscript(col: Int, row: Int) -> Int {
            get {
                return matrix[cols * row + col]
            }
            set {
                matrix[cols * row + col] = newValue
            }
        }
    }
}
