// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXDecoderResult.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXPDF417BarcodeMetadata.h"
// #import "ZXPDF417BarcodeValue.h"
// #import "ZXPDF417BoundingBox.h"
// #import "ZXPDF417Codeword.h"
// #import "ZXPDF417CodewordDecoder.h"
// #import "ZXPDF417Common.h"
// #import "ZXPDF417DecodedBitStreamParser.h"
// #import "ZXPDF417DetectionResult.h"
// #import "ZXPDF417DetectionResultRowIndicatorColumn.h"
// #import "ZXPDF417ECErrorCorrection.h"
// #import "ZXPDF417ScanningDecoder.h"
// #import "ZXResultPoint.h"
let ZX_PDF417_CODEWORD_SKEW_SIZE: CInt = 2
let ZX_PDF417_MAX_ERRORS: CInt = 3
let ZX_PDF417_MAX_EC_CODEWORDS: CInt = 512
var errorCorrection: ZXPDF417ECErrorCorrection!

/*
 * Copyright 2013 ZXing authors
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
/*
 * Copyright 2013 ZXing authors
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
class ZXPDF417ScanningDecoder: NSObject {
    @objc
    static func initialize() {
        if self.self != ZXPDF417ScanningDecoder.self {
            return
        }

        errorCorrection = ZXPDF417ECErrorCorrection()
    }
    // TODO don't pass in minCodewordWidth and maxCodewordWidth, pass in barcode columns for start and stop pattern
    // columns. That way width can be deducted from the pattern column.
    // This approach also allows to detect more details about the barcode, e.g. if a bar type (white or black) is wider
    // than it should be. This can happen if the scanner used a bad blackpoint.
    @objc
    static func decode(_ image: ZXBitMatrix!, imageTopLeft: ZXResultPoint!, imageBottomLeft: ZXResultPoint!, imageTopRight: ZXResultPoint!, imageBottomRight: ZXResultPoint!, minCodewordWidth: CInt, maxCodewordWidth: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        var boundingBox: ZXPDF417BoundingBox! = ZXPDF417BoundingBox(image: image, topLeft: imageTopLeft, bottomLeft: imageBottomLeft, topRight: imageTopRight, bottomRight: imageBottomRight)
        var leftRowIndicatorColumn: ZXPDF417DetectionResultRowIndicatorColumn!
        var rightRowIndicatorColumn: ZXPDF417DetectionResultRowIndicatorColumn!
        var detectionResult: ZXPDF417DetectionResult!
        var i: CInt = 0

        while i < 2 {
            defer {
                i += 1
            }

            if imageTopLeft {
                leftRowIndicatorColumn = self.rowIndicatorColumn(image, boundingBox: boundingBox, startPoint: imageTopLeft, leftToRight: true, minCodewordWidth: minCodewordWidth, maxCodewordWidth: maxCodewordWidth)
            }

            if imageTopRight {
                rightRowIndicatorColumn = self.rowIndicatorColumn(image, boundingBox: boundingBox, startPoint: imageTopRight, leftToRight: false, minCodewordWidth: minCodewordWidth, maxCodewordWidth: maxCodewordWidth)
            }

            detectionResult = self.merge(leftRowIndicatorColumn, rightRowIndicatorColumn: rightRowIndicatorColumn, error: error)

            if !detectionResult {
                return nil
            }

            if i == 0 && detectionResult.boundingBox && ((detectionResult.boundingBox.minY ?? 0) < boundingBox.minY || (detectionResult.boundingBox.maxY ?? 0) > boundingBox.maxY) {
                boundingBox = detectionResult.boundingBox
            } else {
                detectionResult.boundingBox = boundingBox

                break
            }
        }

        let maxBarcodeColumn = detectionResult.barcodeColumnCount + 1

        detectionResult.setDetectionResultColumn(0, detectionResultColumn: leftRowIndicatorColumn)
        detectionResult.setDetectionResultColumn(maxBarcodeColumn, detectionResultColumn: rightRowIndicatorColumn)

        let leftToRight = leftRowIndicatorColumn != nil
        var barcodeColumnCount: CInt = 1

        while barcodeColumnCount <= maxBarcodeColumn {
            defer {
                barcodeColumnCount += 1
            }

            let barcodeColumn = leftToRight ? barcodeColumnCount : maxBarcodeColumn - barcodeColumnCount

            if detectionResult.detectionResultColumn(barcodeColumn) {
                // This will be the case for the opposite row indicator column, which doesn't need to be decoded again.
                continue
            }

            var detectionResultColumn: ZXPDF417DetectionResultColumn!

            if barcodeColumn == 0 || barcodeColumn == maxBarcodeColumn {
                detectionResultColumn = ZXPDF417DetectionResultRowIndicatorColumn(boundingBox: boundingBox, isLeft: barcodeColumn == 0)
            } else {
                detectionResultColumn = ZXPDF417DetectionResultColumn(boundingBox: boundingBox)
            }

            detectionResult.setDetectionResultColumn(barcodeColumn, detectionResultColumn: detectionResultColumn)

            var startColumn: CInt = 1
            var previousStartColumn = startColumn
            var imageRow = boundingBox.minY

            while imageRow <= boundingBox.maxY {
                defer {
                    imageRow += 1
                }

                startColumn = self.startColumn(detectionResult, barcodeColumn: barcodeColumn, imageRow: imageRow, leftToRight: leftToRight)

                if startColumn < 0 || startColumn > boundingBox.maxX {
                    if previousStartColumn == 1 {
                        continue
                    }

                    startColumn = previousStartColumn
                }

                let codeword = self.detectCodeword(image, minColumn: boundingBox.minX, maxColumn: boundingBox.maxX, leftToRight: leftToRight, startColumn: startColumn, imageRow: imageRow, minCodewordWidth: minCodewordWidth, maxCodewordWidth: maxCodewordWidth)

                if codeword != nil {
                    detectionResultColumn.setCodeword(imageRow, codeword: codeword)

                    previousStartColumn = startColumn

                    minCodewordWidth = min(minCodewordWidth, codeword?.width)

                    maxCodewordWidth = max(maxCodewordWidth, codeword?.width)
                }
            }
        }

        return self.createDecoderResult(detectionResult, error: error)
    }
    @objc
    static func merge(_ leftRowIndicatorColumn: ZXPDF417DetectionResultRowIndicatorColumn!, rightRowIndicatorColumn: ZXPDF417DetectionResultRowIndicatorColumn!, error: UnsafeMutablePointer<Error?>!) -> ZXPDF417DetectionResult? {
        if !leftRowIndicatorColumn && !rightRowIndicatorColumn {
            return nil
        }

        let barcodeMetadata = self.barcodeMetadata(leftRowIndicatorColumn, rightRowIndicatorColumn: rightRowIndicatorColumn)

        if barcodeMetadata == nil {
            return nil
        }

        ZXPDF417BoundingBox * leftBoundingBox
        rightBoundingBox.pointee

        if !self.adjustBoundingBox(&leftBoundingBox, rowIndicatorColumn: leftRowIndicatorColumn, error: error) {
            return nil
        }

        if !self.adjustBoundingBox(&rightBoundingBox, rowIndicatorColumn: rightRowIndicatorColumn, error: error) {
            return nil
        }

        let boundingBox = ZXPDF417BoundingBox.mergeLeftBox(leftBoundingBox, rightBox: rightBoundingBox)

        if boundingBox == nil {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        return ZXPDF417DetectionResult(barcodeMetadata: barcodeMetadata, boundingBox: boundingBox)
    }
    @objc
    static func adjustBoundingBox(_ boundingBox: UnsafeMutablePointer<ZXPDF417BoundingBox?>!, rowIndicatorColumn: ZXPDF417DetectionResultRowIndicatorColumn!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        if !rowIndicatorColumn {
            boundingBox.pointee = nil

            return true
        }

        var rowHeights: ZXIntArray!

        if !rowIndicatorColumn.getRowHeights(&rowHeights) {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            boundingBox.pointee = nil

            return false
        }

        if !rowHeights {
            boundingBox.pointee = nil

            return true
        }

        let maxRowHeight = self.max(rowHeights)
        var missingStartRows: CInt = 0
        var i: CInt = 0

        while i < rowHeights.length {
            defer {
                i += 1
            }

            let rowHeight: CInt = rowHeights.array[i]

            missingStartRows += maxRowHeight - rowHeight

            if rowHeight > 0 {
                break
            }
        }

        let codewords = rowIndicatorColumn.codewords
        var row: CInt = 0

        while missingStartRows > 0 && codewords?[Int(row)] == NSNull.null() {
            defer {
                row += 1
            }

            missingStartRows -= 1
        }

        var missingEndRows: CInt = 0
        var row: CInt = CInt(rowHeights.length - 1)

        while row >= 0 {
            defer {
                row -= 1
            }

            missingEndRows += maxRowHeight - rowHeights.array[row]

            if rowHeights.array[row] > 0 {
                break
            }
        }

        var row: CInt = CInt(codewords?.count ?? 0) - 1

        while missingEndRows > 0 && codewords?[Int(row)] == NSNull.null() {
            defer {
                row -= 1
            }

            missingEndRows -= 1
        }

        boundingBox.pointee = rowIndicatorColumn.boundingBox.addMissingRows(missingStartRows, missingEndRows: missingEndRows, isLeft: rowIndicatorColumn.isLeft)

        return boundingBox.pointee != nil
    }
    @objc
    static func max(_ values: ZXIntArray!) -> CInt {
        var maxValue: CInt = 1
        var i: CInt = 0

        while i < values.length {
            defer {
                i += 1
            }

            let value: CInt = values.array[i]

            maxValue = max(maxValue, value)
        }

        return maxValue
    }
    @objc
    static func barcodeMetadata(_ leftRowIndicatorColumn: ZXPDF417DetectionResultRowIndicatorColumn!, rightRowIndicatorColumn: ZXPDF417DetectionResultRowIndicatorColumn!) -> ZXPDF417BarcodeMetadata? {
        var leftBarcodeMetadata: ZXPDF417BarcodeMetadata!

        if !leftRowIndicatorColumn || !(leftBarcodeMetadata = leftRowIndicatorColumn.barcodeMetadata) {
            return rightRowIndicatorColumn ? rightRowIndicatorColumn.barcodeMetadata : nil
        }

        var rightBarcodeMetadata: ZXPDF417BarcodeMetadata!

        if !rightRowIndicatorColumn || !(rightBarcodeMetadata = rightRowIndicatorColumn.barcodeMetadata) {
            return leftRowIndicatorColumn.barcodeMetadata
        }

        if leftBarcodeMetadata.columnCount != rightBarcodeMetadata.columnCount && leftBarcodeMetadata.errorCorrectionLevel != rightBarcodeMetadata.errorCorrectionLevel && leftBarcodeMetadata.rowCount != rightBarcodeMetadata.rowCount {
            return nil
        }

        return leftBarcodeMetadata
    }
    @objc
    static func rowIndicatorColumn(_ image: ZXBitMatrix!, boundingBox: ZXPDF417BoundingBox!, startPoint: ZXResultPoint!, leftToRight: Bool, minCodewordWidth: CInt, maxCodewordWidth: CInt) -> ZXPDF417DetectionResultRowIndicatorColumn {
        let rowIndicatorColumn = ZXPDF417DetectionResultRowIndicatorColumn(boundingBox: boundingBox, isLeft: leftToRight)
        var i: CInt = 0

        while i < 2 {
            defer {
                i += 1
            }

            let increment: CInt = (i == 0) ? 1 : 1
            var startColumn: CInt = CInt(startPoint.x)
            var imageRow: CInt = CInt(startPoint.y)

            while imageRow <= boundingBox.maxY && imageRow >= boundingBox.minY {
                defer {
                    imageRow += increment
                }

                let codeword = self.detectCodeword(image, minColumn: 0, maxColumn: image.width, leftToRight: leftToRight, startColumn: startColumn, imageRow: imageRow, minCodewordWidth: minCodewordWidth, maxCodewordWidth: maxCodewordWidth)

                if codeword != nil {
                    rowIndicatorColumn.setCodeword(imageRow, codeword: codeword)

                    if leftToRight {
                        startColumn = (codeword?.startX ?? 0)
                    } else {
                        startColumn = (codeword?.endX ?? 0)
                    }
                }
            }
        }

        return rowIndicatorColumn
    }
    @objc
    static func adjustCodewordCount(_ detectionResult: ZXPDF417DetectionResult!, barcodeMatrix: NSArray!) -> Bool {
        let numberOfCodewords: ZXIntArray! = (barcodeMatrix[0][1] as? ZXPDF417BarcodeValue).value()
        let calculatedNumberOfCodewords = detectionResult.barcodeColumnCount * detectionResult.barcodeRowCount()

        self.numberOfECCodeWords(detectionResult.barcodeECLevel)

        if numberOfCodewords.length == 0 {
            if calculatedNumberOfCodewords < 1 || calculatedNumberOfCodewords > ZX_PDF417_MAX_CODEWORDS_IN_BARCODE {
                return false
            }

            (barcodeMatrix[0][1] as? ZXPDF417BarcodeValue).setValue(calculatedNumberOfCodewords)
        } else if numberOfCodewords.array[0] != calculatedNumberOfCodewords {
            // The calculated one is more reliable as it is derived from the row indicator columns
            (barcodeMatrix[0][1] as? ZXPDF417BarcodeValue).setValue(calculatedNumberOfCodewords)
        }

        return true
    }
    @objc
    static func createDecoderResult(_ detectionResult: ZXPDF417DetectionResult!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        let barcodeMatrix = self.createBarcodeMatrix(detectionResult)

        if !barcodeMatrix {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            return nil
        }

        if !self.adjustCodewordCount(detectionResult, barcodeMatrix: barcodeMatrix) {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let erasures = NSMutableArray()
        let codewords = ZXIntArray(length: detectionResult.barcodeRowCount * detectionResult.barcodeColumnCount)
        let ambiguousIndexValuesList = NSMutableArray()
        let ambiguousIndexesList = NSMutableArray()
        var row: CInt = 0

        while row < detectionResult.barcodeRowCount {
            defer {
                row += 1
            }

            var column: CInt = 0

            while column < detectionResult.barcodeColumnCount {
                defer {
                    column += 1
                }

                let values: ZXIntArray! = (barcodeMatrix[Int(row)][column + 1] as? ZXPDF417BarcodeValue).value()
                let codewordIndex = row * detectionResult.barcodeColumnCount + column

                if values.length == 0 {
                    erasures.add(codewordIndex)
                } else if values.length == 1 {
                    codewords.array[codewordIndex] = values.array[0]
                } else {
                    ambiguousIndexesList.add(codewordIndex)
                    ambiguousIndexValuesList.add(values)
                }
            }
        }

        return self.createDecoderResultFromAmbiguousValues(detectionResult.barcodeECLevel, codewords: codewords, erasureArray: ZXPDF417Common.toIntArray(erasures), ambiguousIndexes: ZXPDF417Common.toIntArray(ambiguousIndexesList), ambiguousIndexValues: ambiguousIndexValuesList, error: error)
    }
    /**
 * This method deals with the fact, that the decoding process doesn't always yield a single most likely value. The
 * current error correction implementation doesn't deal with erasures very well, so it's better to provide a value
 * for these ambiguous codewords instead of treating it as an erasure. The problem is that we don't know which of
 * the ambiguous values to choose. We try decode using the first value, and if that fails, we use another of the
 * ambiguous values and try to decode again. This usually only happens on very hard to read and decode barcodes,
 * so decoding the normal barcodes is not affected by this.
 *
 * @param erasureArray contains the indexes of erasures
 * @param ambiguousIndexes array with the indexes that have more than one most likely value
 * @param ambiguousIndexValues two dimensional array that contains the ambiguous values. The first dimension must
 * be the same length as the ambiguousIndexes array
 */
    @objc
    static func createDecoderResultFromAmbiguousValues(_ ecLevel: CInt, codewords: ZXIntArray!, erasureArray: ZXIntArray!, ambiguousIndexes: ZXIntArray!, ambiguousIndexValues: NSArray!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        let ambiguousIndexCount = ZXIntArray(length: ambiguousIndexes.length)
        var tries: CInt = 100

        while tries -= 1 > 0 {
            var i: CInt = 0

            while i < ambiguousIndexCount.length {
                defer {
                    i += 1
                }

                let a: ZXIntArray! = ambiguousIndexValues[Int(i)]

                codewords.array[ambiguousIndexes.array[i]] = a.array[(ambiguousIndexCount.array[i] + 1) % (ambiguousIndexValues[Int(i)] as? ZXIntArray)?.length]
            }

            var e: Error!
            let result = self.decodeCodewords(codewords, ecLevel: ecLevel, erasures: erasureArray, error: &e)

            if result {
                return result
            } else if e.code != ZXChecksumError {
                if error != nil {
                    error.pointee = e
                }

                return nil
            }

            if ambiguousIndexCount.length == 0 {
                if error != nil {
                    error.pointee = ZXChecksumErrorInstance()
                }

                return nil
            }

            var i: CInt = 0

            while i < ambiguousIndexCount.length {
                defer {
                    i += 1
                }

                if ambiguousIndexCount.array[i] < ((ambiguousIndexValues[Int(i)] as? ZXIntArray)?.length ?? 0) - 1 {
                    ambiguousIndexCount.array[i] += 1

                    break
                } else {
                    ambiguousIndexCount.array[i] = 0

                    if i == ambiguousIndexes.length - 1 {
                        if error != nil {
                            error.pointee = ZXChecksumErrorInstance()
                        }

                        return nil
                    }
                }
            }
        }

        if error != nil {
            error.pointee = ZXChecksumErrorInstance()
        }

        return nil
    }
    @objc
    static func createBarcodeMatrix(_ detectionResult: ZXPDF417DetectionResult!) -> NSArray {
        let barcodeMatrix = NSMutableArray()
        var row: CInt = 0

        while row < detectionResult.barcodeRowCount {
            defer {
                row += 1
            }

            barcodeMatrix.add(NSMutableArray())

            var column: CInt = 0

            while column < detectionResult.barcodeColumnCount + 2 {
                defer {
                    column += 1
                }

                barcodeMatrix[Int(row)][column] = ZXPDF417BarcodeValue()
            }
        }

        var column: CInt = 0

        for detectionResultColumn in detectionResult.detectionResultColumns() {
            if detectionResultColumn as? AnyObject != NSNull.null() {
                for codeword in detectionResultColumn.codewords {
                    if codeword as? AnyObject != NSNull.null() {
                        let rowNumber: CInt = codeword.rowNumber

                        if rowNumber >= 0 {
                            if rowNumber >= barcodeMatrix.count {
                                // We have more rows than the barcode metadata allows for, ignore them.
                                continue
                            }

                            (barcodeMatrix[Int(rowNumber)][column] as? ZXPDF417BarcodeValue).setValue(codeword.value)
                        }
                    }
                }
            }

            column += 1
        }

        return barcodeMatrix
    }
    @objc
    static func isValidBarcodeColumn(_ detectionResult: ZXPDF417DetectionResult!, barcodeColumn: CInt) -> Bool {
        return barcodeColumn >= 0 && barcodeColumn <= detectionResult.barcodeColumnCount + 1
    }
    @objc
    static func startColumn(_ detectionResult: ZXPDF417DetectionResult!, barcodeColumn: CInt, imageRow: CInt, leftToRight: Bool) -> CInt {
        let offset: CInt = leftToRight ? 1 : 1
        var codeword: ZXPDF417Codeword!

        if self.isValidBarcodeColumn(detectionResult, barcodeColumn: barcodeColumn - offset) {
            codeword = detectionResult.detectionResultColumn(barcodeColumn - offset).codeword(imageRow)
        }

        if codeword {
            return leftToRight ? codeword.endX : codeword.startX
        }

        codeword = detectionResult.detectionResultColumn(barcodeColumn).codewordNearby(imageRow)

        if codeword {
            return leftToRight ? codeword.startX : codeword.endX
        }

        if self.isValidBarcodeColumn(detectionResult, barcodeColumn: barcodeColumn - offset) {
            codeword = detectionResult.detectionResultColumn(barcodeColumn - offset).codewordNearby(imageRow)
        }

        if codeword {
            return leftToRight ? codeword.endX : codeword.startX
        }

        var skippedColumns: CInt = 0

        while self.isValidBarcodeColumn(detectionResult, barcodeColumn: barcodeColumn - offset) {
            barcodeColumn -= offset

            for previousRowCodeword in detectionResult.detectionResultColumn(barcodeColumn).codewords {
                if previousRowCodeword as? AnyObject != NSNull.null() {
                    return (leftToRight ? previousRowCodeword.endX : previousRowCodeword.startX) + offset * skippedColumns * (previousRowCodeword.endX - previousRowCodeword.startX)
                }
            }

            skippedColumns += 1
        }

        return (leftToRight ? detectionResult.boundingBox.minX : detectionResult.boundingBox.maxX) ?? 0
    }
    @objc
    static func detectCodeword(_ image: ZXBitMatrix!, minColumn: CInt, maxColumn: CInt, leftToRight: Bool, startColumn: CInt, imageRow: CInt, minCodewordWidth: CInt, maxCodewordWidth: CInt) -> ZXPDF417Codeword? {
        startColumn = self.adjustCodewordStartColumn(image, minColumn: minColumn, maxColumn: maxColumn, leftToRight: leftToRight, codewordStartColumn: startColumn, imageRow: imageRow)

        // we usually know fairly exact now how long a codeword is. We should provide minimum and maximum expected length
        // and try to adjust the read pixels, e.g. remove single pixel errors or try to cut off exceeding pixels.
        // min and maxCodewordWidth should not be used as they are calculated for the whole barcode an can be inaccurate
        // for the current position
        let moduleBitCount = self.moduleBitCount(image, minColumn: minColumn, maxColumn: maxColumn, leftToRight: leftToRight, startColumn: startColumn, imageRow: imageRow)

        if moduleBitCount == nil {
            return nil
        }

        var endColumn: CInt
        let codewordBitCount = ZXPDF417Common.bitCountSum(moduleBitCount)

        if leftToRight {
            endColumn = startColumn + codewordBitCount
        } else {
            var i: CInt = 0

            while i < (moduleBitCount?.count ?? 0) / 2 {
                defer {
                    i += 1
                }

                let tmpCount: CInt = moduleBitCount?[Int(i)].intValue()

                moduleBitCount?[Int(i)] = moduleBitCount?[moduleBitCount?.count - 1 - i]
                moduleBitCount?[moduleBitCount?.count - 1 - i] = tmpCount
            }

            endColumn = startColumn
            startColumn = endColumn - codewordBitCount
        }

        // TODO implement check for width and correction of black and white bars
        // use start (and maybe stop pattern) to determine if blackbars are wider than white bars. If so, adjust.
        // should probably done only for codewords with a lot more than 17 bits.
        // The following fixes 10-1.png, which has wide black bars and small white bars
        //    for (int i = 0; i < moduleBitCount.length; i++) {
        //      if (i % 2 == 0) {
        //        moduleBitCount[i]--;
        //      } else {
        //        moduleBitCount[i]++;
        //      }
        //    }
        // We could also use the width of surrounding codewords for more accurate results, but this seems
        // sufficient for now
        if !self.checkCodewordSkew(codewordBitCount, minCodewordWidth: minCodewordWidth, maxCodewordWidth: maxCodewordWidth) {
            // We could try to use the startX and endX position of the codeword in the same column in the previous row,
            // create the bit count from it and normalize it to 8. This would help with single pixel errors.
            return nil
        }

        let decodedValue = ZXPDF417CodewordDecoder.decodedValue(moduleBitCount)
        let codeword = ZXPDF417Common.codeword(decodedValue)

        if codeword == 1 {
            return nil
        }

        return ZXPDF417Codeword(startX: startColumn, endX: endColumn, bucket: self.codewordBucketNumber(decodedValue), value: codeword)
    }
    @objc
    static func moduleBitCount(_ image: ZXBitMatrix!, minColumn: CInt, maxColumn: CInt, leftToRight: Bool, startColumn: CInt, imageRow: CInt) -> NSMutableArray? {
        var imageColumn = startColumn
        let moduleBitCount: NSMutableArray! = NSMutableArray.arrayWithCapacity(8)
        var i: CInt = 0

        while i < 8 {
            defer {
                i += 1
            }

            moduleBitCount.add(0)
        }

        var moduleNumber: CInt = 0
        let increment: CInt = leftToRight ? 1 : 1
        var previousPixelValue = leftToRight

        while ((leftToRight && imageColumn < maxColumn) || (!leftToRight && imageColumn >= minColumn)) && moduleNumber < moduleBitCount.count {
            if image.getX(imageColumn, y: imageRow) == previousPixelValue {
                moduleBitCount[Int(moduleNumber)] = moduleBitCount[Int(moduleNumber)].intValue() + 1
                imageColumn += increment
            } else {
                moduleNumber += 1
                previousPixelValue = !previousPixelValue
            }
        }

        if moduleNumber == moduleBitCount.count || (((leftToRight && imageColumn == maxColumn) || (!leftToRight && imageColumn == minColumn)) && moduleNumber == moduleBitCount.count - 1) {
            return moduleBitCount
        }

        return nil
    }
    @objc
    static func numberOfECCodeWords(_ barcodeECLevel: CInt) -> CInt {
        return 2 << barcodeECLevel
    }
    @objc
    static func adjustCodewordStartColumn(_ image: ZXBitMatrix!, minColumn: CInt, maxColumn: CInt, leftToRight: Bool, codewordStartColumn: CInt, imageRow: CInt) -> CInt {
        var correctedStartColumn = codewordStartColumn
        var increment: CInt = leftToRight ? 1 : 1
        var i: CInt = 0

        while i < 2 {
            defer {
                i += 1
            }

            while ((leftToRight && correctedStartColumn >= minColumn) || (!leftToRight && correctedStartColumn < maxColumn)) && leftToRight == image.getX(correctedStartColumn, y: imageRow) {
                if abs(codewordStartColumn - correctedStartColumn) > ZX_PDF417_CODEWORD_SKEW_SIZE {
                    return codewordStartColumn
                }

                correctedStartColumn += increment
            }

            increment = -increment
            leftToRight = !leftToRight
        }

        return correctedStartColumn
    }
    @objc
    static func checkCodewordSkew(_ codewordSize: CInt, minCodewordWidth: CInt, maxCodewordWidth: CInt) -> Bool {
        return minCodewordWidth - ZX_PDF417_CODEWORD_SKEW_SIZE <= codewordSize && codewordSize <= maxCodewordWidth + ZX_PDF417_CODEWORD_SKEW_SIZE
    }
    @objc
    static func decodeCodewords(_ codewords: ZXIntArray!, ecLevel: CInt, erasures: ZXIntArray!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult {
        if codewords.length == 0 {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            return nil
        }

        let numECCodewords = 1 << (ecLevel + 1)
        let correctedErrorsCount = self.correctErrors(codewords, erasures: erasures, numECCodewords: numECCodewords)

        if correctedErrorsCount == 1 {
            if error != nil {
                error.pointee = ZXChecksumErrorInstance()
            }

            return nil
        }

        if !self.verifyCodewordCount(codewords, numECCodewords: numECCodewords) {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            return nil
        }

        // Decode the codewords
        let decoderResult = ZXPDF417DecodedBitStreamParser.decode(codewords, ecLevel: ecLevel.stringValue(), error: error)

        if !decoderResult {
            return nil
        }

        decoderResult.errorsCorrected = correctedErrorsCount
        decoderResult.erasures = erasures.length

        return decoderResult
    }
    /**
 * Given data and error-correction codewords received, possibly corrupted by errors, attempts to
 * correct the errors in-place.
 *
 * @param codewords   data and error correction codewords
 * @param erasures positions of any known erasures
 * @param numECCodewords number of error correction codewords that are available in codewords
 * @throws ChecksumException if error correction fails
 */
    @objc
    static func correctErrors(_ codewords: ZXIntArray!, erasures: ZXIntArray!, numECCodewords: CInt) -> CInt {
        if erasures && (erasures.length > numECCodewords / 2 + ZX_PDF417_MAX_ERRORS || numECCodewords < 0 || numECCodewords > ZX_PDF417_MAX_EC_CODEWORDS) {
            // Too many errors or EC Codewords is corrupted
            return 1
        }

        return errorCorrection.decode(codewords, numECCodewords: numECCodewords, erasures: erasures)
    }
    /**
 * Verify that all is OK with the codeword array.
 */
    @objc
    static func verifyCodewordCount(_ codewords: ZXIntArray!, numECCodewords: CInt) -> Bool {
        if codewords.length < 4 {
            // Codeword array size should be at least 4 allowing for
            // Count CW, At least one Data CW, Error Correction CW, Error Correction CW
            return false
        }

        // The first codeword, the Symbol Length Descriptor, shall always encode the total number of data
        // codewords in the symbol, including the Symbol Length Descriptor itself, data codewords and pad
        // codewords, but excluding the number of error correction codewords.
        let numberOfCodewords: CInt = codewords.array[0]

        if numberOfCodewords > codewords.length {
            return false
        }

        if numberOfCodewords == 0 {
            // Reset to the length of the array - 8 (Allow for at least level 3 Error Correction (8 Error Codewords)
            if numECCodewords < codewords.length {
                codewords.array[0] = codewords.length - numECCodewords
            } else {
                return false
            }
        }

        return true
    }
    @objc
    static func bitCountForCodeword(_ codeword: CInt) -> NSArray {
        let result = NSMutableArray()
        var i: CInt = 0

        while i < 8 {
            defer {
                i += 1
            }

            result.add(0)
        }

        var previousValue: CInt = 0
        var i: CInt = CInt(result.count) - 1

        while true {
            if (codeword & 0x1) != previousValue {
                previousValue = codeword & 0x1
                i -= 1

                if i < 0 {
                    break
                }
            }

            result[Int(i)] = result[Int(i)].intValue() + 1
            codeword >>= 1
        }

        return result
    }
    @objc
    static func codewordBucketNumber(_ codeword: CInt) -> CInt {
        return self.codewordBucketNumberWithModuleBitCount(self.bitCountForCodeword(codeword))
    }
    @objc
    static func codewordBucketNumberWithModuleBitCount(_ moduleBitCount: NSArray!) -> CInt {
        return (moduleBitCount[0].intValue() - moduleBitCount[2].intValue() + moduleBitCount[4].intValue() - moduleBitCount[6].intValue() + 9) % 9
    }
    @objc
    func description(_ barcodeMatrix: NSArray!) -> String? {
        let result = NSMutableString()
        var row: CInt = 0

        while row < barcodeMatrix.count {
            defer {
                row += 1
            }

            result.appendFormat("Row %2d: ", row)

            var column: CInt = 0

            while column < ((barcodeMatrix[Int(row)] as? NSArray)?.count ?? 0) {
                defer {
                    column += 1
                }

                let barcodeValue: ZXPDF417BarcodeValue! = barcodeMatrix[Int(row)][column]

                if barcodeValue.value().length == 0 {
                    result.append("        ")
                } else {
                    result.appendFormat("%4d(%2d)", barcodeValue.value().array[0], barcodeValue.confidence(barcodeValue.value().array[0]).intValue())
                }
            }

            result.append("\\n")
        }

        return String.stringWithString(result)
    }
}