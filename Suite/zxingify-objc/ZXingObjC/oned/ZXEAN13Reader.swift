// Preprocessor directives found in file:
// #import "ZXUPCEANReader.h"
// #import "ZXBitArray.h"
// #import "ZXEAN13Reader.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
var ZX_EAN13_FIRST_DIGIT_ENCODINGS: UnsafePointer<CInt>!

/**
 * Implements decoding of the EAN-13 format.
 */
/**
 * Implements decoding of the EAN-13 format.
 */
@objc
class ZXEAN13Reader: ZXUPCEANReader {
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

        if !self.determineFirstDigit(result, lgPatternFound: lgPatternFound) {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return 1
        }

        let middleRange: NSRange = type(of: self).findGuardPattern(row, rowOffset: rowOffset, whiteFirst: true, pattern: ZX_UPC_EAN_MIDDLE_PATTERN, patternLen: ZX_UPC_EAN_MIDDLE_PATTERN_LEN, error: error)

        if middleRange.location == NSNotFound {
            return 1
        }

        rowOffset = CInt(NSMaxRange(middleRange))

        var x: CInt = 0

        while x < 6 && rowOffset < end {
            defer {
                x += 1
            }

            let bestMatch = ZXUPCEANReader.decodeDigit(row, counters: counters, rowOffset: rowOffset, patternType: ZX_UPC_EAN_PATTERNS.ZX_UPC_EAN_PATTERNS_L_PATTERNS, error: error)

            if bestMatch == 1 {
                return 1
            }

            result.appendFormat("%C", ('0' + bestMatch) as? unichar)
            rowOffset += (counters?.sum() ?? 0)
        }

        return rowOffset
    }
    @objc
    func barcodeFormat() -> ZXBarcodeFormat {
        return ZXBarcodeFormat.kBarcodeFormatEan13
    }
    /**
 * Based on pattern of odd-even ('L' and 'G') patterns used to encoded the explicitly-encoded
 * digits in a barcode, determines the implicitly encoded first digit and adds it to the
 * result string.
 *
 * @param resultString string to insert decoded first digit into
 * @param lgPatternFound int whose bits indicates the pattern of odd/even L/G patterns used to
 *  encode digits
 * @return NO if first digit cannot be determined
 */
    @objc
    func determineFirstDigit(_ resultString: NSMutableString!, lgPatternFound: CInt) -> Bool {
        var d: CInt = 0

        while d < 10 {
            defer {
                d += 1
            }

            if lgPatternFound == ZX_EAN13_FIRST_DIGIT_ENCODINGS[d] {
                resultString.insert(String(format: "%C", ('0' + d) as? unichar), at: 0)

                return true
            }
        }

        return false
    }
}

// MARK: -
@objc
extension ZXEAN13Reader {
    @objc var decodeMiddleCounters: ZXIntArray! {
        return self._decodeMiddleCounters
    }
}