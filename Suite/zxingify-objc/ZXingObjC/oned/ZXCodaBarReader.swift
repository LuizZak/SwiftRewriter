// Preprocessor directives found in file:
// #import "ZXOneDReader.h"
// #import "ZXBitArray.h"
// #import "ZXCodaBarReader.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXResult.h"
// #import "ZXResultPoint.h"
var ZX_CODA_MAX_ACCEPTABLE: CFloat = 2.0
var ZX_CODA_PADDING: CFloat = 1.5
var ZX_CODA_ALPHABET: UnsafePointer<unichar>!
let ZX_CODA_ALPHABET_LEN: CInt = MemoryLayout.size(ofValue: ZX_CODA_ALPHABET) / MemoryLayout.size(ofValue: unichar)
var ZX_CODA_CHARACTER_ENCODINGS: UnsafePointer<CInt>!
let ZX_CODA_MIN_CHARACTER_LENGTH: CInt = 3
var ZX_CODA_STARTEND_ENCODING: UnsafePointer<unichar>!

/**
 * Decodes Codabar barcodes.
 */
/**
 * Decodes Codabar barcodes.
 */
@objc
class ZXCodaBarReader: ZXOneDReader {
    private var _decodeRowResult: NSMutableString!
    private var _counters: ZXIntArray!
    private var _counterLength: CInt = 0

    @objc
    override init() {
        if self = super.init() {
            _decodeRowResult = NSMutableString(capacity: 20)
            _counters = ZXIntArray(length: 80)
            _counterLength = 0
        }

        return self
    }

    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        self.counters.clear()

