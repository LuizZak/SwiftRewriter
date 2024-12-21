// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXByteArray.h"
// #import "ZXDataMatrixBitMatrixParser.h"
// #import "ZXDataMatrixVersion.h"
// #import "ZXErrors.h"
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
class ZXDataMatrixBitMatrixParser: NSObject {
    private var _mappingBitMatrix: ZXBitMatrix!
    private var _readMappingMatrix: ZXBitMatrix!
    private var _version: ZXDataMatrixVersion!
    @objc var version: ZXDataMatrixVersion! {
        return self._version
    }

    @objc
    init?(bitMatrix: ZXBitMatrix!, error: UnsafeMutablePointer<Error?>!) {
        if self = super.init() {
            let dimension = bitMatrix.height

            if dimension < 8 || dimension > 144 || (dimension & 0x1) != 0 {
                if error {
                    *error = ZXFormatErrorInstance()
                }

                return nil
            }

            _version = self.readVersion(bitMatrix)

            if !_version {
                if error {
                    *error = ZXFormatErrorInstance()
                }

                return nil
            }

            _mappingBitMatrix = self.extractDataRegion(bitMatrix)
            _readMappingMatrix = ZXBitMatrix(width: _mappingBitMatrix.width, height: _mappingBitMatrix.height)
        }

        return self
    }

