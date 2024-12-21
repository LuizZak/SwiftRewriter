import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXAbstractExpandedDecoder.h"
// #import "ZXAI013103decoder.h"
// #import "ZXAI01320xDecoder.h"
// #import "ZXAI01392xDecoder.h"
// #import "ZXAI01393xDecoder.h"
// #import "ZXAI013x0x1xDecoder.h"
// #import "ZXAI01AndOtherAIs.h"
// #import "ZXAnyAIDecoder.h"
// #import "ZXBitArray.h"
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
class ZXAbstractExpandedDecoder: NSObject {
    private var _generalDecoder: ZXRSSExpandedGeneralAppIdDecoder!
    private var _information: ZXBitArray!
    @objc var generalDecoder: ZXRSSExpandedGeneralAppIdDecoder! {
        return self._generalDecoder
    }
    @objc var information: ZXBitArray! {
        return self._information
    }

    @objc
    init(information: ZXBitArray!) {
        if self = super.init() {
            _information = information
            _generalDecoder = ZXRSSExpandedGeneralAppIdDecoder(information: information)
        }

        return self
    }

    @objc
    func parseInformationWithError(_ error: UnsafeMutablePointer<Error?>!) -> String {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
    @objc
    static func createDecoder(_ information: ZXBitArray!) -> ZXAbstractExpandedDecoder {
        if information.get(1) {
            return ZXAI01AndOtherAIs(information: information)
        }

        if !information.get(2) {
            return ZXAnyAIDecoder(information: information)
        }

        let fourBitEncodationMethod = ZXRSSExpandedGeneralAppIdDecoder.extractNumericValueFromBitArray(information, pos: 1, bits: 4)

        switch fourBitEncodationMethod {
        case 4:
            return ZXAI013103decoder(information: information)
        case 5:
            return ZXAI01320xDecoder(information: information)
        default:
            break
        }

        let fiveBitEncodationMethod = ZXRSSExpandedGeneralAppIdDecoder.extractNumericValueFromBitArray(information, pos: 1, bits: 5)

        switch fiveBitEncodationMethod {
        case 12:
            return ZXAI01392xDecoder(information: information)
        case 13:
            return ZXAI01393xDecoder(information: information)
        default:
            break
        }

        let sevenBitEncodationMethod = ZXRSSExpandedGeneralAppIdDecoder.extractNumericValueFromBitArray(information, pos: 1, bits: 7)

        switch sevenBitEncodationMethod {
        case 56:
            return ZXAI013x0x1xDecoder(information: information, firstAIdigits: "310", dateCode: "11")
        case 57:
            return ZXAI013x0x1xDecoder(information: information, firstAIdigits: "320", dateCode: "11")
        case 58:
            return ZXAI013x0x1xDecoder(information: information, firstAIdigits: "310", dateCode: "13")
        case 59:
            return ZXAI013x0x1xDecoder(information: information, firstAIdigits: "320", dateCode: "13")
        case 60:
            return ZXAI013x0x1xDecoder(information: information, firstAIdigits: "310", dateCode: "15")
        case 61:
            return ZXAI013x0x1xDecoder(information: information, firstAIdigits: "320", dateCode: "15")
        case 62:
            return ZXAI013x0x1xDecoder(information: information, firstAIdigits: "310", dateCode: "17")
        case 63:
            return ZXAI013x0x1xDecoder(information: information, firstAIdigits: "320", dateCode: "17")
        default:
            break
        }

        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"unknown decoder: %@",information]userInfo:nil];
        */
    }
}