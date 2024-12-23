// Preprocessor directives found in file:
// #import "ZXBarcodeFormat.h"
// #import "ZXUPCEANReader.h"
// #import "ZXBitArray.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXUPCEReader.h"
let ZX_UPCE_MIDDLE_END_PATTERN_LEN: CInt = 6
var ZX_UPCE_MIDDLE_END_PATTERN: UnsafePointer<CInt>!
var ZX_UCPE_NUMSYS_AND_CHECK_DIGIT_PATTERNS: (CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt)

/**
 * Implements decoding of the UPC-E format.
 *
 * http://www.barcodeisland.com/upce.phtml is a great reference for UPC-E information.
 */
/**
 * Implements decoding of the UPC-E format.
 *
 * http://www.barcodeisland.com/upce.phtml is a great reference for UPC-E information.
 */
@objc
class ZXUPCEReader: ZXUPCEANReader {
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
        var lgPatternFound: CInt = 0
        var x: CInt = 0

        while x < 6 && rowOffset < end {
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
                lgPatternFound |= 1 << (5 - x)
            }
        }

        if !self.determineNumSysAndCheckDigit(result, lgPatternFound: lgPatternFound) {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return 1
        }

        return rowOffset
    }
    @objc
    func decodeEnd(_ row: ZXBitArray!, endStart: CInt, error: UnsafeMutablePointer<Error?>!) -> NSRange {
        return ZXUPCEANReader.findGuardPattern(row, rowOffset: endStart, whiteFirst: true, pattern: ZX_UPCE_MIDDLE_END_PATTERN, patternLen: CInt(MemoryLayout.size(ofValue: ZX_UPCE_MIDDLE_END_PATTERN) / MemoryLayout<CInt>.size), error: error)
    }
    @objc
    static func checkStandardUPCEANChecksum(_ s: String!) -> Bool {
        return super.checkStandardUPCEANChecksum(ZXUPCEReader.convertUPCEtoUPCA(s))
    }
    @objc
    func determineNumSysAndCheckDigit(_ resultString: NSMutableString!, lgPatternFound: CInt) -> Bool {
        var numSys: CInt = 0

        while numSys <= 1 {
            defer {
                numSys += 1
            }

            var d: CInt = 0

            while d < 10 {
                defer {
                    d += 1
                }

                if lgPatternFound == ZX_UCPE_NUMSYS_AND_CHECK_DIGIT_PATTERNS[numSys][d] {
                    resultString.insert(String(format: "%C", ('0' + numSys) as? unichar), at: 0)
                    resultString.appendFormat("%C", ('0' + d) as? unichar)

                    return true
                }
            }
        }

        return false
    }
    @objc
    func barcodeFormat() -> ZXBarcodeFormat {
        return ZXBarcodeFormat.kBarcodeFormatUPCE
    }
    /**
 * Expands a UPC-E value back into its full, equivalent UPC-A code value.
 *
 * @param upce UPC-E code as string of digits
 * @return equivalent UPC-A code as string of digits
 */
    @objc
    static func convertUPCEtoUPCA(_ upce: String!) -> String? {
        let upceChars: String! = upce.substringWithRange(NSMakeRange(1, 6))
        let result = NSMutableString(capacity: 12)

        result.appendFormat("%C", upce.characterAtIndex(0))

        let lastChar: unichar = upceChars.characterAtIndex(5)

        switch lastChar {
        case '0', '1', '2':
            result.append(upceChars.substringToIndex(2))
            result.appendFormat("%C", lastChar)
            result.append("0000")
            result.append(upceChars.substringWithRange(NSMakeRange(2, 3)))
        case '3':
            result.append(upceChars.substringToIndex(3))
            result.append("00000")
            result.append(upceChars.substringWithRange(NSMakeRange(3, 2)))
        case '4':
            result.append(upceChars.substringToIndex(4))
            result.append("00000")
            result.append(upceChars.substringWithRange(NSMakeRange(4, 1)))
        default:
            result.append(upceChars.substringToIndex(5))
            result.append("0000")
            result.appendFormat("%C", lastChar)
        }

        // Only append check digit in conversion if supplied
        if upce.length >= 8 {
            result.appendFormat("%C", upce.characterAtIndex(7))
        }

        return result
    }
}

// MARK: -
@objc
extension ZXUPCEReader {
    @objc var decodeMiddleCounters: ZXIntArray! {
        return self._decodeMiddleCounters
    }
}