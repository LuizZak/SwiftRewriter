// Preprocessor directives found in file:
// #import "ZXBarcodeFormat.h"
// #import "ZXOneDReader.h"
// #import "ZXBitArray.h"
// #import "ZXDecodeHints.h"
// #import "ZXEANManufacturerOrgSupport.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXResult.h"
// #import "ZXResultPoint.h"
// #import "ZXResultPointCallback.h"
// #import "ZXUPCEANReader.h"
// #import "ZXUPCEANExtensionSupport.h"
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
enum ZX_UPC_EAN_PATTERNS: CInt {
    case ZX_UPC_EAN_PATTERNS_L_PATTERNS = 0
    case ZX_UPC_EAN_PATTERNS_L_AND_G_PATTERNS
}

var ZX_UPC_EAN_MAX_AVG_VARIANCE: CFloat = 0.48
var ZX_UPC_EAN_MAX_INDIVIDUAL_VARIANCE: CFloat = 0.7
let ZX_UPC_EAN_START_END_PATTERN_LEN: CInt = 3
var ZX_UPC_EAN_START_END_PATTERN: UnsafePointer<CInt>!
let ZX_UPC_EAN_MIDDLE_PATTERN_LEN: CInt = 5
var ZX_UPC_EAN_MIDDLE_PATTERN: UnsafePointer<CInt>!
let ZX_UPC_EAN_L_PATTERNS_LEN: CInt = 10
let ZX_UPC_EAN_L_PATTERNS_SUB_LEN: CInt = 4
var ZX_UPC_EAN_L_PATTERNS: UnsafePointer<CInt>!
let ZX_UPC_EAN_L_AND_G_PATTERNS_LEN: CInt = 20
let ZX_UPC_EAN_L_AND_G_PATTERNS_SUB_LEN: CInt = 4
var ZX_UPC_EAN_L_AND_G_PATTERNS: UnsafePointer<CInt>!

/**
 * Encapsulates functionality and implementation that is common to UPC and EAN families
 * of one-dimensional barcodes.
 */
/**
 * Encapsulates functionality and implementation that is common to UPC and EAN families
 * of one-dimensional barcodes.
 */
@objc
class ZXUPCEANReader: ZXOneDReader {
    private var _decodeRowNSMutableString: NSMutableString!
    private var _extensionReader: ZXUPCEANExtensionSupport!
    private var _eanManSupport: ZXEANManufacturerOrgSupport!

    @objc
    override init() {
        if self = super.init() {
            _decodeRowNSMutableString = NSMutableString(capacity: 20)
            _extensionReader = ZXUPCEANExtensionSupport()
            _eanManSupport = ZXEANManufacturerOrgSupport()
        }

        return self
    }

