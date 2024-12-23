// Preprocessor directives found in file:
// #import "ZXUPCEANReader.h"
// #import "ZXBitArray.h"
// #import "ZXEAN8Reader.h"
// #import "ZXIntArray.h"
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
 * Implements decoding of the EAN-8 format.
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
/**
 * Implements decoding of the EAN-8 format.
 */
@objc
class ZXEAN8Reader: ZXUPCEANReader {
    private var _decodeMiddleCounters: ZXIntArray!

    @objc
    override init() {
        if self = super.init() {
            _decodeMiddleCounters = ZXIntArray(length: 4)
        }

        return self
    }

    @objc
    func decodeMiddle(_ row: ZXBitArray!, startRange: NSRange, result: NSMutableString!, error: UnsafeMutablePointer<Error?>!) -> CInt {
        let counters = self.decodeMiddleCounters

        counters?.clear()

        let end = row.size
        var rowOffset: CInt = CInt(NSMaxRange(startRange))
        var x: CInt = 0

        while x < 4 && rowOffset < end {
            defer {
                x += 1
            }

            let bestMatch = ZXUPCEANReader.decodeDigit(row, counters: counters, rowOffset: rowOffset, patternType: ZX_UPC_EAN_PATTERNS.ZX_UPC_EAN_PATTERNS_L_PATTERNS, error: error)

            if bestMatch == 1 {
                return 1
            }

            result.appendFormat("%C", ("0" + bestMatch) as? unichar)
            rowOffset += (counters?.sum() ?? 0)
        }

        let middleRange: NSRange = type(of: self).findGuardPattern(row, rowOffset: rowOffset, whiteFirst: true, pattern: ZX_UPC_EAN_MIDDLE_PATTERN, patternLen: ZX_UPC_EAN_MIDDLE_PATTERN_LEN, error: error)

        if middleRange.location == NSNotFound {
            return 1
        }

        rowOffset = CInt(NSMaxRange(middleRange))

        var x: CInt = 0

        while x < 4 && rowOffset < end {
            defer {
                x += 1
            }

            let bestMatch = ZXUPCEANReader.decodeDigit(row, counters: counters, rowOffset: rowOffset, patternType: ZX_UPC_EAN_PATTERNS.ZX_UPC_EAN_PATTERNS_L_PATTERNS, error: error)

            if bestMatch == 1 {
                return 1
            }

            result.appendFormat("%C", ("0" + bestMatch) as? unichar)
            rowOffset += (counters?.sum() ?? 0)
        }

        return rowOffset
    }
    @objc
    func barcodeFormat() -> ZXBarcodeFormat {
        return ZXBarcodeFormat.kBarcodeFormatEan8
    }
}

// MARK: -
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
extension ZXEAN8Reader {
    @objc var decodeMiddleCounters: ZXIntArray! {
        return self._decodeMiddleCounters
    }
}