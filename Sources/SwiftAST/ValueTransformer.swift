public struct ValueTransformer<T, U> {
    var transformer: (T) -> U?
    
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
    
}
