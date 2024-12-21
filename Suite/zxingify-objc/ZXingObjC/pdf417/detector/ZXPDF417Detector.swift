// Preprocessor directives found in file:
// #import "ZXBitArray.h"
// #import "ZXBitMatrix.h"
// #import "ZXBinaryBitmap.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXGridSampler.h"
// #import "ZXMathUtils.h"
// #import "ZXPDF417Detector.h"
// #import "ZXPDF417DetectorResult.h"
// #import "ZXPerspectiveTransform.h"
// #import "ZXResultPoint.h"
var ZX_PDF417_INDEXES_START_PATTERN: UnsafePointer<CInt>!
var ZX_PDF417_INDEXES_STOP_PATTERN: UnsafePointer<CInt>!
let ZX_PDF417_MAX_AVG_VARIANCE: CFloat = 0.42
let ZX_PDF417_MAX_INDIVIDUAL_VARIANCE: CFloat = 0.8
var ZX_PDF417_DETECTOR_START_PATTERN: UnsafePointer<CInt>!
var ZX_PDF417_DETECTOR_STOP_PATTERN: UnsafePointer<CInt>!
let ZX_PDF417_MAX_PIXEL_DRIFT: CInt = 3
let ZX_PDF417_MAX_PATTERN_DRIFT: CInt = 5
let ZX_PDF417_SKIPPED_ROW_COUNT_MAX: CInt = 25
let ZX_PDF417_ROW_STEP: CInt = 5
let ZX_PDF417_BARCODE_MIN_HEIGHT: CInt = 10

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
 * Encapsulates logic that can detect a PDF417 Code in an image, even if the
 * PDF417 Code is rotated or skewed, or partially obscured.
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
 * Encapsulates logic that can detect a PDF417 Code in an image, even if the
 * PDF417 Code is rotated or skewed, or partially obscured.
 */
