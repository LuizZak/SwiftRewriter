// Preprocessor directives found in file:
// #import "ZXAztecToken.h"
// #import "ZXAztecSimpleToken.h"
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
@objc
class ZXAztecSimpleToken: ZXAztecToken {
    private var _value: int16_t
    private var _bitCount: int16_t

    @objc
    init(previous: ZXAztecToken!, value: CInt, bitCount: CInt) {
        if self = super.init(previous: previous) {
            _value = value as? int16_t
            _bitCount = bitCount as? int16_t
        }

        return self
    }

    @objc
    func appendTo(_ bitArray: ZXBitArray!, text: ZXByteArray!) {
        bitArray.appendBits(self.value, numBits: self.bitCount)
    }
    @objc
    func description() -> String? {
        var value = self.value & ((1 << self.bitCount) - 1)

        value |= 1 << self.bitCount

        let str = NSMutableString()
        var i = value | (1 << self.bitCount)

        while i > 0 {
            defer {
                i >>= 1
            }

            str.insert((i & 1) ? "1" : "0", at: 0)
        }

        return String(format: "<%@>", str.substringFromIndex(1))
    }
}

// MARK: -
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
extension ZXAztecSimpleToken {
    // For normal words, indicates value and bitCount
    @objc var value: int16_t {
        return self._value
    }
    @objc var bitCount: int16_t {
        return self._bitCount
    }
}