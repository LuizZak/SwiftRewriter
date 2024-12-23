// Preprocessor directives found in file:
// #import "ZXAI01weightDecoder.h"
// #import "ZXAI013x0x1xDecoder.h"
// #import "ZXBitArray.h"
// #import "ZXErrors.h"
// #import "ZXRSSExpandedGeneralAppIdDecoder.h"
let ZX_AI013x0x1x_HEADER_SIZE: CInt = 7 + 1
let ZX_AI013x0x1x_WEIGHT_SIZE: CInt = 20
let ZX_AI013x0x1x_DATE_SIZE: CInt = 16

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
class ZXAI013x0x1xDecoder: ZXAI01weightDecoder {
    private var _dateCode: String!
    private var _firstAIdigits: String!

    @objc
    init(information: ZXBitArray!, firstAIdigits: String!, dateCode: String!) {
        if self = super.init(information: information) {
            _dateCode = dateCode
            _firstAIdigits = firstAIdigits
        }

        return self
    }

    @objc
    func parseInformationWithError(_ error: UnsafeMutablePointer<Error?>!) -> String? {
        if self.information.size != ZX_AI013x0x1x_HEADER_SIZE + ZX_AI01_GTIN_SIZE + ZX_AI013x0x1x_WEIGHT_SIZE + ZX_AI013x0x1x_DATE_SIZE {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let buf = NSMutableString()

        self.encodeCompressedGtin(buf, currentPos: ZX_AI013x0x1x_HEADER_SIZE)
        self.encodeCompressedWeight(buf, currentPos: ZX_AI013x0x1x_HEADER_SIZE + ZX_AI01_GTIN_SIZE, weightSize: ZX_AI013x0x1x_WEIGHT_SIZE)
        self.encodeCompressedDate(buf, currentPos: ZX_AI013x0x1x_HEADER_SIZE + ZX_AI01_GTIN_SIZE + ZX_AI013x0x1x_WEIGHT_SIZE)

        return buf
    }
    @objc
    func encodeCompressedDate(_ buf: NSMutableString!, currentPos: CInt) {
        var numericDate = self.generalDecoder.extractNumericValueFromBitArray(currentPos, bits: ZX_AI013x0x1x_DATE_SIZE) ?? 0

        if numericDate == 38400 {
            return
        }

        buf.appendFormat("(%@)", self.dateCode)

        let day = numericDate % 32

        numericDate /= 32

        let month = numericDate % 12 + 1

        numericDate /= 12

        let year = numericDate

        if year / 10 == 0 {
            buf.append("0")
        }

        buf.appendFormat("%d", year)

        if month / 10 == 0 {
            buf.append("0")
        }

        buf.appendFormat("%d", month)

        if day / 10 == 0 {
            buf.append("0")
        }

        buf.appendFormat("%d", day)
    }
    @objc
    func addWeightCode(_ buf: NSMutableString!, weight: CInt) {
        let lastAI = weight / 100000

        buf.appendFormat("(%@%d)", self.firstAIdigits, lastAI)
    }
    @objc
    func checkWeight(_ weight: CInt) -> CInt {
        return weight % 100000
    }
}

// MARK: -
@objc
extension ZXAI013x0x1xDecoder {
    @objc var dateCode: String! {
        return self._dateCode
    }
    @objc var firstAIdigits: String! {
        return self._firstAIdigits
    }
}