// Preprocessor directives found in file:
// #import "ZXWriter.h"
// #import "ZXBitMatrix.h"
// #import "ZXByteArray.h"
// #import "ZXEncodeHints.h"
// #import "ZXPDF417.h"
// #import "ZXPDF417BarcodeMatrix.h"
// #import "ZXPDF417Dimensions.h"
// #import "ZXPDF417Writer.h"
let ZX_PDF417_WHITE_SPACE: CInt = 30
let ZX_PDF417_DEFAULT_ERROR_CORRECTION_LEVEL: CInt = 2

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
class ZXPDF417Writer: NSObject, ZXWriter {
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        if format != ZXBarcodeFormat.kBarcodeFormatPDF417 {
            NSException.raise(NSInvalidArgumentException, format: "Can only encode PDF_417, but got %d", format)
        }

        let encoder = ZXPDF417()
        var margin = ZX_PDF417_WHITE_SPACE
        var errorCorrectionLevel = ZX_PDF417_DEFAULT_ERROR_CORRECTION_LEVEL

        if hints != nil {
            encoder.compact = hints.pdf417Compact
            encoder.compaction = hints.pdf417Compaction

            if hints.pdf417Dimensions != nil {
                let dimensions = hints.pdf417Dimensions

                encoder.setDimensionsWithMaxCols(dimensions?.maxCols ?? 0, minCols: dimensions?.minCols ?? 0, maxRows: dimensions?.maxRows ?? 0, minRows: dimensions?.minRows ?? 0)
            }

            if hints.margin {
                margin = hints.margin.intValue()
            }

            if hints.errorCorrectionLevelPDF417 {
                errorCorrectionLevel = hints.errorCorrectionLevelPDF417.intValue
            }

            if hints.encoding > 0 {
                encoder.encoding = hints.encoding
            }
        }

        return self.bitMatrixFromEncoder(encoder, contents: contents, errorCorrectionLevel: errorCorrectionLevel, width: width, height: height, margin: margin, error: error)
    }
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        return self.encode(contents, format: format, width: width, height: height, hints: nil, error: error)
    }
    /**
 * Takes encoder, accounts for width/height, and retrieves bit matrix
 */
    @objc
    func bitMatrixFromEncoder(_ encoder: ZXPDF417!, contents: String!, errorCorrectionLevel: CInt, width: CInt, height: CInt, margin: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        if !encoder.generateBarcodeLogic(contents, errorCorrectionLevel: errorCorrectionLevel, error: error) {
            return nil
        }

        let aspectRatio: CInt = 4
        var originalScale = encoder.barcodeMatrix.scaledMatrixWithXScale(1, yScale: aspectRatio)
        var rotated = false

        if (height > width) ^ (((originalScale?[0] as? ZXByteArray)?.length ?? 0) < (originalScale?.count ?? 0)) {
            originalScale = self.rotateArray(originalScale)
            rotated = true
        }

        let scaleX: CInt = width / CInt(CInt((originalScale?[0] as? ZXByteArray)?.length ?? 0))
        let scaleY: CInt = height / CInt(CInt(originalScale?.count ?? 0))
        var scale: CInt

        if scaleX < scaleY {
            scale = scaleX
        } else {
            scale = scaleY
        }

        if scale > 1 {
            var scaledMatrix = encoder.barcodeMatrix.scaledMatrixWithXScale(scale, yScale: scale * aspectRatio)

            if rotated {
                scaledMatrix = self.rotateArray(scaledMatrix)
            }

            return self.bitMatrixFromBitArray(scaledMatrix, margin: margin)
        }

        return self.bitMatrixFromBitArray(originalScale, margin: margin)
    }
    /**
 * This takes an array holding the values of the PDF 417
 *
 * @param input a byte array of information with 0 is black, and 1 is white
 * @param margin border around the barcode
 * @return BitMatrix of the input
 */
    @objc
    func bitMatrixFromBitArray(_ input: NSArray!, margin: CInt) -> ZXBitMatrix {
        // Creates the bitmatrix with extra space for whtespace
        let output = ZXBitMatrix(width: CInt(CInt((input[0] as? ZXByteArray)?.length ?? 0)) + 2 * margin, height: CInt(input.count) + 2 * margin)

        output.clear()

        var y: CInt = 0, yOutput = output.height - margin - 1

        while y < input.count {
            defer {
                y += 1
                yOutput -= 1
            }

            var x: CInt = 0

            while x < ((input[0] as? ZXByteArray)?.length ?? 0) {
                defer {
                    x += 1
                }

                // Zero is white in the byte matrix
                if (input[Int(y)] as? ZXByteArray)?.array[x] == 1 {
                    output.setX(x + margin, y: yOutput)
                }
            }
        }

        return output
    }
    /**
 * Takes and rotates the it 90 degrees
 */
    @objc
    func rotateArray(_ bitarray: NSArray!) -> NSArray {
        let temp = NSMutableArray()
        var i: CInt = 0

        while i < ((bitarray[0] as? ZXByteArray)?.length ?? 0) {
            defer {
                i += 1
            }

            temp.add(ZXByteArray(length: CUnsignedInt(bitarray.count)))
        }

        var ii: CInt = 0

        while ii < bitarray.count {
            defer {
                ii += 1
            }

            // This makes the direction consistent on screen when rotating the
            // screen;
            let inverseii: CInt = CInt(bitarray.count) - ii - 1
            var jj: CInt = 0

            while jj < ((bitarray[0] as? ZXByteArray)?.length ?? 0) {
                defer {
                    jj += 1
                }

                let b: ZXByteArray! = temp[Int(jj)]

                b.array[inverseii] = (bitarray[Int(ii)] as? ZXByteArray)?.array[jj]
            }
        }

        return temp
    }
}