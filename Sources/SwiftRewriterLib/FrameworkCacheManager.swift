import Foundation

/// Provides utilities for creating, inspecting and manipulating caches for
/// parsed framework headers.
public class FrameworkCacheManager {
    public var cachePath: URL {
        return fileProvider
            .userHomeURL
            .appendingPathComponent(".swiftrewriter")
            .appendingPathComponent("cache")
    }
    
    var fileProvider: FileProvider
    
    public init(fileProvider: FileProvider) {
        self.fileProvider = fileProvider
    }
    
    /// Returns `true` if the cache directory currently exists
    public func cacheExists() -> Bool {
        return fileProvider.directoryExists(atPath: cachePath.path)
    }
    
    /// Creates the cache directory, if it doesn't currently exists
    public func createCacheDirectory() throws {
        if cacheExists() {
            return
        }
        
        try fileProvider.createDirectory(atPath: cachePath.path)
    }
    
    /// Erases the current cache path
    public func clearCache() throws {
        try fileProvider.deleteDirectory(atPath: cachePath.path)
    }
    
    /// Returns a proxy for interacting with cache files for a framework with a
    /// given name
    public func cacheForFramework(named name: String) -> FrameworkCacheEntry {
        let path = cachePath.appendingPathComponent(name)
        
        return FrameworkCacheEntry(fileProvider: fileProvider,
                                   frameworkName: name,
                                   folderPath: path)
    }
    
    /// Describes an entry for a framework and their respective module files
    /// in the cache
    public class FrameworkCacheEntry {
        var fileProvider: FileProvider
        var frameworkName: String
        var folderPath: URL
        
        init(fileProvider: FileProvider, frameworkName: String, folderPath: URL) {
            self.fileProvider = fileProvider
            self.frameworkName = frameworkName
            self.folderPath = folderPath
        }
        
        /// Returns `true` if the cache directory currently exists
        public func cacheExists() -> Bool {
            return fileProvider.directoryExists(atPath: folderPath.path)
        }
        
        /// Creates the cache directory, if it doesn't currently exists
        public func createCacheDirectory() throws {
            if cacheExists() {
                return
            }
            
            try fileProvider.createDirectory(atPath: folderPath.path)
        }
        
        /// Clears the cache in disk for the framework referenced by this
        /// `FrameworkCacheEntry`
        public func clearCache() throws {
            try fileProvider.deleteDirectory(atPath: folderPath.path)
        }
        
        /// Stores the contents of a Swift-converted module with a given name
        public func storeModuleFile(moduleName: String, contents: String) throws {
            let fileLocation = folderPath.appendingPathComponent("\(moduleName).swift")
            
            if let data = contents.data(using: .utf8) {
                try fileProvider.save(data: data, atPath: fileLocation.path)
            }
        }
    }
}
