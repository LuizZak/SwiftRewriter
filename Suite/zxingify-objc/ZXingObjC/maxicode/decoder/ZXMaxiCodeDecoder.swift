// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXByteArray.h"
// #import "ZXDecodeHints.h"
// #import "ZXDecoderResult.h"
// #import "ZXErrors.h"
// #import "ZXGenericGF.h"
// #import "ZXIntArray.h"
// #import "ZXMaxiCodeBitMatrixParser.h"
// #import "ZXMaxiCodeDecodedBitStreamParser.h"
// #import "ZXMaxiCodeDecoder.h"
// #import "ZXReedSolomonDecoder.h"
let ZX_MAXI_CODE_ALL: CInt = 0
let ZX_MAXI_CODE_EVEN: CInt = 1
let ZX_MAXI_CODE_ODD: CInt = 2

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
 * The main class which implements MaxiCode decoding -- as opposed to locating and extracting
 * the MaxiCode from an image.
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
 * The main class which implements MaxiCode decoding -- as opposed to locating and extracting
 * the MaxiCode from an image.
 */
@objc
class ZXMaxiCodeDecoder: NSObject {
    private var _rsDecoder: ZXReedSolomonDecoder!

    @objc
    override init() {
        if self = super.init() {
            _rsDecoder = ZXReedSolomonDecoder(field: ZXGenericGF.MaxiCodeField64())
        }

        return self
    }

    @objc
    func decode(_ bits: ZXBitMatrix!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        return self.decode(bits, hints: nil, error: error)
    }
    @objc
    func decode(_ bits: ZXBitMatrix!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXDecoderResult? {
        let parser = ZXMaxiCodeBitMatrixParser(bitMatrix: bits, error: error)

        if !parser {
            return nil
        }

        let codewords = parser.readCodewords()

        if !self.correctErrors(codewords, start: 0, dataCodewords: 10, ecCodewords: 10, mode: ZX_MAXI_CODE_ALL, error: error) {
            return nil
        }

        let mode: CInt = codewords.array[0] & 0xf
        var datawords: ZXByteArray!

        switch mode {
        case 2, 3, 4:
            if !self.correctErrors(codewords, start: 20, dataCodewords: 84, ecCodewords: 40, mode: ZX_MAXI_CODE_EVEN, error: error) {
                return nil
            }

            if !self.correctErrors(codewords, start: 20, dataCodewords: 84, ecCodewords: 40, mode: ZX_MAXI_CODE_ODD, error: error) {
                return nil
            }

            datawords = ZXByteArray(length: 94)
        case 5:
            if !self.correctErrors(codewords, start: 20, dataCodewords: 68, ecCodewords: 56, mode: ZX_MAXI_CODE_EVEN, error: error) {
                return nil
            }

            if !self.correctErrors(codewords, start: 20, dataCodewords: 68, ecCodewords: 56, mode: ZX_MAXI_CODE_ODD, error: error) {
                return nil
            }

            datawords = ZXByteArray(length: 78)
        default:
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        var i: CInt = 0

        while i < 10 {
            defer {
                i += 1
            }

            datawords.array[i] = codewords.array[i]
        }

        var i: CInt = 20

        while i < datawords.length + 10 {
            defer {
                i += 1
            }

            datawords.array[i - 10] = codewords.array[i]
        }

        return ZXMaxiCodeDecodedBitStreamParser.decode(datawords, mode: mode)
    }
    @objc
    func correctErrors(_ codewordBytes: ZXByteArray!, start: CInt, dataCodewords: CInt, ecCodewords: CInt, mode: CInt, error: UnsafeMutablePointer<Error?>!) -> Bool {
        let codewords = dataCodewords + ecCodewords
        // in EVEN or ODD mode only half the codewords
        let divisor: CInt = (mode == ZX_MAXI_CODE_ALL) ? 1 : 2
        // First read into an array of ints
        let codewordsInts = ZXIntArray(length: CUnsignedInt(codewords / divisor))
        var i: CInt = 0

        while i < codewords {
            defer {
                i += 1
            }

            if (mode == ZX_MAXI_CODE_ALL) || (i % 2 == (mode - 1)) {
                codewordsInts.array[i / divisor] = codewordBytes.array[i + start] & 0xff
            }
        }

        var decodeError: Error! = nil

        if self.rsDecoder.decode(codewordsInts, twoS: ecCodewords / divisor, error: &decodeError) != true {
            if decodeError?.code == ZXReedSolomonError && error {
                *error = ZXChecksumErrorInstance()
            }

            return false
        }

        var i: CInt = 0

        while i < dataCodewords {
            defer {
                i += 1
            }

            if (mode == ZX_MAXI_CODE_ALL) || (i % 2 == (mode - 1)) {
                codewordBytes.array[i + start] = codewordsInts.array[i / divisor] as? int8_t
            }
        }

        return true
    }
}

// MARK: -
@objc
extension ZXMaxiCodeDecoder {
    @objc var rsDecoder: ZXReedSolomonDecoder! {
        return self._rsDecoder
    }
}