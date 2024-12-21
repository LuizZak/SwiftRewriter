// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXBoolArray.h"
// #import "ZXByteArray.h"
// #import "ZXDecoderResult.h"
// #import "ZXErrors.h"
// #import "ZXGenericGF.h"
// #import "ZXIntArray.h"
// #import "ZXQRCodeBitMatrixParser.h"
// #import "ZXQRCodeDataBlock.h"
// #import "ZXQRCodeDecodedBitStreamParser.h"
// #import "ZXQRCodeDecoder.h"
// #import "ZXQRCodeDecoderMetaData.h"
// #import "ZXQRCodeErrorCorrectionLevel.h"
// #import "ZXQRCodeFormatInformation.h"
// #import "ZXQRCodeVersion.h"
// #import "ZXReedSolomonDecoder.h"
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
 * The main class which implements QR Code decoding -- as opposed to locating and extracting
 * the QR Code from an image.
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
 * The main class which implements QR Code decoding -- as opposed to locating and extracting
 * the QR Code from an image.
 */
@objc
class ZXQRCodeDecoder: NSObject {
    private var _rsDecoder: ZXReedSolomonDecoder!

    @objc
    override init() {
        if self = super.init() {
            _rsDecoder = ZXReedSolomonDecoder(field: ZXGenericGF.QrCodeField256())
        }

        return self
    }

