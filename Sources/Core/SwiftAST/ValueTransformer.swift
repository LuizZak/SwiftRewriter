public struct ValueTransformer<T, U> {
    @usableFromInline
    let transformer: AnyTransformer
    
    @usableFromInline
    let file: String
    @usableFromInline
    let line: Int
    
    @inlinable
    public init(file: String = #file, line: Int = #line, transformer: @escaping (T) -> U?) {
        self.transformer = AnyTransformer(file: file, line: line, closure: { value in
            if let result = transformer(value) {
                return .success(value: result)
            }
            
            return .failure(message: "Transformer returned nil")
        })
        self.file = file
        self.line = line
    }
    
    @inlinable
    public init(line: Int = #line, file: String = #file, transformer: @escaping (T) -> Result<U>) {
        self.transformer = AnyTransformer(file: file, line: line, closure: { value in
            return transformer(value)
        })
        self.file = file
        self.line = line
    }
    
    @usableFromInline
    init<Z>(file: String = #file, line: Int = #line,
            previous: ValueTransformer<T, Z>,
            transformer: @escaping (Z) -> U?) {
        
        self.transformer = AnyTransformer(file: file, line: line, previous: previous, closure: { value in
            if let result = transformer(value) {
                return .success(value: result)
            }
            
            return .failure(message: "Transformer returned nil")
        })
        
        self.file = file
        self.line = line
    }
    
    @usableFromInline
    init<Z>(line: Int, file: String,
            previous: ValueTransformer<T, Z>,
            transformer: @escaping (Z) -> Result<U>) {
        
        self.transformer = AnyTransformer(file: file, line: line, previous: previous, closure: { value in
            return transformer(value)
        })
        
        self.file = file
        self.line = line
    }
    
    @inlinable
    public init(keyPath: KeyPath<T, U>, file: String = #file, line: Int = #line) {
        self.transformer = AnyTransformer(file: file, line: line, closure: {
            .success(value: $0[keyPath: keyPath])
        })
        self.file = file
        self.line = line
    }
    
    @inlinable
    public init(keyPath: KeyPath<T, U?>, file: String = #file, line: Int = #line) {
        self.transformer = AnyTransformer(file: file, line: line, closure: {
            if let value = $0[keyPath: keyPath] {
                return .success(value: value)
            }
            
            return .failure(message: "Keypath \(keyPath) returned nil")
        })
        self.file = file
        self.line = line
    }
    
    /// Transforms a given value
    @inlinable
    public func callAsFunction(transform value: T) -> U? {
        return transform(value: value)
    }
    
    @inlinable
    public func transform(value: T) -> U? {
        transformResult(value: value).value
    }
    
    @inlinable
    public func transformResult(value: T) -> Result<U> {
        transformer.transform(value: value)
    }
    
    @inlinable
    public func debugTransform(value: T) -> U? {
        debugTransform(value: value) { (string: @autoclosure () -> String) in
            print(string())
        }
    }
    
    @inlinable
    public func debugTransform(value: T, _ printer: (@autoclosure () -> String) -> Void) -> U? {
        debugTransformResult(value: value, printer).value
    }
    
    @inlinable
    public func debugTransformResult(value: T, _ printer: (@autoclosure () -> String) -> Void) -> Result<U> {
        printer("Invoking transformer from \(file):\(line) with \(value)...")
        
        let result = transformer.debugTransform(value: value, printer)
        
        switch result {
        case .success(let value):
            printer("Transformation succeeded with \(String(describing: value))")
            return .success(value: value)
            
        case .failure(let message):
            return .failure(message: message())
        }
    }
    
    @inlinable
    public func transforming<Z>(file: String = #file,
                                line: Int = #line,
                                _ callback: @escaping (U) -> Z?) -> ValueTransformer<T, Z> {
        
        ValueTransformer<T, Z>(file: file, line: line, previous: self) { value in
            return callback(value)
        }
    }
    
    @inlinable
    public func transformingResult<Z>(file: String = #file,
                                      line: Int = #line,
                                      _ callback: @escaping (U) -> Result<Z>) -> ValueTransformer<T, Z> {
        
        ValueTransformer<T, Z>(line: line, file: file, previous: self) { (value: U) -> Result<Z> in
            return callback(value)
        }
    }
    
    @inlinable
    public func validate(file: String = #file,
                         line: Int = #line,
                         _ predicate: @escaping (U) -> Bool) -> ValueTransformer<T, U> {
        
        ValueTransformer<T, U>(file: file, line: line) { value in
            guard let value = self(transform: value) else {
                return nil
            }
            
            return predicate(value) ? value : nil
        }
    }
    
    @inlinable
    public func validateResult(file: String = #file,
                               line: Int = #line,
                               _ predicate: @escaping (U) -> Result<U>) -> ValueTransformer<T, U> {
        
        ValueTransformer<T, U>(line: line, file: file) { (value: T) -> Result<U> in
            let result =
                self.transformResult(value: value)
                    .flatMap {
                        predicate($0)
                    }
            
            switch result {
            case .success(let value):
                return predicate(value)
                
            case .failure(let message):
                return .failure(message: "Validation failed: \(message())")
            }
        }
    }
    
    @inlinable
    public func validate(file: String = #file,
                         line: Int = #line,
                         matcher: ValueMatcher<U>) -> ValueTransformer<T, U> {
        
        ValueTransformer<T, U>(line: line, file: file, previous: self) { value in
            if matcher(matches: value) {
                return .success(value: value)
            } else {
                return .failure(message: "Failed to pass matcher at \(file):\(line)")
            }
        }
    }
    
    @usableFromInline
    struct AnyTransformer {
        @usableFromInline
        let previous: Any?
        @usableFromInline
        let closure: (T) -> Result<U>
        @usableFromInline
        let debugClosure: (T, (@autoclosure () -> String) -> Void) -> Result<U>
        @usableFromInline
        let file: String
        @usableFromInline
        let line: Int
        
        @usableFromInline
        init(file: String, line: Int, closure: @escaping (T) -> Result<U>) {
            self.file = file
            self.line = line
            previous = nil
            self.closure = closure
            self.debugClosure = { value, printer in
                let result = closure(value)
                
                switch result {
                case .success(let value):
                    return .success(value: value)
                case .failure(let message):
                    printer("Transformation from \(file):\(line) failed: \(message())")
                    return .failure(message: message())
                }
            }
        }
        
        @usableFromInline
        init<Z>(file: String, line: Int,
                previous: ValueTransformer<T, Z>,
                closure: @escaping (Z) -> Result<U>) {
            
            self.file = file
            self.line = line
            self.previous = previous
            self.closure = { value in
                let prev = previous.transformResult(value: value)
                
                switch prev {
                case .success(let value):
                    return closure(value)
                    
                case .failure(let message):
                    return .failure(message: message())
                }
            }
            self.debugClosure = { value, printer in
                let prev = previous.debugTransformResult(value: value, printer)
                
                switch prev {
                case .success(let value):
                    let result = closure(value)
                    
                    switch result {
                    case .success(let value):
                        return .success(value: value)
                        
                    case .failure(let message):
                        printer("Transformation from \(file):\(line) failed: \(message())")
                        return .failure(message: message())
                    }
                    
                case .failure(let message):
                    return .failure(message: message())
                }
            }
        }
        
        @usableFromInline
        func transform(value: T) -> Result<U> {
            closure(value)
        }
        
        @usableFromInline
        func debugTransform(value: T, _ print: (@autoclosure () -> String) -> Void) -> Result<U> {
            debugClosure(value, print)
        }
    }
}

