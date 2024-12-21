// Preprocessor directives found in file:
// #import "ZXReader.h"
// #import "ZXBinaryBitmap.h"
// #import "ZXBitMatrix.h"
// #import "ZXDecodeHints.h"
// #import "ZXDecoderResult.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXMaxiCodeDecoder.h"
// #import "ZXMaxiCodeReader.h"
// #import "ZXResult.h"
let ZX_MATRIX_WIDTH: CInt = 30
let ZX_MATRIX_HEIGHT: CInt = 33

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
 * This implementation can detect and decode a MaxiCode in an image.
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
 * This implementation can detect and decode a MaxiCode in an image.
 */
@objc
class ZXMaxiCodeReader: NSObject, ZXReader {
    private var _decoder: ZXMaxiCodeDecoder!

    @objc
    override init() {
        if self = super.init() {
            _decoder = ZXMaxiCodeDecoder()
        }

        return self
    }

    /**
 * Locates and decodes a MaxiCode in an image.
 *
 * @return a String representing the content encoded by the MaxiCode
 * @return nil if a MaxiCode cannot be found
 * @return nil if a MaxiCode cannot be decoded
 * @return nil if error correction fails
 */
    @objc
    func decode(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        return self.decode(image, hints: nil, error: error)
    }
    @objc
    func decode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        var decoderResult: ZXDecoderResult!

        if hints != nil && hints.pureBarcode {
            let matrix = image.blackMatrixWithError(error)

            if matrix == nil {
                return nil
            }

            let bits = self.extractPureBits(matrix)

            if !bits {
                if error {
                    *error = ZXNotFoundErrorInstance()
                }

                return nil
            }

            decoderResult = self.decoder.decode(bits, hints: hints, error: error)

            if !decoderResult {
                return nil
            }
        } else {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let points = []
        let result = ZXResult.resultWithText(decoderResult.text, rawBytes: decoderResult.rawBytes, resultPoints: points, format: ZXBarcodeFormat.kBarcodeFormatMaxiCode)
        let ecLevel = decoderResult.ecLevel

        if ecLevel != nil {
            result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeErrorCorrectionLevel, value: ecLevel)
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
        let enclosingRectangle: ZXIntArray = image.enclosingRectangle

        if enclosingRectangle == nil {
            return nil
        }

        let left: CInt = enclosingRectangle.array[0]
        let top: CInt = enclosingRectangle.array[1]
        let width: CInt = enclosingRectangle.array[2]
        let height: CInt = enclosingRectangle.array[3]
        // Now just read off the bits
        let bits = ZXBitMatrix(width: ZX_MATRIX_WIDTH, height: ZX_MATRIX_HEIGHT)
        var y: CInt = 0

        while y < ZX_MATRIX_HEIGHT {
            defer {
                y += 1
            }

            let iy = top + (y * height + height / 2) / ZX_MATRIX_HEIGHT
            var x: CInt = 0

            while x < ZX_MATRIX_WIDTH {
                defer {
                    x += 1
                }

                let ix = left + (x * width + width / 2 + (y & 0x1) * width / 2) / ZX_MATRIX_WIDTH

                if image.getX(ix, y: iy) {
                    bits.setX(x, y: y)
                }
            }
        }

        return bits
    }
}

// MARK: -
@objc
extension ZXMaxiCodeReader {
    @objc var decoder: ZXMaxiCodeDecoder! {
        return self._decoder
    }
}