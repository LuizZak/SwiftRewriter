import SwiftAST
import XCTest

class AccessLevelTests: XCTestCase {
    func testIsMoreAccessibleThan() {
        XCTAssert(AccessLevel.open.isMoreAccessible(than: .private))
        XCTAssert(AccessLevel.open.isMoreAccessible(than: .fileprivate))
        XCTAssert(AccessLevel.open.isMoreAccessible(than: .internal))
        XCTAssertFalse(AccessLevel.open.isMoreAccessible(than: .public))
        XCTAssertFalse(AccessLevel.open.isMoreAccessible(than: .open))

        XCTAssert(AccessLevel.public.isMoreAccessible(than: .private))
        XCTAssert(AccessLevel.public.isMoreAccessible(than: .fileprivate))
        XCTAssert(AccessLevel.public.isMoreAccessible(than: .internal))
        XCTAssertFalse(AccessLevel.public.isMoreAccessible(than: .public))
        XCTAssertFalse(AccessLevel.public.isMoreAccessible(than: .open))

        XCTAssert(AccessLevel.internal.isMoreAccessible(than: .private))
        XCTAssert(AccessLevel.internal.isMoreAccessible(than: .fileprivate))
        XCTAssertFalse(AccessLevel.internal.isMoreAccessible(than: .internal))
        XCTAssertFalse(AccessLevel.internal.isMoreAccessible(than: .public))
        XCTAssertFalse(AccessLevel.internal.isMoreAccessible(than: .open))

        XCTAssert(AccessLevel.fileprivate.isMoreAccessible(than: .private))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreAccessible(than: .fileprivate))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreAccessible(than: .internal))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreAccessible(than: .public))
        XCTAssertFalse(AccessLevel.fileprivate.isMoreAccessible(than: .open))

        XCTAssertFalse(AccessLevel.private.isMoreAccessible(than: .private))
        XCTAssertFalse(AccessLevel.private.isMoreAccessible(than: .fileprivate))
        XCTAssertFalse(AccessLevel.private.isMoreAccessible(than: .internal))
        XCTAssertFalse(AccessLevel.private.isMoreAccessible(than: .public))
        XCTAssertFalse(AccessLevel.private.isMoreAccessible(than: .open))
    }
}