@objc
class ZXPDF417Detector: NSObject {
    /**
 * Detects a PDF417 Code in an image. Only checks 0 and 180 degree rotations.
 *
 * @param image barcode image to decode
 * @param hints optional hints to detector
 * @param multiple if true, then the image is searched for multiple codes. If false, then at most one code will
 * be found and returned
 * @return ZXPDF417DetectorResult encapsulating results of detecting a PDF417 code or nil
 *  if no PDF417 Code can be found
 */
    /**
 * Detects a PDF417 Code in an image. Only checks 0 and 180 degree rotations.
 *
 * @param image barcode image to decode
 * @param hints optional hints to detector
 * @param multiple if true, then the image is searched for multiple codes. If false, then at most one code will
 * be found and returned
 * @return ZXPDF417DetectorResult encapsulating results of detecting a PDF417 code or nil
 *  if no PDF417 Code can be found
 */
    @objc
    static func detect(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, multiple: Bool, error: UnsafeMutablePointer<Error?>!) -> ZXPDF417DetectorResult? {
        // TODO detection improvement, tryHarder could try several different luminance thresholds/blackpoints or even
        // different binarizers
        //boolean tryHarder = hints != null && hints.containsKey(DecodeHintType.TRY_HARDER);
        var bitMatrix = image.blackMatrixWithError(error)
        var barcodeCoordinates = self.detect(multiple, bitMatrix: bitMatrix, error: error)

        if !barcodeCoordinates {
            return nil
        }

        if barcodeCoordinates.count == 0 {
            bitMatrix = bitMatrix?.copy()
            bitMatrix?.rotate180()
            barcodeCoordinates = self.detect(multiple, bitMatrix: bitMatrix, error: error)

            if !barcodeCoordinates {
                return nil
            }
        }

        return ZXPDF417DetectorResult(bits: bitMatrix, points: barcodeCoordinates)
    }
    /**
 * Detects PDF417 codes in an image. Only checks 0 degree rotation
 * @param multiple if true, then the image is searched for multiple codes. If false, then at most one code will
 * be found and returned
 * @param bitMatrix bit matrix to detect barcodes in
 * @return List of ResultPoint arrays containing the coordinates of found barcodes
 */
    @objc
    static func detect(_ multiple: Bool, bitMatrix: ZXBitMatrix!, error: UnsafeMutablePointer<Error?>!) -> NSArray {
        let barcodeCoordinates = NSMutableArray()
        var row: CInt = 0
        var column: CInt = 0
        var foundBarcodeInRow = false

        while row < bitMatrix.height {
            let vertices = self.findVertices(bitMatrix, startRow: row, startColumn: column)

            if vertices[0] == NSNull.null() && vertices[3] == NSNull.null() {
                if !foundBarcodeInRow {
                    // we didn't find any barcode so that's the end of searching
                    break
                }

                // we didn't find a barcode starting at the given column and row. Try again from the first column and slightly
                // below the lowest barcode we found so far.
                foundBarcodeInRow = false
                column = 0

                for barcodeCoordinate in barcodeCoordinates {
                    if barcodeCoordinate[1] != NSNull.null() {
                        row = max(row, CInt((barcodeCoordinate[1] as? ZXResultPoint).y()))
                    }

                    if barcodeCoordinate[3] != NSNull.null() {
                        row = max(row, CInt((barcodeCoordinate[3] as? ZXResultPoint).y()))
                    }
                }

                row += ZX_PDF417_ROW_STEP

                continue
            }

            foundBarcodeInRow = true
            barcodeCoordinates.add(vertices)

            if !multiple {
                break
            }

            // if we didn't find a right row indicator column, then continue the search for the next barcode after the
            // start pattern of the barcode just found.
            if vertices[2] != NSNull.null() {
                column = CInt((vertices[2] as? ZXResultPoint)?.x ?? 0.0)
                row = CInt((vertices[2] as? ZXResultPoint)?.y ?? 0.0)
            } else {
                column = CInt((vertices[4] as? ZXResultPoint)?.x ?? 0.0)
                row = CInt((vertices[4] as? ZXResultPoint)?.y ?? 0.0)
            }
        }

        return barcodeCoordinates
    }
    /**
 * Locate the vertices and the codewords area of a black blob using the Start
 * and Stop patterns as locators.
 *
 * @param matrix the scanned barcode image.
 * @return an array containing the vertices:
 *           vertices[0] x, y top left barcode
 *           vertices[1] x, y bottom left barcode
 *           vertices[2] x, y top right barcode
 *           vertices[3] x, y bottom right barcode
 *           vertices[4] x, y top left codeword area
 *           vertices[5] x, y bottom left codeword area
 *           vertices[6] x, y top right codeword area
 *           vertices[7] x, y bottom right codeword area
 */
    @objc
    static func findVertices(_ matrix: ZXBitMatrix!, startRow: CInt, startColumn: CInt) -> NSMutableArray {
        let height = matrix.height
        let width = matrix.width
        let result: NSMutableArray! = NSMutableArray.arrayWithCapacity(8)
        var i: CInt = 0

        while i < 8 {
            defer {
                i += 1
            }

            result.add(NSNull.null())
        }

        self.copyToResult(result, tmpResult: self.findRowsWithPattern(matrix, height: height, width: width, startRow: startRow, startColumn: startColumn, pattern: ZX_PDF417_DETECTOR_START_PATTERN, patternLen: CInt(MemoryLayout.size(ofValue: ZX_PDF417_DETECTOR_START_PATTERN) / MemoryLayout<CInt>.size)), destinationIndexes: ZX_PDF417_INDEXES_START_PATTERN, length: CInt(MemoryLayout.size(ofValue: ZX_PDF417_INDEXES_START_PATTERN) / MemoryLayout<CInt>.size))

        if result[4] != NSNull.null() {
            startColumn = CInt((result[4] as? ZXResultPoint)?.x ?? 0.0)
            startRow = CInt((result[4] as? ZXResultPoint)?.y ?? 0.0)
        }

        self.copyToResult(result, tmpResult: self.findRowsWithPattern(matrix, height: height, width: width, startRow: startRow, startColumn: startColumn, pattern: ZX_PDF417_DETECTOR_STOP_PATTERN, patternLen: CInt(MemoryLayout.size(ofValue: ZX_PDF417_DETECTOR_STOP_PATTERN) / MemoryLayout<CInt>.size)), destinationIndexes: ZX_PDF417_INDEXES_STOP_PATTERN, length: CInt(MemoryLayout.size(ofValue: ZX_PDF417_INDEXES_STOP_PATTERN) / MemoryLayout<CInt>.size))

        return result
    }
    @objc
    static func copyToResult(_ result: NSMutableArray!, tmpResult: NSMutableArray!, destinationIndexes: UnsafePointer<CInt>!, length: CInt) {
        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            result[destinationIndexes[i]] = tmpResult[Int(i)]
        }
    }
    @objc
    static func findRowsWithPattern(_ matrix: ZXBitMatrix!, height: CInt, width: CInt, startRow: CInt, startColumn: CInt, pattern: UnsafePointer<CInt>!, patternLen: CInt) -> NSMutableArray {
        let result = NSMutableArray()
        var i: CInt = 0

        while i < 4 {
            defer {
                i += 1
            }

            result.add(NSNull.null())
        }

        var found = false
        let counters: UnsafeMutablePointer<CInt>!

        memset(counters, 0, Int(patternLen) * MemoryLayout<CInt>.size)

        while startRow < height {
            defer {
                startRow += ZX_PDF417_ROW_STEP
            }

            var loc = self.findGuardPattern(matrix, column: startColumn, row: startRow, width: width, whiteFirst: false, pattern: pattern, patternLen: patternLen, counters: counters)

            if loc.location != NSNotFound {
                while startRow > 0 {
                    var previousRowLoc = self.findGuardPattern(matrix, column: startColumn, row: startRow -= 1, width: width, whiteFirst: false, pattern: pattern, patternLen: patternLen, counters: counters)

                    if previousRowLoc.location != NSNotFound {
                        loc = previousRowLoc
                    } else {
                        startRow += 1

                        break
                    }
                }

                result[0] = ZXResultPoint(x: loc.location, y: CFloat(startRow))
                result[1] = ZXResultPoint(x: NSMaxRange(loc), y: CFloat(startRow))
                found = true

                break
            }
        }

        var stopRow = startRow + 1

        // Last row of the current symbol that contains pattern
        if found {
            var skippedRowCount: CInt = 0
            var previousRowLoc: NSRange = NSMakeRange(UInt((result[0] as? ZXResultPoint)?.x ?? 0.0), (UInt((result[1] as? ZXResultPoint)?.x ?? 0.0)) - (UInt((result[0] as? ZXResultPoint)?.x ?? 0.0)))

            while stopRow < height {
                defer {
                    stopRow += 1
                }

                var loc = self.findGuardPattern(matrix, column: CInt(previousRowLoc.location), row: stopRow, width: width, whiteFirst: false, pattern: pattern, patternLen: patternLen, counters: counters)

                // a found pattern is only considered to belong to the same barcode if the start and end positions
                // don't differ too much. Pattern drift should be not bigger than two for consecutive rows. With
                // a higher number of skipped rows drift could be larger. To keep it simple for now, we allow a slightly
                // larger drift and don't check for skipped rows.
                if loc.location != NSNotFound && ABS(CInt(previousRowLoc.location) - CInt(loc.location)) < ZX_PDF417_MAX_PATTERN_DRIFT && ABS(CInt(NSMaxRange(previousRowLoc)) - CInt(NSMaxRange(loc))) < ZX_PDF417_MAX_PATTERN_DRIFT {
                    previousRowLoc = loc
                    skippedRowCount = 0
                } else if skippedRowCount > ZX_PDF417_SKIPPED_ROW_COUNT_MAX {
                    break
                } else {
                    skippedRowCount += 1
                }
            }

            stopRow -= skippedRowCount + 1
            result[2] = ZXResultPoint(x: previousRowLoc.location, y: CFloat(stopRow))
            result[3] = ZXResultPoint(x: NSMaxRange(previousRowLoc), y: CFloat(stopRow))
        }

        if stopRow - startRow < ZX_PDF417_BARCODE_MIN_HEIGHT {
            var i: CInt = 0

            while i < 4 {
                defer {
                    i += 1
                }

                result[Int(i)] = NSNull.null()
            }
        }

        return result
    }
    /**
 * @param matrix row of black/white values to search
 * @param column x position to start search
 * @param row y position to start search
 * @param width the number of pixels to search on this row
 * @param pattern pattern of counts of number of black and white pixels that are
 *                 being searched for as a pattern
 * @param counters array of counters, as long as pattern, to re-use
 * @return start/end horizontal offset of guard pattern, as an array of two ints.
 */
    @objc
    static func findGuardPattern(_ matrix: ZXBitMatrix!, column: CInt, row: CInt, width: CInt, whiteFirst: Bool, pattern: UnsafePointer<CInt>!, patternLen: CInt, counters: UnsafeMutablePointer<CInt>!) -> NSRange {
        let patternLength = patternLen

        memset(counters, 0, Int(patternLength) * MemoryLayout<CInt>.size)

        var isWhite = whiteFirst
        var patternStart = column
        var pixelDrift: CInt = 0

        // if there are black pixels left of the current pixel shift to the left, but only for ZX_PDF417_MAX_PIXEL_DRIFT pixels
        while matrix.getX(patternStart, y: row) && patternStart > 0 && pixelDrift += 1 < ZX_PDF417_MAX_PIXEL_DRIFT {
            patternStart -= 1
        }

        var x = patternStart
        var counterPosition: CInt = 0

        while x < width {
            defer {
                x += 1
            }

            let pixel = matrix.getX(x, y: row)

            if pixel ^ isWhite {
                counters[counterPosition] = counters[counterPosition] + 1
            } else {
                if counterPosition == patternLength - 1 {
                    if self.patternMatchVariance(counters, countersSize: patternLength, pattern: pattern, maxIndividualVariance: ZX_PDF417_MAX_INDIVIDUAL_VARIANCE) < ZX_PDF417_MAX_AVG_VARIANCE {
                        return NSMakeRange(patternStart, x - patternStart)
                    }

                    patternStart += counters[0] + counters[1]

                    var y: CInt = 2

                    while y < patternLength {
                        defer {
                            y += 1
                        }

                        counters[y - 2] = counters[y]
                    }

                    counters[patternLength - 2] = 0
                    counters[patternLength - 1] = 0
                    counterPosition -= 1
                } else {
                    counterPosition += 1
                }

                counters[counterPosition] = 1
                isWhite = !isWhite
            }
        }

        if counterPosition == patternLength - 1 {
            if self.patternMatchVariance(counters, countersSize: patternLen, pattern: pattern, maxIndividualVariance: ZX_PDF417_MAX_INDIVIDUAL_VARIANCE) < ZX_PDF417_MAX_AVG_VARIANCE {
                return NSMakeRange(patternStart, x - patternStart - 1)
            }
        }

        return NSMakeRange(NSNotFound, 0)
    }
    /**
 * Determines how closely a set of observed counts of runs of black/white
 * values matches a given target pattern. This is reported as the ratio of
 * the total variance from the expected pattern proportions across all
 * pattern elements, to the length of the pattern.
 *
 * @param counters observed counters
 * @param pattern expected pattern
 * @param maxIndividualVariance The most any counter can differ before we give up
 * @return ratio of total variance between counters and pattern compared to total pattern size
 */
    @objc
    static func patternMatchVariance(_ counters: UnsafeMutablePointer<CInt>!, countersSize: CInt, pattern: UnsafePointer<CInt>!, maxIndividualVariance: CFloat) -> CFloat {
        let numCounters = countersSize
        var total: CInt = 0
        var patternLength: CInt = 0
        var i: CInt = 0

        while i < numCounters {
            defer {
                i += 1
            }

            total += counters[i]
            patternLength += pattern[i]
        }

        if total < patternLength || patternLength == 0 {
            return FLT_MAX
        }

        let unitBarWidth: CFloat = CFloat(total) / patternLength

        maxIndividualVariance *= unitBarWidth

        var totalVariance: CFloat = 0.0
        var x: CInt = 0

        while x < numCounters {
            defer {
                x += 1
            }

            let counter: CInt = counters[x]
            let scaledPattern: CFloat = pattern[x] * unitBarWidth
            let variance: CFloat = (counter > scaledPattern) ? CFloat(counter) - scaledPattern : scaledPattern - CFloat(counter)

            if variance > maxIndividualVariance {
                return FLT_MAX
            }

            totalVariance += variance
        }

        return totalVariance / CFloat(total)
    }
}