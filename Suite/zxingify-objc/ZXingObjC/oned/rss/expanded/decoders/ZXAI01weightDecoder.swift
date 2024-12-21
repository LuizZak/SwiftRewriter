// Preprocessor directives found in file:
// #import "ZXAI01decoder.h"
// #import "ZXAI01weightDecoder.h"
// #import "ZXRSSExpandedGeneralAppIdDecoder.h"
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
class ZXAI01weightDecoder: ZXAI01decoder {
    @objc
    func encodeCompressedWeight(_ buf: NSMutableString!, currentPos: CInt, weightSize: CInt) {
        let originalWeightNumeric = self.generalDecoder.extractNumericValueFromBitArray(currentPos, bits: weightSize) ?? 0

        self.addWeightCode(buf, weight: originalWeightNumeric)

        let weightNumeric = self.checkWeight(originalWeightNumeric)
        var currentDivisor: CInt = 100000
        var i: CInt = 0

        while i < 5 {
            defer {
                i += 1
            }

            if weightNumeric / currentDivisor == 0 {
                buf.append("0")
            }

            currentDivisor /= 10
        }

        buf.appendFormat("%d", weightNumeric)
    }
    @objc
    func addWeightCode(_ buf: NSMutableString!, weight: CInt) {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
    @objc
    func checkWeight(_ weight: CInt) -> CInt {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
}