    @objc
    static func findStartGuardPattern(_ row: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> NSRange {
        var foundStart = false
        var startRange: NSRange = NSMakeRange(NSNotFound, 0)
        var nextStart: CInt = 0
        let counters = ZXIntArray(length: CUnsignedInt(ZX_UPC_EAN_START_END_PATTERN_LEN))

        while !foundStart {
            counters.clear()
            startRange = self.findGuardPattern(row, rowOffset: nextStart, whiteFirst: false, pattern: ZX_UPC_EAN_START_END_PATTERN, patternLen: ZX_UPC_EAN_START_END_PATTERN_LEN, counters: counters, error: error)

            if startRange.location == NSNotFound {
                return startRange
            }

            let start: CInt = CInt(startRange.location)

            nextStart = CInt(NSMaxRange(startRange))

            // Make sure there is a quiet zone at least as big as the start pattern before the barcode.
            // If this check would run off the left edge of the image, do not accept this barcode,
            // as it is very likely to be a false positive.
            let quietStart = start - (nextStart - start)

            if quietStart >= 0 {
                foundStart = row.isRange(quietStart, end: start, value: false)
            }
        }

        return startRange
    }
    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        return self.decodeRow(rowNumber, row: row, startGuardRange: type(of: self).findStartGuardPattern(row, error: error), hints: hints, error: error)
    }
    /**
 * Like decodeRow:row:hints:, but allows caller to inform method about where the UPC/EAN start pattern is
 * found. This allows this to be computed once and reused across many implementations.
 *
 *
 * @param rowNumber row index into the image
 * @param row encoding of the row of the barcode image
 * @param startGuardRange start/end column where the opening start pattern was found
 * @param hints optional hints that influence decoding
 * @return ZXResult encapsulating the result of decoding a barcode in the row or nil if:
 *   - no potential barcode is found
 *   - a potential barcode is found but does not pass its checksum
 *   - a potential barcode is found but format is invalid
 */
    /**
 * Like decodeRow:row:hints:, but allows caller to inform method about where the UPC/EAN start pattern is
 * found. This allows this to be computed once and reused across many implementations.
 *
 *
 * @param rowNumber row index into the image
 * @param row encoding of the row of the barcode image
 * @param startGuardRange start/end column where the opening start pattern was found
 * @param hints optional hints that influence decoding
 * @return ZXResult encapsulating the result of decoding a barcode in the row or nil if:
 *   - no potential barcode is found
 *   - a potential barcode is found but does not pass its checksum
 *   - a potential barcode is found but format is invalid
 */
    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, startGuardRange: NSRange, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let resultPointCallback: ZXResultPointCallback! = (hints == nil) ? nil : hints.resultPointCallback

        if resultPointCallback != nil {
            resultPointCallback.foundPossibleResultPoint(ZXResultPoint(x: (startGuardRange.location + NSMaxRange(startGuardRange)) / 2.0, y: CFloat(rowNumber)))
        }

        let result = NSMutableString()
        let endStart = self.decodeMiddle(row, startRange: startGuardRange, result: result, error: error)

        if endStart == 1 {
            return nil
        }

        if resultPointCallback != nil {
            resultPointCallback.foundPossibleResultPoint(ZXResultPoint(x: CFloat(endStart), y: CFloat(rowNumber)))
        }

        let endRange = self.decodeEnd(row, endStart: endStart, error: error)

        if endRange.location == NSNotFound {
            return nil
        }

        if resultPointCallback != nil {
            resultPointCallback.foundPossibleResultPoint(ZXResultPoint(x: (endRange.location + NSMaxRange(endRange)) / 2.0, y: CFloat(rowNumber)))
        }

        // Make sure there is a quiet zone at least as big as the end pattern after the barcode. The
        // spec might want more whitespace, but in practice this is the maximum we can count on.
        let end: CInt = CInt(NSMaxRange(endRange))
        let quietEnd: CInt = end + (end - CInt(endRange.location))

        if quietEnd >= row.size || !row.isRange(end, end: quietEnd, value: false) {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let resultString = result.description

        // UPC/EAN should never be less than 8 chars anyway
        if resultString.length() < 8 {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            return nil
        }

        if !self.checkChecksum(resultString, error: error) {
            if error != nil {
                error.pointee = ZXChecksumErrorInstance()
            }

            return nil
        }

        let left: CFloat = CFloat(NSMaxRange(startGuardRange) + startGuardRange.location) / 2.0
        let right: CFloat = CFloat(NSMaxRange(endRange) + endRange.location) / 2.0
        let format = self.barcodeFormat()
        let decodeResult = ZXResult.resultWithText(resultString, rawBytes: nil, resultPoints: [ZXResultPoint(x: left, y: CFloat(rowNumber)), ZXResultPoint(x: right, y: CFloat(rowNumber))], format: format)
        var extensionLength: CInt = 0
        let extensionResult = self.extensionReader.decodeRow(rowNumber, row: row, rowOffset: CInt(NSMaxRange(endRange)), error: error)

        if extensionResult != nil {
            decodeResult?.putMetadata(ZXResultMetadataType.kResultMetadataTypeUPCEANExtension, value: extensionResult?.text)
            decodeResult?.putAllMetadata(extensionResult?.resultMetadata())
            decodeResult?.addResultPoints(extensionResult?.resultPoints())

            extensionLength = CInt(extensionResult?.text.length())
        }

        let allowedExtensions: ZXIntArray! = (hints == nil) ? nil : hints.allowedEANExtensions

        if allowedExtensions != nil {
            var valid = false
            var i: CInt = 0

            while i < allowedExtensions.length {
                defer {
                    i += 1
                }

                if extensionLength == allowedExtensions.array[i] {
                    valid = true

                    break
                }
            }

            if !valid {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
                }

                return nil
            }
        }

