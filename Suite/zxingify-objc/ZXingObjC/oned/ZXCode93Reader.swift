// Preprocessor directives found in file:
// #import "ZXOneDReader.h"
// #import "ZXBitArray.h"
// #import "ZXCode93Reader.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXResult.h"
// #import "ZXResultPoint.h"
let ZX_CODE93_ALPHABET_STRING: String! = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%abcd*"
var ZX_CODE93_ALPHABET: UnsafePointer<unichar>!
var ZX_CODE93_CHARACTER_ENCODINGS: UnsafePointer<CInt>!
let ZX_CODE93_ASTERISK_ENCODING: CInt = 0x15e

/**
 * Decodes Code 93 barcodes.
 */
/**
 * Decodes Code 93 barcodes.
 */
@objc
class ZXCode93Reader: ZXOneDReader {
    private var _counters: ZXIntArray!

    @objc
    override init() {
        if self = super.init() {
            _counters = ZXIntArray(length: 6)
        }

        return self
    }

    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let start = self.findAsteriskPattern(row)

        if start == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        // Read off white space
        var nextStart = row.nextSet(start?.array[1])
        let end = row.size
        let theCounters = self.counters

        memset(theCounters?.array, 0, (theCounters?.length ?? 0) * MemoryLayout.size(ofValue: int32_t))

        let result = NSMutableString()
        var decodedChar: unichar
        var lastStart: CInt

        repeat {
            if !ZXOneDReader.recordPattern(row, start: nextStart, counters: theCounters) {
                if error {
                    *error = ZXNotFoundErrorInstance()
                }

                return nil
            }

            let pattern = self.toPattern(theCounters)

            if pattern < 0 {
                if error {
                    *error = ZXNotFoundErrorInstance()
                }

                return nil
            }

            decodedChar = self.patternToChar(pattern)

            if decodedChar == 0 {
                if error {
                    *error = ZXNotFoundErrorInstance()
                }

                return nil
            }

            result.appendFormat("%C", decodedChar)
            lastStart = nextStart

            var i: CInt = 0

            while i < (theCounters?.length ?? 0) {
                defer {
                    i += 1
                }

                nextStart += theCounters?.array[i]
            }

            // Read off white space
            nextStart = row.nextSet(nextStart)
        } while decodedChar != '*'

        result.deleteCharacters(in: NSMakeRange(result.length() - 1, 1)) // remove asterisk

        let lastPatternSize = theCounters?.sum() ?? 0

