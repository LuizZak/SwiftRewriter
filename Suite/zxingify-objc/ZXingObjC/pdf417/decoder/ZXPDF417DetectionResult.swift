// Preprocessor directives found in file:
// #import "ZXPDF417BarcodeMetadata.h"
// #import "ZXPDF417BoundingBox.h"
// #import "ZXPDF417Codeword.h"
// #import "ZXPDF417Common.h"
// #import "ZXPDF417DetectionResult.h"
// #import "ZXPDF417DetectionResultColumn.h"
// #import "ZXPDF417DetectionResultRowIndicatorColumn.h"
let ZX_PDF417_ADJUST_ROW_NUMBER_SKIP: CInt = 2

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
class ZXPDF417DetectionResult: NSObject {
    private var _barcodeMetadata: ZXPDF417BarcodeMetadata!
    private var _detectionResultColumnsInternal: NSMutableArray!
    private var _boundingBox: ZXPDF417BoundingBox!
    @objc var boundingBox: ZXPDF417BoundingBox! {
        get {
            return self._boundingBox
        }
        set {
            self._boundingBox = newValue
        }
    }

    @objc
    init(barcodeMetadata: ZXPDF417BarcodeMetadata!, boundingBox: ZXPDF417BoundingBox!) {
        _barcodeMetadata = barcodeMetadata

        _barcodeColumnCount = barcodeMetadata.columnCount

        _boundingBox = boundingBox

        _detectionResultColumnsInternal = NSMutableArray.arrayWithCapacity(_barcodeColumnCount + 2)

        var i: CInt = 0

        while i < _barcodeColumnCount + 2 {
            defer {
                i += 1
            }

            _detectionResultColumnsInternal.add(NSNull.null())
        }

        super.init()
    }

