// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXBoolArray.h"
// #import "ZXByteArray.h"
// #import "ZXDataMatrixBitMatrixParser.h"
// #import "ZXDataMatrixDataBlock.h"
// #import "ZXDataMatrixDecodedBitStreamParser.h"
// #import "ZXDataMatrixDecoder.h"
// #import "ZXDataMatrixVersion.h"
// #import "ZXDecoderResult.h"
// #import "ZXErrors.h"
// #import "ZXGenericGF.h"
// #import "ZXIntArray.h"
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
 * The main class which implements Data Matrix Code decoding -- as opposed to locating and extracting
 * the Data Matrix Code from an image.
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
 * The main class which implements Data Matrix Code decoding -- as opposed to locating and extracting
 * the Data Matrix Code from an image.
 */
@objc
class ZXDataMatrixDecoder: NSObject {
    private var _rsDecoder: ZXReedSolomonDecoder!

    @objc
    override init() {
        if self = super.init() {
            _rsDecoder = ZXReedSolomonDecoder(field: ZXGenericGF.DataMatrixField256())
        }

        return self
    }

    /**
 * Convenience method that can decode a Data Matrix Code represented as a 2D array of booleans.
 * "true" is taken to mean a black module.
 *
 * @param image booleans representing white/black Data Matrix Code modules
 * @return text and bytes encoded within the Data Matrix Code
 * @return nil if the Data Matrix Code cannot be decoded
 * @return nil if error correction fails
 */
    /**
 * Convenience method that can decode a Data Matrix Code represented as a 2D array of booleans.
 * "true" is taken to mean a black module.
 *
 * @param image booleans representing white/black Data Matrix Code modules
 * @return text and bytes encoded within the Data Matrix Code
 * @return nil if the Data Matrix Code cannot be decoded
 * @return nil if error correction fails
 */
    @objc
    func decode(_ image: NSArray!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
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

        return self.decodeMatrix(bits, error: error)
    }
    /**
 * Decodes a Data Matrix Code represented as a ZXBitMatrix. A 1 or "true" is taken
 * to mean a black module.
 *
 * @param bits booleans representing white/black Data Matrix Code modules
 * @return text and bytes encoded within the Data Matrix Code
 * @return nil if the Data Matrix Code cannot be decoded
 * @return nil if error correction fails
 */
    /**
 * Decodes a Data Matrix Code represented as a ZXBitMatrix. A 1 or "true" is taken
 * to mean a black module.
 *
 * @param bits booleans representing white/black Data Matrix Code modules
 * @return text and bytes encoded within the Data Matrix Code
 * @return nil if the Data Matrix Code cannot be decoded
 * @return nil if error correction fails
 */
    @objc
    func decodeMatrix(_ bits: ZXBitMatrix!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        let parser = ZXDataMatrixBitMatrixParser(bitMatrix: bits, error: error)

        if !parser {
            return nil
        }

        let version = parser.version
        let codewords = parser.readCodewords()
        let dataBlocks = ZXDataMatrixDataBlock.dataBlocks(codewords, version: version)
        let dataBlocksCount: UInt = UInt(dataBlocks.count)
        var totalBytes: CInt = 0
        var i: CInt = 0

        while i < dataBlocksCount {
            defer {
                i += 1
            }

            totalBytes += dataBlocks[Int(i)].numDataCodewords()
        }

        if totalBytes == 0 {
            return nil
        }

        let resultBytes = ZXByteArray(length: CUnsignedInt(totalBytes))
        var j: CInt = 0

        while j < dataBlocksCount {
            defer {
                j += 1
            }

            let dataBlock: ZXDataMatrixDataBlock! = dataBlocks[Int(j)]
            let codewordBytes = dataBlock.codewords
            let numDataCodewords = dataBlock.numDataCodewords

            if !self.correctErrors(codewordBytes, numDataCodewords: numDataCodewords, error: error) {
                return nil
            }

            var i: CInt = 0

            while i < numDataCodewords {
                defer {
                    i += 1
                }

                // De-interlace data blocks.
                resultBytes.array[UInt(i) * dataBlocksCount + j] = codewordBytes?.array[i]
            }
        }

        return ZXDataMatrixDecodedBitStreamParser.decode(resultBytes, error: error)
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
                if error != nil {
                    error.pointee = ZXChecksumErrorInstance()
                }

                return false
            } else {
                if error != nil {
                    error.pointee = decodeError
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
extension ZXDataMatrixDecoder {
    @objc var rsDecoder: ZXReedSolomonDecoder! {
        return self._rsDecoder
    }
}