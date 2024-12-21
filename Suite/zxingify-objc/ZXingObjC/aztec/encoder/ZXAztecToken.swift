import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXAztecBinaryShiftToken.h"
// #import "ZXAztecSimpleToken.h"
// #import "ZXAztecToken.h"
// #import "ZXBitArray.h"
/*
 * Copyright 2014 ZXing authors
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
 * Copyright 2014 ZXing authors
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
class ZXAztecToken: NSObject {
    private var _previous: ZXAztecToken!
    @objc var previous: ZXAztecToken! {
        return self._previous
    }

    @objc
    init(previous: ZXAztecToken!) {
        if self = super.init() {
            _previous = previous
        }

        return self
    }

    @objc
    static func empty() -> ZXAztecToken? {
        return ZXAztecSimpleToken(previous: nil, value: 0, bitCount: 0)
    }
    @objc
    func add(_ value: CInt, bitCount: CInt) -> ZXAztecToken? {
        return ZXAztecSimpleToken(previous: self, value: value, bitCount: bitCount)
    }
    @objc
    func addBinaryShift(_ start: CInt, byteCount: CInt) -> ZXAztecToken? {
        //  int bitCount = (byteCount * 8) + (byteCount <= 31 ? 10 : byteCount <= 62 ? 20 : 21);
        return ZXAztecBinaryShiftToken(previous: self, binaryShiftStart: start, binaryShiftByteCount: byteCount)
    }
    @objc
    func appendTo(_ bitArray: ZXBitArray!, text: ZXByteArray!) {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
}