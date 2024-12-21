// Preprocessor directives found in file:
// #import "ZXQRCodeErrorCorrectionLevel.h"
// #import "ZXQRCodeFormatInformation.h"
let ZX_FORMAT_INFO_MASK_QR: CInt = 0x5412
let ZX_FORMAT_INFO_DECODE_LOOKUP_LEN: CInt = 32
var ZX_FORMAT_INFO_DECODE_LOOKUP: (CInt, CInt)
var ZX_BITS_SET_IN_HALF_BYTE: UnsafePointer<CInt>!

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
 * Encapsulates a QR Code's format information, including the data mask used and
 * error correction level.
 */
@objc
class ZXQRCodeFormatInformation: NSObject {
    private var _errorCorrectionLevel: ZXQRCodeErrorCorrectionLevel!
    private var _dataMask: int8_t
    @objc var errorCorrectionLevel: ZXQRCodeErrorCorrectionLevel! {
        return self._errorCorrectionLevel
    }
    @objc var dataMask: int8_t {
        return self._dataMask
    }

    @objc
    init(formatInfo: CInt) {
        if self = super.init() {
            _errorCorrectionLevel = ZXQRCodeErrorCorrectionLevel.forBits((formatInfo >> 3) & 0x3)
            _dataMask = (formatInfo & 0x7) as? int8_t
        }

        return self
    }

    @objc
    static func numBitsDiffering(_ a: CInt, b: CInt) -> CInt {
        a ^= b

        return ZX_BITS_SET_IN_HALF_BYTE[a & 0xf] + ZX_BITS_SET_IN_HALF_BYTE[CInt(CUnsignedInt(a)) >> 4 & 0xf] + ZX_BITS_SET_IN_HALF_BYTE[CInt(CUnsignedInt(a)) >> 8 & 0xf] + ZX_BITS_SET_IN_HALF_BYTE[CInt(CUnsignedInt(a)) >> 12 & 0xf] + ZX_BITS_SET_IN_HALF_BYTE[CInt(CUnsignedInt(a)) >> 16 & 0xf] + ZX_BITS_SET_IN_HALF_BYTE[CInt(CUnsignedInt(a)) >> 20 & 0xf] + ZX_BITS_SET_IN_HALF_BYTE[CInt(CUnsignedInt(a)) >> 24 & 0xf] + ZX_BITS_SET_IN_HALF_BYTE[CInt(CUnsignedInt(a)) >> 28 & 0xf]
    }
    /**
 * @param maskedFormatInfo1 format info indicator, with mask still applied
 * @param maskedFormatInfo2 second copy of same info; both are checked at the same time
 *  to establish best match
 * @return information about the format it specifies, or {@code null}
 *  if doesn't seem to match any known pattern
 */
    @objc
    static func decodeFormatInformation(_ maskedFormatInfo1: CInt, maskedFormatInfo2: CInt) -> ZXQRCodeFormatInformation? {
        let formatInfo = self.doDecodeFormatInformation(maskedFormatInfo1, maskedFormatInfo2: maskedFormatInfo2)

        if formatInfo != nil {
            return formatInfo
        }

        return self.doDecodeFormatInformation(maskedFormatInfo1 ^ ZX_FORMAT_INFO_MASK_QR, maskedFormatInfo2: maskedFormatInfo2 ^ ZX_FORMAT_INFO_MASK_QR)
    }
    @objc
    static func doDecodeFormatInformation(_ maskedFormatInfo1: CInt, maskedFormatInfo2: CInt) -> ZXQRCodeFormatInformation? {
        var bestDifference: CInt = INT_MAX
        var bestFormatInfo: CInt = 0
        var i: CInt = 0

        while i < ZX_FORMAT_INFO_DECODE_LOOKUP_LEN {
            defer {
                i += 1
            }

            let targetInfo: CInt = ZX_FORMAT_INFO_DECODE_LOOKUP[i][0]

            if targetInfo == maskedFormatInfo1 || targetInfo == maskedFormatInfo2 {
                return ZXQRCodeFormatInformation(formatInfo: ZX_FORMAT_INFO_DECODE_LOOKUP[i][1])
            }

            var bitsDifference = self.numBitsDiffering(maskedFormatInfo1, b: targetInfo)

            if bitsDifference < bestDifference {
                bestFormatInfo = ZX_FORMAT_INFO_DECODE_LOOKUP[i][1]
                bestDifference = bitsDifference
            }

            if maskedFormatInfo1 != maskedFormatInfo2 {
                bitsDifference = self.numBitsDiffering(maskedFormatInfo2, b: targetInfo)

                if bitsDifference < bestDifference {
                    bestFormatInfo = ZX_FORMAT_INFO_DECODE_LOOKUP[i][1]
                    bestDifference = bitsDifference
                }
            }
        }

        if bestDifference <= 3 {
            return ZXQRCodeFormatInformation(formatInfo: bestFormatInfo)
        }

        return nil
    }
    @objc
    func hash() -> UInt {
        return ((self.errorCorrectionLevel.ordinal ?? 0) << 3) | CInt(self.dataMask)
    }
    @objc
    func isEqual(_ o: AnyObject) -> Bool {
        if !o.isKindOfClass(ZXQRCodeFormatInformation.self) {
            return false
        }

        let other = o as? ZXQRCodeFormatInformation

        return self.errorCorrectionLevel == other?.errorCorrectionLevel && self.dataMask == other?.dataMask
    }
}