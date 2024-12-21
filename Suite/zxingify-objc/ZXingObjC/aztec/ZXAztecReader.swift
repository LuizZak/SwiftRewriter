// Preprocessor directives found in file:
// #import "ZXReader.h"
// #import "ZXAztecDecoder.h"
// #import "ZXAztecDetector.h"
// #import "ZXAztecDetectorResult.h"
// #import "ZXAztecReader.h"
// #import "ZXBinaryBitmap.h"
// #import "ZXDecodeHints.h"
// #import "ZXDecoderResult.h"
// #import "ZXReader.h"
// #import "ZXResult.h"
// #import "ZXResultPointCallback.h"
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
 * This implementation can detect and decode Aztec codes in an image.
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
 * This implementation can detect and decode Aztec codes in an image.
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
class ZXAztecReader: NSObject, ZXReader {
    @objc
    func decode(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        return self.decode(image, hints: nil, error: error)
    }
    @objc
    func decode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let matrix = image.blackMatrixWithError(error)

        if matrix == nil {
            return nil
        }

        let detector = ZXAztecDetector(image: matrix)
        var points: NSArray! = nil
        var decoderResult: ZXDecoderResult! = nil
        var detectorResult = detector.detectWithMirror(false, error: error)

        if detectorResult != nil {
            points = detectorResult?.points
            decoderResult = ZXAztecDecoder().decode(detectorResult, error: error)
        }

        if decoderResult == nil {
            detectorResult = detector.detectWithMirror(true, error: nil)
            points = detectorResult?.points

            if detectorResult != nil {
                decoderResult = ZXAztecDecoder().decode(detectorResult, error: nil)
            }
        }

        if decoderResult == nil {
            return nil
        }

        if hints != nil {
            let rpcb = hints.resultPointCallback

            if rpcb != nil {
                for p in points {
                    rpcb?.foundPossibleResultPoint(p)
                }
            }
        }

        let result = ZXResult.resultWithText(decoderResult?.text, rawBytes: decoderResult?.rawBytes, numBits: decoderResult?.numBits ?? 0, resultPoints: points, format: ZXBarcodeFormat.kBarcodeFormatAztec)
        let byteSegments = decoderResult?.byteSegments

        if byteSegments != nil {
            result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeByteSegments, value: byteSegments)
        }

        let ecLevel = decoderResult?.ecLevel

        if ecLevel != nil {
            result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeErrorCorrectionLevel, value: ecLevel)
        }

        return result
    }
    @objc
    func reset() {
        // do nothing
    }
}