import XCTest
import SwiftAST

class AccessLevelTests: XCTestCase {
    func testIsMoreVisibleThan() {
        XCTAssert(AccessLevel.public.isMoreVisible(than: .private))
        XCTAssert(AccessLevel.public.isMoreVisible(than: .fileprivate))
        XCTAssert(AccessLevel.public.isMoreVisible(than: .internal))
        XCTAssertFalse(AccessLevel.public.isMoreVisible(than: .public))
        
        XCTAssert(AccessLevel.internal.isMoreVisible(than: .private))
        XCTAssert(AccessLevel.internal.isMoreVisible(than: .fileprivate))
        XCTAssertFalse(AccessLevel.internal.isMoreVisible(than: .internal))
        XCTAssertFalse(AccessLevel.internal.isMoreVisible(than: .public))
        
        XCTAssert(AccessLevel.fileprivate.isMoreVisible(than: .private))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreVisible(than: .fileprivate))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreVisible(than: .internal))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreVisible(than: .public))
        
        XCTAssertFalse(AccessLevel.private.isMoreVisible(than: .private))
        XCTAssertFalse(AccessLevel.private.isMoreVisible(than: .fileprivate))
        XCTAssertFalse(AccessLevel.private.isMoreVisible(than: .internal))
        XCTAssertFalse(AccessLevel.private.isMoreVisible(than: .public))
    }
}
