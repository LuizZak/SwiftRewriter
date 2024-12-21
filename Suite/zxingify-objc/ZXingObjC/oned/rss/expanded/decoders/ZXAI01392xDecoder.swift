// Preprocessor directives found in file:
// #import "ZXAI01decoder.h"
// #import "ZXAI01392xDecoder.h"
// #import "ZXBitArray.h"
// #import "ZXErrors.h"
// #import "ZXRSSExpandedDecodedInformation.h"
// #import "ZXRSSExpandedGeneralAppIdDecoder.h"
let ZX_AI01392x_HEADER_SIZE: CInt = 5 + 1 + 2
let ZX_AI01392x_LAST_DIGIT_SIZE: CInt = 2

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
class ZXAI01392xDecoder: ZXAI01decoder {
    @objc
    func parseInformationWithError(_ error: UnsafeMutablePointer<Error?>!) -> String? {
        if (self.information.size ?? 0) < ZX_AI01392x_HEADER_SIZE + ZX_AI01_GTIN_SIZE {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let buf = NSMutableString()

        self.encodeCompressedGtin(buf, currentPos: ZX_AI01392x_HEADER_SIZE)

        let lastAIdigit = self.generalDecoder.extractNumericValueFromBitArray(ZX_AI01392x_HEADER_SIZE + ZX_AI01_GTIN_SIZE, bits: ZX_AI01392x_LAST_DIGIT_SIZE) ?? 0

        buf.appendFormat("(392%d)", lastAIdigit)

        let decodedInformation = self.generalDecoder.decodeGeneralPurposeField(ZX_AI01392x_HEADER_SIZE + ZX_AI01_GTIN_SIZE + ZX_AI01392x_LAST_DIGIT_SIZE, remaining: nil)

        if let theNewString = decodedInformation?.theNewString {
            buf.append(theNewString)
        }

        return buf
    }
}