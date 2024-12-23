// Preprocessor directives found in file:
// #import "ZXBarcodeFormat.h"
// #import "ZXBitArray.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXResult.h"
// #import "ZXResultMetadataType.h"
// #import "ZXResultPoint.h"
// #import "ZXUPCEANExtension2Support.h"
// #import "ZXUPCEANReader.h"
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
 * @see UPCEANExtension5Support
 */
@objc
class ZXUPCEANExtension2Support: NSObject {
    private var _decodeMiddleCounters: ZXIntArray!

    @objc
    override init() {
        if self = super.init() {
            _decodeMiddleCounters = ZXIntArray(length: 4)
        }

        return self
    }

    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, extensionStartRange: NSRange, error: UnsafeMutablePointer<Error?>!) -> ZXResult {
        let resultString = NSMutableString()
        let end = self.decodeMiddle(row, startRange: extensionStartRange, result: resultString, error: error)

        if end == 1 {
            return nil
        }

        let extensionData = self.parseExtensionString(resultString)
        let extensionResult = ZXResult(text: resultString, rawBytes: nil, resultPoints: [ZXResultPoint(x: (extensionStartRange.location + NSMaxRange(extensionStartRange)) / 2.0, y: CFloat(rowNumber)), ZXResultPoint(x: CFloat(end), y: CFloat(rowNumber))], format: ZXBarcodeFormat.kBarcodeFormatUPCEANExtension)

        if extensionData != nil {
            extensionResult.putAllMetadata(extensionData)
        }

        return extensionResult
    }
    @objc
    func decodeMiddle(_ row: ZXBitArray!, startRange: NSRange, result: NSMutableString!, error: UnsafeMutablePointer<Error?>!) -> CInt {
        let counters = self.decodeMiddleCounters

        counters?.clear()

        let end = row.size
        var rowOffset: CInt = CInt(NSMaxRange(startRange))
        var checkParity: CInt = 0
        var x: CInt = 0

        while x < 2 && rowOffset < end {
            defer {
                x += 1
            }

            let bestMatch = ZXUPCEANReader.decodeDigit(row, counters: counters, rowOffset: rowOffset, patternType: ZX_UPC_EAN_PATTERNS.ZX_UPC_EAN_PATTERNS_L_AND_G_PATTERNS, error: error)

            if bestMatch == 1 {
                return 1
            }

            result.appendFormat("%C", ("0" + bestMatch % 10) as? unichar)
            rowOffset += (counters?.sum() ?? 0)

            if bestMatch >= 10 {
                checkParity |= 1 << (1 - x)
            }

            if x != 1 {
                // Read off separator if not last
                rowOffset = row.nextSet(rowOffset)
                rowOffset = row.nextUnset(rowOffset)
            }
        }

        if result.length != 2 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return 1
        }

        if result.intValue() % 4 != checkParity {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return 1
        }

        return rowOffset
    }
    /**
 * @param raw raw content of extension
 * @return formatted interpretation of raw content as a NSDictionary mapping
 *  one ZXResultMetadataType to appropriate value, or nil if not known
 */
    @objc
    func parseExtensionString(_ raw: String!) -> NSMutableDictionary? {
        if raw.length != 2 {
            return nil
        }

        return NSMutableDictionary.dictionaryWithObject(raw.intValue(), forKey: ZXResultMetadataType.kResultMetadataTypeIssueNumber)
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
extension ZXUPCEANExtension2Support {
    @objc var decodeMiddleCounters: ZXIntArray! {
        return self._decodeMiddleCounters
    }
}