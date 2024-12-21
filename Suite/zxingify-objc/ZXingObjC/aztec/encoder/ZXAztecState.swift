// Preprocessor directives found in file:
// #import "ZXAztecHighLevelEncoder.h"
// #import "ZXAztecState.h"
// #import "ZXAztecToken.h"
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
/**
 * State represents all information about a sequence necessary to generate the current output.
 * Note that a state is immutable.
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
class ZXAztecState: NSObject {
    private var _mode: CInt = 0
    private var _token: ZXAztecToken!
    private var _binaryShiftByteCount: CInt = 0
    private var _bitCount: CInt = 0
    // The current mode of the encoding (or the mode to which we'll return if
    // we're in Binary Shift mode.
    @objc var mode: CInt {
        return self._mode
    }
    // The list of tokens that we output.  If we are in Binary Shift mode, this
    // token list does *not* yet included the token for those bytes
    @objc var token: ZXAztecToken! {
        return self._token
    }
    // If non-zero, the number of most recent bytes that should be output
    // in Binary Shift mode.
    @objc var binaryShiftByteCount: CInt {
        return self._binaryShiftByteCount
    }
    // The total number of bits generated (including Binary Shift).
    @objc var bitCount: CInt {
        return self._bitCount
    }

    @objc
    init(token: ZXAztecToken!, mode: CInt, binaryBytes: CInt, bitCount: CInt) {
        if self = super.init() {
            _token = token

            _mode = mode

            _binaryShiftByteCount = binaryBytes

            _bitCount = bitCount
        }

        return self
    }

    @objc
    static func initialState() -> ZXAztecState? {
        return ZXAztecState(token: ZXAztecToken.empty(), mode: ZX_AZTEC_MODE_UPPER, binaryBytes: 0, bitCount: 0)
    }
    // Create a new state representing this state with a latch to a (not
    // necessary different) mode, and then a code.
    @objc
    func latchAndAppend(_ mode: CInt, value: CInt) -> ZXAztecState? {
        var bitCount = self.bitCount
        var token = self.token

        if mode != self.mode {
            let latch: CInt = ZX_AZTEC_LATCH_TABLE[self.mode][mode]

            token = token?.add(latch & 0xffff, bitCount: latch >> 16)
            bitCount += latch >> 16
        }

        let latchModeBitCount: CInt = (mode == ZX_AZTEC_MODE_DIGIT) ? 4 : 5

        token = token?.add(value, bitCount: latchModeBitCount)

        return ZXAztecState(token: token, mode: mode, binaryBytes: 0, bitCount: bitCount + latchModeBitCount)
    }
    // Create a new state representing this state, with a temporary shift
    // to a different mode to output a single value.
    @objc
    func shiftAndAppend(_ mode: CInt, value: CInt) -> ZXAztecState? {
        //assert binaryShiftByteCount == 0 && this.mode != mode;
        var token = self.token
        let thisModeBitCount: CInt = (self.mode == ZX_AZTEC_MODE_DIGIT) ? 4 : 5

        // Shifts exist only to UPPER and PUNCT, both with tokens size 5.
        token = token?.add(ZX_AZTEC_SHIFT_TABLE[self.mode][mode], bitCount: thisModeBitCount)
        token = token?.add(value, bitCount: 5)

        return ZXAztecState(token: token, mode: self.mode, binaryBytes: 0, bitCount: self.bitCount + thisModeBitCount + 5)
    }
    // Create a new state representing this state, but an additional character
    // output in Binary Shift mode.
    @objc
    func addBinaryShiftChar(_ index: CInt) -> ZXAztecState {
        var token = self.token
        var mode = self.mode
        var bitCount = self.bitCount

        if self.mode == ZX_AZTEC_MODE_PUNCT || self.mode == ZX_AZTEC_MODE_DIGIT {
            let latch: CInt = ZX_AZTEC_LATCH_TABLE[mode][ZX_AZTEC_MODE_UPPER]

            token = token?.add(latch & 0xffff, bitCount: latch >> 16)
            bitCount += latch >> 16
            mode = ZX_AZTEC_MODE_UPPER
        }

        let deltaBitCount: CInt = (self.binaryShiftByteCount == 0 || self.binaryShiftByteCount == 31) ? 18 : (self.binaryShiftByteCount == 62) ? 9 : 8
        var result: ZXAztecState! = ZXAztecState(token: token, mode: mode, binaryBytes: self.binaryShiftByteCount + 1, bitCount: bitCount + deltaBitCount)

        if result.binaryShiftByteCount == 2047 + 31 {
            // The string is as long as it's allowed to be.  We should end it.
            result = result.endBinaryShift(index + 1)
        }

        return result
    }
    // Create the state identical to this one, but we are no longer in
    // Binary Shift mode.
    @objc
    func endBinaryShift(_ index: CInt) -> ZXAztecState? {
        if self.binaryShiftByteCount == 0 {
            return self
        }

        var token = self.token

        token = token?.addBinaryShift(index - self.binaryShiftByteCount, byteCount: self.binaryShiftByteCount)

        return ZXAztecState(token: token, mode: self.mode, binaryBytes: 0, bitCount: self.bitCount)
    }
    // Returns true if "this" state is better (or equal) to be in than "that"
    // state under all possible circumstances.
    @objc
    func isBetterThanOrEqualTo(_ other: ZXAztecState!) -> Bool {
        var newModeBitCount: CInt = self.bitCount + (ZX_AZTEC_LATCH_TABLE[self.mode][other.mode] >> 16)

        if self.binaryShiftByteCount < other.binaryShiftByteCount {
            // add additional B/S encoding cost of other, if any
            newModeBitCount += self.calculateBinaryShiftCost(other) - self.calculateBinaryShiftCost(self)
        } else if self.binaryShiftByteCount > other.binaryShiftByteCount && other.binaryShiftByteCount > 0 {
            // maximum possible additional cost (we end up exceeding the 31 byte boundary and other state can stay beneath it)
            newModeBitCount += 10
        }

        return newModeBitCount <= other.bitCount
    }
    @objc
    func calculateBinaryShiftCost(_ state: ZXAztecState!) -> CInt {
        if state.binaryShiftByteCount > 62 {
            return 21 // B/S with extended length
        }

        if state.binaryShiftByteCount > 31 {
            return 20 // two B/S
        }

        if state.binaryShiftByteCount > 0 {
            return 10 // one B/S
        }

        return 0
    }
    @objc
    func toBitArray(_ text: ZXByteArray!) -> ZXBitArray {
        // Reverse the tokens, so that they are in the order that they should
        // be output
        let symbols = NSMutableArray()
        var token = self.endBinaryShift(CInt(text.length)).token

        while token != nil {
            defer {
                token = token?.previous
            }

            symbols.insertObject(token, atIndex: 0)
        }

        let bitArray = ZXBitArray()

        // Add each token to the result.
        for symbol in symbols {
            symbol.appendTo(bitArray, text: text)
        }

        return bitArray
    }
    @objc
    func description() -> String? {
        return String(format: "%@ bits=%d bytes=%d", ZX_AZTEC_MODE_NAMES[Int(self.mode)], self.bitCount, self.binaryShiftByteCount)
    }
}