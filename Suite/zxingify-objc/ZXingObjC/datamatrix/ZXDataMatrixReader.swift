// Preprocessor directives found in file:
// #import "ZXReader.h"
// #import "ZXBinaryBitmap.h"
// #import "ZXBitMatrix.h"
// #import "ZXDataMatrixDecoder.h"
// #import "ZXDataMatrixDetector.h"
// #import "ZXDataMatrixReader.h"
// #import "ZXDecodeHints.h"
// #import "ZXDecoderResult.h"
// #import "ZXDetectorResult.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXResult.h"
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
 * This implementation can detect and decode Data Matrix codes in an image.
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
 * This implementation can detect and decode Data Matrix codes in an image.
 */
@objc
class ZXDataMatrixReader: NSObject, ZXReader {
    private var _decoder: ZXDataMatrixDecoder!

    @objc
    override init() {
        if self = super.init() {
            _decoder = ZXDataMatrixDecoder()
        }

        return self
    }

    /**
 * Locates and decodes a Data Matrix code in an image.
 *
 * @return a String representing the content encoded by the Data Matrix code
 */
    @objc
    func decode(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        return self.decode(image, hints: nil, error: error)
    }
    @objc
    func decode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        var decoderResult: ZXDecoderResult!
        var points: NSArray!

        if hints != nil && hints.pureBarcode {
            let matrix = image.blackMatrixWithError(error)

            if matrix == nil {
                return nil
            }

            let bits = self.extractPureBits(matrix)

            if !bits {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
                }

                return nil
            }

            decoderResult = self.decoder.decodeMatrix(bits, error: error)

            if !decoderResult {
                return nil
            }

            points = []
        } else {
            let matrix = image.blackMatrixWithError(error)

            if matrix == nil {
                return nil
            }

            let detector = ZXDataMatrixDetector(image: matrix, error: error)

            if !detector {
                return nil
            }

            let detectorResult = detector.detectWithError(error)

            if detectorResult == nil {
                return nil
            }

            decoderResult = self.decoder.decodeMatrix(detectorResult?.bits, error: error)

            if !decoderResult {
                return nil
            }

            points = detectorResult?.points
        }

        let result = ZXResult.resultWithText(decoderResult.text, rawBytes: decoderResult.rawBytes, resultPoints: points, format: ZXBarcodeFormat.kBarcodeFormatDataMatrix)

        if decoderResult.byteSegments != nil {
            result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeByteSegments, value: decoderResult.byteSegments)
        }

        if decoderResult.ecLevel != nil {
            result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeErrorCorrectionLevel, value: decoderResult.ecLevel)
        }

        return result
    }
    @objc
    func reset() {
        // do nothing
    }
    /**
 * This method detects a code in a "pure" image -- that is, pure monochrome image
 * which contains only an unrotated, unskewed, image of a code, with some white border
 * around it. This is a specialized method that works exceptionally fast in this special
 * case.
 */
    @objc
    func extractPureBits(_ image: ZXBitMatrix!) -> ZXBitMatrix {
        let leftTopBlack: ZXIntArray = image.topLeftOnBit
        let rightBottomBlack: ZXIntArray = image.bottomRightOnBit

        if leftTopBlack == nil || rightBottomBlack == nil {
            return nil
        }

        let moduleSize = self.moduleSize(leftTopBlack, image: image)

        if moduleSize == 1 {
            return nil
        }

        var top: CInt = leftTopBlack.array[1]
        let bottom: CInt = rightBottomBlack.array[1]
        var left: CInt = leftTopBlack.array[0]
        let right: CInt = rightBottomBlack.array[0]
        let matrixWidth = (right - left + 1) / moduleSize
        let matrixHeight = (bottom - top + 1) / moduleSize

        if matrixWidth <= 0 || matrixHeight <= 0 {
            return nil
        }

        let nudge = moduleSize / 2

        top += nudge
        left += nudge

        let bits = ZXBitMatrix(width: matrixWidth, height: matrixHeight)
        var y: CInt = 0

        while y < matrixHeight {
            defer {
                y += 1
            }

            let iOffset = top + y * moduleSize
            var x: CInt = 0

            while x < matrixWidth {
                defer {
                    x += 1
                }

                if image.getX(left + x * moduleSize, y: iOffset) {
                    bits.setX(x, y: y)
                }
            }
        }

        return bits
    }
    @objc
    func moduleSize(_ leftTopBlack: ZXIntArray!, image: ZXBitMatrix!) -> CInt {
        let width = image.width
        var x: CInt = leftTopBlack.array[0]
        let y: CInt = leftTopBlack.array[1]

        while x < width && image.getX(x, y: y) {
            x += 1
        }

        if x == width {
            return 1
        }

        let moduleSize: CInt = x - leftTopBlack.array[0]

        if moduleSize == 0 {
            return 1
        }

        return moduleSize
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
extension ZXDataMatrixReader {
    @objc var decoder: ZXDataMatrixDecoder! {
        return self._decoder
    }
}