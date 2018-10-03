public struct ValueTransformer<T, U> {
    let transformer: (T) -> U?
    
    public init(transformer: @escaping (T) -> U?) {
        self.transformer = transformer
    }
    
    public init(keyPath: KeyPath<T, U>) {
        self.transformer = {
            $0[keyPath: keyPath]
        }
    }
    
    public init(keyPath: KeyPath<T, U?>) {
        self.transformer = {
            $0[keyPath: keyPath]
        }
    }
    
    public func transform(value: T) -> U? {
        return transformer(value)
    }
    
    public func transforming<Z>(_ callback: @escaping (U) -> Z?) -> ValueTransformer<T, Z> {
        return ValueTransformer<T, Z> { [transformer] value in
            guard let value = transformer(value) else {
                return nil
            }
            
            return callback(value)
        }
    }
    
    public func validate(_ predicate: @escaping (U) -> Bool) -> ValueTransformer<T, U> {
        return ValueTransformer<T, U> { [transformer] value in
            guard let value = transformer(value) else {
                return nil
            }
            
            return predicate(value) ? value : nil
        }
    }
    
    public func validate(matcher: ValueMatcher<U>) -> ValueTransformer<T, U> {
        return ValueTransformer<T, U> { [transformer] value in
            guard let value = transformer(value) else {
                return nil
            }
            
            return matcher.matches(value) ? value : nil
        }
    }
}

public extension ValueTransformer where T == U {
    public init() {
        self.init { (value: T) -> U? in
            return value
        }
    }
}

public extension ValueTransformer where U: MutableCollection {
    
    public func transformIndex(index: U.Index,
                               transformer: ValueTransformer<U.Element, U.Element>) -> ValueTransformer {
        
        return transforming { value in
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
    
    public func replacing(index: U.Index,
                          with newValue: U.Element) -> ValueTransformer {
        
        return transforming { value in
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
    
    public func removing(index: U.Index) -> ValueTransformer {
        
        return transforming { value in
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
    
    public func removingFirst() -> ValueTransformer<T, U.SubSequence> {
        
        return transforming { value in
            return value.dropFirst()
        }
        
    }
    
}
