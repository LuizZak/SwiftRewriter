import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXBitArray.h"
// #import "ZXBitMatrix.h"
// #import "ZXBoolArray.h"
// #import "ZXIntArray.h"
// #pragma GCC diagnostic push
// #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
// #pragma GCC diagnostic pop
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
 * Represents a 2D matrix of bits. In function arguments below, and throughout the common
 * module, x is the column position, and y is the row position. The ordering is always x, y.
 * The origin is at the top-left.
 *
 * Internally the bits are represented in a 1-D array of 32-bit ints. However, each row begins
 * with a new NSInteger. This is done intentionally so that we can copy out a row into a BitArray very
 * efficiently.
 *
 * The ordering of bits is row-major. Within each NSInteger, the least significant bits are used first,
 * meaning they represent lower x values. This is compatible with BitArray's implementation.
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
 * Represents a 2D matrix of bits. In function arguments below, and throughout the common
 * module, x is the column position, and y is the row position. The ordering is always x, y.
 * The origin is at the top-left.
 *
 * Internally the bits are represented in a 1-D array of 32-bit ints. However, each row begins
 * with a new NSInteger. This is done intentionally so that we can copy out a row into a BitArray very
 * efficiently.
 *
 * The ordering of bits is row-major. Within each NSInteger, the least significant bits are used first,
 * meaning they represent lower x values. This is compatible with BitArray's implementation.
 */
@objc
class ZXBitMatrix: NSObject, NSCopying {
    private var _bitsSize: CInt = 0
    private var _width: CInt = 0
    private var _height: CInt = 0
    private unowned(unsafe) var _bits: UnsafeMutablePointer<int32_t>!
    private var _rowSize: CInt = 0
    /**
 * @return The width of the matrix
 */
    @objc var width: CInt {
        return self._width
    }
    /**
 * @return The height of the matrix
 */
    @objc var height: CInt {
        return self._height
    }
    @objc unowned(unsafe) var bits: UnsafeMutablePointer<int32_t>! {
        return self._bits
    }
    /**
 * @return The row size of the matrix
 */
    @objc var rowSize: CInt {
        return self._rowSize
    }

