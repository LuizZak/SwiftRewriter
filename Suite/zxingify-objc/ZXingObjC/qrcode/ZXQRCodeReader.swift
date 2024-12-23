// Preprocessor directives found in file:
// #import "ZXReader.h"
// #import "ZXBarcodeFormat.h"
// #import "ZXBinaryBitmap.h"
// #import "ZXBitMatrix.h"
// #import "ZXDecodeHints.h"
// #import "ZXDecoderResult.h"
// #import "ZXDetectorResult.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXQRCodeDecoder.h"
// #import "ZXQRCodeDecoderMetaData.h"
// #import "ZXQRCodeDetector.h"
// #import "ZXQRCodeReader.h"
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
 * This implementation can detect and decode QR Codes in an image.
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
 * This implementation can detect and decode QR Codes in an image.
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
class ZXQRCodeReader: NSObject, ZXReader {
    private var _decoder: ZXQRCodeDecoder!
    @objc var decoder: ZXQRCodeDecoder! {
        return self._decoder
    }

    @objc
    override init() {
        if self = super.init() {
            _decoder = ZXQRCodeDecoder()
        }

        return self
    }

    /**
 * Locates and decodes a QR code in an image.
 *
 * @return a String representing the content encoded by the QR code
 * @throws NotFoundException if a QR code cannot be found
 * @throws FormatException if a QR code cannot be decoded
 * @throws ChecksumException if error correction fails
 */
    @objc
    func decode(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        return self.decode(image, hints: nil, error: error)
    }
    @objc
    func decode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        var decoderResult: ZXDecoderResult!
        var points: NSMutableArray!
        let matrix = image.blackMatrixWithError(error)

        if matrix == nil {
            return nil
        }

        if hints != nil && hints.pureBarcode {
            let bits = self.extractPureBits(matrix)

            if !bits {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
                }

                return nil
            }

            decoderResult = self.decoder.decodeMatrix(bits, hints: hints, error: error)

            if !decoderResult {
                return nil
            }

            points = NSMutableArray()
        } else {
            let detectorResult = ZXQRCodeDetector(image: matrix).detect(hints, error: error)

            if detectorResult == nil {
                return nil
            }

            decoderResult = self.decoder.decodeMatrix(detectorResult?.bits(), hints: hints, error: error)

            if !decoderResult {
                return nil
            }

            points = detectorResult?.points.mutableCopy()
        }

        // If the code was mirrored: swap the bottom-left and the top-right points.
        if decoderResult.other.isKindOfClass(ZXQRCodeDecoderMetaData.self) {
            (decoderResult.other as? ZXQRCodeDecoderMetaData)?.applyMirroredCorrection(points)
        }

        let result = ZXResult.resultWithText(decoderResult.text, rawBytes: decoderResult.rawBytes, resultPoints: points, format: ZXBarcodeFormat.kBarcodeFormatQRCode)
        let byteSegments = decoderResult.byteSegments

        if byteSegments != nil {
            result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeByteSegments, value: byteSegments)
        }

        let ecLevel = decoderResult.ecLevel

        if ecLevel != nil {
            result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeErrorCorrectionLevel, value: ecLevel)
        }

        if decoderResult.hasStructuredAppend() {
            result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeStructuredAppendSequence, value: decoderResult.structuredAppendSequenceNumber)
            result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeStructuredAppendParity, value: decoderResult.structuredAppendParity)
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
        var right: CInt = rightBottomBlack.array[0]

        // Sanity check!
        if left >= right || top >= bottom {
            return nil
        }

        if bottom - top != right - left {
            // Special case, where bottom-right module wasn't black so we found something else in the last row
            // Assume it's a square, so use height as the width
            right = left + (bottom - top)

            if right >= image.width {
                // Abort if that would not make sense -- off image
                return nil
            }
        }

        let matrixWidth: CInt = round(CFloat(right - left + 1) / moduleSize)
        let matrixHeight: CInt = round(CFloat(bottom - top + 1) / moduleSize)

        if matrixWidth <= 0 || matrixHeight <= 0 {
            return nil
        }

        if matrixHeight != matrixWidth {
            return nil
        }

        let nudge: CInt = CInt(moduleSize / 2.0)

        top += nudge
        left += nudge

        // But careful that this does not sample off the edge
        // "right" is the farthest-right valid pixel location -- right+1 is not necessarily
        // This is positive by how much the inner x loop below would be too large
        let nudgedTooFarRight: CInt = left + CInt(CFloat(matrixWidth - 1) * moduleSize) - right

        if nudgedTooFarRight > 0 {
            if nudgedTooFarRight > nudge {
                // Neither way fits; abort
                return nil
            }

            left -= nudgedTooFarRight
        }

        // See logic above
        let nudgedTooFarDown: CInt = top + CInt(CFloat(matrixHeight - 1) * moduleSize) - bottom

        if nudgedTooFarDown > 0 {
            if nudgedTooFarDown > nudge {
                // Neither way fits; abort
                return nil
            }

            top -= nudgedTooFarDown
        }

        // Now just read off the bits
        let bits = ZXBitMatrix(width: matrixWidth, height: matrixHeight)
        var y: CInt = 0

        while y < matrixHeight {
            defer {
                y += 1
            }

            let iOffset: CInt = top + CInt(CFloat(y) * moduleSize)
            var x: CInt = 0

            while x < matrixWidth {
                defer {
                    x += 1
                }

                if image.getX(left + CInt(CFloat(x) * moduleSize), y: iOffset) {
                    bits.setX(x, y: y)
                }
            }
        }

        return bits
    }
    @objc
    func moduleSize(_ leftTopBlack: ZXIntArray!, image: ZXBitMatrix!) -> CFloat {
        let height = image.height
        let width = image.width
        var x: CInt = leftTopBlack.array[0]
        var y: CInt = leftTopBlack.array[1]
        var inBlack = true
        var transitions: CInt = 0

        while x < width && y < height {
            if inBlack != image.getX(x, y: y) {
                if transitions += 1 == 5 {
                    break
                }

                inBlack = !inBlack
            }

            x += 1
            y += 1
        }

        if x == width || y == height {
            return 1
        }

        return (x - leftTopBlack.array[0]) / 7.0
    }
}