// Preprocessor directives found in file:
// #import "ZXPDF417DetectionResultColumn.h"
// #import "ZXIntArray.h"
// #import "ZXPDF417BarcodeMetadata.h"
// #import "ZXPDF417BarcodeValue.h"
// #import "ZXPDF417BoundingBox.h"
// #import "ZXPDF417Codeword.h"
// #import "ZXPDF417Common.h"
// #import "ZXPDF417DetectionResult.h"
// #import "ZXPDF417DetectionResultRowIndicatorColumn.h"
// #import "ZXResultPoint.h"
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
class ZXPDF417DetectionResultRowIndicatorColumn: ZXPDF417DetectionResultColumn {
    private var _isLeft: Bool = false
    @objc var isLeft: Bool {
        return self._isLeft
    }

    @objc
    init(boundingBox: ZXPDF417BoundingBox!, isLeft: Bool) {
        _isLeft = isLeft
        super.init(boundingBox: boundingBox)
    }

    @objc
    func setRowNumbers() {
        for codeword in self.codewords {
            if codeword as? AnyObject != NSNull.null() {
                codeword.setRowNumberAsRowIndicatorColumn()
            }
        }
    }
    // TODO implement properly
    // TODO maybe we should add missing codewords to store the correct row number to make
    // finding row numbers for other columns easier
    // use row height count to make detection of invalid row numbers more reliable
    @objc
    func adjustCompleteIndicatorColumnRowNumbers(_ barcodeMetadata: ZXPDF417BarcodeMetadata!) -> CInt {
        self.setRowNumbers()
        self.removeIncorrectCodewords(barcodeMetadata)

        let top = self.isLeft ? self.boundingBox.topLeft : self.boundingBox.topRight
        let bottom = self.isLeft ? self.boundingBox.bottomLeft : self.boundingBox.bottomRight
        let firstRow = self.imageRowToCodewordIndex(CInt(top?.y ?? 0.0))
        let lastRow = self.imageRowToCodewordIndex(CInt(bottom?.y ?? 0.0))
        // We need to be careful using the average row height. Barcode could be skewed so that we have smaller and
        // taller rows
        let averageRowHeight: CFloat = (lastRow - firstRow) / CFloat(barcodeMetadata.rowCount)
        var barcodeRow: CInt = 1
        var maxRowHeight: CInt = 1
        var currentRowHeight: CInt = 0
        var codewordsRow = firstRow

        while codewordsRow < lastRow {
            defer {
                codewordsRow += 1
            }

            if self.codewords[Int(codewordsRow)] == NSNull.null() {
                continue
            }

            let codeword: ZXPDF417Codeword! = self.codewords[Int(codewordsRow)]
            //      float expectedRowNumber = (codewordsRow - firstRow) / averageRowHeight;
            //      if (Math.abs(codeword.getRowNumber() - expectedRowNumber) > 2) {
            //        SimpleLog.log(LEVEL.WARNING,
            //            "Removing codeword, rowNumberSkew too high, codeword[" + codewordsRow + "]: Expected Row: " +
            //                expectedRowNumber + ", RealRow: " + codeword.getRowNumber() + ", value: " + codeword.getValue());
            //        codewords[codewordsRow] = null;
            //      }
            let rowDifference = (codeword?.rowNumber ?? 0) - barcodeRow

            // TODO improve handling with case where first row indicator doesn't start with 0
            if rowDifference == 0 {
                currentRowHeight += 1
            } else if rowDifference == 1 {
                maxRowHeight = max(maxRowHeight, currentRowHeight)
                currentRowHeight = 1
                barcodeRow = (codeword?.rowNumber ?? 0)
            } else if rowDifference < 0 || (codeword?.rowNumber ?? 0) >= barcodeMetadata.rowCount || rowDifference > codewordsRow {
                self.codewords[Int(codewordsRow)] = NSNull.null()
            } else {
                var checkedRows: CInt

                if maxRowHeight > 2 {
                    checkedRows = (maxRowHeight - 2) * rowDifference
                } else {
                    checkedRows = rowDifference
                }

                var closePreviousCodewordFound = checkedRows >= codewordsRow
                var i: CInt = 1

                while i <= checkedRows && !closePreviousCodewordFound {
                    defer {
                        i += 1
                    }

                    // there must be (height * rowDifference) number of codewords missing. For now we assume height = 1.
                    // This should hopefully get rid of most problems already.
                    closePreviousCodewordFound = self.codewords[Int(codewordsRow - i)] != NSNull.null()
                }

                if closePreviousCodewordFound {
                    self.codewords[Int(codewordsRow)] = NSNull.null()
                } else {
                    barcodeRow = (codeword?.rowNumber ?? 0)
                    currentRowHeight = 1
                }
            }
        }

        return CInt(averageRowHeight + 0.5)
    }
    @objc
    func getRowHeights(_ rowHeights: UnsafeMutablePointer<ZXIntArray?>!) -> Bool {
        let barcodeMetadata = self.barcodeMetadata()

        if !barcodeMetadata {
            *rowHeights = nil

            return true
        }

        self.adjustIncompleteIndicatorColumnRowNumbers(barcodeMetadata)

        let result = ZXIntArray(length: CUnsignedInt(barcodeMetadata.rowCount))

        for codeword in self.codewords {
            if codeword as? AnyObject != NSNull.null() {
                let rowNumber: CInt = codeword.rowNumber

                if rowNumber >= result.length {
                    *rowHeights = nil

                    // We have more rows than the barcode metadata allows for, ignore them.
                    continue
                }

                result.array[rowNumber] += 1
            } // else throw exception?
        }

        *rowHeights = result

        return true
    }
    // TODO maybe we should add missing codewords to store the correct row number to make
    // finding row numbers for other columns easier
    // use row height count to make detection of invalid row numbers more reliable
    @objc
    func adjustIncompleteIndicatorColumnRowNumbers(_ barcodeMetadata: ZXPDF417BarcodeMetadata!) -> CInt {
        let top = self.isLeft ? self.boundingBox.topLeft : self.boundingBox.topRight
        let bottom = self.isLeft ? self.boundingBox.bottomLeft : self.boundingBox.bottomRight
        let firstRow = self.imageRowToCodewordIndex(CInt(top?.y ?? 0.0))
        let lastRow = self.imageRowToCodewordIndex(CInt(bottom?.y ?? 0.0))
        let averageRowHeight: CFloat = (lastRow - firstRow) / CFloat(barcodeMetadata.rowCount)
        var barcodeRow: CInt = 1
        var maxRowHeight: CInt = 1
        var currentRowHeight: CInt = 0
        var codewordsRow = firstRow

        while codewordsRow < lastRow {
            defer {
                codewordsRow += 1
            }

            if self.codewords[Int(codewordsRow)] == NSNull.null() {
                continue
            }

            let codeword: ZXPDF417Codeword! = self.codewords[Int(codewordsRow)]

            codeword?.setRowNumberAsRowIndicatorColumn()

            let rowDifference = (codeword?.rowNumber ?? 0) - barcodeRow

            // TODO improve handling with case where first row indicator doesn't start with 0
            if rowDifference == 0 {
                currentRowHeight += 1
            } else if rowDifference == 1 {
                maxRowHeight = max(maxRowHeight, currentRowHeight)
                currentRowHeight = 1
                barcodeRow = (codeword?.rowNumber ?? 0)
            } else if (codeword?.rowNumber ?? 0) >= barcodeMetadata.rowCount {
                self.codewords[Int(codewordsRow)] = NSNull.null()
            } else {
                barcodeRow = (codeword?.rowNumber ?? 0)
                currentRowHeight = 1
            }
        }

        return CInt(averageRowHeight + 0.5)
    }
    @objc
    func barcodeMetadata() -> ZXPDF417BarcodeMetadata {
        let barcodeColumnCount = ZXPDF417BarcodeValue()
        let barcodeRowCountUpperPart = ZXPDF417BarcodeValue()
        let barcodeRowCountLowerPart = ZXPDF417BarcodeValue()
        let barcodeECLevel = ZXPDF417BarcodeValue()

        for codeword in self.codewords {
            if codeword as? AnyObject == NSNull.null() {
                continue
            }

            codeword.setRowNumberAsRowIndicatorColumn()

            let rowIndicatorValue: CInt = codeword.value % 30
            var codewordRowNumber: CInt = codeword.rowNumber

            if !self.isLeft {
                codewordRowNumber += 2
            }

            switch codewordRowNumber % 3 {
            case 0:
                barcodeRowCountUpperPart.setValue(rowIndicatorValue * 3 + 1)
            case 1:
                barcodeECLevel.setValue(rowIndicatorValue / 3)
                barcodeRowCountLowerPart.setValue(rowIndicatorValue % 3)
            case 2:
                barcodeColumnCount.setValue(rowIndicatorValue + 1)
            default:
                break
            }
        }

        // Maybe we should check if we have ambiguous values?
        if (barcodeColumnCount.value().length == 0) || (barcodeRowCountUpperPart.value().length == 0) || (barcodeRowCountLowerPart.value().length == 0) || (barcodeECLevel.value().length == 0) || barcodeColumnCount.value().array[0] < 1 || barcodeRowCountUpperPart.value().array[0] + barcodeRowCountLowerPart.value().array[0] < ZX_PDF417_MIN_ROWS_IN_BARCODE || barcodeRowCountUpperPart.value().array[0] + barcodeRowCountLowerPart.value().array[0] > ZX_PDF417_MAX_ROWS_IN_BARCODE {
            return nil
        }

        let barcodeMetadata = ZXPDF417BarcodeMetadata(columnCount: barcodeColumnCount.value().array[0], rowCountUpperPart: barcodeRowCountUpperPart.value().array[0], rowCountLowerPart: barcodeRowCountLowerPart.value().array[0], errorCorrectionLevel: barcodeECLevel.value().array[0])

        self.removeIncorrectCodewords(barcodeMetadata)

        return barcodeMetadata
    }
    @objc
    func removeIncorrectCodewords(_ barcodeMetadata: ZXPDF417BarcodeMetadata!) {
        var codewordRow: CInt = 0

        while codewordRow < (self.codewords.count ?? 0) {
            defer {
                codewordRow += 1
            }

            let codeword: ZXPDF417Codeword! = self.codewords[Int(codewordRow)]

            if self.codewords[Int(codewordRow)] == NSNull.null() {
                continue
            }

            let rowIndicatorValue = (codeword?.value ?? 0) % 30
            var codewordRowNumber = codeword?.rowNumber ?? 0

            if codewordRowNumber > barcodeMetadata.rowCount {
                self.codewords[Int(codewordRow)] = NSNull.null()

                continue
            }

            if !self.isLeft {
                codewordRowNumber += 2
            }

            switch codewordRowNumber % 3 {
            case 0:
                if rowIndicatorValue * 3 + 1 != barcodeMetadata.rowCountUpperPart {
                    self.codewords[Int(codewordRow)] = NSNull.null()
                }
            case 1:
                if rowIndicatorValue / 3 != barcodeMetadata.errorCorrectionLevel || rowIndicatorValue % 3 != barcodeMetadata.rowCountLowerPart {
                    self.codewords[Int(codewordRow)] = NSNull.null()
                }
            case 2:
                if rowIndicatorValue + 1 != barcodeMetadata.columnCount {
                    self.codewords[Int(codewordRow)] = NSNull.null()
                }
            default:
                break
            }
        }
    }
    @objc
    override func description() -> String? {
        return String(format: "IsLeft: %@\\n%@", self.isLeft, super.description())
    }
}