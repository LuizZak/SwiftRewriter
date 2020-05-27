import XCTest
import SwiftRewriterLib
import TestCommons

class FrameworkCacheManagerTests: XCTestCase {
    var fileDisk: VirtualFileDisk!
    var sut: FrameworkCacheManager!
    
    override func setUp() {
        super.setUp()
        
        fileDisk = VirtualFileDisk()
        try! fileDisk.createDirectory(atPath: fileDisk.userHomeURL.path)
        sut = FrameworkCacheManager(fileProvider: fileDisk)
    }
    
    func testCacheExists() throws {
        XCTAssertFalse(sut.cacheExists())
        
        try fileDisk.createDirectory(atPath:
            fileDisk
                .userHomeURL
                .appendingPathComponent(".swiftrewriter")
                .appendingPathComponent("cache")
                .path
        )
        
        XCTAssert(sut.cacheExists())
    }
    
    func testCreateCacheDirectory() throws {
        try sut.createCacheDirectory()
        
        XCTAssert(fileDisk.directoryExists(atPath: sut.cachePath.path))
    }
    
    func testClearCache() throws {
        try fileDisk.createDirectory(atPath: sut.cachePath.path)
        
        try sut.clearCache()
        
        XCTAssertFalse(fileDisk.directoryExists(atPath: sut.cachePath.path))
    }
}
