import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXRSSExpandedRow.h"
/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * One row of an RSS Expanded Stacked symbol, consisting of 1+ expanded pairs.
 */
/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
@objc
class ZXRSSExpandedRow: NSObject {
    private var _pairs: NSArray!
    private var _rowNumber: CInt = 0
    private var _wasReversed: Bool = false
    @objc var pairs: NSArray! {
        return self._pairs
    }
    @objc var rowNumber: CInt {
        return self._rowNumber
    }
    /** Did this row of the image have to be reversed (mirrored) to recognize the pairs? */
    @objc var wasReversed: Bool {
        return self._wasReversed
    }

    @objc
    init(pairs: NSArray!, rowNumber: CInt, wasReversed: Bool) {
        if self = super.init() {
            _pairs = NSArray.arrayWithArray(pairs)
            _rowNumber = rowNumber
            _wasReversed = wasReversed
        }

        return self
    }

    @objc
    func isReversed() -> Bool {
        return self.wasReversed
    }
    @objc
    func isEquivalent(_ otherPairs: NSArray!) -> Bool {
        return self.pairs.isEqualToArray(otherPairs)
    }
    @objc
    func description() -> String? {
        return String(format: "{%@}", self.pairs)
    }
    /**
 * Two rows are equal if they contain the same pairs in the same order.
 */
    @objc
    func isEqual(_ object: AnyObject) -> Bool {
        if !object.isKindOfClass(ZXRSSExpandedRow.self) {
            return false
        }

        let that = object as? ZXRSSExpandedRow

        return (self.pairs.isEqual(that?.pairs) == true) && (self.wasReversed == that?.wasReversed)
    }
    @objc
    func hash() -> UInt {
        return self.pairs.hash ^ self.wasReversed.hash
    }
}