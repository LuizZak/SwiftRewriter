// Preprocessor directives found in file:
// #import "ZXAbstractExpandedDecoder.h"
// #import "ZXAnyAIDecoder.h"
// #import "ZXRSSExpandedGeneralAppIdDecoder.h"
let ZX_ANY_AI_HEADER_SIZE: CInt = 2 + 1 + 2

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
class ZXAnyAIDecoder: ZXAbstractExpandedDecoder {
    @objc
    func parseInformationWithError(_ error: UnsafeMutablePointer<Error?>!) -> String? {
        let buf = NSMutableString()

        return self.generalDecoder.decodeAllCodes(buf, initialPosition: ZX_ANY_AI_HEADER_SIZE, error: error)
    }
}