public struct ValueTransformer<T, U> {
    private let transformer: AnyTransformer
    
    private let file: String
    private let line: Int
    
    public init(file: String = #file, line: Int = #line, transformer: @escaping (T) -> U?) {
        self.transformer = AnyTransformer(closure: transformer)
        self.file = file
        self.line = line
    }
    
    private init<Z>(file: String = #file, line: Int = #line,
                     previous: ValueTransformer<T, Z>,
                     transformer: @escaping (Z) -> U?) {
        
        self.transformer = AnyTransformer(previous: previous, closure: transformer)
        self.file = file
        self.line = line
    }
    
    public init(keyPath: KeyPath<T, U>, file: String = #file, line: Int = #line) {
        self.transformer = AnyTransformer(closure: {
            $0[keyPath: keyPath]
        })
        self.file = file
        self.line = line
    }
    
    public init(keyPath: KeyPath<T, U?>, file: String = #file, line: Int = #line) {
        self.transformer = AnyTransformer(closure: {
            $0[keyPath: keyPath]
        })
        self.file = file
        self.line = line
    }
    
    public func transform(value: T) -> U? {
        return transformer.transform(value: value)
    }
    
    public func transforming<Z>(file: String,
                                line: Int,
                                _ callback: @escaping (U) -> Z?) -> ValueTransformer<T, Z> {
        
        return ValueTransformer<T, Z>(file: file, line: line, previous: self) { value in
            return callback(value)
        }
    }
    
    public func validate(file: String = #file,
                         line: Int = #line,
                         _ predicate: @escaping (U) -> Bool) -> ValueTransformer<T, U> {
        
        return ValueTransformer<T, U>(file: file, line: line) { value in
            guard let value = self.transform(value: value) else {
                return nil
            }
            
            return predicate(value) ? value : nil
        }
    }
    
    public func validate(file: String = #file,
                         line: Int = #line,
                         matcher: ValueMatcher<U>) -> ValueTransformer<T, U> {
        
        return ValueTransformer<T, U>(file: file, line: line) { value in
            guard let value = self.transform(value: value) else {
                return nil
            }
            
            return matcher.matches(value) ? value : nil
        }
    }
    
    private struct AnyTransformer {
        let previous: Any?
        let closure: (T) -> U?
        
        init(closure: @escaping (T) -> U?) {
            previous = nil
            self.closure = closure
        }
        
        init<Z>(previous: ValueTransformer<T, Z>,
                closure: @escaping (Z) -> U?) {
            
            self.previous = previous
            self.closure = { value in
                guard let prev = previous.transform(value: value) else {
                    return nil
                }
                
                return closure(prev)
            }
        }
        
        func transform(value: T) -> U? {
            return closure(value)
        }
    }
}

public extension ValueTransformer where T == U {
    public init(file: String = #file, line: Int = #line) {
        self.init(file: file, line: line) { (value: T) -> U? in
            value
        }
    }
}

public extension ValueTransformer where U: MutableCollection {
    
    public func transformIndex(file: String = #file,
                               line: Int = #line,
                               index: U.Index,
                               transformer: ValueTransformer<U.Element, U.Element>) -> ValueTransformer {
        
        return transforming(file: file, line: line) { value in
            guard value.endIndex > index else {
                return nil
            }
            
            guard let new = transformer.transform(value: value[index]) else {
                return nil
            }
            
            var value = value
            value[index] = new
            return value
        }
    }
    
    public func replacing(file: String = #file,
                          line: Int = #line,
                          index: U.Index,
                          with newValue: U.Element) -> ValueTransformer {
        
        return transforming(file: file, line: line) { value in
            guard value.endIndex > index else {
                return nil
            }
            
            var value = value
            value[index] = newValue
            return value
        }
    }
}

public extension ValueTransformer where U: RangeReplaceableCollection {
    
    public func removing(file: String = #file,
                         line: Int = #line,
                         index: U.Index) -> ValueTransformer {
        
        return transforming(file: file, line: line) { value in
            guard value.endIndex > index else {
                return nil
            }
            
            var value = value
            value.remove(at: index)
            return value
        }
    }
}

public extension ValueTransformer where U: Sequence {
    
    public func removingFirst(file: String = #file,
                              line: Int = #line) -> ValueTransformer<T, U.SubSequence> {
        
        return transforming(file: file, line: line) { value in
            return value.dropFirst()
        }
    }
}