        if format == ZXBarcodeFormat.kBarcodeFormatEan13 || format == ZXBarcodeFormat.kBarcodeFormatUPCA {
            let countryID = self.eanManSupport.lookupCountryIdentifier(resultString)

            if countryID != nil {
                decodeResult?.putMetadata(ZXResultMetadataType.kResultMetadataTypePossibleCountry, value: countryID)
            }
        }

        return decodeResult
    }
    /**
 * @param s string of digits to check
 * @return checkStandardUPCEANChecksum: or nil if the string does not contain only digits
 */
    /**
 * @param s string of digits to check
 * @return checkStandardUPCEANChecksum: or nil if the string does not contain only digits
 */
    @objc
    func checkChecksum(_ s: String!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        if type(of: self).checkStandardUPCEANChecksum(s) {
            return true
        } else {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            return false
        }
    }
    /**
 * Computes the UPC/EAN checksum on a string of digits, and reports
 * whether the checksum is correct or not.
 *
 * @param s string of digits to check
 * @return YES iff string of digits passes the UPC/EAN checksum algorithm
 * @return NO if the string does not contain only digits
 */
    /**
 * Computes the UPC/EAN checksum on a string of digits, and reports
 * whether the checksum is correct or not.
 *
 * @param s string of digits to check
 * @return YES iff string of digits passes the UPC/EAN checksum algorithm
 * @return NO if the string does not contain only digits
 */
    @objc
    static func checkStandardUPCEANChecksum(_ s: String!) -> Bool {
        let length: CInt = CInt(s.length())

        if length == 0 {
            return false
        }

        let check: CInt = s.substringWithRange(NSMakeRange(length - 1, 1)).intValue()

        return self.standardUPCEANChecksum(s.substringWithRange(NSMakeRange(0, length - 1))) == check
    }
    @objc
    static func standardUPCEANChecksum(_ s: String!) -> CInt {
        let length: CInt = CInt(s.length())
        var sum: CInt = 0
        var i = length - 1

        while i >= 0 {
            defer {
                i -= 2
            }

            let digit: CInt = CInt(s.characterAtIndex(i)) - CInt('0')

            if digit < 0 || digit > 9 {
                return false
            }

            sum += digit
        }

        sum *= 3

        var i = length - 2

        while i >= 0 {
            defer {
                i -= 2
            }

            let digit: CInt = CInt(s.characterAtIndex(i)) - CInt('0')

            if digit < 0 || digit > 9 {
                return false
            }

            sum += digit
        }

        return (1000 - sum) % 10
    }
    @objc
    func decodeEnd(_ row: ZXBitArray!, endStart: CInt, error: UnsafeMutablePointer<Error?>!) -> NSRange {
        return type(of: self).findGuardPattern(row, rowOffset: endStart, whiteFirst: false, pattern: ZX_UPC_EAN_START_END_PATTERN, patternLen: ZX_UPC_EAN_START_END_PATTERN_LEN, error: error)
    }
    @objc
    static func findGuardPattern(_ row: ZXBitArray!, rowOffset: CInt, whiteFirst: Bool, pattern: UnsafePointer<CInt>!, patternLen: CInt, error: UnsafeMutablePointer<Error?>!) -> NSRange {
        let counters = ZXIntArray(length: CUnsignedInt(patternLen))

        return self.findGuardPattern(row, rowOffset: rowOffset, whiteFirst: whiteFirst, pattern: pattern, patternLen: patternLen, counters: counters, error: error)
    }
    /**
 * @param row row of black/white values to search
 * @param rowOffset position to start search
 * @param whiteFirst if true, indicates that the pattern specifies white/black/white/...
 * pixel counts, otherwise, it is interpreted as black/white/black/...
 * @param pattern pattern of counts of number of black and white pixels that are being
 * searched for as a pattern
 * @param counters array of counters, as long as pattern, to re-use
 * @return start/end horizontal offset of guard pattern, as an array of two ints
 */
    /**
 * @param row row of black/white values to search
 * @param rowOffset position to start search
 * @param whiteFirst if true, indicates that the pattern specifies white/black/white/...
 * pixel counts, otherwise, it is interpreted as black/white/black/...
 * @param pattern pattern of counts of number of black and white pixels that are being
 * searched for as a pattern
 * @param counters array of counters, as long as pattern, to re-use
 * @return start/end horizontal offset of guard pattern, as an array of two ints
 */
    @objc
    static func findGuardPattern(_ row: ZXBitArray!, rowOffset: CInt, whiteFirst: Bool, pattern: UnsafePointer<CInt>!, patternLen: CInt, counters: ZXIntArray!, error: UnsafeMutablePointer<Error?>!) -> NSRange {
        let patternLength = patternLen
        let width = row.size
        var isWhite = whiteFirst

        rowOffset = whiteFirst ? row.nextUnset(rowOffset) : row.nextSet(rowOffset)

        var counterPosition: CInt = 0
        var patternStart = rowOffset
        var array = counters.array
        var x = rowOffset

        while x < width {
            defer {
                x += 1
            }

            if row.get(x) ^ isWhite {
                array?[counterPosition] += 1
            } else {
                if counterPosition == patternLength - 1 {
                    if self.patternMatchVariance(counters, pattern: pattern, maxIndividualVariance: ZX_UPC_EAN_MAX_INDIVIDUAL_VARIANCE) < ZX_UPC_EAN_MAX_AVG_VARIANCE {
                        return NSMakeRange(patternStart, x - patternStart)
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

        if error != nil {
            error.pointee = ZXNotFoundErrorInstance()
        }

        return NSMakeRange(NSNotFound, 0)
    }
    /**
 * Attempts to decode a single UPC/EAN-encoded digit.
 *
 * @param row row of black/white values to decode
 * @param counters the counts of runs of observed black/white/black/... values
 * @param rowOffset horizontal offset to start decoding from
 * @param patternType the set of patterns to use to decode -- sometimes different encodings
 * for the digits 0-9 are used, and this indicates the encodings for 0 to 9 that should
 * be used
 * @return horizontal offset of first pixel beyond the decoded digit
 * @return -1 if digit cannot be decoded
 */
    /**
 * Attempts to decode a single UPC/EAN-encoded digit.
 *
 * @param row row of black/white values to decode
 * @param counters the counts of runs of observed black/white/black/... values
 * @param rowOffset horizontal offset to start decoding from
 * @param patternType the set of patterns to use to decode -- sometimes different encodings
 * for the digits 0-9 are used, and this indicates the encodings for 0 to 9 that should
 * be used
 * @return horizontal offset of first pixel beyond the decoded digit
 * @return -1 if digit cannot be decoded
 */
    /**
 * Attempts to decode a single UPC/EAN-encoded digit.
 */
    @objc
    static func decodeDigit(_ row: ZXBitArray!, counters: ZXIntArray!, rowOffset: CInt, patternType: ZX_UPC_EAN_PATTERNS, error: UnsafeMutablePointer<Error?>!) -> CInt {
        if !self.recordPattern(row, start: rowOffset, counters: counters) {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return 1
        }

        var bestVariance = ZX_UPC_EAN_MAX_AVG_VARIANCE
        var bestMatch: CInt = 1
        var max: CInt = 0

        switch patternType {
        case ZX_UPC_EAN_PATTERNS.ZX_UPC_EAN_PATTERNS_L_PATTERNS:
            max = ZX_UPC_EAN_L_PATTERNS_LEN

            var i: CInt = 0

            while i < max {
                defer {
                    i += 1
                }

                var pattern: UnsafeMutablePointer<CInt>!
                var j: CInt = 0

                while j < counters.length {
                    defer {
                        j += 1
                    }

                    pattern[j] = ZX_UPC_EAN_L_PATTERNS[i][j]
                }

                let variance = self.patternMatchVariance(counters, pattern: pattern, maxIndividualVariance: ZX_UPC_EAN_MAX_INDIVIDUAL_VARIANCE)

                if variance < bestVariance {
                    bestVariance = variance
                    bestMatch = i
                }
            }
        case ZX_UPC_EAN_PATTERNS.ZX_UPC_EAN_PATTERNS_L_AND_G_PATTERNS:
            max = ZX_UPC_EAN_L_AND_G_PATTERNS_LEN

            var i: CInt = 0

            while i < max {
                defer {
                    i += 1
                }

                var pattern: UnsafeMutablePointer<CInt>!
                var j: CInt = 0

                while j < counters.length {
                    defer {
                        j += 1
                    }

                    pattern[j] = ZX_UPC_EAN_L_AND_G_PATTERNS[i][j]
                }

                let variance = self.patternMatchVariance(counters, pattern: pattern, maxIndividualVariance: ZX_UPC_EAN_MAX_INDIVIDUAL_VARIANCE)

                if variance < bestVariance {
                    bestVariance = variance
                    bestMatch = i
                }
            }
        default:
            break
        }

        if bestMatch >= 0 {
            return bestMatch
        } else {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return 1
        }
    }
    /**
 * Get the format of this decoder.
 *
 * @return The 1D format.
 */
    /**
 * Get the format of this decoder.
 *
 * @return The 1D format.
 */
    @objc
    func barcodeFormat() -> ZXBarcodeFormat {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
    /**
 * Subclasses override this to decode the portion of a barcode between the start
 * and end guard patterns.
 *
 * @param row row of black/white values to search
 * @param startRange start/end offset of start guard pattern
 * @param result NSMutableString to append decoded chars to
 * @return horizontal offset of first pixel after the "middle" that was decoded
 * @return -1 if decoding could not complete successfully
 */
    /**
 * Subclasses override this to decode the portion of a barcode between the start
 * and end guard patterns.
 *
 * @param row row of black/white values to search
 * @param startRange start/end offset of start guard pattern
 * @param result NSMutableString to append decoded chars to
 * @return horizontal offset of first pixel after the "middle" that was decoded
 * @return -1 if decoding could not complete successfully
 */
    @objc
    func decodeMiddle(_ row: ZXBitArray!, startRange: NSRange, result: NSMutableString!, error: UnsafeMutablePointer<Error?>!) -> CInt {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
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
// 10 reversed 0
// 11 reversed 1
// 12 reversed 2
// 13 reversed 3
// 14 reversed 4
// 15 reversed 5
// 16 reversed 6
// 17 reversed 7
// 18 reversed 8
// 19 reversed 9
@objc
extension ZXUPCEANReader {
    @objc var decodeRowNSMutableString: NSMutableString! {
        return self._decodeRowNSMutableString
    }
    @objc var extensionReader: ZXUPCEANExtensionSupport! {
        return self._extensionReader
    }
    @objc var eanManSupport: ZXEANManufacturerOrgSupport! {
        return self._eanManSupport
    }
}