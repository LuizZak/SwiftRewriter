// Preprocessor directives found in file:
// #import "ZXWriter.h"
// #import "ZXBitMatrix.h"
// #import "ZXByteMatrix.h"
// #import "ZXDataMatrixDefaultPlacement.h"
// #import "ZXDataMatrixErrorCorrection.h"
// #import "ZXDataMatrixHighLevelEncoder.h"
// #import "ZXDataMatrixSymbolInfo.h"
// #import "ZXDataMatrixWriter.h"
// #import "ZXDimension.h"
// #import "ZXEncodeHints.h"
// #pragma GCC diagnostic push
// #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
// #pragma GCC diagnostic pop
// #pragma GCC diagnostic push
// #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
// #pragma GCC diagnostic pop
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
/**
 * This object renders a Data Matrix code as a BitMatrix 2D array of greyscale values.
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
/**
 * This object renders a Data Matrix code as a BitMatrix 2D array of greyscale values.
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
class ZXDataMatrixWriter: NSObject, ZXWriter {
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        return self.encode(contents, format: format, width: width, height: height, hints: nil, error: error)
    }
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if contents.length == 0 {
            NSException.raise(NSInvalidArgumentException, format: "Found empty contents")
        }

        if format != ZXBarcodeFormat.kBarcodeFormatDataMatrix {
            NSException.raise(NSInvalidArgumentException, format: "Can only encode kBarcodeFormatDataMatrix")
        }

        if width < 0 || height < 0 {
            NSException.raise(NSInvalidArgumentException, format: "Requested dimensions cannot be negative: %dx%d", width, height)
        }

        // Try to get force shape & min / max size
        var shape = ZXDataMatrixSymbolShapeHint.ZXDataMatrixSymbolShapeHintForceNone
        var minSize: ZXDimension! = nil
        var maxSize: ZXDimension! = nil

        if hints != nil {
            shape = hints.dataMatrixShape

            let requestedMinSize = hints.minSize

            if requestedMinSize != nil {
                minSize = requestedMinSize
            }

            let requestedMaxSize = hints.maxSize

            if requestedMaxSize != nil {
                maxSize = requestedMaxSize
            }
        }

        //1. step: Data encodation
        let encoded = ZXDataMatrixHighLevelEncoder.encodeHighLevel(contents, shape: shape, minSize: minSize, maxSize: maxSize)
        let symbolInfo = ZXDataMatrixSymbolInfo.lookup(CInt(encoded?.length), shape: shape, minSize: minSize, maxSize: maxSize, fail: true)
        //2. step: ECC generation
        let codewords = ZXDataMatrixErrorCorrection.encodeECC200(encoded, symbolInfo: symbolInfo)
        //3. step: Module placement in Matrix
        let placement = ZXDataMatrixDefaultPlacement(codewords: codewords, numcols: symbolInfo?.symbolDataWidth, numrows: symbolInfo?.symbolDataHeight)

        placement.place()

        //4. step: low-level encoding
        return self.encodeLowLevel(placement, symbolInfo: symbolInfo, width: width, height: height)
    }
    /**
 * Encode the given symbol info to a bit matrix.
 *
 * @param placement  The DataMatrix placement.
 * @param symbolInfo The symbol info to encode.
 * @return The bit matrix generated.
 */
    @objc
    func encodeLowLevel(_ placement: ZXDataMatrixDefaultPlacement!, symbolInfo: ZXDataMatrixSymbolInfo!, width: CInt, height: CInt) -> ZXBitMatrix? {
        let symbolWidth: CInt = symbolInfo.symbolDataWidth
        let symbolHeight: CInt = symbolInfo.symbolDataHeight
        let matrix = ZXByteMatrix(width: symbolInfo.symbolWidth, height: symbolInfo.symbolHeight)
        var matrixY: CInt = 0
        var y: CInt = 0

        while y < symbolHeight {
            defer {
                y += 1
            }

            // Fill the top edge with alternate 0 / 1
            var matrixX: CInt

            if (y % symbolInfo.matrixHeight) == 0 {
                matrixX = 0

                var x: CInt = 0

                while x < symbolInfo.symbolWidth {
                    defer {
                        x += 1
                    }

                    matrix.setX(matrixX, y: matrixY, boolValue: (x % 2) == 0)
                    matrixX += 1
                }

                matrixY += 1
            }

            matrixX = 0

            var x: CInt = 0

            while x < symbolWidth {
                defer {
                    x += 1
                }

                // Fill the right edge with full 1
                if (x % symbolInfo.matrixWidth) == 0 {
                    matrix.setX(matrixX, y: matrixY, boolValue: true)
                    matrixX += 1
                }

                matrix.setX(matrixX, y: matrixY, boolValue: placement.bitAtCol(x, row: y))
                matrixX += 1

                // Fill the right edge with alternate 0 / 1
                if (x % symbolInfo.matrixWidth) == symbolInfo.matrixWidth - 1 {
                    matrix.setX(matrixX, y: matrixY, boolValue: (y % 2) == 0)
                    matrixX += 1
                }
            }

            matrixY += 1

            // Fill the bottom edge with full 1
            if (y % symbolInfo.matrixHeight) == symbolInfo.matrixHeight - 1 {
                matrixX = 0

                var x: CInt = 0

                while x < symbolInfo.symbolWidth {
                    defer {
                        x += 1
                    }

                    matrix.setX(matrixX, y: matrixY, boolValue: true)
                    matrixX += 1
                }

                matrixY += 1
            }
        }

        return self.convertByteMatrixToBitMatrix(matrix, width: width, height: height)
    }
    /**
 * Convert the ZXByteMatrix to ZXBitMatrix.
 *
 * @param matrix The input matrix.
 * @param width The requested width of the image (in pixels) with the Datamatrix code
 * @param height The requested height of the image (in pixels) with the Datamatrix code
 * @return The output matrix.
 */
    @objc
    func convertByteMatrixToBitMatrix(_ matrix: ZXByteMatrix!, width: CInt, height: CInt) -> ZXBitMatrix? {
        let matrixWidth = matrix.width
        let matrixHeight = matrix.height
        let outputWidth = max(width, matrixWidth)
        let outputHeight = max(height, matrixHeight)
        let multiple = min(outputWidth / matrixWidth, outputHeight / matrixHeight)
        var leftPadding = (outputWidth - (matrixWidth * multiple)) / 2
        var topPadding = (outputHeight - (matrixHeight * multiple)) / 2
        var output: ZXBitMatrix!

        // remove padding if requested width and height are too small
        if height < matrixHeight || width < matrixWidth {
            leftPadding = 0
            topPadding = 0
            output = ZXBitMatrix(width: matrixWidth, height: matrixHeight)
        } else {
            output = ZXBitMatrix(width: width, height: height)
        }

        var inputY: CInt = 0, outputY = topPadding

        while inputY < matrixHeight {
            defer {
                inputY += 1
                outputY += multiple
            }

            var inputX: CInt = 0, outputX = leftPadding

            while inputX < matrixWidth {
                defer {
                    inputX += 1
                    outputX += multiple
                }

                if matrix.getX(inputX, y: inputY) == 1 {
                    output.setRegionAtLeft(outputX, top: outputY, width: multiple, height: multiple)
                }
            }
        }

        return output
    }
}