/// Encapsulates the result of a transformation
public enum Result<T> {
    case success(value: T)
    case failure(message: @autoclosure () -> String)
    
    @inlinable
    var value: T? {
        switch self {
        case .success(let value):
            return value
            
        case .failure:
            return nil
        }
    }
    
    @inlinable
    public func map<U>(_ mapper: (T) -> U) -> Result<U> {
        switch self {
        case .success(let value):
            return .success(value: mapper(value))
        case .failure(let message):
            return .failure(message: message())
        }
    }
    
    @inlinable
    public func flatMap<U>(_ mapper: (T) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let value):
            return mapper(value)
        case .failure(let message):
            return .failure(message: message())
        }
    }
}

public extension ValueTransformer where T == U {
    @inlinable
    init(file: String = #file, line: Int = #line) {
        self.init(file: file, line: line) { (value: T) -> U? in
            value
        }
    }
}

public extension ValueTransformer where U: MutableCollection {
    
    @inlinable
    func transformIndex(file: String = #file,
                        line: Int = #line,
                        index: U.Index,
                        transformer: ValueTransformer<U.Element, U.Element>) -> ValueTransformer {
        
        transformingResult(file: file, line: line) { value in
            guard value.endIndex > index else {
                return .failure(message: "\(index) >= \(value.endIndex)")
            }
            
            return transformer.transformResult(value: value[index]).map { new in
                var value = value
                value[index] = new
                return value
            }
        }
    }
    
    @inlinable
    func replacing(file: String = #file,
                   line: Int = #line,
                   index: U.Index,
                   with newValue: U.Element) -> ValueTransformer {
        
        transforming(file: file, line: line) { value in
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
    
    @inlinable
    func removing(file: String = #file,
                  line: Int = #line,
                  index: U.Index) -> ValueTransformer {
        
        transforming(file: file, line: line) { value in
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
    
    @inlinable
    func removingFirst(file: String = #file,
                       line: Int = #line) -> ValueTransformer<T, DropFirstSequence<U>> {
        
        transforming(file: file, line: line) { value in
            return value.dropFirst()
        }
    }
}