    @objc
    func detectionResultColumns() -> NSArray? {
        self.adjustIndicatorColumnRowNumbers(self.detectionResultColumnsInternal[0])
        self.adjustIndicatorColumnRowNumbers(self.detectionResultColumnsInternal[Int(self.barcodeColumnCount + 1)])

        var unadjustedCodewordCount = ZX_PDF417_MAX_CODEWORDS_IN_BARCODE
        var previousUnadjustedCount: CInt

        repeat {
            previousUnadjustedCount = unadjustedCodewordCount
            unadjustedCodewordCount = self.adjustRowNumbers()
        } while unadjustedCodewordCount > 0 && unadjustedCodewordCount < previousUnadjustedCount

        return self.detectionResultColumnsInternal
    }
    @objc
    func adjustIndicatorColumnRowNumbers(_ detectionResultColumn: ZXPDF417DetectionResultColumn!) {
        if detectionResultColumn && detectionResultColumn as? AnyObject != NSNull.null() {
            (detectionResultColumn as? ZXPDF417DetectionResultRowIndicatorColumn)?.adjustCompleteIndicatorColumnRowNumbers(self.barcodeMetadata)
        }
    }
    // TODO ensure that no detected codewords with unknown row number are left
    // we should be able to estimate the row height and use it as a hint for the row number
    // we should also fill the rows top to bottom and bottom to top
    /**
 * @return number of codewords which don't have a valid row number. Note that the count is not accurate as codewords
 * will be counted several times. It just serves as an indicator to see when we can stop adjusting row numbers
 */
    @objc
    func adjustRowNumbers() -> CInt {
        let unadjustedCount = self.adjustRowNumbersByRow()

        if unadjustedCount == 0 {
            return 0
        }

        var barcodeColumn: CInt = 1

        while barcodeColumn < self.barcodeColumnCount + 1 {
            defer {
                barcodeColumn += 1
            }

            let codewords: NSArray! = self.detectionResultColumnsInternal[Int(barcodeColumn)].codewords()
            var codewordsRow: CInt = 0

            while codewordsRow < codewords.count {
                defer {
                    codewordsRow += 1
                }

                if codewords[Int(codewordsRow)] as? AnyObject == NSNull.null() {
                    continue
                }

                if !codewords[Int(codewordsRow)].hasValidRowNumber() {
                    self.adjustRowNumbers(barcodeColumn, codewordsRow: codewordsRow, codewords: codewords)
                }
            }
        }

        return unadjustedCount
    }
    @objc
    func adjustRowNumbersByRow() -> CInt {
        self.adjustRowNumbersFromBothRI()

        // TODO we should only do full row adjustments if row numbers of left and right row indicator column match.
        // Maybe it's even better to calculated the height (in codeword rows) and divide it by the number of barcode
        // rows. This, together with the LRI and RRI row numbers should allow us to get a good estimate where a row
        // number starts and ends.
        let unadjustedCount = self.adjustRowNumbersFromLRI()

        return unadjustedCount + self.adjustRowNumbersFromRRI()
    }
    @objc
    func adjustRowNumbersFromBothRI() {
        if self.detectionResultColumnsInternal[0] == NSNull.null() || self.detectionResultColumnsInternal[Int(self.barcodeColumnCount + 1)] == NSNull.null() {
            return
        }

        let LRIcodewords = (self.detectionResultColumnsInternal[0] as? ZXPDF417DetectionResultColumn)?.codewords
        let RRIcodewords: NSArray! = (self.detectionResultColumnsInternal[Int(self.barcodeColumnCount + 1)] as? ZXPDF417DetectionResultColumn)?.codewords
        var codewordsRow: CInt = 0

        while codewordsRow < (LRIcodewords?.count ?? 0) {
            defer {
                codewordsRow += 1
            }

            if LRIcodewords?[Int(codewordsRow)] != NSNull.null() && RRIcodewords?[Int(codewordsRow)] != NSNull.null() && (LRIcodewords?[Int(codewordsRow)] as? ZXPDF417Codeword)?.rowNumber == (RRIcodewords?[Int(codewordsRow)] as? ZXPDF417Codeword)?.rowNumber {
                var barcodeColumn: CInt = 1

                while barcodeColumn <= self.barcodeColumnCount {
                    defer {
                        barcodeColumn += 1
                    }

                    let codeword: ZXPDF417Codeword! = (self.detectionResultColumnsInternal[Int(barcodeColumn)] as? ZXPDF417DetectionResultColumn)?.codewords[Int(codewordsRow)]

                    if codeword as? AnyObject == NSNull.null() {
                        continue
                    }

                    codeword?.rowNumber = (LRIcodewords?[Int(codewordsRow)] as? ZXPDF417Codeword)?.rowNumber

                    if !codeword?.hasValidRowNumber() {
                        (self.detectionResultColumnsInternal[Int(barcodeColumn)] as? ZXPDF417DetectionResultColumn)?.codewords[Int(codewordsRow)] = NSNull.null()
                    }
                }
            }
        }
    }
    @objc
    func adjustRowNumbersFromRRI() -> CInt {
        if self.detectionResultColumnsInternal[Int(self.barcodeColumnCount + 1)] == NSNull.null() {
            return 0
        }

        var unadjustedCount: CInt = 0
        let codewords: NSArray! = self.detectionResultColumnsInternal[Int(self.barcodeColumnCount + 1)].codewords()
        var codewordsRow: CInt = 0

        while codewordsRow < codewords.count {
            defer {
                codewordsRow += 1
            }

            if codewords[Int(codewordsRow)] as? AnyObject == NSNull.null() {
                continue
            }

            let rowIndicatorRowNumber: CInt = codewords[Int(codewordsRow)].rowNumber()
            var invalidRowCounts: CInt = 0
            var barcodeColumn = self.barcodeColumnCount + 1

            while barcodeColumn > 0 && invalidRowCounts < ZX_PDF417_ADJUST_ROW_NUMBER_SKIP {
                defer {
                    barcodeColumn -= 1
                }

                if self.detectionResultColumnsInternal[Int(barcodeColumn)] != NSNull.null() {
                    let codeword: ZXPDF417Codeword! = self.detectionResultColumnsInternal[Int(barcodeColumn)].codewords()[codewordsRow]

                    if codeword as? AnyObject != NSNull.null() {
                        invalidRowCounts = self.adjustRowNumberIfValid(rowIndicatorRowNumber, invalidRowCounts: invalidRowCounts, codeword: codeword)

                        if !codeword.hasValidRowNumber() {
                            unadjustedCount += 1
                        }
                    }
                }
            }
        }

        return unadjustedCount
    }
    @objc
    func adjustRowNumbersFromLRI() -> CInt {
        if self.detectionResultColumnsInternal[0] == NSNull.null() {
            return 0
        }

        var unadjustedCount: CInt = 0
        let codewords: NSArray! = self.detectionResultColumnsInternal[0].codewords()
        var codewordsRow: CInt = 0

        while codewordsRow < codewords.count {
            defer {
                codewordsRow += 1
            }

            if codewords[Int(codewordsRow)] as? AnyObject == NSNull.null() {
                continue
            }

            let rowIndicatorRowNumber: CInt = codewords[Int(codewordsRow)].rowNumber()
            var invalidRowCounts: CInt = 0
            var barcodeColumn: CInt = 1

            while barcodeColumn < self.barcodeColumnCount + 1 && invalidRowCounts < ZX_PDF417_ADJUST_ROW_NUMBER_SKIP {
                defer {
                    barcodeColumn += 1
                }

                if self.detectionResultColumnsInternal[Int(barcodeColumn)] != NSNull.null() {
                    let codeword: ZXPDF417Codeword! = self.detectionResultColumnsInternal[Int(barcodeColumn)].codewords()[codewordsRow]

                    if codeword as? AnyObject != NSNull.null() {
                        invalidRowCounts = self.adjustRowNumberIfValid(rowIndicatorRowNumber, invalidRowCounts: invalidRowCounts, codeword: codeword)

                        if !codeword.hasValidRowNumber() {
                            unadjustedCount += 1
                        }
                    }
                }
            }
        }

        return unadjustedCount
    }
    @objc
    func adjustRowNumberIfValid(_ rowIndicatorRowNumber: CInt, invalidRowCounts: CInt, codeword: ZXPDF417Codeword!) -> CInt {
        if !codeword {
            return invalidRowCounts
        }

        if !codeword.hasValidRowNumber() {
            if codeword.isValidRowNumber(rowIndicatorRowNumber) {
                codeword.setRowNumber(rowIndicatorRowNumber)
                invalidRowCounts = 0
            } else {
                invalidRowCounts += 1
            }
        }

        return invalidRowCounts
    }
    @objc
    func adjustRowNumbers(_ barcodeColumn: CInt, codewordsRow: CInt, codewords: NSArray!) {
        let codeword: ZXPDF417Codeword! = codewords[Int(codewordsRow)]
        let previousColumnCodewords: NSArray! = self.detectionResultColumnsInternal[Int(barcodeColumn - 1)].codewords()
        var nextColumnCodewords = previousColumnCodewords

        if self.detectionResultColumnsInternal[Int(barcodeColumn + 1)] != NSNull.null() {
            nextColumnCodewords = self.detectionResultColumnsInternal[Int(barcodeColumn + 1)].codewords()
        }

        let otherCodewords: NSMutableArray! = NSMutableArray.arrayWithCapacity(14)
        var i: CInt = 0

        while i < 14 {
            defer {
                i += 1
            }

            otherCodewords.add(NSNull.null())
        }

        otherCodewords[2] = previousColumnCodewords[Int(codewordsRow)]
        otherCodewords[3] = nextColumnCodewords[Int(codewordsRow)]

        if codewordsRow > 0 {
            otherCodewords[0] = codewords[Int(codewordsRow - 1)]
            otherCodewords[4] = previousColumnCodewords[Int(codewordsRow - 1)]
            otherCodewords[5] = nextColumnCodewords[Int(codewordsRow - 1)]
        }

        if codewordsRow > 1 {
            otherCodewords[8] = codewords[Int(codewordsRow - 2)]
            otherCodewords[10] = previousColumnCodewords[Int(codewordsRow - 2)]
            otherCodewords[11] = nextColumnCodewords[Int(codewordsRow - 2)]
        }

        if codewordsRow < codewords.count - 1 {
            otherCodewords[1] = codewords[Int(codewordsRow + 1)]
            otherCodewords[6] = previousColumnCodewords[Int(codewordsRow + 1)]
            otherCodewords[7] = nextColumnCodewords[Int(codewordsRow + 1)]
        }

        if codewordsRow < codewords.count - 2 {
            otherCodewords[9] = codewords[Int(codewordsRow + 2)]
            otherCodewords[12] = previousColumnCodewords[Int(codewordsRow + 2)]
            otherCodewords[13] = nextColumnCodewords[Int(codewordsRow + 2)]
        }

        for otherCodeword in otherCodewords {
            if self.adjustRowNumber(codeword, otherCodeword: otherCodeword) {
                return
            }
        }
    }
    /**
 * @return true, if row number was adjusted, false otherwise
 */
    @objc
    func adjustRowNumber(_ codeword: ZXPDF417Codeword!, otherCodeword: ZXPDF417Codeword!) -> Bool {
        if otherCodeword as? AnyObject == NSNull.null() {
            return false
        }

        if otherCodeword.hasValidRowNumber() && otherCodeword.bucket == codeword.bucket {
            codeword.setRowNumber(otherCodeword.rowNumber)

            return true
        }

        return false
    }
    @objc
    func barcodeRowCount() -> CInt {
        return self.barcodeMetadata.rowCount ?? 0
    }
    @objc
    func barcodeECLevel() -> CInt {
        return self.barcodeMetadata.errorCorrectionLevel ?? 0
    }
    @objc
    func setDetectionResultColumn(_ barcodeColumn: CInt, detectionResultColumn: ZXPDF417DetectionResultColumn!) {
        if !detectionResultColumn {
            self.detectionResultColumnsInternal[Int(barcodeColumn)] = NSNull.null()
        } else {
            self.detectionResultColumnsInternal[Int(barcodeColumn)] = detectionResultColumn
        }
    }
    @objc
    func detectionResultColumn(_ barcodeColumn: CInt) -> ZXPDF417DetectionResultColumn? {
        let result: ZXPDF417DetectionResultColumn! = self.detectionResultColumnsInternal[Int(barcodeColumn)]

        return (result as? AnyObject == NSNull.null()) ? nil : result
    }
    @objc
    func description() -> String? {
        var rowIndicatorColumn: ZXPDF417DetectionResultColumn! = self.detectionResultColumnsInternal[0]

        if rowIndicatorColumn as? AnyObject == NSNull.null() {
            rowIndicatorColumn = self.detectionResultColumnsInternal[Int(self.barcodeColumnCount + 1)]
        }

        let result = NSMutableString()
        var codewordsRow: CInt = 0

        while codewordsRow < (rowIndicatorColumn?.codewords.count ?? 0) {
            defer {
                codewordsRow += 1
            }

            result.appendFormat("CW %3d:", codewordsRow)

            var barcodeColumn: CInt = 0

            while barcodeColumn < self.barcodeColumnCount + 2 {
                defer {
                    barcodeColumn += 1
                }

                if self.detectionResultColumnsInternal[Int(barcodeColumn)] == NSNull.null() {
                    result.append("    |   ")

                    continue
                }

                let codeword: ZXPDF417Codeword! = (self.detectionResultColumnsInternal[Int(barcodeColumn)] as? ZXPDF417DetectionResultColumn)?.codewords[Int(codewordsRow)]

                if codeword as? AnyObject == NSNull.null() {
                    result.append("    |   ")

                    continue
                }

                result.appendFormat(" %3d|%3d", codeword?.rowNumber ?? 0, codeword?.value ?? 0)
            }

            result.append("\\n")
        }

        return String.stringWithString(result)
    }
}

// MARK: -
@objc
extension ZXPDF417DetectionResult {
    @objc var barcodeMetadata: ZXPDF417BarcodeMetadata! {
        return self._barcodeMetadata
    }
    @objc var detectionResultColumnsInternal: NSMutableArray! {
        return self._detectionResultColumnsInternal
    }
    @objc var barcodeColumnCount: CInt {
    }
}