        // Should be at least one more black module
        if nextStart == end || !row.get(nextStart) {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        if result.length() < 2 {
            // false positive -- need at least 2 checksum digits
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        if !self.checkChecksums(result, error: error) {
            return nil
        }

        result.deleteCharacters(in: NSMakeRange(result.length() - 2, 2))

        let resultString = self.decodeExtended(result)

        if resultString == nil {
            if error {
                *error = ZXFormatErrorInstance()
            }

            return nil
        }

        let left: CFloat = CFloat(start?.array[1] + start?.array[0]) / 2.0
        let right = lastStart + lastPatternSize / 2.0

        return ZXResult.resultWithText(resultString, rawBytes: nil, resultPoints: [ZXResultPoint(x: left, y: CFloat(rowNumber)), ZXResultPoint(x: right, y: CFloat(rowNumber))], format: ZXBarcodeFormat.kBarcodeFormatCode93)
    }
    @objc
    func findAsteriskPattern(_ row: ZXBitArray!) -> ZXIntArray? {
        let width = row.size
        let rowOffset = row.nextSet(0)

        self.counters.clear()

        let theCounters = self.counters
        var patternStart = rowOffset
        var isWhite = false
        let patternLength: CInt = CInt(CInt(theCounters?.length ?? 0))
        var counterPosition: CInt = 0
        var i = rowOffset

        while i < width {
            defer {
                i += 1
            }

            if row.get(i) ^ isWhite {
                theCounters?.array[counterPosition] += 1
            } else {
                if counterPosition == patternLength - 1 {
                    if self.toPattern(theCounters) == ZX_CODE93_ASTERISK_ENCODING {
                        return ZXIntArray(ints: patternStart, i, 1)
                    }

                    patternStart += theCounters?.array[0] + theCounters?.array[1]

                    var y: CInt = 2

                    while y < patternLength {
                        defer {
                            y += 1
                        }

                        theCounters?.array[y - 2] = theCounters?.array[y]
                    }

                    theCounters?.array[patternLength - 2] = 0
                    theCounters?.array[patternLength - 1] = 0
                    counterPosition -= 1
                } else {
                    counterPosition += 1
                }

                theCounters?.array[counterPosition] = 1
                isWhite = !isWhite
            }
        }

        return nil
    }
    @objc
    func toPattern(_ counters: ZXIntArray!) -> CInt {
        let max: CInt = CInt(counters.length)
        let sum = counters.sum()
        let array = counters.array
        var pattern: CInt = 0
        var i: CInt = 0

        while i < max {
            defer {
                i += 1
            }

            let scaled: CInt = round(array?[i] * 9.0 / sum)

            if scaled < 1 || scaled > 4 {
                return 1
            }

            if (i & 0x1) == 0 {
                var j: CInt = 0

                while j < scaled {
                    defer {
                        j += 1
                    }

                    pattern = (pattern << 1) | 0x1
                }
            } else {
                pattern <<= scaled
            }
        }

        return pattern
    }
    @objc
    func patternToChar(_ pattern: CInt) -> unichar {
        var i: CInt = 0

        while i < MemoryLayout.size(ofValue: ZX_CODE93_CHARACTER_ENCODINGS) / MemoryLayout<CInt>.size {
            defer {
                i += 1
            }

            if ZX_CODE93_CHARACTER_ENCODINGS[i] == pattern {
                return ZX_CODE93_ALPHABET[i]
            }
        }

        return 1
    }
    @objc
    func decodeExtended(_ encoded: NSMutableString!) -> String? {
        let length: UInt = encoded.length()
        let decoded = NSMutableString(capacity: Int(length))
        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            let c: unichar = encoded.characterAtIndex(i)

            if c >= 'a' && c <= 'd' {
                if i >= length - 1 {
                    return nil
                }

                let next: unichar = encoded.characterAtIndex(i + 1)
                var decodedChar: unichar = '\0'

                switch c {
                case 'd':
                    if next >= 'A' && next <= 'Z' {
                        decodedChar = (next + 32) as? unichar
                    } else {
                        return nil
                    }
                case 'a':
                    if next >= 'A' && next <= 'Z' {
                        decodedChar = (next - 64) as? unichar
                    } else {
                        return nil
                    }
                case 'b':
                    if next >= 'A' && next <= 'E' {
                        // %A to %E map to control codes ESC to USep
                        decodedChar = (next - 38) as? unichar
                    } else if next >= 'F' && next <= 'J' {
                        // %F to %J map to ; < = > ?
                        decodedChar = (next - 11) as? unichar
                    } else if next >= 'K' && next <= 'O' {
                        // %K to %O map to [ \ ] ^ _
                        decodedChar = (next + 16) as? unichar
                    } else if next >= 'P' && next <= 'T' {
                        // %P to %T map to { | } ~ DEL
                        decodedChar = (next + 43) as? unichar
                    } else if next == 'U' {
                        // %U map to NUL
                        decodedChar = '\0'
                    } else if next == 'V' {
                        // %V map to @
                        decodedChar = '@'
                    } else if next == 'W' {
                        // %W map to `
                        decodedChar = '`'
                    } else if next >= 'X' && next <= 'Z' {
                        // %X to %Z all map to DEL (127)
                        decodedChar = 127
                    } else {
                        return nil
                    }
                case 'c':
                    if next >= 'A' && next <= 'O' {
                        decodedChar = (next - 32) as? unichar
                    } else if next == 'Z' {
                        decodedChar = ':'
                    } else {
                        return nil
                    }
                default:
                    break
                }

                decoded.appendFormat("%C", decodedChar)
                i += 1
            } else {
                decoded.appendFormat("%C", c)
            }
        }

        return decoded
    }
    @objc
    func checkChecksums(_ result: NSMutableString!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        let length: UInt = result.length()

        if !self.checkOneChecksum(result, checkPosition: CInt(length) - 2, weightMax: 20, error: error) {
            return false
        }

        return self.checkOneChecksum(result, checkPosition: CInt(length) - 1, weightMax: 15, error: error)
    }
    @objc
    func checkOneChecksum(_ result: NSMutableString!, checkPosition: CInt, weightMax: CInt, error: UnsafeMutablePointer<Error?>!) -> Bool {
        var weight: CInt = 1
        var total: CInt = 0
        var i = checkPosition - 1

        while i >= 0 {
            defer {
                i -= 1
            }

            total += weight * ZX_CODE93_ALPHABET_STRING.rangeOfString(String(format: "%C", result.characterAtIndex(i))).location

            if weight += 1 > weightMax {
                weight = 1
            }
        }

        if result.characterAtIndex(checkPosition) != ZX_CODE93_ALPHABET[total % 47] {
            if error {
                *error = ZXChecksumErrorInstance()
            }

            return false
        }

        return true
    }
}

// MARK: -
@objc
extension ZXCode93Reader {
    @objc var counters: ZXIntArray! {
        return self._counters
    }
}