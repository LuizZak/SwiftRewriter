// Preprocessor directives found in file:
// #import "ZXMultipleBarcodeReader.h"
// #import "ZXQRCodeReader.h"
// #import "ZXByteArray.h"
// #import "ZXDecoderResult.h"
// #import "ZXDetectorResult.h"
// #import "ZXMultiDetector.h"
// #import "ZXQRCodeDecoder.h"
// #import "ZXQRCodeDecoderMetaData.h"
// #import "ZXQRCodeMultiReader.h"
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
 * This implementation can detect and decode multiple QR Codes in an image.
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
 * This implementation can detect and decode multiple QR Codes in an image.
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
class ZXQRCodeMultiReader: ZXQRCodeReader, ZXMultipleBarcodeReader {
    @objc
    func decodeMultiple(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> NSArray {
        return self.decodeMultiple(image, hints: nil, error: error)
    }
    @objc
    func decodeMultiple(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> NSArray {
        let matrix = image.blackMatrixWithError(error)

        if matrix == nil {
            return nil
        }

        var results = NSMutableArray()
        let detectorResults = ZXMultiDetector(image: matrix).detectMulti(hints, error: error)

        if !detectorResults {
            return nil
        }

        for detectorResult in detectorResults {
            let decoderResult = self.decoder.decodeMatrix(detectorResult.bits(), hints: hints, error: nil)

            if decoderResult != nil {
                let points: NSMutableArray! = detectorResult.points().mutableCopy()

                // If the code was mirrored: swap the bottom-left and the top-right points.
                if decoderResult?.other.isKindOfClass(ZXQRCodeDecoderMetaData.self) {
                    (decoderResult?.other as? ZXQRCodeDecoderMetaData)?.applyMirroredCorrection(points)
                }

                let result = ZXResult.resultWithText(decoderResult?.text, rawBytes: decoderResult?.rawBytes, resultPoints: points, format: ZXBarcodeFormat.kBarcodeFormatQRCode)
                let byteSegments = decoderResult?.byteSegments

                if byteSegments != nil {
                    result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeByteSegments, value: byteSegments)
                }

                let ecLevel = decoderResult?.ecLevel

                if ecLevel != nil {
                    result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeErrorCorrectionLevel, value: ecLevel)
                }

                if decoderResult?.hasStructuredAppend() == true {
                    result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeStructuredAppendSequence, value: decoderResult?.structuredAppendSequenceNumber ?? 0)
                    result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeStructuredAppendParity, value: decoderResult?.structuredAppendParity ?? 0)
                }

                if let result = result {
                    results.add(result)
                }
            }
        }

        results = self.processStructuredAppend(results)

        return results
    }
    @objc
    func processStructuredAppend(_ results: NSMutableArray!) -> NSMutableArray {
        var hasSA = false

        // first, check, if there is at least on SA result in the list
        for result in results {
            if result.resultMetadata[kResultMetadataTypeStructuredAppendSequence] {
                hasSA = true

                break
            }
        }

        if !hasSA {
            return results
        }

        // it is, second, split the lists and built a new result list
        let newResults = NSMutableArray()
        let saResults = NSMutableArray()

        for result in results {
            newResults.add(result)

            if result.resultMetadata[kResultMetadataTypeStructuredAppendSequence] {
                saResults.add(result)
            }
        }

        // sort and concatenate the SA list items
        saResults.sortUsingComparator { (a: ZXResult!, b: ZXResult!) -> ComparisonResult in
            let aNumber: CInt = a.resultMetadata[ZXResultMetadataType.kResultMetadataTypeStructuredAppendSequence].intValue()
            let bNumber: CInt = b.resultMetadata[ZXResultMetadataType.kResultMetadataTypeStructuredAppendSequence].intValue()

            if aNumber < bNumber {
                return ComparisonResult.orderedAscending
            }

            if aNumber > bNumber {
                return ComparisonResult.orderedDescending
            }

            return ComparisonResult.orderedSame
        }

        let concatedText = NSMutableString()
        var rawBytesLen: CInt = 0
        var byteSegmentLength: CInt = 0

        for saResult in saResults {
            concatedText.append(saResult.text)
            rawBytesLen += saResult.rawBytes.length

            if saResult.resultMetadata[kResultMetadataTypeByteSegments] {
                for segment in saResult.resultMetadata[kResultMetadataTypeByteSegments] {
                    byteSegmentLength += segment.length
                }
            }
        }

        let newRawBytes = ZXByteArray(length: CUnsignedInt(rawBytesLen))
        let newByteSegment = ZXByteArray(length: CUnsignedInt(byteSegmentLength))
        var newRawBytesIndex: CInt = 0
        var byteSegmentIndex: CInt = 0

        for saResult in saResults {
            memcpy(newRawBytes.array, saResult.rawBytes.array, saResult.rawBytes.length * MemoryLayout.size(ofValue: int8_t))
            newRawBytesIndex += saResult.rawBytes.length

            if saResult.resultMetadata[kResultMetadataTypeByteSegments] {
                for segment in saResult.resultMetadata[kResultMetadataTypeByteSegments] {
                    memcpy(newByteSegment.array, segment.array, segment.length * MemoryLayout.size(ofValue: int8_t))
                    byteSegmentIndex += segment.length
                }
            }
        }

        let newResult = ZXResult(text: concatedText, rawBytes: newRawBytes, resultPoints: [], format: ZXBarcodeFormat.kBarcodeFormatQRCode)

        if byteSegmentLength > 0 {
            let byteSegmentList = NSMutableArray()

            byteSegmentList.add(newByteSegment)
            newResult.putMetadata(ZXResultMetadataType.kResultMetadataTypeByteSegments, value: byteSegmentList)
        }

        newResults.add(newResult)

        return newResults
    }
}