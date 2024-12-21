import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXBitSource.h"
// #import "ZXByteArray.h"
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
 * This provides an easy abstraction to read bits at a time from a sequence of bytes, where the
 * number of bits read is not often a multiple of 8.
 *
 * This class is thread-safe but not reentrant -- unless the caller modifies the bytes array
 * it passed in, in which case all bets are off.
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
 * This provides an easy abstraction to read bits at a time from a sequence of bytes, where the
 * number of bits read is not often a multiple of 8.
 *
 * This class is thread-safe but not reentrant -- unless the caller modifies the bytes array
 * it passed in, in which case all bets are off.
 */
@objc
class ZXBitSource: NSObject {
    private var _bytes: ZXByteArray!
    /**
 * @return index of next bit in current byte which would be read by the next call to `readBits:`.
 */
    @objc var bitOffset: CInt = 0
    /**
 * @return index of next byte in input byte array which would be read by the next call to `readBits:`.
 */
    @objc var byteOffset: CInt = 0

    @objc
    init(bytes: ZXByteArray!) {
        if self = super.init() {
            _bytes = bytes
        }

        return self
    }

    /**
 * @param numBits number of bits to read
 * @return int representing the bits read. The bits will appear as the least-significant
 *         bits of the int
 * @throws NSInvalidArgumentException if numBits isn't in [1,32] or more than is available
 */
    /**
 * @param numBits number of bits to read
 * @return int representing the bits read. The bits will appear as the least-significant
 *         bits of the int
 * @throws NSInvalidArgumentException if numBits isn't in [1,32] or more than is available
 */
    @objc
    func readBits(_ numBits: CInt) -> CInt {
        if numBits < 1 || numBits > 32 || numBits > self.available {
            NSException.raise(NSInvalidArgumentException, format: "Invalid number of bits: %d", numBits)
        }

        var result: CInt = 0

        // First, read remainder from current byte
        if self.bitOffset > 0 {
            let bitsLeft = 8 - self.bitOffset
            let toRead = (numBits < bitsLeft) ? numBits : bitsLeft
            let bitsToNotRead = bitsLeft - toRead
            let mask = (0xff >> (8 - toRead)) << bitsToNotRead

            result = (self.bytes.array[self.byteOffset] & mask) >> bitsToNotRead
            numBits -= toRead
            self.bitOffset += toRead

            if self.bitOffset == 8 {
                self.bitOffset = 0
                self.byteOffset += 1
            }
        }

        // Next read whole bytes
        if numBits > 0 {
            while numBits >= 8 {
                result = (result << 8) | (self.bytes.array[self.byteOffset] & 0xff)
                self.byteOffset += 1
                numBits -= 8
            }

            // Finally read a partial byte
            if numBits > 0 {
                let bitsToNotRead = 8 - numBits
                let mask = (0xff >> bitsToNotRead) << bitsToNotRead

                result = (result << numBits) | ((self.bytes.array[self.byteOffset] & mask) >> bitsToNotRead)
                self.bitOffset += numBits
            }
        }

        return result
    }
    /**
 * @return number of bits that can be read successfully
 */
    /**
 * @return number of bits that can be read successfully
 */
    @objc
    func available() -> CInt {
        return 8 * ((self.bytes.length ?? 0) - self.byteOffset) - self.bitOffset
    }
}

// MARK: -
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
extension ZXBitSource {
    @objc var bytes: ZXByteArray! {
        return self._bytes
    }
}