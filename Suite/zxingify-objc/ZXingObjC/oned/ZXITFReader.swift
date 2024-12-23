// Preprocessor directives found in file:
// #import "ZXOneDReader.h"
// #import "ZXBitArray.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXITFReader.h"
// #import "ZXResult.h"
// #import "ZXResultPoint.h"
var ZX_ITF_MAX_AVG_VARIANCE: CFloat = 0.38
var ZX_ITF_MAX_INDIVIDUAL_VARIANCE: CFloat = 0.5
let ZX_ITF_W3: CInt = 3
let ZX_ITF_W2: CInt = 2
let ZX_ITF_N: CInt = 1
var ZX_ITF_DEFAULT_ALLOWED_LENGTHS: UnsafePointer<CInt>!
var ZX_ITF_ITF_START_PATTERN: UnsafePointer<CInt>!
var ZX_ITF_END_PATTERN_REVERSED: (CInt, CInt, CInt)
let ZX_ITF_PATTERNS_LEN: CInt = 20
var ZX_ITF_PATTERNS: (CInt, CInt, CInt, CInt, CInt)

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
 * Implements decoding of the ITF format, or Interleaved Two of Five.
 *
 * This Reader will scan ITF barcodes of certain lengths only.
 * At the moment it reads length 6, 8, 10, 12, 14, 16, 18, 20, 24, and 44 as these have appeared "in the wild". Not all
 * lengths are scanned, especially shorter ones, to avoid false positives. This in turn is due to a lack of
 * required checksum function.
 *
 * The checksum is optional and is not applied by this Reader. The consumer of the decoded
 * value will have to apply a checksum if required.
 *
 * http://en.wikipedia.org/wiki/Interleaved_2_of_5 is a great reference for Interleaved 2 of 5 information.
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
 * Implements decoding of the ITF format, or Interleaved Two of Five.
 *
 * This Reader will scan ITF barcodes of certain lengths only.
 * At the moment it reads length 6, 8, 10, 12, 14, 16, 18, 20, 24, and 44 as these have appeared "in the wild". Not all
 * lengths are scanned, especially shorter ones, to avoid false positives. This in turn is due to a lack of
 * required checksum function.
 *
 * The checksum is optional and is not applied by this Reader. The consumer of the decoded
 * value will have to apply a checksum if required.
 *
 * http://en.wikipedia.org/wiki/Interleaved_2_of_5 is a great reference for Interleaved 2 of 5 information.
 */
@objc
class ZXITFReader: ZXOneDReader {
    private var _narrowLineWidth: CInt = 0

    @objc
    override init() {
        if self = super.init() {
            _narrowLineWidth = 1
        }

        return self
    }

    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        // Find out where the Middle section (payload) starts & ends
        let startRange = self.decodeStart(row)
        let endRange = self.decodeEnd(row)

