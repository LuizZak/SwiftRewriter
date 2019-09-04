import XCTest
import SwiftAST

class AccessLevelTests: XCTestCase {
    func testIsMoreVisibleThan() {
        XCTAssert(AccessLevel.open.isMoreVisible(than: .private))
        XCTAssert(AccessLevel.open.isMoreVisible(than: .fileprivate))
        XCTAssert(AccessLevel.open.isMoreVisible(than: .internal))
        XCTAssertFalse(AccessLevel.open.isMoreVisible(than: .open))
        XCTAssertFalse(AccessLevel.open.isMoreVisible(than: .public))

        XCTAssert(AccessLevel.public.isMoreVisible(than: .private))
        XCTAssert(AccessLevel.public.isMoreVisible(than: .fileprivate))
        XCTAssert(AccessLevel.public.isMoreVisible(than: .internal))
        XCTAssertFalse(AccessLevel.public.isMoreVisible(than: .public))
        XCTAssertFalse(AccessLevel.public.isMoreVisible(than: .open))
        
        XCTAssert(AccessLevel.internal.isMoreVisible(than: .private))
        XCTAssert(AccessLevel.internal.isMoreVisible(than: .fileprivate))
        XCTAssertFalse(AccessLevel.internal.isMoreVisible(than: .internal))
        XCTAssertFalse(AccessLevel.internal.isMoreVisible(than: .public))
        XCTAssertFalse(AccessLevel.internal.isMoreVisible(than: .open))
        
        XCTAssert(AccessLevel.fileprivate.isMoreVisible(than: .private))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreVisible(than: .fileprivate))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreVisible(than: .internal))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreVisible(than: .public))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreVisible(than: .open))
        
        XCTAssertFalse(AccessLevel.private.isMoreVisible(than: .private))
        XCTAssertFalse(AccessLevel.private.isMoreVisible(than: .fileprivate))
        XCTAssertFalse(AccessLevel.private.isMoreVisible(than: .internal))
        XCTAssertFalse(AccessLevel.private.isMoreVisible(than: .public))
        XCTAssertFalse(AccessLevel.private.isMoreVisible(than: .open))
    }
}
