// Preprocessor directives found in file:
// #import "ZXOneDReader.h"
// #import "ZXBitArray.h"
// #import "ZXCode39Reader.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXResult.h"
// #import "ZXResultPoint.h"
var ZX_CODE39_ALPHABET: UnsafeMutablePointer<unichar>!
var ZX_CODE39_ALPHABET_STRING: String! = nil
var ZX_CODE39_CHARACTER_ENCODINGS: UnsafePointer<CInt>!
let ZX_CODE39_ASTERISK_ENCODING: CInt = 0x94

/**
 * Decodes Code 39 barcodes. Supports "Full ASCII Code 39" if USE_CODE_39_EXTENDED_MODE is set.
 */
/**
 * Decodes Code 39 barcodes. Supports "Full ASCII Code 39" if USE_CODE_39_EXTENDED_MODE is set.
 */
@objc
class ZXCode39Reader: ZXOneDReader {
    private var _extendedMode: Bool = false
    private var _usingCheckDigit: Bool = false
    private var _counters: ZXIntArray!

    @objc
    override init() {
        return self.initUsingCheckDigit(false, extendedMode: false)
    }

    @objc
    static func load() {
        ZX_CODE39_ALPHABET_STRING = String(characters: ZX_CODE39_ALPHABET, length: MemoryLayout.size(ofValue: ZX_CODE39_ALPHABET) / MemoryLayout.size(ofValue: unichar))
    }
    /**
 * Creates a reader that can be configured to check the last character as a check digit.
 * It will not decoded "extended Code 39" sequences.
 *
 * @param usingCheckDigit if true, treat the last data character as a check digit, not
 * data, and verify that the checksum passes.
 */
    /**
 * Creates a reader that can be configured to check the last character as a check digit.
 * It will not decoded "extended Code 39" sequences.
 *
 * @param usingCheckDigit if true, treat the last data character as a check digit, not
 * data, and verify that the checksum passes.
 */
    @objc
    func initUsingCheckDigit(_ isUsingCheckDigit: Bool) -> AnyObject? {
        return self.initUsingCheckDigit(isUsingCheckDigit, extendedMode: false)
    }
    /**
 * Creates a reader that can be configured to check the last character as a check digit,
 * or optionally attempt to decode "extended Code 39" sequences that are used to encode
 * the full ASCII character set.
 *
 * @param usingCheckDigit if true, treat the last data character as a check digit, not
 * data, and verify that the checksum passes.
 * @param extendedMode if true, will attempt to decode extended Code 39 sequences in the
 * text.
 */
    /**
 * Creates a reader that can be configured to check the last character as a check digit,
 * or optionally attempt to decode "extended Code 39" sequences that are used to encode
 * the full ASCII character set.
 *
 * @param usingCheckDigit if true, treat the last data character as a check digit, not
 * data, and verify that the checksum passes.
 * @param extendedMode if true, will attempt to decode extended Code 39 sequences in the
 * text.
 */
    @objc
    func initUsingCheckDigit(_ usingCheckDigit: Bool, extendedMode: Bool) -> AnyObject? {
        if self = super.init() {
            _usingCheckDigit = usingCheckDigit
            _extendedMode = extendedMode
            _counters = ZXIntArray(length: 9)
        }

        return self
    }
    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let theCounters = self.counters

        theCounters?.clear()

        let result = NSMutableString(capacity: 20)
        let start = self.findAsteriskPattern(row, counters: theCounters)

        if start == nil {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        // Read off white space
        var nextStart = row.nextSet(start?.array[1])
        let end = row.size
        var decodedChar: unichar
        var lastStart: CInt

        repeat {
            if !ZXOneDReader.recordPattern(row, start: nextStart, counters: theCounters) {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
                }

                return nil
            }

            let pattern = self.toNarrowWidePattern(theCounters)

            if pattern < 0 {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
                }

                return nil
            }

            decodedChar = self.patternToChar(pattern)

            if decodedChar == 0 {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
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
        } while decodedChar != "*"