    @objc
    func decode(_ image: NSArray!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        return self.decode(image, hints: nil, error: error)
    }
    /**
 * Convenience method that can decode a QR Code represented as a 2D array of booleans.
 * "true" is taken to mean a black module.
 *
 * @param image booleans representing white/black QR Code modules
 * @param hints decoding hints that should be used to influence decoding
 * @return text and bytes encoded within the QR Code or nil if:
 *   - the QR Code cannot be decoded
 *   - error correction fails
 */
    /**
 * Convenience method that can decode a QR Code represented as a 2D array of booleans.
 * "true" is taken to mean a black module.
 *
 * @param image booleans representing white/black QR Code modules
 * @param hints decoding hints that should be used to influence decoding
 * @return text and bytes encoded within the QR Code or nil if:
 *   - the QR Code cannot be decoded
 *   - error correction fails
 */
    @objc
    func decode(_ image: NSArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        let dimension: CInt = CInt(image.count)
        let bits = ZXBitMatrix(dimension: dimension)
        var i: CInt = 0

        while i < dimension {
            defer {
                i += 1
            }

            let b: ZXBoolArray! = image[Int(i)]
            var j: CInt = 0

            while j < dimension {
                defer {
                    j += 1
                }

                if b.array[j] {
                    bits.setX(j, y: i)
                }
            }
        }

        return self.decodeMatrix(bits, hints: hints, error: error)
    }
    @objc
    func decodeMatrix(_ bits: ZXBitMatrix!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        return self.decodeMatrix(bits, hints: nil, error: error)
    }
    /**
 * Decodes a QR Code represented as a ZXBitMatrix. A 1 or "true" is taken to mean a black module.
 *
 * @param bits booleans representing white/black QR Code modules
 * @param hints decoding hints that should be used to influence decoding
 * @return text and bytes encoded within the QR Code
 * @return nil if the QR Code cannot be decoded
 * @return nil if error correction fails
 */
    /**
 * Decodes a QR Code represented as a ZXBitMatrix. A 1 or "true" is taken to mean a black module.
 *
 * @param bits booleans representing white/black QR Code modules
 * @param hints decoding hints that should be used to influence decoding
 * @return text and bytes encoded within the QR Code
 * @return nil if the QR Code cannot be decoded
 * @return nil if error correction fails
 */
    @objc
    func decodeMatrix(_ bits: ZXBitMatrix!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        let parser = ZXQRCodeBitMatrixParser(bitMatrix: bits, error: error)

        if !parser {
            return nil
        }

        var result = self.decodeParser(parser, hints: hints, error: error)

        if result != nil {
            return result
        }

        // Revert the bit matrix
        parser.remask()
        // Will be attempting a mirrored reading of the version and format info.
        parser.setMirror(true)

        // Preemptively read the version.
        if !parser.readVersionWithError(error) {
            return nil
        }

        /*
   * Since we're here, this means we have successfully detected some kind
   * of version and format information when mirrored. This is a good sign,
   * that the QR code may be mirrored, and we should try once more with a
   * mirrored content.
   */
        // Prepare for a mirrored reading.
        parser.mirror()
        result = self.decodeParser(parser, hints: hints, error: error)

        if result == nil {
            return nil
        }

        // Success! Notify the caller that the code was mirrored.
        result?.other = ZXQRCodeDecoderMetaData(mirrored: true)

        return result
    }
    @objc
    func decodeParser(_ parser: ZXQRCodeBitMatrixParser!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        let version = parser.readVersionWithError(error)

        if version == nil {
            return nil
        }

        let formatInfo = parser.readFormatInformationWithError(error)

        if formatInfo == nil {
            return nil
        }

        let ecLevel = formatInfo?.errorCorrectionLevel
        let codewords = parser.readCodewordsWithError(error)

        if !codewords {
            return nil
        }

        let dataBlocks = ZXQRCodeDataBlock.dataBlocks(codewords, version: version, ecLevel: ecLevel)
        var totalBytes: CInt = 0

        for dataBlock in dataBlocks {
            totalBytes += dataBlock.numDataCodewords
        }

        if totalBytes == 0 {
            return nil
        }

        let resultBytes = ZXByteArray(length: CUnsignedInt(totalBytes))
        var resultOffset: CInt = 0

        for dataBlock in dataBlocks {
            let codewordBytes: ZXByteArray! = dataBlock.codewords
            let numDataCodewords: CInt = dataBlock.numDataCodewords()

            if !self.correctErrors(codewordBytes, numDataCodewords: numDataCodewords, error: error) {
                return nil
            }

            var i: CInt = 0

            while i < numDataCodewords {
                defer {
                    i += 1
                }

                resultBytes.array[resultOffset += 1] = codewordBytes.array[i]
            }
        }

        return ZXQRCodeDecodedBitStreamParser.decode(resultBytes, version: version, ecLevel: ecLevel, hints: hints, error: error)
    }
    /**
 * Given data and error-correction codewords received, possibly corrupted by errors, attempts to
 * correct the errors in-place using Reed-Solomon error correction.
 *
 * @param codewordBytes data and error correction codewords
 * @param numDataCodewords number of codewords that are data bytes
 * @return NO if error correction fails
 */
    @objc
    func correctErrors(_ codewordBytes: ZXByteArray!, numDataCodewords: CInt, error: UnsafeMutablePointer<Error?>!) -> Bool {
        let numCodewords: CInt = CInt(codewordBytes.length)
        // First read into an array of ints
        let codewordsInts = ZXIntArray(length: CUnsignedInt(numCodewords))
        var i: CInt = 0

        while i < numCodewords {
            defer {
                i += 1
            }

            codewordsInts.array[i] = codewordBytes.array[i] & 0xff
        }

        let numECCodewords: CInt = CInt(codewordBytes.length) - numDataCodewords
        var decodeError: Error! = nil

        if self.rsDecoder.decode(codewordsInts, twoS: numECCodewords, error: &decodeError) != true {
            if decodeError?.code == ZXReedSolomonError {
                if error {
                    *error = ZXChecksumErrorInstance()
                }

                return false
            } else {
                if error {
                    *error = decodeError
                }

                return false
            }
        }

        var i: CInt = 0

        while i < numDataCodewords {
            defer {
                i += 1
            }

            codewordBytes.array[i] = codewordsInts.array[i] as? int8_t
        }

        return true
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
extension ZXQRCodeDecoder {
    @objc var rsDecoder: ZXReedSolomonDecoder! {
        return self._rsDecoder
    }
}