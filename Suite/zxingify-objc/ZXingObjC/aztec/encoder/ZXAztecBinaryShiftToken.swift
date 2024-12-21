// Preprocessor directives found in file:
// #import "ZXAztecToken.h"
// #import "ZXAztecBinaryShiftToken.h"
// #import "ZXBitArray.h"
// #import "ZXByteArray.h"
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
class ZXAztecBinaryShiftToken: ZXAztecToken {
    private var _binaryShiftStart: int16_t
    private var _binaryShiftByteCount: int16_t

    @objc
    init(previous: ZXAztecToken!, binaryShiftStart: CInt, binaryShiftByteCount: CInt) {
        if self = super.init(previous: previous) {
            _binaryShiftStart = binaryShiftStart as? int16_t
            _binaryShiftByteCount = binaryShiftByteCount as? int16_t
        }

        return self
    }

    @objc
    func appendTo(_ bitArray: ZXBitArray!, text: ZXByteArray!) {
        var i: CInt = 0

        while i < self.binaryShiftByteCount {
            defer {
                i += 1
            }

            if i == 0 || (i == 31 && self.binaryShiftByteCount <= 62) {
                // We need a header before the first character, and before
                // character 31 when the total byte code is <= 62
                bitArray.appendBits(31, numBits: 5) // BINARY_SHIFT

                if self.binaryShiftByteCount > 62 {
                    bitArray.appendBits(self.binaryShiftByteCount - 31, numBits: 16)
                } else if i == 0 {
                    // 1 <= binaryShiftByteCode <= 62
                    bitArray.appendBits(min(self.binaryShiftByteCount, 31), numBits: 5)
                } else {
                    // 32 <= binaryShiftCount <= 62 and i == 31
                    bitArray.appendBits(self.binaryShiftByteCount - 31, numBits: 5)
                }
            }

            bitArray.appendBits(text.array[self.binaryShiftStart + i], numBits: 8)
        }
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
extension ZXAztecBinaryShiftToken {
    @objc var binaryShiftStart: int16_t {
        return self._binaryShiftStart
    }
    @objc var binaryShiftByteCount: int16_t {
        return self._binaryShiftByteCount
    }
}