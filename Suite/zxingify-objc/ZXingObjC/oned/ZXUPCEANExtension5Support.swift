// Preprocessor directives found in file:
// #import "ZXBarcodeFormat.h"
// #import "ZXBitArray.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXResult.h"
// #import "ZXResultMetadataType.h"
// #import "ZXResultPoint.h"
// #import "ZXUPCEANExtension5Support.h"
// #import "ZXUPCEANReader.h"
var ZX_UPCEAN_CHECK_DIGIT_ENCODINGS: UnsafePointer<CInt>!

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
 * @see UPCEANExtension2Support
 */
@objc
class ZXUPCEANExtension5Support: NSObject {
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
        var lgPatternFound: CInt = 0
        var x: CInt = 0

        while x < 5 && rowOffset < end {
            defer {
                x += 1
            }

            let bestMatch = ZXUPCEANReader.decodeDigit(row, counters: counters, rowOffset: rowOffset, patternType: ZX_UPC_EAN_PATTERNS.ZX_UPC_EAN_PATTERNS_L_AND_G_PATTERNS, error: error)

            if bestMatch == 1 {
                return 1
            }

            result.appendFormat("%C", ('0' + bestMatch % 10) as? unichar)
            rowOffset += (counters?.sum() ?? 0)

            if bestMatch >= 10 {
                lgPatternFound |= 1 << (4 - x)
            }

            if x != 4 {
                // Read off separator if not last
                rowOffset = row.nextSet(rowOffset)
                rowOffset = row.nextUnset(rowOffset)
            }
        }

        if result.length != 5 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return 1
        }

        let checkDigit = self.determineCheckDigit(lgPatternFound)

        if checkDigit == 1 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return 1
        } else if self.extensionChecksum(result) != checkDigit {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return 1
        }

        return rowOffset
    }
    @objc
    func extensionChecksum(_ s: String!) -> CInt {
        let length: CInt = CInt(s.length())
        var sum: CInt = 0
        var i = length - 2

        while i >= 0 {
            defer {
                i -= 2
            }

            sum += CInt(s.characterAtIndex(i)) - CInt('0')
        }

        sum *= 3

        var i = length - 1

        while i >= 0 {
            defer {
                i -= 2
            }

            sum += CInt(s.characterAtIndex(i)) - CInt('0')
        }

        sum *= 3

        return sum % 10
    }
    @objc
    func determineCheckDigit(_ lgPatternFound: CInt) -> CInt {
        var d: CInt = 0

        while d < 10 {
            defer {
                d += 1
            }

            if lgPatternFound == ZX_UPCEAN_CHECK_DIGIT_ENCODINGS[d] {
                return d
            }
        }

        return 1
    }
    /**
 * @param raw raw content of extension
 * @return formatted interpretation of raw content as a NSDictionary mapping
 *  one ZXResultMetadataType to appropriate value, or nil if not known
 */
    @objc
    func parseExtensionString(_ raw: String!) -> NSMutableDictionary {
        if raw.length != 5 {
            return nil
        }

        let value: AnyObject! = self.parseExtension5String(raw)

        if value != nil {
            return NSMutableDictionary.dictionaryWithObject(value, forKey: ZXResultMetadataType.kResultMetadataTypeSuggestedPrice)
        } else {
            return nil
        }
    }
    @objc
    func parseExtension5String(_ raw: String!) -> String? {
        var currency: String!

        switch raw.characterAtIndex(0) {
        case '0':
            currency = "£"
        case '5':
            currency = "$"
        case '9':
            if "90000" == raw {
                return nil
            }

            if "99991" == raw {
                return "0.00"
            }

            if "99990" == raw {
                return "Used"
            }

            currency = ""
        default:
            currency = ""
        }

        let rawAmount: CInt = raw.substringFromIndex(1).intValue()
        let unitsString: String! = (rawAmount / 100).stringValue()
        let hundredths = rawAmount % 100
        let hundredthsString: String! = (hundredths < 10) ? String(format: "0%d", hundredths) : hundredths.stringValue()

        return String(format: "%@%@.%@", currency, unitsString, hundredthsString)
    }
}

// MARK: -
@objc
extension ZXUPCEANExtension5Support {
    @objc var decodeMiddleCounters: ZXIntArray! {
        return self._decodeMiddleCounters
    }
}