    /**
 * Creates the version object based on the dimension of the original bit matrix from
 * the datamatrix code.
 *
 * See ISO 16022:2006 Table 7 - ECC 200 symbol attributes<
 *
 * @param bitMatrix Original ZXBitMatrix including alignment patterns
 * @return ZXDatamatrixVersion encapsulating the Data Matrix Code's "version"
 *  or nil if the dimensions of the mapping matrix are not valid
 *  Data Matrix dimensions.
 */
    @objc
    func readVersion(_ bitMatrix: ZXBitMatrix!) -> ZXDataMatrixVersion? {
        let numRows = bitMatrix.height
        let numColumns = bitMatrix.width

        return ZXDataMatrixVersion.versionForDimensions(numRows, numColumns: numColumns)
    }
    /**
 * Reads the bits in the ZXBitMatrix representing the mapping matrix (No alignment patterns)
 * in the correct order in order to reconstitute the codewords bytes contained within the
 * Data Matrix Code.
 *
 * @return bytes encoded within the Data Matrix Code or nil if the exact number of bytes expected is not read
 */
    @objc
    func readCodewords() -> ZXByteArray {
        let result = ZXByteArray(length: CUnsignedInt(CUnsignedInt(self.version.totalCodewords ?? 0)))
        var resultOffset: CInt = 0
        var row: CInt = 4
        var column: CInt = 0
        let numRows = self.mappingBitMatrix.height ?? 0
        let numColumns = self.mappingBitMatrix.width ?? 0
        var corner1Read = false
        var corner2Read = false
        var corner3Read = false
        var corner4Read = false

        repeat {
            if (row == numRows) && (column == 0) && !corner1Read {
                result.array[resultOffset += 1] = self.readCorner1(numRows, numColumns: numColumns) as? int8_t

                row -= 2

                column += 2

                corner1Read = true
            } else if (row == numRows - 2) && (column == 0) && ((numColumns & 0x3) != 0) && !corner2Read {
                result.array[resultOffset += 1] = self.readCorner2(numRows, numColumns: numColumns) as? int8_t

                row -= 2

                column += 2

                corner2Read = true
            } else if (row == numRows + 4) && (column == 2) && ((numColumns & 0x7) == 0) && !corner3Read {
                result.array[resultOffset += 1] = self.readCorner3(numRows, numColumns: numColumns) as? int8_t

                row -= 2

                column += 2

                corner3Read = true
            } else if (row == numRows - 2) && (column == 0) && ((numColumns & 0x7) == 4) && !corner4Read {
                result.array[resultOffset += 1] = self.readCorner4(numRows, numColumns: numColumns) as? int8_t

                row -= 2

                column += 2

                corner4Read = true
            } else {
                repeat {
                    if (row < numRows) && (column >= 0) && (self.readMappingMatrix.getX(column, y: row) != true) {
                        result.array[resultOffset += 1] = self.readUtah(row, column: column, numRows: numRows, numColumns: numColumns) as? int8_t
                    }

                    row -= 2
                    column += 2
                } while (row >= 0) && (column < numColumns)

                row += 1
                column += 3

                repeat {
                    if (row >= 0) && (column < numColumns) && (self.readMappingMatrix.getX(column, y: row) != true) {
                        result.array[resultOffset += 1] = self.readUtah(row, column: column, numRows: numRows, numColumns: numColumns) as? int8_t
                    }

                    row += 2
                    column -= 2
                } while (row < numRows) && (column >= 0)

                row += 3
                column += 1
            }
        } while (row < numRows) || (column < numColumns)

        if resultOffset != self.version.totalCodewords {
            return nil
        }

        return result
    }
    /**
 * Reads a bit of the mapping matrix accounting for boundary wrapping.
 *
 * @param row Row to read in the mapping matrix
 * @param column Column to read in the mapping matrix
 * @param numRows Number of rows in the mapping matrix
 * @param numColumns Number of columns in the mapping matrix
 * @return value of the given bit in the mapping matrix
 */
    @objc
    func readModule(_ row: CInt, column: CInt, numRows: CInt, numColumns: CInt) -> Bool {
        if row < 0 {
            row += numRows
            column += 4 - ((numRows + 4) & 0x7)
        }

        if column < 0 {
            column += numColumns
            row += 4 - ((numColumns + 4) & 0x7)
        }

        self.readMappingMatrix.setX(column, y: row)

        return self.mappingBitMatrix.getX(column, y: row) == true
    }
    /**
 * Reads the 8 bits of the standard Utah-shaped pattern.
 *
 * See ISO 16022:2006, 5.8.1 Figure 6
 *
 * @param row Current row in the mapping matrix, anchored at the 8th bit (LSB) of the pattern
 * @param column Current column in the mapping matrix, anchored at the 8th bit (LSB) of the pattern
 * @param numRows Number of rows in the mapping matrix
 * @param numColumns Number of columns in the mapping matrix
 * @return byte from the utah shape
 */
    @objc
    func readUtah(_ row: CInt, column: CInt, numRows: CInt, numColumns: CInt) -> CInt {
        var currentByte: CInt = 0

        if self.readModule(row - 2, column: column - 2, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(row - 2, column: column - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(row - 1, column: column - 2, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(row - 1, column: column - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(row - 1, column: column, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(row, column: column - 2, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(row, column: column - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(row, column: column, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        return currentByte
    }
    /**
 * Reads the 8 bits of the special corner condition 1.
 *
 * See ISO 16022:2006, Figure F.3
 *
 * @param numRows Number of rows in the mapping matrix
 * @param numColumns Number of columns in the mapping matrix
 * @return byte from the Corner condition 1
 */
    @objc
    func readCorner1(_ numRows: CInt, numColumns: CInt) -> CInt {
        var currentByte: CInt = 0

        if self.readModule(numRows - 1, column: 0, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(numRows - 1, column: 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(numRows - 1, column: 2, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 2, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(1, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(2, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(3, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        return currentByte
    }
    /**
 * Reads the 8 bits of the special corner condition 2.
 *
 * See ISO 16022:2006, Figure F.4
 *
 * @param numRows Number of rows in the mapping matrix
 * @param numColumns Number of columns in the mapping matrix
 * @return byte from the Corner condition 2
 */
    @objc
    func readCorner2(_ numRows: CInt, numColumns: CInt) -> CInt {
        var currentByte: CInt = 0

        if self.readModule(numRows - 3, column: 0, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(numRows - 2, column: 0, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(numRows - 1, column: 0, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 4, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 3, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 2, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(1, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        return currentByte
    }
    /**
 * Reads the 8 bits of the special corner condition 3.
 *
 * See ISO 16022:2006, Figure F.5
 *
 * @param numRows Number of rows in the mapping matrix
 * @param numColumns Number of columns in the mapping matrix
 * @return byte from the Corner condition 3
 */
    @objc
    func readCorner3(_ numRows: CInt, numColumns: CInt) -> CInt {
        var currentByte: CInt = 0

        if self.readModule(numRows - 1, column: 0, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(numRows - 1, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 3, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 2, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(1, column: numColumns - 3, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(1, column: numColumns - 2, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(1, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        return currentByte
    }
    /**
 * Reads the 8 bits of the special corner condition 4.
 *
 * See ISO 16022:2006, Figure F.6
 *
 * @param numRows Number of rows in the mapping matrix
 * @param numColumns Number of columns in the mapping matrix
 * @return byte from the Corner condition 4
 */
    @objc
    func readCorner4(_ numRows: CInt, numColumns: CInt) -> CInt {
        var currentByte: CInt = 0

        if self.readModule(numRows - 3, column: 0, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(numRows - 2, column: 0, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(numRows - 1, column: 0, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 2, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(0, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(1, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(2, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        currentByte <<= 1

        if self.readModule(3, column: numColumns - 1, numRows: numRows, numColumns: numColumns) {
            currentByte |= 1
        }

        return currentByte
    }
    /**
 * Extracts the data region from a ZXBitMatrix that contains
 * alignment patterns.
 *
 * @param bitMatrix Original ZXBitMatrix with alignment patterns
 * @return BitMatrix that has the alignment patterns removed
 */
    @objc
    func extractDataRegion(_ bitMatrix: ZXBitMatrix!) -> ZXBitMatrix {
        let symbolSizeRows = self.version.symbolSizeRows ?? 0
        let symbolSizeColumns = self.version.symbolSizeColumns ?? 0

        if bitMatrix.height != symbolSizeRows {
            NSException.raise(NSInvalidArgumentException, format: "Dimension of bitMatrix must match the version size")
        }

        let dataRegionSizeRows = self.version.dataRegionSizeRows ?? 0
        let dataRegionSizeColumns = self.version.dataRegionSizeColumns ?? 0
        let numDataRegionsRow = symbolSizeRows / dataRegionSizeRows
        let numDataRegionsColumn = symbolSizeColumns / dataRegionSizeColumns
        let sizeDataRegionRow = numDataRegionsRow * dataRegionSizeRows
        let sizeDataRegionColumn = numDataRegionsColumn * dataRegionSizeColumns
        let bitMatrixWithoutAlignment = ZXBitMatrix(width: sizeDataRegionColumn, height: sizeDataRegionRow)
        var dataRegionRow: CInt = 0

        while dataRegionRow < numDataRegionsRow {
            defer {
                dataRegionRow += 1
            }

            let dataRegionRowOffset = dataRegionRow * dataRegionSizeRows
            var dataRegionColumn: CInt = 0

            while dataRegionColumn < numDataRegionsColumn {
                defer {
                    dataRegionColumn += 1
                }

                let dataRegionColumnOffset = dataRegionColumn * dataRegionSizeColumns
                var i: CInt = 0

                while i < dataRegionSizeRows {
                    defer {
                        i += 1
                    }

                    let readRowOffset = dataRegionRow * (dataRegionSizeRows + 2) + 1 + i
                    let writeRowOffset = dataRegionRowOffset + i
                    var j: CInt = 0

                    while j < dataRegionSizeColumns {
                        defer {
                            j += 1
                        }

                        let readColumnOffset = dataRegionColumn * (dataRegionSizeColumns + 2) + 1 + j

                        if bitMatrix.getX(readColumnOffset, y: readRowOffset) {
                            let writeColumnOffset = dataRegionColumnOffset + j

                            bitMatrixWithoutAlignment.setX(writeColumnOffset, y: writeRowOffset)
                        }
                    }
                }
            }
        }

        return bitMatrixWithoutAlignment
    }
}

// MARK: -
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
extension ZXDataMatrixBitMatrixParser {
    @objc var mappingBitMatrix: ZXBitMatrix! {
        return self._mappingBitMatrix
    }
    @objc var readMappingMatrix: ZXBitMatrix! {
        return self._readMappingMatrix
    }
}