// Preprocessor directives found in file:
// #import "ZXOneDReader.h"
// #import "ZXBitArray.h"
// #import "ZXByteArray.h"
// #import "ZXCode128Reader.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXOneDReader.h"
// #import "ZXResult.h"
// #import "ZXResultPoint.h"
let ZX_CODE128_CODE_PATTERNS_LEN: CInt = 107
var ZX_CODE128_CODE_PATTERNS: (CInt, CInt, CInt, CInt, CInt, CInt, CInt)
var ZX_CODE128_MAX_AVG_VARIANCE: CFloat = 0.25
var ZX_CODE128_MAX_INDIVIDUAL_VARIANCE: CFloat = 0.7
let ZX_CODE128_CODE_SHIFT: CInt = 98
let ZX_CODE128_CODE_CODE_C: CInt = 99
let ZX_CODE128_CODE_CODE_B: CInt = 100
let ZX_CODE128_CODE_CODE_A: CInt = 101
let ZX_CODE128_CODE_FNC_1: CInt = 102
let ZX_CODE128_CODE_FNC_2: CInt = 97
let ZX_CODE128_CODE_FNC_3: CInt = 96
let ZX_CODE128_CODE_FNC_4_A: CInt = 101
let ZX_CODE128_CODE_FNC_4_B: CInt = 100
let ZX_CODE128_CODE_START_A: CInt = 103
let ZX_CODE128_CODE_START_B: CInt = 104
let ZX_CODE128_CODE_START_C: CInt = 105
let ZX_CODE128_CODE_STOP: CInt = 106

/**
 * Decodes Code 128 barcodes.
 */
/**
 * Decodes Code 128 barcodes.
 */