        if !self.setCountersWithRow(row) {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let startOffset = self.findStartPattern()

        if startOffset == 1 {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        var nextStart = startOffset

        self.decodeRowResult = NSMutableString()

        repeat {
            let charOffset = self.toNarrowWidePattern(nextStart)

            if charOffset == 1 {
                if error {
                    *error = ZXNotFoundErrorInstance()
                }

                return nil
            }

            // Hack: We store the position in the alphabet table into a
            // NSMutableString, so that we can access the decoded patterns in
            // validatePattern. We'll translate to the actual characters later.
            self.decodeRowResult.appendFormat("%C", charOffset as? unichar)
            nextStart += 8

            // Stop as soon as we see the end character.
            if self.decodeRowResult.length > 1 && ZXCodaBarReader.arrayContains(ZX_CODA_STARTEND_ENCODING, length: CUnsignedInt(MemoryLayout.size(ofValue: ZX_CODA_STARTEND_ENCODING) / MemoryLayout.size(ofValue: unichar)), key: ZX_CODA_ALPHABET[charOffset]) {
                break
            }
        } while nextStart < self.counterLength // no fixed end pattern so keep on reading while data is available

        // Look for whitespace after pattern:
        let trailingWhitespace: CInt = self.counters.array[nextStart - 1]
        var lastPatternSize: CInt = 0
        var i: CInt = 8

        while i < 1 {
            defer {
                i += 1
            }

            lastPatternSize += self.counters.array[nextStart + i]
        }

        // We need to see whitespace equal to 50% of the last pattern size,
        // otherwise this is probably a false positive. The exception is if we are
        // at the end of the row. (I.e. the barcode barely fits.)
        if nextStart < self.counterLength && trailingWhitespace < lastPatternSize / 2 {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        if !self.validatePattern(startOffset) {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        var i: CInt = 0

        while i < self.decodeRowResult.length {
            defer {
                i += 1
            }

            self.decodeRowResult.replaceCharacters(in: NSMakeRange(i, 1), with: String(format: "%c", ZX_CODA_ALPHABET[self.decodeRowResult.characterAtIndex(i)]))
        }

        // Ensure a valid start and end character
        let startchar: unichar = self.decodeRowResult.characterAtIndex(0)

        if !ZXCodaBarReader.arrayContains(ZX_CODA_STARTEND_ENCODING, length: CUnsignedInt(MemoryLayout.size(ofValue: ZX_CODA_STARTEND_ENCODING) / MemoryLayout.size(ofValue: unichar)), key: startchar) {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let endchar: unichar = self.decodeRowResult.characterAtIndex(self.decodeRowResult.length - 1)

        if !ZXCodaBarReader.arrayContains(ZX_CODA_STARTEND_ENCODING, length: CUnsignedInt(MemoryLayout.size(ofValue: ZX_CODA_STARTEND_ENCODING) / MemoryLayout.size(ofValue: unichar)), key: endchar) {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        // remove stop/start characters character and check if a long enough string is contained
        if self.decodeRowResult.length <= ZX_CODA_MIN_CHARACTER_LENGTH {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        if !hints.returnCodaBarStartEnd {
            self.decodeRowResult.deleteCharacters(in: NSMakeRange(self.decodeRowResult.length - 1, 1))
            self.decodeRowResult.deleteCharacters(in: NSMakeRange(0, 1))
        }

        var runningCount: CInt = 0
        var i: CInt = 0

        while i < startOffset {
            defer {
                i += 1
            }

            runningCount += self.counters.array[i]
        }

        let left: CFloat = CFloat(runningCount)
        var i = startOffset

        while i < nextStart - 1 {
            defer {
                i += 1
            }

            runningCount += self.counters.array[i]
        }

        let right: CFloat = CFloat(runningCount)

        return ZXResult.resultWithText(self.decodeRowResult, rawBytes: nil, resultPoints: [ZXResultPoint(x: left, y: CFloat(rowNumber)), ZXResultPoint(x: right, y: CFloat(rowNumber))], format: ZXBarcodeFormat.kBarcodeFormatCodabar)
    }
    @objc
    func validatePattern(_ start: CInt) -> Bool {
        // First, sum up the total size of our four categories of stripe sizes;
        var sizes: (CInt, CInt, CInt, CInt)
        var counts: (CInt, CInt, CInt, CInt)
        let end: CInt = CInt(self.decodeRowResult.length) - 1
        // We break out of this loop in the middle, in order to handle
        // inter-character spaces properly.
        var pos = start
        var i: CInt = 0

        while true {
            defer {
                i += 1
            }

            var pattern: CInt = ZX_CODA_CHARACTER_ENCODINGS[self.decodeRowResult.characterAtIndex(i)]
            var j: CInt = 6

            while j >= 0 {
                defer {
                    j -= 1
                }

                // Even j = bars, while odd j = spaces. Categories 2 and 3 are for
                // long stripes, while 0 and 1 are for short stripes.
                let category = (j & 1) + (pattern & 1) * 2

                sizes[category] += self.counters.array[pos + j]
                counts[category] += 1
                pattern >>= 1
            }

            if i >= end {
                break
            }

            // We ignore the inter-character space - it could be of any size.
            pos += 8
        }

        // Calculate our allowable size thresholds using fixed-point math.
        var maxes: (CFloat, CFloat, CFloat, CFloat)
        var mins: (CFloat, CFloat, CFloat, CFloat)
        var i: CInt = 0

        while i < 2 {
            defer {
                i += 1
            }

            mins[i] = 0.0 // Accept arbitrarily small "short" stripes.
            mins[i + 2] = (CFloat(sizes[i]) / counts[i] + CFloat(sizes[i + 2]) / counts[i + 2]) / 2.0

            maxes[i] = mins[i + 2]
            maxes[i + 2] = (sizes[i + 2] * ZX_CODA_MAX_ACCEPTABLE + ZX_CODA_PADDING) / counts[i + 2]
        }

        // Now verify that all of the stripes are within the thresholds.
        pos = start

        var i: CInt = 0

        while true {
            defer {
                i += 1
            }

            var pattern: CInt = ZX_CODA_CHARACTER_ENCODINGS[self.decodeRowResult.characterAtIndex(i)]
            var j: CInt = 6

            while j >= 0 {
                defer {
                    j -= 1
                }

                // Even j = bars, while odd j = spaces. Categories 2 and 3 are for
                // long stripes, while 0 and 1 are for short stripes.
                let category = (j & 1) + (pattern & 1) * 2
                let size: CInt = self.counters.array[pos + j]

                if size < mins[category] || size > maxes[category] {
                    return false
                }

                pattern >>= 1
            }

            if i >= end {
                break
            }

            pos += 8
        }

        return true
    }
    /**
 * Records the size of all runs of white and black pixels, starting with white.
 * This is just like recordPattern, except it records all the counters, and
 * uses our builtin "counters" member for storage.
 */
    @objc
    func setCountersWithRow(_ row: ZXBitArray!) -> Bool {
        self.counterLength = 0

        // Start from the first white bit.
        var i = row.nextUnset(0)
        let end = row.size

        if i >= end {
            return false
        }

        var isWhite = true
        var count: CInt = 0

        while i < end {
            if row.get(i) ^ isWhite {
                // that is, exactly one is true
                count += 1
            } else {
                self.counterAppend(count)
                count = 1
                isWhite = !isWhite
            }

            i += 1
        }

        self.counterAppend(count)

        return true
    }
    @objc
    func counterAppend(_ e: CInt) {
        self.counters.array[self.counterLength] = e
        self.counterLength += 1

        if self.counterLength >= (self.counters.length ?? 0) {
            let temp = ZXIntArray(length: CUnsignedInt(self.counterLength * 2))

            memcpy(temp.array, self.counters.array, (self.counters.length ?? 0) * MemoryLayout.size(ofValue: int32_t))
            self.counters = temp
        }
    }
    @objc
    func findStartPattern() -> CInt {
        var i: CInt = 1

        while i < self.counterLength {
            defer {
                i += 2
            }

            let charOffset = self.toNarrowWidePattern(i)

            if charOffset != 1 && type(of: self).arrayContains(ZX_CODA_STARTEND_ENCODING, length: MemoryLayout.size(ofValue: ZX_CODA_STARTEND_ENCODING) / MemoryLayout.size(ofValue: unichar), key: ZX_CODA_ALPHABET[charOffset]) {
                // Look for whitespace before start pattern, >= 50% of width of start pattern
                // We make an exception if the whitespace is the first element.
                var patternSize: CInt = 0
                var j = i

                while j < i + 7 {
                    defer {
                        j += 1
                    }

                    patternSize += self.counters.array[j]
                }

                if i == 1 || self.counters.array[i - 1] >= patternSize / 2 {
                    return i
                }
            }
        }

        return 1
    }
    @objc
    static func arrayContains(_ array: UnsafePointer<unichar>!, length: CUnsignedInt, key: unichar) -> Bool {
        if array != nil {
            var i: CInt = 0

            while i < length {
                defer {
                    i += 1
                }

                if array[i] == key {
                    return true
                }
            }
        }

        return false
    }
    // Assumes that counters[position] is a bar.
    @objc
    func toNarrowWidePattern(_ position: CInt) -> CInt {
        let array = self.counters.array
        let end = position + 7

        if end >= self.counterLength {
            return 1
        }

        var maxBar: CInt = 0
        var minBar: CInt = INT_MAX
        var j = position

        while j < end {
            defer {
                j += 2
            }

            let currentCounter: CInt = array?[j]

            if currentCounter < minBar {
                minBar = currentCounter
            }

            if currentCounter > maxBar {
                maxBar = currentCounter
            }
        }

        let thresholdBar = (minBar + maxBar) / 2
        var maxSpace: CInt = 0
        var minSpace: CInt = INT_MAX
        var j = position + 1

        while j < end {
            defer {
                j += 2
            }

            let currentCounter: CInt = array?[j]

            if currentCounter < minSpace {
                minSpace = currentCounter
            }

            if currentCounter > maxSpace {
                maxSpace = currentCounter
            }
        }

        let thresholdSpace = (minSpace + maxSpace) / 2
        var bitmask: CInt = 1 << 7
        var pattern: CInt = 0
        var i: CInt = 0

        while i < 7 {
            defer {
                i += 1
            }

            let threshold = ((i & 1) == 0) ? thresholdBar : thresholdSpace

            bitmask >>= 1

            if array?[position + i] > threshold {
                pattern |= bitmask
            }
        }

        var i: CInt = 0

        while i < MemoryLayout.size(ofValue: ZX_CODA_CHARACTER_ENCODINGS) / MemoryLayout<CInt>.size {
            defer {
                i += 1
            }

            if ZX_CODA_CHARACTER_ENCODINGS[i] == pattern {
                return i
            }
        }

        return 1
    }
}

// MARK: -
// some codabar generator allow the codabar string to be closed by every
// character. This will cause lots of false positives!
// some industries use a checksum standard but this is not part of the original codabar standard
// for more information see : http://www.mecsw.com/specs/codabar.html
@objc
extension ZXCodaBarReader {
    @objc var decodeRowResult: NSMutableString! {
        get {
            return self._decodeRowResult
        }
        set {
            self._decodeRowResult = newValue
        }
    }
    @objc var counters: ZXIntArray! {
        get {
            return self._counters
        }
        set {
            self._counters = newValue
        }
    }
    @objc var counterLength: CInt {
        get {
            return self._counterLength
        }
        set {
            self._counterLength = newValue
        }
    }
}