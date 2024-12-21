// Preprocessor directives found in file:
// #import "ZXMultipleBarcodeReader.h"
// #import "ZXReader.h"
// #import "ZXBarcodeFormat.h"
// #import "ZXBinaryBitmap.h"
// #import "ZXBitMatrix.h"
// #import "ZXDecodeHints.h"
// #import "ZXDecoderResult.h"
// #import "ZXDetectorResult.h"
// #import "ZXErrors.h"
// #import "ZXPDF417Common.h"
// #import "ZXPDF417Detector.h"
// #import "ZXPDF417DetectorResult.h"
// #import "ZXPDF417Reader.h"
// #import "ZXPDF417ResultMetadata.h"
// #import "ZXPDF417ScanningDecoder.h"
// #import "ZXResult.h"
// #import "ZXResultPoint.h"
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
 * This implementation can detect and decode PDF417 codes in an image.
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
 * This implementation can detect and decode PDF417 codes in an image.
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
class ZXPDF417Reader: NSObject, ZXReader, ZXMultipleBarcodeReader {
    /**
 * Locates and decodes a PDF417 code in an image.
 *
 * @return a String representing the content encoded by the PDF417 code
 * @return nil if a PDF417 code cannot be found,
 * @return nil if a PDF417 cannot be decoded
 */
    @objc
    func decode(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        return self.decode(image, hints: nil, error: error)
    }
    @objc
    func decode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let result = self.decode(image, hints: hints, multiple: false, error: error)

        if (result == nil) || result?.count == 0 || (result?[0] == nil) {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        return result?[0]
    }
    @objc
    func decodeMultiple(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> NSArray? {
        return self.decodeMultiple(image, hints: nil, error: error)
    }
    @objc
    func decodeMultiple(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> NSArray? {
        return self.decode(image, hints: hints, multiple: true, error: error)
    }
    @objc
    func decode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, multiple: Bool, error: UnsafeMutablePointer<Error?>!) -> NSArray? {
        let results = NSMutableArray()
        let detectorResult = ZXPDF417Detector.detect(image, hints: hints, multiple: multiple, error: error)

        if detectorResult == nil {
            return nil
        }

        for points in detectorResult?.points {
            let imageTopLeft: ZXResultPoint! = (points[4] == NSNull.null()) ? nil : points[4]
            let imageBottomLeft: ZXResultPoint! = (points[5] == NSNull.null()) ? nil : points[5]
            let imageTopRight: ZXResultPoint! = (points[6] == NSNull.null()) ? nil : points[6]
            let imageBottomRight: ZXResultPoint! = (points[7] == NSNull.null()) ? nil : points[7]
            let decoderResult = ZXPDF417ScanningDecoder.decode(detectorResult?.bits, imageTopLeft: imageTopLeft, imageBottomLeft: imageBottomLeft, imageTopRight: imageTopRight, imageBottomRight: imageBottomRight, minCodewordWidth: self.minCodewordWidth(points), maxCodewordWidth: self.maxCodewordWidth(points), error: error)

            if decoderResult == nil {
                return nil
            }

            let result = ZXResult(text: decoderResult?.text, rawBytes: decoderResult?.rawBytes, resultPoints: points, format: ZXBarcodeFormat.kBarcodeFormatPDF417)

            result.putMetadata(ZXResultMetadataType.kResultMetadataTypeErrorCorrectionLevel, value: decoderResult?.ecLevel)

            let pdf417ResultMetadata = decoderResult?.other

            if pdf417ResultMetadata != nil {
                result.putMetadata(ZXResultMetadataType.kResultMetadataTypePDF417ExtraMetadata, value: pdf417ResultMetadata)
            }

            results.add(result)
        }

        return NSArray.arrayWithArray(results)
    }
    @objc
    func maxWidth(_ p1: ZXResultPoint!, p2: ZXResultPoint!) -> CInt {
        if !p1 || !p2 || p1 as? AnyObject == NSNull.null() || p2 == NSNull.null() as? AnyObject {
            return 0
        }

        return CInt(fabsf(p1.x - p2.x))
    }
    @objc
    func minWidth(_ p1: ZXResultPoint!, p2: ZXResultPoint!) -> CInt {
        if !p1 || !p2 || p1 as? AnyObject == NSNull.null() || p2 == NSNull.null() as? AnyObject {
            return INT_MAX
        }

        return CInt(fabsf(p1.x - p2.x))
    }
    @objc
    func maxCodewordWidth(_ p: NSArray!) -> CInt {
        return max(max(self.maxWidth(p[0], p2: p[4]), self.maxWidth(p[6], p2: p[2]) * ZX_PDF417_MODULES_IN_CODEWORD / ZX_PDF417_MODULES_IN_STOP_PATTERN), max(self.maxWidth(p[1], p2: p[5]), self.maxWidth(p[7], p2: p[3]) * ZX_PDF417_MODULES_IN_CODEWORD / ZX_PDF417_MODULES_IN_STOP_PATTERN))
    }
    @objc
    func minCodewordWidth(_ p: NSArray!) -> CInt {
        return min(min(self.minWidth(p[0], p2: p[4]), self.minWidth(p[6], p2: p[2]) * ZX_PDF417_MODULES_IN_CODEWORD / ZX_PDF417_MODULES_IN_STOP_PATTERN), min(self.minWidth(p[1], p2: p[5]), self.minWidth(p[7], p2: p[3]) * ZX_PDF417_MODULES_IN_CODEWORD / ZX_PDF417_MODULES_IN_STOP_PATTERN))
    }
    @objc
    func reset() {
        // nothing needs to be reset
    }
}