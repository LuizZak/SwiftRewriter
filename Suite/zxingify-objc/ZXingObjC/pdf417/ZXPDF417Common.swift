// Preprocessor directives found in file:
// #define ZX_PDF417_SYMBOL_TABLE_LEN 2787
// #define ZX_PDF417_BARS_IN_MODULE 8
// #import "ZXIntArray.h"
// #import "ZXPDF417.h"
// #import "ZXPDF417Common.h"
let ZX_PDF417_NUMBER_OF_CODEWORDS: CInt = 929
let ZX_PDF417_MAX_CODEWORDS_IN_BARCODE: CInt = ZX_PDF417_NUMBER_OF_CODEWORDS - 1
let ZX_PDF417_MIN_ROWS_IN_BARCODE: CInt = 3
let ZX_PDF417_MAX_ROWS_IN_BARCODE: CInt = 90
let ZX_PDF417_MODULES_IN_CODEWORD: CInt = 17
let ZX_PDF417_MODULES_IN_STOP_PATTERN: CInt = 18
var ZX_PDF417_COMMON_CODEWORD_TABLE: UnsafePointer<CInt>!
var ZX_PDF417_SYMBOL_TABLE: UnsafePointer<CInt>!
var ZX_PDF417_COMMON_CODEWORD_TABLE: UnsafePointer<CInt>!
let ZX_PDF417_SYMBOL_TABLE_LEN: Int = 2787
let ZX_PDF417_BARS_IN_MODULE: Int = 8

@objc
class ZXPDF417Common: NSObject {
    @objc
    static func bitCountSum(_ moduleBitCount: NSArray!) -> CInt {
        var bitCountSum: CInt = 0

        for count in moduleBitCount {
            bitCountSum += count.intValue()
        }

        return bitCountSum
    }
    @objc
    static func toIntArray(_ list: NSArray!) -> ZXIntArray {
        let result = ZXIntArray(length: CUnsignedInt(list.count))
        var i: CInt = 0

        for integer in list {
            result.array[i += 1] = integer.intValue() as? int32_t
        }

        return result
    }
    /**
 * @param symbol encoded symbol to translate to a codeword
 * @return the codeword corresponding to the symbol.
 */
    /**
 * @param symbol encoded symbol to translate to a codeword
 * @return the codeword corresponding to the symbol.
 */
    @objc
    static func codeword(_ symbol: CInt) -> CInt {
        let i = self.binarySearch(symbol & 0x3ffff)

        if i == 1 {
            return 1
        }

        return (ZX_PDF417_COMMON_CODEWORD_TABLE[i] - 1) % ZX_PDF417_NUMBER_OF_CODEWORDS
    }
    /**
 * Use a binary search to find the index of the codeword corresponding to
 * this symbol.
 *
 * @param symbol the symbol from the barcode.
 * @return the index into the codeword table.
 */
    @objc
    static func binarySearch(_ symbol: CInt) -> CInt {
        var first: CInt = 0
        var upto: CInt = CInt(ZX_PDF417_SYMBOL_TABLE_LEN)

        while first < upto {
            let mid = (first + upto) / 2 // Compute mid point.

            if symbol < ZX_PDF417_SYMBOL_TABLE[mid] {
                upto = mid // continue search in bottom half.
            } else if symbol > ZX_PDF417_SYMBOL_TABLE[mid] {
                first = mid + 1 // continue search in top half.
            } else {
                return mid // Found it. return position
            }
        }

        return 1
    }
}