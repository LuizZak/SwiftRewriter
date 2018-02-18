import Cocoa

/// Protocol to be implemented by objects that lazyly feed data to a console
/// output routine.
/// This can be used to reduce data-to-string overheads on very large data sets.
public protocol ConsoleDataProvider {
    
    /// The data contained within this console data provider
    associatedtype Data: CustomStringConvertible
    
    /// Gets the number of items contained within this console data provider
    var count: Int { get }
    
    /// Gets a header to be displayed just above the items list page
    var header: String { get }
    
    /// Gets the display data contained on top of a given index of this console
    /// data provider
    func data(atIndex index: Int) -> Data
}

/// A basic wrapper on top of a console data provider, which feeds data based on
/// a custom closure
public class AnyConsoleDataProvider<T: CustomStringConvertible>: ConsoleDataProvider {
    public typealias Data = T
    
    public let count: Int
    public let header: String
    public let generator: (Int) -> Data
    
    /// Creates a basic generic data provider over a known index count and
    /// external generator
    public init(count: Int, header: String, generator: @escaping (Int) -> Data) {
        self.count = count
        self.header = header
        self.generator = generator
    }
    
    /// Creates a converter wrapper on top of another console data provider
    public init<P: ConsoleDataProvider>(provider: P, converter: @escaping (P.Data) -> Data) {
        self.count = provider.count
        self.header = provider.header
        self.generator = { index in
            return converter(provider.data(atIndex: index))
        }
    }
    
    public func data(atIndex index: Int) -> Data {
        return generator(index)
    }
}