        if (startRange == nil) || (endRange == nil) {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let resultString = NSMutableString(capacity: 20)

        if !self.decodeMiddle(row, payloadStart: startRange?.array[1], payloadEnd: endRange?.array[0], resultString: resultString) {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        var allowedLengths: NSArray! = nil

        if hints != nil {
            allowedLengths = hints.allowedLengths
        }

        if allowedLengths == nil {
            let temp = NSMutableArray()
            var i: CInt = 0

            while i < MemoryLayout.size(ofValue: ZX_ITF_DEFAULT_ALLOWED_LENGTHS) / MemoryLayout<CInt>.size {
                defer {
                    i += 1
                }

                temp.add(ZX_ITF_DEFAULT_ALLOWED_LENGTHS[i])
            }

            allowedLengths = NSArray.arrayWithArray(temp)
        }

        // To avoid false positives with 2D barcodes (and other patterns), make
        // an assumption that the decoded string must be a 'standard' length if it's short
        let length: UInt = resultString.length()
        var lengthOK = false
        var maxAllowedLength: CInt = 0

        for i in allowedLengths {
            let allowedLength: CInt = i.intValue()

            if length == allowedLength {
                lengthOK = true

                break
            }

            if allowedLength > maxAllowedLength {
                maxAllowedLength = allowedLength
            }
        }

        if !lengthOK && length > maxAllowedLength {
            lengthOK = true
        }

        if !lengthOK {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            return nil
        }

        return ZXResult.resultWithText(resultString, rawBytes: nil, resultPoints: [ZXResultPoint(x: startRange?.array[1], y: CFloat(rowNumber)), ZXResultPoint(x: endRange?.array[0], y: CFloat(rowNumber))], format: ZXBarcodeFormat.kBarcodeFormatITF)
    }
    /**
 * @param row          row of black/white values to search
 * @param payloadStart offset of start pattern
 * @param resultString NSMutableString to append decoded chars to
 * @return NO if decoding could not complete successfully
 */
    @objc
    func decodeMiddle(_ row: ZXBitArray!, payloadStart: CInt, payloadEnd: CInt, resultString: NSMutableString!) -> Bool {
        // Digits are interleaved in pairs - 5 black lines for one digit, and the
        // 5
        // interleaved white lines for the second digit.
        // Therefore, need to scan 10 lines and then
        // split these into two arrays
        let counterDigitPair = ZXIntArray(length: 10)
        let counterBlack = ZXIntArray(length: 5)
        let counterWhite = ZXIntArray(length: 5)

        while payloadStart < payloadEnd {
            // Get 10 runs of black/white.
            if !ZXOneDReader.recordPattern(row, start: payloadStart, counters: counterDigitPair) {
                return false
            }

            var k: CInt = 0

            while k < 5 {
                defer {
                    k += 1
                }

                let twoK = 2 * k

                counterBlack.array[k] = counterDigitPair.array[twoK]
                counterWhite.array[k] = counterDigitPair.array[twoK + 1]
            }

            var bestMatch = self.decodeDigit(counterBlack)

            if bestMatch == 1 {
                return false
            }

            resultString.appendFormat("%C", ("0" + bestMatch) as? unichar)
            bestMatch = self.decodeDigit(counterWhite)

            if bestMatch == 1 {
                return false
            }

            resultString.appendFormat("%C", ("0" + bestMatch) as? unichar)

            var i: CInt = 0

            while i < counterDigitPair.length {
                defer {
                    i += 1
                }

                payloadStart += counterDigitPair.array[i]
            }
        }

        return true
    }
    /**
 * Identify where the start of the middle / payload section starts.
 *
 * @param row row of black/white values to search
 * @return Array, containing index of start of 'start block' and end of
 *         'start block'
 */
    @objc
    func decodeStart(_ row: ZXBitArray!) -> ZXIntArray? {
        let endStart = self.skipWhiteSpace(row)

        if endStart == 1 {
            return nil
        }

        let startPattern = self.findGuardPattern(row, rowOffset: endStart, pattern: ZX_ITF_ITF_START_PATTERN, patternLen: CInt(MemoryLayout.size(ofValue: ZX_ITF_ITF_START_PATTERN) / MemoryLayout<CInt>.size))

        if startPattern == nil {
            return nil
        }

        self.narrowLineWidth = (startPattern?.array[1] - startPattern?.array[0]) / 4

        if !self.validateQuietZone(row, startPattern: startPattern?.array[0]) {
            return nil
        }

        return startPattern
    }
    /**
 * The start & end patterns must be pre/post fixed by a quiet zone. This
 * zone must be at least 10 times the width of a narrow line.  Scan back until
 * we either get to the start of the barcode or match the necessary number of
 * quiet zone pixels.
 *
 * Note: Its assumed the row is reversed when using this method to find
 * quiet zone after the end pattern.
 *
 * ref: http://www.barcode-1.net/i25code.html
 *
 * @param row bit array representing the scanned barcode.
 * @param startPattern index into row of the start or end pattern.
 * @return NO if the quiet zone cannot be found, a ReaderException is thrown.
 */
    @objc
    func validateQuietZone(_ row: ZXBitArray!, startPattern: CInt) -> Bool {
        var quietCount = self.narrowLineWidth * 10

        // if there are not so many pixel at all let's try as many as possible
        quietCount = (quietCount < startPattern) ? quietCount : startPattern

        var i = startPattern - 1

        while quietCount > 0 && i >= 0 {
            defer {
                i -= 1
            }

            if row.get(i) {
                break
            }

            quietCount -= 1
        }

        if quietCount != 0 {
            return false
        }

        return true
    }
    /**
 * Skip all whitespace until we get to the first black line.
 *
 * @param row row of black/white values to search
 * @return index of the first black line or -1 if no black lines are found in the row
 */
    @objc
    func skipWhiteSpace(_ row: ZXBitArray!) -> CInt {
        let width = row.size
        let endStart = row.nextSet(0)

        if endStart == width {
            return 1
        }

        return endStart
    }
    /**
 * Identify where the end of the middle / payload section ends.
 *
 * @param row row of black/white values to search
 * @return Array, containing index of start of 'end block' and end of 'end
 *         block'
 */
    @objc
    func decodeEnd(_ row: ZXBitArray!) -> ZXIntArray? {
        // For convenience, reverse the row and then
        // search from 'the start' for the end block
        row.reverse()

        let endStart = self.skipWhiteSpace(row)

        if endStart == 1 {
            row.reverse()

            return nil
        }

        var endPattern = self.findGuardPattern(row, rowOffset: endStart, pattern: ZX_ITF_END_PATTERN_REVERSED[0], patternLen: CInt(MemoryLayout.size(ofValue: ZX_ITF_END_PATTERN_REVERSED[0]) / MemoryLayout<CInt>.size))

        if endPattern == nil {
            endPattern = self.findGuardPattern(row, rowOffset: endStart, pattern: ZX_ITF_END_PATTERN_REVERSED[1], patternLen: CInt(MemoryLayout.size(ofValue: ZX_ITF_END_PATTERN_REVERSED[1]) / MemoryLayout<CInt>.size))
        }

        if endPattern == nil {
            row.reverse()

            return nil
        }

        // The start & end patterns must be pre/post fixed by a quiet zone. This
        // zone must be at least 10 times the width of a narrow line.
        // ref: http://www.barcode-1.net/i25code.html
        if !self.validateQuietZone(row, startPattern: endPattern?.array[0]) {
            row.reverse()

            return nil
        }

        // Now recalculate the indices of where the 'endblock' starts & stops to
        // accommodate the reversed nature of the search
        let temp: CInt = endPattern?.array[0]

        endPattern?.array[0] = row.size - endPattern?.array[1]
        endPattern?.array[1] = row.size - temp
        // Put the row back the right way.
        row.reverse()

        return endPattern
    }
    /**
 * @param row       row of black/white values to search
 * @param rowOffset position to start search
 * @param pattern   pattern of counts of number of black and white pixels that are
 *                  being searched for as a pattern
 * @return start/end horizontal offset of guard pattern, as an array of two
 *         ints or nil if pattern is not found
 */
    @objc
    func findGuardPattern(_ row: ZXBitArray!, rowOffset: CInt, pattern: UnsafePointer<CInt>!, patternLen: CInt) -> ZXIntArray? {
        let patternLength = patternLen
        let counters = ZXIntArray(length: CUnsignedInt(patternLength))
        var array = counters.array
        let width = row.size
        var isWhite = false
        var counterPosition: CInt = 0
        var patternStart = rowOffset
        var x = rowOffset

        while x < width {
            defer {
                x += 1
            }

            if row.get(x) ^ isWhite {
                array?[counterPosition] += 1
            } else {
                if counterPosition == patternLength - 1 {
                    if ZXOneDReader.patternMatchVariance(counters, pattern: pattern, maxIndividualVariance: ZX_ITF_MAX_INDIVIDUAL_VARIANCE) < ZX_ITF_MAX_AVG_VARIANCE {
                        return ZXIntArray(ints: patternStart, x, 1)
                    }

                    patternStart += array?[0] + array?[1]

                    var y: CInt = 2

                    while y < patternLength {
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
    /**
 * Attempts to decode a sequence of ITF black/white lines into single
 * digit.
 *
 * @param counters the counts of runs of observed black/white/black/... values
 * @return The decoded digit or -1 if digit cannot be decoded
 */
    @objc
    func decodeDigit(_ counters: ZXIntArray!) -> CInt {
        var bestVariance = ZX_ITF_MAX_AVG_VARIANCE // worst variance we'll accept
        var bestMatch: CInt = 1
        let max = ZX_ITF_PATTERNS_LEN
        var i: CInt = 0

        while i < max {
            defer {
                i += 1
            }

            var pattern: UnsafeMutablePointer<CInt>!
            var ind: CInt = 0

            while ind < counters.length {
                defer {
                    ind += 1
                }

                pattern[ind] = ZX_ITF_PATTERNS[i][ind]
            }

            let variance = ZXOneDReader.patternMatchVariance(counters, pattern: pattern, maxIndividualVariance: ZX_ITF_MAX_INDIVIDUAL_VARIANCE)

            if variance < bestVariance {
                bestVariance = variance
                bestMatch = i
            } else if variance == bestVariance {
                // if we find a second 'best match' with the same variance, we can not reliably report to have a suitable match
                bestMatch = 1
            }
        }

        if bestMatch >= 0 {
            return bestMatch % 10
        } else {
            return 1
        }
    }
}

// MARK: -
// 0
// 1
// 2
// 3
// 4
// 5
// 6
// 7
// 8
// 9
// 0
// 1
// 2
// 3
// 4
// 5
// 6
// 7
// 8
// 9
@objc
extension ZXITFReader {
    @objc var narrowLineWidth: CInt {
        get {
            return self._narrowLineWidth
        }
        set {
            self._narrowLineWidth = newValue
        }
    }
}