@objc
class ZXCode128Reader: ZXOneDReader {
    @objc
    func findStartPattern(_ row: ZXBitArray!) -> ZXIntArray? {
        let width = row.size
        let rowOffset = row.nextSet(0)
        var counterPosition: CInt = 0
        let counters = ZXIntArray(length: 6)
        var array = counters.array
        var patternStart = rowOffset
        var isWhite = false
        let patternLength: CInt = CInt(counters.length)
        var i = rowOffset

        while i < width {
            defer {
                i += 1
            }

            if row.get(i) ^ isWhite {
                array?[counterPosition] += 1
            } else {
                if counterPosition == patternLength - 1 {
                    var bestVariance = ZX_CODE128_MAX_AVG_VARIANCE
                    var bestMatch: CInt = 1
                    var startCode = ZX_CODE128_CODE_START_A

                    while startCode <= ZX_CODE128_CODE_START_C {
                        defer {
                            startCode += 1
                        }

                        let variance = ZXOneDReader.patternMatchVariance(counters, pattern: ZX_CODE128_CODE_PATTERNS[startCode], maxIndividualVariance: ZX_CODE128_MAX_INDIVIDUAL_VARIANCE)

                        if variance < bestVariance {
                            bestVariance = variance
                            bestMatch = startCode
                        }
                    }

                    // Look for whitespace before start pattern, >= 50% of width of start pattern
                    if bestMatch >= 0 && row.isRange(max(0, patternStart - (i - patternStart) / 2), end: patternStart, value: false) {
                        return ZXIntArray(ints: patternStart, i, bestMatch, 1)
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
    @objc
    func decodeCode(_ row: ZXBitArray!, counters: ZXIntArray!, rowOffset: CInt) -> CInt {
        if !ZXOneDReader.recordPattern(row, start: rowOffset, counters: counters) {
            return 1
        }

        var bestVariance = ZX_CODE128_MAX_AVG_VARIANCE
        var bestMatch: CInt = 1
        var d: CInt = 0

        while d < ZX_CODE128_CODE_PATTERNS_LEN {
            defer {
                d += 1
            }

            let variance = ZXOneDReader.patternMatchVariance(counters, pattern: ZX_CODE128_CODE_PATTERNS[d], maxIndividualVariance: ZX_CODE128_MAX_INDIVIDUAL_VARIANCE)

            if variance < bestVariance {
                bestVariance = variance
                bestMatch = d
            }
        }

        if bestMatch >= 0 {
            return bestMatch
        } else {
            return 1
        }
    }
    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let convertFNC1 = hints && hints.assumeGS1
        let startPatternInfo = self.findStartPattern(row)

        if startPatternInfo == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let startCode: CInt = startPatternInfo?.array[2]
        var codeSet: CInt
        let rawCodes: NSMutableArray! = [startCode].mutableCopy()

        switch startCode {
        case ZX_CODE128_CODE_START_A:
            codeSet = ZX_CODE128_CODE_CODE_A
        case ZX_CODE128_CODE_START_B:
            codeSet = ZX_CODE128_CODE_CODE_B
        case ZX_CODE128_CODE_START_C:
            codeSet = ZX_CODE128_CODE_CODE_C
        default:
            if error {
                *error = ZXFormatErrorInstance()
            }

            return nil
        }

        var done = false
        var isNextShifted = false
        let result = NSMutableString(capacity: 20)
        var lastStart: CInt = startPatternInfo?.array[0]
        var nextStart: CInt = startPatternInfo?.array[1]
        let counters = ZXIntArray(length: 6)
        var lastCode: CInt = 0
        var code: CInt = 0
        var checksumTotal = startCode
        var multiplier: CInt = 0
        var lastCharacterWasPrintable = true
        var upperMode = false
        var shiftUpperMode = false

        while !done {
            let unshift = isNextShifted

            isNextShifted = false
            // Save off last code
            lastCode = code
            // Decode another code from image
            code = self.decodeCode(row, counters: counters, rowOffset: nextStart)

            if code == 1 {
                if error {
                    *error = ZXNotFoundErrorInstance()
                }

                return nil
            }

            rawCodes.add(code)

            // Remember whether the last code was printable or not
            // and Add to checksum computation
            // (excluding ZX_CODE128_CODE_STOP)
            if code != ZX_CODE128_CODE_STOP {
                lastCharacterWasPrintable = true
                multiplier += 1
                checksumTotal += multiplier * code
            }

            // Advance to where the next code will to start
            lastStart = nextStart
            nextStart += counters.sum()

            // Take care of illegal start codes
            switch code {
            case ZX_CODE128_CODE_START_A, ZX_CODE128_CODE_START_B, ZX_CODE128_CODE_START_C:
                if error {
                    *error = ZXFormatErrorInstance()
                }

                return nil
            default:
                break
            }

            var wasAlreadyAppended = false

            if hints.substitutions != nil && (hints.substitutions.count ?? 0) > 0 {
                let signCandidate: String! = hints.substitutions.valueForKey(String(format: "%d", code))

                if signCandidate != nil {
                    // Substitute
                    result.append(signCandidate)
                    wasAlreadyAppended = true
                }
            }

            switch codeSet {
            case ZX_CODE128_CODE_CODE_A:
                if code < 64 {
                    if shiftUpperMode == upperMode {
                        if !wasAlreadyAppended {
                            result.appendFormat("%C", (' ' + code) as? unichar)
                        }
                    } else if !wasAlreadyAppended {
                        result.appendFormat("%C", (' ' + code + 128) as? unichar)
                    }

                    shiftUpperMode = false
                } else if code < 96 {
                    if shiftUpperMode == upperMode {
                        result.appendFormat("%C", (code - 64) as? unichar)
                    } else {
                        result.appendFormat("%C", (code + 64) as? unichar)
                    }

                    shiftUpperMode = false
                } else {
                    // Don't let CODE_STOP, which always appears, affect whether whether we think the last
                    // code was printable or not.
                    if code != ZX_CODE128_CODE_STOP {
                        lastCharacterWasPrintable = false
                    }

                    switch code {
                    case ZX_CODE128_CODE_FNC_1:
                        if convertFNC1 {
                            if result.length == 0 {
                                // GS1 specification 5.4.3.7. and 5.4.6.4. If the first char after the start code
                                // is FNC1 then this is GS1-128. We add the symbology identifier.
                                result.append("]C1")
                            } else {
                                // GS1 specification 5.4.7.5. Every subsequent FNC1 is returned as ASCII 29 (GS)
                                result.appendFormat("%C", 29 as? unichar)
                            }
                        }
                    case ZX_CODE128_CODE_FNC_2, ZX_CODE128_CODE_FNC_3:
                        // do nothing?
                        break
                    case ZX_CODE128_CODE_FNC_4_A:
                        if !upperMode && shiftUpperMode {
                            upperMode = true
                            shiftUpperMode = false
                        } else if upperMode && shiftUpperMode {
                            upperMode = false
                            shiftUpperMode = false
                        } else {
                            shiftUpperMode = true
                        }
                    case ZX_CODE128_CODE_SHIFT:
                        isNextShifted = true
                        codeSet = ZX_CODE128_CODE_CODE_B
                    case ZX_CODE128_CODE_CODE_B:
                        codeSet = ZX_CODE128_CODE_CODE_B
                    case ZX_CODE128_CODE_CODE_C:
                        codeSet = ZX_CODE128_CODE_CODE_C
                    case ZX_CODE128_CODE_STOP:
                        done = true
                    default:
                        break
                    }
                }
            case ZX_CODE128_CODE_CODE_B:
                if code < 96 {
                    if shiftUpperMode == upperMode {
                        if !wasAlreadyAppended {
                            result.appendFormat("%C", (' ' + code) as? unichar)
                        }
                    } else if !wasAlreadyAppended {
                        result.appendFormat("%C", (' ' + code + 128) as? unichar)
                    }

                    shiftUpperMode = false
                } else {
                    if code != ZX_CODE128_CODE_STOP {
                        lastCharacterWasPrintable = false
                    }

                    switch code {
                    case ZX_CODE128_CODE_FNC_1:
                        if convertFNC1 {
                            if result.length == 0 {
                                // GS1 specification 5.4.3.7. and 5.4.6.4. If the first char after the start code
                                // is FNC1 then this is GS1-128. We add the symbology identifier.
                                result.append("]C1")
                            } else {
                                // GS1 specification 5.4.7.5. Every subsequent FNC1 is returned as ASCII 29 (GS)
                                result.appendFormat("%C", 29 as? unichar)
                            }
                        }
                    case ZX_CODE128_CODE_FNC_2, ZX_CODE128_CODE_FNC_3:
                        // do nothing?
                        break
                    case ZX_CODE128_CODE_FNC_4_B:
                        if !upperMode && shiftUpperMode {
                            upperMode = true
                            shiftUpperMode = false
                        } else if upperMode && shiftUpperMode {
                            upperMode = false
                            shiftUpperMode = false
                        } else {
                            shiftUpperMode = true
                        }
                    case ZX_CODE128_CODE_SHIFT:
                        isNextShifted = true
                        codeSet = ZX_CODE128_CODE_CODE_A
                    case ZX_CODE128_CODE_CODE_A:
                        codeSet = ZX_CODE128_CODE_CODE_A
                    case ZX_CODE128_CODE_CODE_C:
                        codeSet = ZX_CODE128_CODE_CODE_C
                    case ZX_CODE128_CODE_STOP:
                        done = true
                    default:
                        break
                    }
                }
            case ZX_CODE128_CODE_CODE_C:
                if code < 100 {
                    if !wasAlreadyAppended {
                        if code < 10 {
                            result.append("0")
                        }

                        result.appendFormat("%d", code)
                    }
                } else {
                    if code != ZX_CODE128_CODE_STOP {
                        lastCharacterWasPrintable = false
                    }

                    switch code {
                    case ZX_CODE128_CODE_FNC_1:
                        if convertFNC1 {
                            if result.length == 0 {
                                // GS1 specification 5.4.3.7. and 5.4.6.4. If the first char after the start code
                                // is FNC1 then this is GS1-128. We add the symbology identifier.
                                result.append("]C1")
                            } else {
                                // GS1 specification 5.4.7.5. Every subsequent FNC1 is returned as ASCII 29 (GS)
                                result.appendFormat("%C", 29 as? unichar)
                            }
                        }
                    case ZX_CODE128_CODE_CODE_A:
                        codeSet = ZX_CODE128_CODE_CODE_A
                    case ZX_CODE128_CODE_CODE_B:
                        codeSet = ZX_CODE128_CODE_CODE_B
                    case ZX_CODE128_CODE_STOP:
                        done = true
                    default:
                        break
                    }
                }
            default:
                break
            }

            // Unshift back to another code set if we were shifted
            if unshift {
                codeSet = (codeSet == ZX_CODE128_CODE_CODE_A) ? ZX_CODE128_CODE_CODE_B : ZX_CODE128_CODE_CODE_A
            }
        }

        let lastPatternSize = nextStart - lastStart

        // Check for ample whitespace following pattern, but, to do this we first need to remember that
        // we fudged decoding CODE_STOP since it actually has 7 bars, not 6. There is a black bar left
        // to read off. Would be slightly better to properly read. Here we just skip it:
        nextStart = row.nextUnset(nextStart)

        if !row.isRange(nextStart, end: min(row.size, nextStart + (nextStart - lastStart) / 2), value: false) {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        // Pull out from sum the value of the penultimate check code
        checksumTotal -= multiplier * lastCode

        // lastCode is the checksum then:
        if checksumTotal % 103 != lastCode {
            if error {
                *error = ZXChecksumErrorInstance()
            }

            return nil
        }

        // Need to pull out the check digits from string
        let resultLength: UInt = result.length()

        if resultLength == 0 {
            // false positive
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        // Only bother if the result had at least one character, and if the checksum digit happened to
        // be a printable character. If it was just interpreted as a control code, nothing to remove.
        if resultLength > 0 && lastCharacterWasPrintable {
            if codeSet == ZX_CODE128_CODE_CODE_C {
                result.deleteCharacters(in: NSMakeRange(resultLength - 2, 2))
            } else {
                result.deleteCharacters(in: NSMakeRange(resultLength - 1, 1))
            }
        }

        let left: CFloat = CFloat(startPatternInfo?.array[1] + startPatternInfo?.array[0]) / 2.0
        let right = lastStart + lastPatternSize / 2.0
        let rawCodesSize: UInt = UInt(rawCodes.count)
        let rawBytes = ZXByteArray(length: CUnsignedInt(rawCodesSize))
        var i: CInt = 0

        while i < rawCodesSize {
            defer {
                i += 1
            }

            rawBytes.array[i] = rawCodes[Int(i)].intValue() as? int8_t
        }

        return ZXResult.resultWithText(result, rawBytes: rawBytes, resultPoints: [ZXResultPoint(x: left, y: CFloat(rowNumber)), ZXResultPoint(x: right, y: CFloat(rowNumber))], format: ZXBarcodeFormat.kBarcodeFormatCode128)
    }
}