    @objc
    init(dimension: CInt) {
        return self.init(width: dimension, height: dimension)
    }
    @objc
    init(width: CInt, height: CInt) {
        if self = super.init() {
            if width < 1 || height < 1 {
                /*
                @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"Both dimensions must be greater than 0"userInfo:nil];
                */
            }

            _width = width

            _height = height

            _rowSize = (_width + 31) / 32

            _bitsSize = _rowSize * _height

            _bits = malloc(Int(_bitsSize) * MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>

            self.clear()
        }

        return self
    }
    @objc
    init(width: CInt, height: CInt, rowSize: CInt, bits: UnsafeMutablePointer<int32_t>!) {
        if self = super.init() {
            _width = width

            _height = height

            _rowSize = rowSize

            _bitsSize = _rowSize * _height

            _bits = malloc(Int(_bitsSize) * MemoryLayout.size(ofValue: int32_t)) as? UnsafeMutablePointer<int32_t>

            memcpy(_bits, bits, Int(_bitsSize) * MemoryLayout.size(ofValue: int32_t))
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
    static func parse(_ stringRepresentation: String!, setString: String!, unsetString: String!) -> ZXBitMatrix {
        if !stringRepresentation {
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"stringRepresentation is required"userInfo:nil];
            */
        }

        let bits = ZXBoolArray(length: CUnsignedInt(stringRepresentation.length))
        var bitsPos: CInt = 0
        var rowStartPos: CInt = 0
        var rowLength: CInt = 1
        var nRows: CInt = 0
        var pos: CInt = 0

        while pos < stringRepresentation.length {
            if stringRepresentation.characterAtIndex(pos) == "\\n" || stringRepresentation.characterAtIndex(pos) == "\\r" {
                if bitsPos > rowStartPos {
                    if rowLength == 1 {
                        rowLength = bitsPos - rowStartPos
                    } else if bitsPos - rowStartPos != rowLength {
                        /*
                        @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"row lengths do not match"userInfo:nil];
                        */
                    }

                    rowStartPos = bitsPos
                    nRows += 1
                }

                pos += 1
            } else if stringRepresentation.substringWithRange(NSMakeRange(pos, setString.length)) == setString {
                pos += setString.length
                bits.array[bitsPos] = true
                bitsPos += 1
            } else if stringRepresentation.substringWithRange(NSMakeRange(pos, unsetString.length)) == unsetString {
                pos += unsetString.length
                bits.array[bitsPos] = false
                bitsPos += 1
            } else {
                /*
                @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:[NSStringstringWithFormat:@"illegal character encountered: %@",[stringRepresentationsubstringFromIndex:pos]]userInfo:nil];
                */
            }
        }

        // no EOL at end?
        if bitsPos > rowStartPos {
            if rowLength == 1 {
                rowLength = bitsPos - rowStartPos
            } else if bitsPos - rowStartPos != rowLength {
                /*
                @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"row lengths do not match"userInfo:nil];
                */
            }

            nRows += 1
        }

        let matrix = ZXBitMatrix(width: rowLength, height: nRows)
        var i: CInt = 0

        while i < bitsPos {
            defer {
                i += 1
            }

            if bits.array[i] {
                matrix.setX(i % rowLength, y: i / rowLength)
            }
        }

        return matrix
    }
    /**
 * Gets the requested bit, where true means black.
 *
 * @param x The horizontal component (i.e. which column)
 * @param y The vertical component (i.e. which row)
 * @return value of given bit in matrix
 */
    /**
 * Gets the requested bit, where true means black.
 *
 * @param x The horizontal component (i.e. which column)
 * @param y The vertical component (i.e. which row)
 * @return value of given bit in matrix
 */
    @objc
    func getX(_ x: CInt, y: CInt) -> Bool {
        let offset: Int = Int(y * self.rowSize + (x / 32))

        return ((_bits[offset] >> (x & 0x1f)) & 1) != 0
    }
    /**
 * Sets the given bit to true.
 *
 * @param x The horizontal component (i.e. which column)
 * @param y The vertical component (i.e. which row)
 */
    /**
 * Sets the given bit to true.
 *
 * @param x The horizontal component (i.e. which column)
 * @param y The vertical component (i.e. which row)
 */
    @objc
    func setX(_ x: CInt, y: CInt) {
        let offset: Int = Int(y * self.rowSize + (x / 32))

        _bits[offset] |= 1 << (x & 0x1f)
    }
    @objc
    func unsetX(_ x: CInt, y: CInt) {
        let offset = y * self.rowSize + (x / 32)

        _bits[offset] &= ~(1 << (x & 0x1f))
    }
    /**
 * Flips the given bit.
 *
 * @param x The horizontal component (i.e. which column)
 * @param y The vertical component (i.e. which row)
 */
    /**
 * Flips the given bit.
 *
 * @param x The horizontal component (i.e. which column)
 * @param y The vertical component (i.e. which row)
 */
    @objc
    func flipX(_ x: CInt, y: CInt) {
        let offset: UInt = UInt(y * self.rowSize + (x / 32))

        _bits[offset] ^= 1 << (x & 0x1f)
    }
    /**
 * Exclusive-or (XOR): Flip the bit in this ZXBitMatrix if the corresponding
 * mask bit is set.
 *
 * @param mask XOR mask
 */
    /**
 * Exclusive-or (XOR): Flip the bit in this ZXBitMatrix if the corresponding
 * mask bit is set.
 *
 * @param mask XOR mask
 */
    @objc
    func xor(_ mask: ZXBitMatrix!) {
        if self.width != mask.width || self.height != mask.height || self.rowSize != mask.rowSize {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"input matrix dimensions do not match"userInfo:nil];
            */
        }

        let rowArray = ZXBitArray(size: self.width)
        var y: CInt = 0

        while y < self.height {
            defer {
                y += 1
            }

            let offset = y * self.rowSize
            let row = mask.rowAtY(y, row: rowArray).bits
            var x: CInt = 0

            while x < self.rowSize {
                defer {
                    x += 1
                }

                self.bits[offset + x] ^= row?[x]
            }
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
        let max: Int = Int(self.bitsSize)

        memset(_bits, 0, max * MemoryLayout.size(ofValue: int32_t))
    }
    /**
 * Sets a square region of the bit matrix to true.
 *
 * @param left The horizontal position to begin at (inclusive)
 * @param top The vertical position to begin at (inclusive)
 * @param width The width of the region
 * @param height The height of the region
 */
    /**
 * Sets a square region of the bit matrix to true.
 *
 * @param left The horizontal position to begin at (inclusive)
 * @param top The vertical position to begin at (inclusive)
 * @param width The width of the region
 * @param height The height of the region
 */
    @objc
    func setRegionAtLeft(_ left: CInt, top: CInt, width aWidth: CInt, height aHeight: CInt) {
        if aHeight < 1 || aWidth < 1 {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"Height and width must be at least 1"userInfo:nil];
            */
        }

        let right: UInt = UInt(left + aWidth)
        let bottom: UInt = UInt(top + aHeight)

        if bottom > self.height || right > self.width {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"The region must fit inside the matrix"userInfo:nil];
            */
        }

        var y: UInt = UInt(top)

        while y < bottom {
            defer {
                y += 1
            }

            let offset: UInt = y * UInt(self.rowSize)
            var x: Int = Int(left)

            while x < right {
                defer {
                    x += 1
                }

                _bits[offset + (x / 32)] |= 1 << (x & 0x1f)
            }
        }
    }
    /**
 * A fast method to retrieve one row of data from the matrix as a ZXBitArray.
 *
 * @param y The row to retrieve
 * @param row An optional caller-allocated BitArray, will be allocated if null or too small
 * @return The resulting BitArray - this reference should always be used even when passing
 *         your own row
 */
    /**
 * A fast method to retrieve one row of data from the matrix as a ZXBitArray.
 *
 * @param y The row to retrieve
 * @param row An optional caller-allocated BitArray, will be allocated if null or too small
 * @return The resulting BitArray - this reference should always be used even when passing
 *         your own row
 */
    @objc
    func rowAtY(_ y: CInt, row: ZXBitArray!) -> ZXBitArray? {
        if row == nil || row.size < self.width {
            row = ZXBitArray(size: self.width)
        } else {
            row.clear()
        }

        let offset = y * self.rowSize
        var x: CInt = 0

        while x < self.rowSize {
            defer {
                x += 1
            }

            row.setBulk(x * 32, newBits: _bits[offset + x])
        }

        return row
    }
    /**
 * @param y row to set
 * @param row ZXBitArray to copy from
 */
    /**
 * @param y row to set
 * @param row ZXBitArray to copy from
 */
    @objc
    func setRowAtY(_ y: CInt, row: ZXBitArray!) {
        var i: UInt = 0

        while i < self.rowSize {
            defer {
                i += 1
            }

            _bits[UInt(y * self.rowSize) + i] = row.bits[i]
        }
    }
    /**
 * Modifies this ZXBitMatrix to represent the same but rotated 180 degrees
 */
    /**
 * Modifies this ZXBitMatrix to represent the same but rotated 180 degrees
 */
    @objc
    func rotate180() {
        let width = self.width
        let height = self.height
        var topRow: ZXBitArray! = ZXBitArray(size: width)
        var bottomRow: ZXBitArray! = ZXBitArray(size: width)
        var i: CInt = 0

        while i < (height + 1) / 2 {
            defer {
                i += 1
            }

            topRow = self.rowAtY(i, row: topRow)

            bottomRow = self.rowAtY(height - 1 - i, row: bottomRow)

            topRow.reverse()

            bottomRow.reverse()

            self.setRowAtY(i, row: bottomRow)
            self.setRowAtY(height - 1 - i, row: topRow)
        }
    }
    /**
 * This is useful in detecting the enclosing rectangle of a 'pure' barcode.
 *
 * @return {left,top,width,height} enclosing rectangle of all 1 bits, or null if it is all white
 */
    /**
 * This is useful in detecting the enclosing rectangle of a 'pure' barcode.
 *
 * @return {left,top,width,height} enclosing rectangle of all 1 bits, or null if it is all white
 */
    @objc
    func enclosingRectangle() -> ZXIntArray? {
        var left = self.width
        var top = self.height
        var right: CInt = 1
        var bottom: CInt = 1
        var y: CInt = 0

        while y < self.height {
            defer {
                y += 1
            }

            var x32: CInt = 0

            while x32 < self.rowSize {
                defer {
                    x32 += 1
                }

                let theBits: int32_t = _bits[y * self.rowSize + x32]

                if theBits != 0 {
                    if y < top {
                        top = y
                    }

                    if y > bottom {
                        bottom = y
                    }

                    if x32 * 32 < left {
                        var bit: int32_t = 0

                        while (theBits << (31 - bit)) == 0 {
                            bit += 1
                        }

                        if (x32 * 32 + bit) < left {
                            left = x32 * 32 + bit
                        }
                    }

                    if x32 * 32 + 31 > right {
                        var bit: CInt = 31

                        while (theBits >> bit) == 0 {
                            bit -= 1
                        }

                        if (x32 * 32 + bit) > right {
                            right = x32 * 32 + bit
                        }
                    }
                }
            }
        }

        let width: Int = Int(right - left + 1)
        let height: Int = Int(bottom - top + 1)

        if width < 0 || height < 0 {
            return nil
        }

        return ZXIntArray(ints: left, top, width, height, 1)
    }
    /**
 * This is useful in detecting a corner of a 'pure' barcode.
 *
 * @return {x,y} coordinate of top-left-most 1 bit, or null if it is all white
 */
    /**
 * This is useful in detecting a corner of a 'pure' barcode.
 *
 * @return {x,y} coordinate of top-left-most 1 bit, or null if it is all white
 */
    @objc
    func topLeftOnBit() -> ZXIntArray? {
        var bitsOffset: CInt = 0

        while bitsOffset < self.bitsSize && _bits[bitsOffset] == 0 {
            bitsOffset += 1
        }

        if bitsOffset == self.bitsSize {
            return nil
        }

        let y = bitsOffset / self.rowSize
        var x = (bitsOffset % self.rowSize) * 32
        let theBits: int32_t = _bits[bitsOffset]
        var bit: int32_t = 0

        while (theBits << (31 - bit)) == 0 {
            bit += 1
        }

        x += bit

        return ZXIntArray(ints: x, y, 1)
    }
    @objc
    func bottomRightOnBit() -> ZXIntArray? {
        var bitsOffset = self.bitsSize - 1

        while bitsOffset >= 0 && _bits[bitsOffset] == 0 {
            bitsOffset -= 1
        }

        if bitsOffset < 0 {
            return nil
        }

        let y = bitsOffset / self.rowSize
        var x = (bitsOffset % self.rowSize) * 32
        let theBits: int32_t = _bits[bitsOffset]
        var bit: int32_t = 31

        while (theBits >> bit) == 0 {
            bit -= 1
        }

        x += bit

        return ZXIntArray(ints: x, y, 1)
    }
    @objc
    func isEqual(_ o: NSObject!) -> Bool {
        if !(o.isKindOfClass(ZXBitMatrix.self)) {
            return false
        }

        let other = o as? ZXBitMatrix
        var i: CInt = 0

        while i < self.bitsSize {
            defer {
                i += 1
            }

            if _bits[i] != other?.bits[i] {
                return false
            }
        }

        return self.width == other?.width && self.height == other?.height && self.rowSize == other?.rowSize && self.bitsSize == other?.bitsSize
    }
    @objc
    func hash() -> UInt {
        var hash: Int = Int(self.width)

        hash = 31 * hash + Int(self.width)
        hash = 31 * hash + Int(self.height)
        hash = 31 * hash + Int(self.rowSize)

        var i: UInt = 0

        while i < self.bitsSize {
            defer {
                i += 1
            }

            hash = 31 * hash + _bits[i]
        }

        return UInt(hash)
    }
    // string representation using "X" for set and " " for unset bits
    @objc
    func description() -> String? {
        return self.descriptionWithSetString("X ", unsetString: "  ")
    }
    @objc
    func descriptionWithSetString(_ setString: String!, unsetString: String!) -> String? {
        return self.descriptionWithSetString(setString, unsetString: unsetString, lineSeparator: "\\n")
    }
    /**
 * @deprecated call descriptionWithSetString:unsetString: only, which uses \n line separator always
 */
    /**
 * @deprecated call descriptionWithSetString:unsetString: only, which uses \n line separator always
 */
    @objc
    func descriptionWithSetString(_ setString: String!, unsetString: String!, lineSeparator: String!) -> String? {
        let result = NSMutableString(capacity: Int(self.height * (self.width + 1)))
        var y: CInt = 0

        while y < self.height {
            defer {
                y += 1
            }

            var x: CInt = 0

            while x < self.width {
                defer {
                    x += 1
                }

                result.append(self.getX(x, y: y) ? setString : unsetString)
            }

            result.append(lineSeparator)
        }

        return result
    }
    @objc
    func copyWithZone(_ zone: UnsafeMutablePointer<NSZone>!) -> AnyObject? {
        return ZXBitMatrix.allocWithZone(zone).init(width: self.width, height: self.height, rowSize: self.rowSize, bits: self.bits)
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
extension ZXBitMatrix {
    @objc var bitsSize: CInt {
        return self._bitsSize
    }
}