        result.deleteCharacters(in: NSMakeRange(result.length() - 1, 1)) // remove asterisk

        // Look for whitespace after pattern:
        var lastPatternSize: CInt = 0
        var i: CInt = 0

        while i < (theCounters?.length ?? 0) {
            defer {
                i += 1
            }

            lastPatternSize += theCounters?.array[i]
        }

        let whiteSpaceAfterEnd = nextStart - lastStart - lastPatternSize

        // If 50% of last pattern size, following last pattern, is not whitespace, fail
        // (but if it's whitespace to the very end of the image, that's OK)
        if nextStart != end && (whiteSpaceAfterEnd << 1) < lastPatternSize {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        if self.usingCheckDigit {
            let max: CInt = CInt(result.length()) - 1
            var total: CInt = 0
            var i: CInt = 0

            while i < max {
                defer {
                    i += 1
                }

                total += ZX_CODE39_ALPHABET_STRING.rangeOfString(result.substringWithRange(NSMakeRange(i, 1))).location
            }

            if result.characterAtIndex(max) != ZX_CODE39_ALPHABET[total % 43] {
                if error != nil {
                    error.pointee = ZXChecksumErrorInstance()
                }

                return nil
            }

            result.deleteCharacters(in: NSMakeRange(max, 1))
        }

        if result.length() == 0 {
            // false positive
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        var resultString: String!

        if self.extendedMode {
            resultString = self.decodeExtended(result)

            if !resultString {
                if error != nil {
                    error.pointee = ZXFormatErrorInstance()
                }

                return nil
            }
        } else {
            resultString = result
        }

        let left: CFloat = CFloat(start?.array[1] + start?.array[0]) / 2.0
        let right = (lastStart + lastPatternSize) / 2.0

        return ZXResult.resultWithText(resultString, rawBytes: nil, resultPoints: [ZXResultPoint(x: left, y: CFloat(rowNumber)), ZXResultPoint(x: right, y: CFloat(rowNumber))], format: ZXBarcodeFormat.kBarcodeFormatCode39)
    }
    @objc
    func findAsteriskPattern(_ row: ZXBitArray!, counters: ZXIntArray!) -> ZXIntArray? {
        let width = row.size
        let rowOffset = row.nextSet(0)
        var counterPosition: CInt = 0
        var patternStart = rowOffset
        var isWhite = false
        let patternLength: CInt = CInt(counters.length)
        var array = counters.array
        var i = rowOffset

        while i < width {
            defer {
                i += 1
            }

            if row.get(i) ^ isWhite {
                array?[counterPosition] += 1
            } else {
                if counterPosition == patternLength - 1 {
                    // Look for whitespace before start pattern, >= 50% of width of start pattern
                    if self.toNarrowWidePattern(counters) == ZX_CODE39_ASTERISK_ENCODING && row.isRange(max(0, patternStart - ((i - patternStart) / 2)), end: patternStart, value: false) {
                        return ZXIntArray(ints: patternLength, i, 1)
                    }

                    patternStart += array?[0] + array?[1]

                    var y: CInt = 2

                    while y < counters.length {
                        defer {
                            y += 1
                        }

                        array?[y - 2] = array?[y]
                    }

                    array?[patternLength - 2] = 0
                    array?[patternLength - 1] = 0
                    counterPosition -= 1
                } else {
                    counterPosition += 1
                }

                array?[counterPosition] = 1
                isWhite = !isWhite
            }
        }

        return nil
    }
    // For efficiency, returns -1 on failure. Not throwing here saved as many as 700 exceptions
    // per image when using some of our blackbox images.
    @objc
    func toNarrowWidePattern(_ counters: ZXIntArray!) -> CInt {
        let numCounters: CInt = CInt(counters.length)
        var maxNarrowCounter: CInt = 0
        var wideCounters: CInt

        repeat {
            var minCounter: CInt = INT_MAX
            let array = counters.array
            var i: CInt = 0

            while i < numCounters {
                defer {
                    i += 1
                }

                let counter: CInt = array?[i]

                if counter < minCounter && counter > maxNarrowCounter {
                    minCounter = counter
                }
            }

            maxNarrowCounter = minCounter
            wideCounters = 0

            var totalWideCountersWidth: CInt = 0
            var pattern: CInt = 0
            var i: CInt = 0

            while i < numCounters {
                defer {
                    i += 1
                }

                let counter: CInt = array?[i]

                if array?[i] > maxNarrowCounter {
                    pattern |= 1 << (numCounters - 1 - i)
                    wideCounters += 1
                    totalWideCountersWidth += counter
                }
            }

            if wideCounters == 3 {
                var i: CInt = 0

                while i < numCounters && wideCounters > 0 {
                    defer {
                        i += 1
                    }

                    let counter: CInt = array?[i]

                    if array?[i] > maxNarrowCounter {
                        wideCounters -= 1

                        // totalWideCountersWidth = 3 * average, so this checks if counter >= 3/2 * average
                        if (counter * 2) >= totalWideCountersWidth {
                            return 1
                        }
                    }
                }

                return pattern
            }
        } while wideCounters > 3

        return 1
    }
    @objc
    func patternToChar(_ pattern: CInt) -> unichar {
        var i: CInt = 0

        while i < MemoryLayout.size(ofValue: ZX_CODE39_CHARACTER_ENCODINGS) / MemoryLayout<CInt>.size {
            defer {
                i += 1
            }

            if ZX_CODE39_CHARACTER_ENCODINGS[i] == pattern {
                return ZX_CODE39_ALPHABET[i]
            }
        }

        if pattern == ZX_CODE39_ASTERISK_ENCODING {
            return "*"
        }

        return 0
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

            if c == "+" || c == "$" || c == "%" || c == "/" {
                let next: unichar = encoded.characterAtIndex(i + 1)
                var decodedChar: unichar = "\\0"

                switch c {
                case "+":
                    // +A to +Z map to a to z
                    if next >= "A" && next <= "Z" {
                        decodedChar = (next + 32) as? unichar
                    } else {
                        return nil
                    }
                case "$":
                    // $A to $Z map to control codes SH to SB
                    if next >= "A" && next <= "Z" {
                        decodedChar = (next - 64) as? unichar
                    } else {
                        return nil
                    }
                case "%":
                    // %A to %E map to control codes ESC to US
                    if next >= "A" && next <= "E" {
                        decodedChar = (next - 38) as? unichar
                    } else if next >= "F" && next <= "J" {
                        decodedChar = (next - 11) as? unichar
                    } else if next >= "K" && next <= "O" {
                        decodedChar = (next + 16) as? unichar
                    } else if next >= "P" && next <= "T" {
                        decodedChar = (next + 43) as? unichar
                    } else if next == "U" {
                        decodedChar = 0 as? unichar
                    } else if next == "V" {
                        decodedChar = "@"
                    } else if next == "W" {
                        decodedChar = "`"
                    } else if next == "X" || next == "Y" || next == "Z" {
                        decodedChar = 127 as? unichar
                    } else {
                        return nil
                    }
                case "/":
                    // /A to /O map to ! to , and /Z maps to :
                    if next >= "A" && next <= "O" {
                        decodedChar = (next - 32) as? unichar
                    } else if next == "Z" {
                        decodedChar = ":"
                    } else {
                        return nil
                    }
                default:
                    break
                }

                decoded.appendFormat("%C", decodedChar)
                // bump up i again since we read two characters
                i += 1
            } else {
                decoded.appendFormat("%C", c)
            }
        }

        return decoded
    }
}

// MARK: -
@objc
extension ZXCode39Reader {
    @objc var extendedMode: Bool {
        return self._extendedMode
    }
    @objc var usingCheckDigit: Bool {
        return self._usingCheckDigit
    }
    @objc var counters: ZXIntArray! {
        return self._counters
    }
}