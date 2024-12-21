import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXBitArray.h"
// #import "ZXByteArray.h"
// #import "ZXIntArray.h"
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
 * A simple, fast array of bits, represented compactly by an array of ints internally.
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
 * A simple, fast array of bits, represented compactly by an array of ints internally.
 */
@objc
class ZXBitArray: NSObject, NSCopying {
    private unowned(unsafe) var _bits: UnsafeMutablePointer<int32_t>!
    private var _bitsLength: CInt = 0
    private var _size: CInt = 0
    /**
 * @return underlying array of ints. The first element holds the first 32 bits, and the least
 *         significant bit is bit 0.
 */
    @objc unowned(unsafe) var bits: UnsafeMutablePointer<int32_t>! {
        return self._bits
    }
    @objc var size: CInt {
        return self._size
    }

    @objc
    override init() {
        if self = super.init() {
            _size = 0
            _bits = calloc(1, MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>
            _bitsLength = 1
        }

        return self
    }
    @objc
    convenience init(bits: ZXIntArray!, size: CInt) {
        if self = self.init(size: size) {
            _bits = bits.array
            _bits = malloc(Int(bits.length) * MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>

            memcpy(_bits, bits.array, Int(bits.length) * MemoryLayout.size(ofValue: int32_t))

            _bitsLength = CInt(bits.length)
        }

        return self
    }
    @objc
    init(size: CInt) {
        if self = super.init() {
            _size = size
            _bitsLength = (size + 31) / 32
            _bits = calloc(_bitsLength, MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>
        }

        return self
    }

    deinit {
        if _bits != nil {
            free(_bits)
            _bits = nil
        }
    }

    @objc
    func sizeInBytes() -> CInt {
        return (self.size + 7) / 8
    }
    @objc
    func ensureCapacity(_ size: CInt) {
        if size > self.bitsLength * 32 {
            let newBitsLength = (size + 31) / 32
            // basically realloc
            let newBits: UnsafeMutablePointer<int32_t>! = malloc(Int(newBitsLength) * MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>

            memcpy(newBits, self.bits, Int(self.bitsLength) * MemoryLayout.size(ofValue: int32_t))

            memset(newBits + self.bitsLength, 0, Int(newBitsLength - self.bitsLength) * MemoryLayout.size(ofValue: int32_t))

            free(self.bits)

            self.bits = nil
            self.bits = newBits

            self.bitsLength = newBitsLength
        }
    }
    /**
 * @param i bit to get
 * @return true iff bit i is set
 */
    /**
 * @param i bit to get
 * @return true iff bit i is set
 */
    @objc
    func get(_ i: CInt) -> Bool {
        return (_bits[i / 32] & (1 << (i & 0x1f))) != 0
    }
    /**
 * Sets bit i.
 *
 * @param i bit to set
 */
    /**
 * Sets bit i.
 *
 * @param i bit to set
 */
    @objc
    func set(_ i: CInt) {
        _bits[i / 32] |= 1 << (i & 0x1f)
    }
    /**
 * Flips bit i.
 *
 * @param i bit to set
 */
    /**
 * Flips bit i.
 *
 * @param i bit to set
 */
    @objc
    func flip(_ i: CInt) {
        _bits[i / 32] ^= 1 << (i & 0x1f)
    }
    /**
 * @param from first bit to check
 * @return index of first bit that is set, starting from the given index, or size if none are set
 *  at or beyond this given index
 */
    /**
 * @param from first bit to check
 * @return index of first bit that is set, starting from the given index, or size if none are set
 *  at or beyond this given index
 */
    @objc
    func nextSet(_ from: CInt) -> CInt {
        if from >= self.size {
            return self.size
        }

        var bitsOffset = from / 32
        var currentBits: int32_t = self.bits[bitsOffset]

        // mask off lesser bits first
        currentBits &= ~((1 << (from & 0x1f)) - 1)

        while currentBits == 0 {
            if bitsOffset += 1 == self.bitsLength {
                return self.size
            }

            currentBits = self.bits[bitsOffset]
        }

        let result = (bitsOffset * 32) + self.numberOfTrailingZeros(currentBits)

        return (result > self.size) ? self.size : result
    }
    /**
 * @param from index to start looking for unset bit
 * @return index of next unset bit, or size if none are unset until the end
 * @see nextSet:
 */
    /**
 * @param from index to start looking for unset bit
 * @return index of next unset bit, or size if none are unset until the end
 * @see nextSet:
 */
    @objc
    func nextUnset(_ from: CInt) -> CInt {
        if from >= self.size {
            return self.size
        }

        var bitsOffset = from / 32
        var currentBits: int32_t = ~self.bits[bitsOffset]

        // mask off lesser bits first
        currentBits &= ~((1 << (from & 0x1f)) - 1)

        while currentBits == 0 {
            if bitsOffset += 1 == self.bitsLength {
                return self.size
            }

            currentBits = ~self.bits[bitsOffset]
        }

        let result = (bitsOffset * 32) + self.numberOfTrailingZeros(currentBits)

        return (result > self.size) ? self.size : result
    }
    /**
 * Sets a block of 32 bits, starting at bit i.
 *
 * @param i first bit to set
 * @param newBits the new value of the next 32 bits. Note again that the least-significant bit
 * corresponds to bit i, the next-least-significant to i+1, and so on.
 */
    /**
 * Sets a block of 32 bits, starting at bit i.
 *
 * @param i first bit to set
 * @param newBits the new value of the next 32 bits. Note again that the least-significant bit
 * corresponds to bit i, the next-least-significant to i+1, and so on.
 */
    @objc
    func setBulk(_ i: CInt, newBits: int32_t) {
        _bits[i / 32] = newBits
    }
    /**
 * Sets a range of bits.
 *
 * @param start start of range, inclusive.
 * @param end end of range, exclusive
 */
    /**
 * Sets a range of bits.
 *
 * @param start start of range, inclusive.
 * @param end end of range, exclusive
 */
    @objc
    func setRange(_ start: CInt, end: CInt) {
        if end < start || start < 0 || end > self.size {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"Start greater than end"userInfo:nil];
            */
        }

        if end == start {
            return
        }

        end -= 1 // will be easier to treat this as the last actually set bit -- inclusive

        let firstInt = start / 32
        let lastInt = end / 32
        var i = firstInt

        while i <= lastInt {
            defer {
                i += 1
            }

            let firstBit: CInt = (i > firstInt) ? 0 : start & 0x1f
            let lastBit: CInt = (i < lastInt) ? 31 : end & 0x1f
            // Ones from firstBit to lastBit, inclusive
            let mask = (2 << lastBit) - (1 << firstBit)

            _bits[i] |= mask
        }
    }
    /**
 * Clears all bits (sets to false).
 */
    /**
 * Clears all bits (sets to false).
 */
    @objc
    func clear() {
        memset(self.bits, 0, Int(self.bitsLength) * MemoryLayout.size(ofValue: int32_t))
    }
    /**
 * Efficient method to check if a range of bits is set, or not set.
 *
 * @param start start of range, inclusive.
 * @param end end of range, exclusive
 * @param value if true, checks that bits in range are set, otherwise checks that they are not set
 * @return true iff all bits are set or not set in range, according to value argument
 * @throws NSInvalidArgumentException if end is less than or equal to start
 */
    /**
 * Efficient method to check if a range of bits is set, or not set.
 *
 * @param start start of range, inclusive.
 * @param end end of range, exclusive
 * @param value if true, checks that bits in range are set, otherwise checks that they are not set
 * @return true iff all bits are set or not set in range, according to value argument
 * @throws NSInvalidArgumentException if end is less than or equal to start
 */
    @objc
    func isRange(_ start: CInt, end: CInt, value: Bool) -> Bool {
        if end < start || start < 0 || end > self.size {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"Start greater than end"userInfo:nil];
            */
        }

        if end == start {
            return true // empty range matches
        }

        end -= 1 // will be easier to treat this as the last actually set bit -- inclusive

        let firstInt = start / 32
        let lastInt = end / 32
        var i = firstInt

        while i <= lastInt {
            defer {
                i += 1
            }

            let firstBit: CInt = (i > firstInt) ? 0 : start & 0x1f
            let lastBit: CInt = (i < lastInt) ? 31 : end & 0x1f
            // Ones from firstBit to lastBit, inclusive
            let mask = (2 << lastBit) - (1 << firstBit)

            // Return false if we're looking for 1s and the masked bits[i] isn't all 1s (that is,
            // equals the mask, or we're looking for 0s and the masked portion is not all 0s
            if (_bits[i] & mask) != (value ? mask : 0) {
                return false
            }
        }

        return true
    }
    @objc
    func appendBit(_ bit: Bool) {
        self.ensureCapacity(self.size + 1)

        if bit {
            self.bits[self.size / 32] |= 1 << (self.size & 0x1f)
        }

        self.size += 1
    }
    /**
 * Appends the least-significant bits, from value, in order from most-significant to
 * least-significant. For example, appending 6 bits from 0x000001E will append the bits
 * 0, 1, 1, 1, 1, 0 in that order.
 *
 * @param value in32_t containing bits to append
 * @param numBits bits from value to append
 */
    /**
 * Appends the least-significant bits, from value, in order from most-significant to
 * least-significant. For example, appending 6 bits from 0x000001E will append the bits
 * 0, 1, 1, 1, 1, 0 in that order.
 *
 * @param value in32_t containing bits to append
 * @param numBits bits from value to append
 */
    @objc
    func appendBits(_ value: int32_t, numBits: CInt) {
        if numBits < 0 || numBits > 32 {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"Num bits must be between 0 and 32"userInfo:nil];
            */
        }

        self.ensureCapacity(self.size + numBits)

        var numBitsLeft = numBits

        while numBitsLeft > 0 {
            defer {
                numBitsLeft -= 1
            }

            self.appendBit(((value >> (numBitsLeft - 1)) & 0x1) == 1)
        }
    }
    @objc
    func appendBitArray(_ other: ZXBitArray!) {
        let otherSize = other.size

        self.ensureCapacity(self.size + otherSize)

        var i: CInt = 0

        while i < otherSize {
            defer {
                i += 1
            }

            self.appendBit(other.get(i))
        }
    }
    @objc
    func xor(_ other: ZXBitArray!) {
        if self.size != other.size {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"Sizes don't match"userInfo:nil];
            */
        }

        var i: CInt = 0

        while i < self.bitsLength {
            defer {
                i += 1
            }

            // The last int could be incomplete (i.e. not have 32 bits in
            // it) but there is no problem since 0 XOR 0 == 0.
            self.bits[i] ^= other.bits[i]
        }
    }
    /**
 *
 * @param bitOffset first bit to start writing
 * @param array array to write into. Bytes are written most-significant byte first. This is the opposite
 *  of the internal representation, which is exposed by `bitArray`
 * @param offset position in array to start writing
 * @param numBytes how many bytes to write
 */
    /**
 *
 * @param bitOffset first bit to start writing
 * @param array array to write into. Bytes are written most-significant byte first. This is the opposite
 *  of the internal representation, which is exposed by `bitArray`
 * @param offset position in array to start writing
 * @param numBytes how many bytes to write
 */
    @objc
    func toBytes(_ bitOffset: CInt, array: ZXByteArray!, offset: CInt, numBytes: CInt) {
        var i: CInt = 0

        while i < numBytes {
            defer {
                i += 1
            }

            var theByte: int32_t = 0
            var j: CInt = 0

            while j < 8 {
                defer {
                    j += 1
                }

                if self.get(bitOffset) {
                    theByte |= 1 << (7 - j)
                }

                bitOffset += 1
            }

            array.array[offset + i] = theByte as? int8_t
        }
    }
    /**
 * @return underlying array of ints. The first element holds the first 32 bits, and the least
 *         significant bit is bit 0.
 */
    /**
 * @return underlying array of ints. The first element holds the first 32 bits, and the least
 *         significant bit is bit 0.
 */
    @objc
    func bitArray() -> ZXIntArray {
        let array = ZXIntArray(length: CUnsignedInt(self.bitsLength))

        memcpy(array.array, self.bits, Int(array.length) * MemoryLayout.size(ofValue: int32_t))

        return array
    }
    @objc
    func isEqual(_ o: AnyObject) -> Bool {
        if !o.isKindOfClass(ZXBitArray.self) {
            return false
        }

        let other = o as? ZXBitArray

        if self.size != other?.size {
            return false
        }

        var i: CInt = 0

        while i < self.bitsLength {
            defer {
                i += 1
            }

            if self.bits[i] != other?.bits[i] {
                return false
            }
        }

        return true
    }
    @objc
    func hash() -> UInt {
        if self.bitsLength == 0 {
            return UInt(31 * self.size)
        }

        var bitsHash: UInt = 1
        var i: CInt = 0

        while i < self.bitsLength {
            defer {
                i += 1
            }

            bitsHash = 31 * bitsHash + self.bits[i]
        }

        return UInt(31 * self.size) + bitsHash
    }
    /**
 * Reverses all bits in the array.
 */
    /**
 * Reverses all bits in the array.
 */
    @objc
    func reverse() {
        var newBits: UnsafeMutablePointer<int32_t>! = calloc(self.bitsLength, MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>
        let size = self.size
        // reverse all int's first
        let len = (size - 1) / 32
        let oldBitsLen = len + 1
        var i: CInt = 0

        while i < oldBitsLen {
            defer {
                i += 1
            }

            var x: CLong = CLong(self.bits[i])

            x = ((x >> 1) & 0x55555555) | ((x & 0x55555555) << 1)
            x = ((x >> 2) & 0x33333333) | ((x & 0x33333333) << 2)
            x = ((x >> 4) & 0xf0f0f0f) | ((x & 0xf0f0f0f) << 4)
            x = ((x >> 8) & 0xff00ff) | ((x & 0xff00ff) << 8)
            x = ((x >> 16) & 0xffff) | ((x & 0xffff) << 16)

            newBits[len - i] = x as? int32_t
        }

        // now correct the int's if the bit size isn't a multiple of 32
        if size != oldBitsLen * 32 {
            let leftOffset = oldBitsLen * 32 - size
            var mask: CInt = 1
            var i: CInt = 0

            while i < 31 - leftOffset {
                defer {
                    i += 1
                }

                mask = (mask << 1) | 1
            }

            var currentInt: int32_t = (newBits[0] >> leftOffset) & mask
            var i: CInt = 1

            while i < oldBitsLen {
                defer {
                    i += 1
                }

                let nextInt: int32_t = newBits[i]

                currentInt |= nextInt << (32 - leftOffset)
                newBits[i - 1] = currentInt
                currentInt = (nextInt >> leftOffset) & mask
            }

            newBits[oldBitsLen - 1] = currentInt
        }

        if self.bits != nil {
            free(self.bits)
        }

        self.bits = newBits
    }
    @objc
    func description() -> String? {
        let result = NSMutableString()
        var i: CInt = 0

        while i < self.size {
            defer {
                i += 1
            }

            if (i & 0x7) == 0 {
                result.append(" ")
            }

            result.append(self.get(i) ? "X" : ".")
        }

        return result
    }
    // Ported from OpenJDK Integer.numberOfTrailingZeros implementation
    @objc
    func numberOfTrailingZeros(_ i: int32_t) -> int32_t {
        var y: int32_t

        if i == 0 {
            return 32
        }

        var n: int32_t = 31

        y = i << 16

        if y != 0 {
            n = n - 16
            i = y
        }

        y = i << 8

        if y != 0 {
            n = n - 8
            i = y
        }

        y = i << 4

        if y != 0 {
            n = n - 4
            i = y
        }

        y = i << 2

        if y != 0 {
            n = n - 2
            i = y
        }

        return n - ((i << 1) as? uint32_t >> 31) as? int32_t
    }
    @objc
    func copyWithZone(_ zone: UnsafeMutablePointer<NSZone>!) -> AnyObject? {
        let copy: ZXBitArray! = ZXBitArray.allocWithZone(zone).init(size: self.size)

        memcpy(copy.bits, self.bits, Int(self.size) * MemoryLayout.size(ofValue: int32_t))

        return copy
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
extension ZXBitArray {
    @objc unowned(unsafe) var bits: UnsafeMutablePointer<int32_t>! {
        get {
            return self._bits
        }
        set {
            self._bits = newValue
        }
    }
    @objc var bitsLength: CInt {
        get {
            return self._bitsLength
        }
        set {
            self._bitsLength = newValue
        }
    }
    @objc var size: CInt {
        get {
            return self._size
        }
        set {
            self._size = newValue
        }
    }
}