import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXDataMatrixDefaultPlacement.h"
/*
 * Copyright 2013 ZXing authors
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
 * Symbol Character Placement Program. Adapted from Annex M.1 in ISO/IEC 16022:2000(E).
 */
/*
 * Copyright 2013 ZXing authors
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
 * Symbol Character Placement Program. Adapted from Annex M.1 in ISO/IEC 16022:2000(E).
 */
/*
 * Copyright 2013 ZXing authors
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
class ZXDataMatrixDefaultPlacement: NSObject {
    private var _codewords: String!
    private var _numrows: CInt = 0
    private var _numcols: CInt = 0
    private unowned(unsafe) var _bits: UnsafeMutablePointer<int8_t>!
    private var _bitsLen: CInt = 0
    @objc var codewords: String! {
        return self._codewords
    }
    @objc var numrows: CInt {
        return self._numrows
    }
    @objc var numcols: CInt {
        return self._numcols
    }
    @objc unowned(unsafe) var bits: UnsafeMutablePointer<int8_t>! {
        return self._bits
    }
    @objc var bitsLen: CInt {
        return self._bitsLen
    }

    @objc
    init(codewords: String!, numcols: CInt, numrows: CInt) {
        if self = super.init() {
            _codewords = codewords.copy()

            _numcols = numcols

            _numrows = numrows

            _bitsLen = numcols * numrows

            _bits = malloc(Int(_bitsLen) * MemoryLayout.size(ofValue: int8_t)) as? UnsafeMutablePointer<int8_t>

            memset(_bits, 1, _bitsLen) //Initialize with "not set" value
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
    func bitAtCol(_ col: CInt, row: CInt) -> Bool {
        return self.bits[row * self.numcols + col] == 1
    }
    @objc
    func setBitAtCol(_ col: CInt, row: CInt, bit: Bool) {
        self.bits[row * self.numcols + col] = bit ? 1 as? int8_t : 0 as? int8_t
    }
    @objc
    func hasBitAtCol(_ col: CInt, row: CInt) -> Bool {
        return self.bits[row * self.numcols + col] >= 0
    }
    @objc
    func place() {
        var pos: CInt = 0
        var row: CInt = 4
        var col: CInt = 0

        repeat {
            /* repeatedly first check for one of the special corner cases, then... */
            if (row == self.numrows) && (col == 0) {
                self.corner1(pos += 1)
            }

            if (row == self.numrows - 2) && (col == 0) && ((self.numcols % 4) != 0) {
                self.corner2(pos += 1)
            }

            if (row == self.numrows - 2) && (col == 0) && (self.numcols % 8 == 4) {
                self.corner3(pos += 1)
            }

            if (row == self.numrows + 4) && (col == 2) && ((self.numcols % 8) == 0) {
                self.corner4(pos += 1)
            }

            /* sweep upward diagonally, inserting successive characters... */
            repeat {
                if (row < self.numrows) && (col >= 0) && !self.hasBitAtCol(col, row: row) {
                    self.utahAtRow(row, col: col, pos: pos += 1)
                }

                row -= 2
                col += 2
            } while row >= 0 && (col < self.numcols)

            row += 1
            col += 3

            /* and then sweep downward diagonally, inserting successive characters, ... */
            repeat {
                if (row >= 0) && (col < self.numcols) && !self.hasBitAtCol(col, row: row) {
                    self.utahAtRow(row, col: col, pos: pos += 1)
                }

                row += 2
                col -= 2
            } while (row < self.numrows) && (col >= 0)

            row += 3
            col += 1
        } while (row < self.numrows) || (col < self.numcols)

        /* ...until the entire array is scanned */
        /* Lastly, if the lower righthand corner is untouched, fill in fixed pattern */
        if !self.hasBitAtCol(self.numcols - 1, row: self.numrows - 1) {
            self.setBitAtCol(self.numcols - 1, row: self.numrows - 1, bit: true)
            self.setBitAtCol(self.numcols - 2, row: self.numrows - 2, bit: true)
        }
    }
    @objc
    func moduleAtRow(_ row: CInt, col: CInt, pos: CInt, bit: CInt) {
        if row < 0 {
            row += self.numrows
            col += 4 - ((self.numrows + 4) % 8)
        }

        if col < 0 {
            col += self.numcols
            row += 4 - ((self.numcols + 4) % 8)
        }

        // Note the conversion:
        var v: CInt = self.codewords.characterAtIndex(pos)

        v &= 1 << (8 - bit)
        self.setBitAtCol(col, row: row, bit: v != 0)
    }
    /**
 * Places the 8 bits of a utah-shaped symbol character in ECC200.
 *
 * @param row the row
 * @param col the column
 * @param pos character position
 */
    @objc
    func utahAtRow(_ row: CInt, col: CInt, pos: CInt) {
        self.moduleAtRow(row - 2, col: col - 2, pos: pos, bit: 1)
        self.moduleAtRow(row - 2, col: col - 1, pos: pos, bit: 2)
        self.moduleAtRow(row - 1, col: col - 2, pos: pos, bit: 3)
        self.moduleAtRow(row - 1, col: col - 1, pos: pos, bit: 4)
        self.moduleAtRow(row - 1, col: col, pos: pos, bit: 5)
        self.moduleAtRow(row, col: col - 2, pos: pos, bit: 6)
        self.moduleAtRow(row, col: col - 1, pos: pos, bit: 7)
        self.moduleAtRow(row, col: col, pos: pos, bit: 8)
    }
    @objc
    func corner1(_ pos: CInt) {
        self.moduleAtRow(self.numrows - 1, col: 0, pos: pos, bit: 1)
        self.moduleAtRow(self.numrows - 1, col: 1, pos: pos, bit: 2)
        self.moduleAtRow(self.numrows - 1, col: 2, pos: pos, bit: 3)
        self.moduleAtRow(0, col: self.numcols - 2, pos: pos, bit: 4)
        self.moduleAtRow(0, col: self.numcols - 1, pos: pos, bit: 5)
        self.moduleAtRow(1, col: self.numcols - 1, pos: pos, bit: 6)
        self.moduleAtRow(2, col: self.numcols - 1, pos: pos, bit: 7)
        self.moduleAtRow(3, col: self.numcols - 1, pos: pos, bit: 8)
    }
    @objc
    func corner2(_ pos: CInt) {
        self.moduleAtRow(self.numrows - 3, col: 0, pos: pos, bit: 1)
        self.moduleAtRow(self.numrows - 2, col: 0, pos: pos, bit: 2)
        self.moduleAtRow(self.numrows - 1, col: 0, pos: pos, bit: 3)
        self.moduleAtRow(0, col: self.numcols - 4, pos: pos, bit: 4)
        self.moduleAtRow(0, col: self.numcols - 3, pos: pos, bit: 5)
        self.moduleAtRow(0, col: self.numcols - 2, pos: pos, bit: 6)
        self.moduleAtRow(0, col: self.numcols - 1, pos: pos, bit: 7)
        self.moduleAtRow(1, col: self.numcols - 1, pos: pos, bit: 8)
    }
    @objc
    func corner3(_ pos: CInt) {
        self.moduleAtRow(self.numrows - 3, col: 0, pos: pos, bit: 1)
        self.moduleAtRow(self.numrows - 2, col: 0, pos: pos, bit: 2)
        self.moduleAtRow(self.numrows - 1, col: 0, pos: pos, bit: 3)
        self.moduleAtRow(0, col: self.numcols - 2, pos: pos, bit: 4)
        self.moduleAtRow(0, col: self.numcols - 1, pos: pos, bit: 5)
        self.moduleAtRow(1, col: self.numcols - 1, pos: pos, bit: 6)
        self.moduleAtRow(2, col: self.numcols - 1, pos: pos, bit: 7)
        self.moduleAtRow(3, col: self.numcols - 1, pos: pos, bit: 8)
    }
    @objc
    func corner4(_ pos: CInt) {
        self.moduleAtRow(self.numrows - 1, col: 0, pos: pos, bit: 1)
        self.moduleAtRow(self.numrows - 1, col: self.numcols - 1, pos: pos, bit: 2)
        self.moduleAtRow(0, col: self.numcols - 3, pos: pos, bit: 3)
        self.moduleAtRow(0, col: self.numcols - 2, pos: pos, bit: 4)
        self.moduleAtRow(0, col: self.numcols - 1, pos: pos, bit: 5)
        self.moduleAtRow(1, col: self.numcols - 3, pos: pos, bit: 6)
        self.moduleAtRow(1, col: self.numcols - 2, pos: pos, bit: 7)
        self.moduleAtRow(1, col: self.numcols - 1, pos: pos, bit: 8)
    }
}