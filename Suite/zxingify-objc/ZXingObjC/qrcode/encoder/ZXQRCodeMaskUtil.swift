// Preprocessor directives found in file:
// #import "ZXByteMatrix.h"
// #import "ZXQRCode.h"
// #import "ZXQRCodeMaskUtil.h"
let ZX_N1: CInt = 3
let ZX_N2: CInt = 3
let ZX_N3: CInt = 40
let ZX_N4: CInt = 10

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
class ZXQRCodeMaskUtil: NSObject {
    /**
 * Apply mask penalty rule 1 and return the penalty. Find repetitive cells with the same color and
 * give penalty to them. Example: 00000 or 11111.
 */
    @objc
    static func applyMaskPenaltyRule1(_ matrix: ZXByteMatrix!) -> CInt {
        return self.applyMaskPenaltyRule1Internal(matrix, isHorizontal: true) + self.applyMaskPenaltyRule1Internal(matrix, isHorizontal: false)
    }
    /**
 * Apply mask penalty rule 2 and return the penalty. Find 2x2 blocks with the same color and give
 * penalty to them. This is actually equivalent to the spec's rule, which is to find MxN blocks and give a
 * penalty proportional to (M-1)x(N-1), because this is the number of 2x2 blocks inside such a block.
 */
    @objc
    static func applyMaskPenaltyRule2(_ matrix: ZXByteMatrix!) -> CInt {
        var penalty: CInt = 0
        let array = matrix.array
        let width = matrix.width
        let height = matrix.height
        var y: CInt = 0

        while y < height - 1 {
            defer {
                y += 1
            }

            var x: CInt = 0

            while x < width - 1 {
                defer {
                    x += 1
                }

                let value: CInt = array?[y][x]

                if value == array?[y][x + 1] && value == array?[y + 1][x] && value == array?[y + 1][x + 1] {
                    penalty += 1
                }
            }
        }

        return ZX_N2 * penalty
    }
    /**
 * Apply mask penalty rule 3 and return the penalty. Find consecutive runs of 1:1:3:1:1:4
 * starting with black, or 4:1:1:3:1:1 starting with white, and give penalty to them.  If we
 * find patterns like 000010111010000, we give penalty once.
 */
    @objc
    static func applyMaskPenaltyRule3(_ matrix: ZXByteMatrix!) -> CInt {
        var numPenalties: CInt = 0
        let array = matrix.array
        let width = matrix.width
        let height = matrix.height
        var y: CInt = 0

        while y < height {
            defer {
                y += 1
            }

            var x: CInt = 0

            while x < width {
                defer {
                    x += 1
                }

                let arrayY: UnsafeMutablePointer<int8_t>! = array?[y] // We can at least optimize this access

                if x + 6 < width && arrayY[x] == 1 && arrayY[x + 1] == 0 && arrayY[x + 2] == 1 && arrayY[x + 3] == 1 && arrayY[x + 4] == 1 && arrayY[x + 5] == 0 && arrayY[x + 6] == 1 && (self.isWhiteHorizontal(arrayY, length: width, from: x - 4, to: x) || self.isWhiteHorizontal(arrayY, length: width, from: x + 7, to: x + 11)) {
                    numPenalties += 1
                }

                if y + 6 < height && array?[y][x] == 1 && array?[y + 1][x] == 0 && array?[y + 2][x] == 1 && array?[y + 3][x] == 1 && array?[y + 4][x] == 1 && array?[y + 5][x] == 0 && array?[y + 6][x] == 1 && (self.isWhiteVertical(array, length: width, col: x, from: y - 4, to: y) || self.isWhiteVertical(array, length: height, col: x, from: y + 7, to: y + 11)) {
                    numPenalties += 1
                }
            }
        }

        return numPenalties * ZX_N3
    }
    @objc
    static func isWhiteHorizontal(_ rowArray: UnsafeMutablePointer<int8_t>!, length: CInt, from: CInt, to: CInt) -> Bool {
        var i = from

        while i < to {
            defer {
                i += 1
            }

            if i >= 0 && i < length && rowArray[i] == 1 {
                return false
            }
        }

        return true
    }
    @objc
    static func isWhiteVertical(_ array: UnsafeMutablePointer<UnsafeMutablePointer<int8_t>?>!, length: CInt, col: CInt, from: CInt, to: CInt) -> Bool {
        var i = from

        while i < to {
            defer {
                i += 1
            }

            if i >= 0 && i < length && array[i][col] == 1 {
                return false
            }
        }

        return true
    }
    /**
 * Apply mask penalty rule 4 and return the penalty. Calculate the ratio of dark cells and give
 * penalty if the ratio is far from 50%. It gives 10 penalty for 5% distance.
 */
    @objc
    static func applyMaskPenaltyRule4(_ matrix: ZXByteMatrix!) -> CInt {
        var numDarkCells: CInt = 0
        let array = matrix.array
        let width = matrix.width
        let height = matrix.height
        var y: CInt = 0

        while y < height {
            defer {
                y += 1
            }

            let arrayY: UnsafeMutablePointer<int8_t>! = array?[y]
            var x: CInt = 0

            while x < width {
                defer {
                    x += 1
                }

                if arrayY[x] == 1 {
                    numDarkCells += 1
                }
            }
        }

        let numTotalCells = matrix.height * matrix.width
        let fivePercentVariances = abs(numDarkCells * 2 - numTotalCells) * 10 / numTotalCells

        return fivePercentVariances * ZX_N4
    }
    /**
 * Return the mask bit for "getMaskPattern" at "x" and "y". See 8.8 of JISX0510:2004 for mask
 * pattern conditions.
 */
    @objc
    static func dataMaskBit(_ maskPattern: CInt, x: CInt, y: CInt) -> Bool {
        var intermediate: CInt
        var temp: CInt

        switch maskPattern {
        case 0:
            intermediate = (y + x) & 0x1
        case 1:
            intermediate = y & 0x1
        case 2:
            intermediate = x % 3
        case 3:
            intermediate = (y + x) % 3
        case 4:
            intermediate = ((y / 2) + (x / 3)) & 0x1
        case 5:
            temp = y * x
            intermediate = (temp & 0x1) + (temp % 3)
        case 6:
            temp = y * x
            intermediate = ((temp & 0x1) + (temp % 3)) & 0x1
        case 7:
            temp = y * x
            intermediate = ((temp % 3) + ((y + x) & 0x1)) & 0x1
        default:
            NSException.raise(NSInvalidArgumentException, format: "Invalid mask pattern: %d", maskPattern)
        }

        return intermediate == 0
    }
    /**
 * Helper function for applyMaskPenaltyRule1. We need this for doing this calculation in both
 * vertical and horizontal orders respectively.
 */
    @objc
    static func applyMaskPenaltyRule1Internal(_ matrix: ZXByteMatrix!, isHorizontal: Bool) -> CInt {
        var penalty: CInt = 0
        let iLimit = isHorizontal ? matrix.height : matrix.width
        let jLimit = isHorizontal ? matrix.width : matrix.height
        let array = matrix.array
        var i: CInt = 0

        while i < iLimit {
            defer {
                i += 1
            }

            var numSameBitCells: CInt = 0
            var prevBit: CInt = 1
            var j: CInt = 0

            while j < jLimit {
                defer {
                    j += 1
                }

                let bit: CInt = isHorizontal ? array?[i][j] : array?[j][i]

                if bit == prevBit {
                    numSameBitCells += 1
                } else {
                    if numSameBitCells >= 5 {
                        penalty += ZX_N1 + (numSameBitCells - 5)
                    }

                    numSameBitCells = 1 // Include the cell itself.
                    prevBit = bit
                }
            }

            if numSameBitCells >= 5 {
                penalty += ZX_N1 + (numSameBitCells - 5)
            }
        }

        return penalty
    }
}