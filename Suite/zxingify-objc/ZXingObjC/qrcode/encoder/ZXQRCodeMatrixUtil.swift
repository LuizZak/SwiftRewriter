// Preprocessor directives found in file:
// #import "ZXBitArray.h"
// #import "ZXByteMatrix.h"
// #import "ZXErrors.h"
// #import "ZXQRCode.h"
// #import "ZXQRCodeErrorCorrectionLevel.h"
// #import "ZXQRCodeMaskUtil.h"
// #import "ZXQRCodeMatrixUtil.h"
// #import "ZXQRCodeVersion.h"
var ZX_POSITION_DETECTION_PATTERN: (CInt, CInt, CInt, CInt, CInt, CInt, CInt)
var ZX_POSITION_ADJUSTMENT_PATTERN: (CInt, CInt, CInt, CInt, CInt)
var ZX_POSITION_ADJUSTMENT_PATTERN_COORDINATE_TABLE: (CInt, CInt, CInt, CInt, CInt, CInt, CInt)
var ZX_TYPE_INFO_COORDINATES: (CInt, CInt)
let ZX_VERSION_INFO_POLY: CInt = 0x1f25
let ZX_TYPE_INFO_POLY: CInt = 0x537
let ZX_TYPE_INFO_MASK_PATTERN: CInt = 0x5412

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
class ZXQRCodeMatrixUtil: NSObject {
    // Set all cells to -1.  -1 means that the cell is empty (not set yet).
    @objc
    static func clearMatrix(_ matrix: ZXByteMatrix!) {
        matrix.clear(1)
    }
    // Build 2D matrix of QR Code from "dataBits" with "ecLevel", "version" and "getMaskPattern". On
    // success, store the result in "matrix" and return true.
    @objc
    static func buildMatrix(_ dataBits: ZXBitArray!, ecLevel: ZXQRCodeErrorCorrectionLevel!, version: ZXQRCodeVersion!, maskPattern: CInt, matrix: ZXByteMatrix!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        self.clearMatrix(matrix)

        if !self.embedBasicPatterns(version, matrix: matrix, error: error) {
            return false
        }

        // Type information appear with any version.
        if !self.embedTypeInfo(ecLevel, maskPattern: maskPattern, matrix: matrix, error: error) {
            return false
        }

        // Version info appear if version >= 7.
        if !self.maybeEmbedVersionInfo(version, matrix: matrix, error: error) {
            return false
        }

        // Data should be embedded at end.
        if !self.embedDataBits(dataBits, maskPattern: maskPattern, matrix: matrix, error: error) {
            return false
        }

        return true
    }
    // Embed basic patterns. On success, modify the matrix and return true.
    // The basic patterns are:
    // - Position detection patterns
    // - Timing patterns
    // - Dark dot at the left bottom corner
    // - Position adjustment patterns, if need be
    @objc
    static func embedBasicPatterns(_ version: ZXQRCodeVersion!, matrix: ZXByteMatrix!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        // Let's get started with embedding big squares at corners.
        if !self.embedPositionDetectionPatternsAndSeparators(matrix) {
            if error {
                *error = Error(domain: ZXErrorDomain, code: ZXNotFoundError, userInfo: nil)
            }

            return false
        }

        // Then, embed the dark dot at the left bottom corner.
        if !self.embedDarkDotAtLeftBottomCorner(matrix) {
            if error {
                *error = Error(domain: ZXErrorDomain, code: ZXNotFoundError, userInfo: nil)
            }

            return false
        }

        // Position adjustment patterns appear if version >= 2.
        self.maybeEmbedPositionAdjustmentPatterns(version, matrix: matrix)
        // Timing patterns should be embedded after position adj. patterns.
        self.embedTimingPatterns(matrix)

        return true
    }
    // Embed type information. On success, modify the matrix.
    @objc
    static func embedTypeInfo(_ ecLevel: ZXQRCodeErrorCorrectionLevel!, maskPattern: CInt, matrix: ZXByteMatrix!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        let typeInfoBits = ZXBitArray()

        if !self.makeTypeInfoBits(ecLevel, maskPattern: maskPattern, bits: typeInfoBits, error: error) {
            return false
        }

        var i: CInt = 0

        while i < typeInfoBits.size {
            defer {
                i += 1
            }

            // Place bits in LSB to MSB order.  LSB (least significant bit) is the last value in
            // "typeInfoBits".
            let bit = typeInfoBits.get(typeInfoBits.size - 1 - i)
            // Type info bits at the left top corner. See 8.9 of JISX0510:2004 (p.46).
            let x1: CInt = ZX_TYPE_INFO_COORDINATES[i][0]
            let y1: CInt = ZX_TYPE_INFO_COORDINATES[i][1]

            matrix.setX(x1, y: y1, boolValue: bit)

            if i < 8 {
                // Right top corner.
                let x2 = matrix.width - i - 1
                let y2: CInt = 8

                matrix.setX(x2, y: y2, boolValue: bit)
            } else {
                // Left bottom corner.
                let x2: CInt = 8
                let y2 = matrix.height - 7 + (i - 8)

                matrix.setX(x2, y: y2, boolValue: bit)
            }
        }

        return true
    }
    // Embed version information if need be. On success, modify the matrix and return true.
    // See 8.10 of JISX0510:2004 (p.47) for how to embed version information.
    @objc
    static func maybeEmbedVersionInfo(_ version: ZXQRCodeVersion!, matrix: ZXByteMatrix!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        if version.versionNumber < 7 {
            // Version info is necessary if version >= 7.
            return true // Don't need version info.
        }

        let versionInfoBits = ZXBitArray()

        if !self.makeVersionInfoBits(version, bits: versionInfoBits, error: error) {
            return false
        }

        var bitIndex: CInt = 6 * 3 - 1 // It will decrease from 17 to 0.
        var i: CInt = 0

        while i < 6 {
            defer {
                i += 1
            }

            var j: CInt = 0

            while j < 3 {
                defer {
                    j += 1
                }

                // Place bits in LSB (least significant bit) to MSB order.
                let bit = versionInfoBits.get(bitIndex)

                bitIndex -= 1
                // Left bottom corner.
                matrix.setX(i, y: matrix.height - 11 + j, boolValue: bit)
                // Right bottom corner.
                matrix.setX(matrix.height - 11 + j, y: i, boolValue: bit)
            }
        }

        return true
    }
    // Embed "dataBits" using "getMaskPattern". On success, modify the matrix and return true.
    // For debugging purposes, it skips masking process if "getMaskPattern" is -1.
    // See 8.7 of JISX0510:2004 (p.38) for how to embed data bits.
    @objc
    static func embedDataBits(_ dataBits: ZXBitArray!, maskPattern: CInt, matrix: ZXByteMatrix!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        var bitIndex: CInt = 0
        var direction: CInt = 1
        // Start from the right bottom cell.
        var x = matrix.width - 1
        var y = matrix.height - 1

        while x > 0 {
            // Skip the vertical timing pattern.
            if x == 6 {
                x -= 1
            }

            while y >= 0 && y < matrix.height {
                var i: CInt = 0

                while i < 2 {
                    defer {
                        i += 1
                    }

                    let xx = x - i

                    // Skip the cell if it's not empty.
                    if !self.isEmpty(matrix.getX(xx, y: y)) {
                        continue
                    }

                    var bit: Bool

                    if bitIndex < dataBits.size {
                        bit = dataBits.get(bitIndex)
                        bitIndex += 1
                    } else {
                        // Padding bit. If there is no bit left, we'll fill the left cells with 0, as described
                        // in 8.4.9 of JISX0510:2004 (p. 24).
                        bit = false
                    }

                    // Skip masking if mask_pattern is -1.
                    if maskPattern != 1 && ZXQRCodeMaskUtil.dataMaskBit(maskPattern, x: xx, y: y) {
                        bit = !bit
                    }

                    matrix.setX(xx, y: y, boolValue: bit)
                }

                y += direction
            }

            direction = -direction // Reverse the direction.
            y += direction
            x -= 2 // Move to the left.
        }

        // All bits should be consumed.
        if bitIndex != dataBits.size {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: String(format: "Not all bits consumed: %d/%d", bitIndex, dataBits.size())]

            if error {
                *error = Error(domain: ZXErrorDomain, code: ZXNotFoundError, userInfo: userInfo)
            }

            return false
        }

        return true
    }
    // Return the position of the most significant bit set (to one) in the "value". The most
    // significant bit is position 32. If there is no bit set, return 0. Examples:
    // - findMSBSet(0) => 0
    // - findMSBSet(1) => 1
    // - findMSBSet(255) => 8
    @objc
    static func findMSBSet(_ value: CInt) -> CInt {
        var numDigits: CInt = 0

        while value != 0 {
            value = CInt(CUnsignedInt(value) >> 1)
            numDigits += 1
        }

        return numDigits
    }
    // Calculate BCH (Bose-Chaudhuri-Hocquenghem) code for "value" using polynomial "poly". The BCH
    // code is used for encoding type information and version information.
    // Example: Calculation of version information of 7.
    // f(x) is created from 7.
    //   - 7 = 000111 in 6 bits
    //   - f(x) = x^2 + x^1 + x^0
    // g(x) is given by the standard (p. 67)
    //   - g(x) = x^12 + x^11 + x^10 + x^9 + x^8 + x^5 + x^2 + 1
    // Multiply f(x) by x^(18 - 6)
    //   - f'(x) = f(x) * x^(18 - 6)
    //   - f'(x) = x^14 + x^13 + x^12
    // Calculate the remainder of f'(x) / g(x)
    //         x^2
    //         __________________________________________________
    //   g(x) )x^14 + x^13 + x^12
    //         x^14 + x^13 + x^12 + x^11 + x^10 + x^7 + x^4 + x^2
    //         --------------------------------------------------
    //                              x^11 + x^10 + x^7 + x^4 + x^2
    //
    // The remainder is x^11 + x^10 + x^7 + x^4 + x^2
    // Encode it in binary: 110010010100
    // The return value is 0xc94 (1100 1001 0100)
    //
    // Since all coefficients in the polynomials are 1 or 0, we can do the calculation by bit
    // operations. We don't care if cofficients are positive or negative.
    @objc
    static func calculateBCHCode(_ value: CInt, poly: CInt) -> CInt {
        // If poly is "1 1111 0010 0101" (version info poly), msbSetInPoly is 13. We'll subtract 1
        // from 13 to make it 12.
        let msbSetInPoly = self.findMSBSet(poly)

        value <<= msbSetInPoly - 1

        // Do the division business using exclusive-or operations.
        while self.findMSBSet(value) >= msbSetInPoly {
            value ^= poly << (self.findMSBSet(value) - msbSetInPoly)
        }

        // Now the "value" is the remainder (i.e. the BCH code)
        return value
    }
    // Make bit vector of type information. On success, store the result in "bits" and return true.
    // Encode error correction level and mask pattern. See 8.9 of
    // JISX0510:2004 (p.45) for details.
    @objc
    static func makeTypeInfoBits(_ ecLevel: ZXQRCodeErrorCorrectionLevel!, maskPattern: CInt, bits: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        if !ZXQRCode.isValidMaskPattern(maskPattern) {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Invalid mask pattern"]

            if error {
                *error = Error(domain: ZXErrorDomain, code: ZXNotFoundError, userInfo: userInfo)
            }

            return false
        }

        let typeInfo: CInt = (ecLevel.bits << 3) | maskPattern

        bits.appendBits(typeInfo, numBits: 5)

        let bchCode = self.calculateBCHCode(typeInfo, poly: ZX_TYPE_INFO_POLY)

        bits.appendBits(bchCode, numBits: 10)

        let maskBits = ZXBitArray()

        maskBits.appendBits(ZX_TYPE_INFO_MASK_PATTERN, numBits: 15)
        bits.xor(maskBits)

        if bits.size != 15 {
            // Just in case.
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: String(format: "should not happen but we got: %d", bits.size())]

            if error {
                *error = Error(domain: ZXErrorDomain, code: ZXNotFoundError, userInfo: userInfo)
            }

            return false
        }

        return true
    }
    // Make bit vector of version information. On success, store the result in "bits" and return true.
    // See 8.10 of JISX0510:2004 (p.45) for details.
    @objc
    static func makeVersionInfoBits(_ version: ZXQRCodeVersion!, bits: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        bits.appendBits(version.versionNumber, numBits: 6)

        let bchCode = self.calculateBCHCode(version.versionNumber, poly: ZX_VERSION_INFO_POLY)

        bits.appendBits(bchCode, numBits: 12)

        if bits.size != 18 {
            // Just in case.
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: String(format: "should not happen but we got: %d", bits.size())]

            if error {
                *error = Error(domain: ZXErrorDomain, code: ZXNotFoundError, userInfo: userInfo)
            }

            return false
        }

        return true
    }
    // Check if "value" is empty.
    @objc
    static func isEmpty(_ value: CInt) -> Bool {
        return value == 1
    }
    @objc
    static func embedTimingPatterns(_ matrix: ZXByteMatrix!) {
        var i: CInt = 8

        while i < matrix.width - 8 {
            defer {
                i += 1
            }

            let bit = (i + 1) % 2

            // Horizontal line.
            if self.isEmpty(matrix.getX(i, y: 6)) {
                matrix.setX(i, y: 6, boolValue: bit != 0)
            }

            // Vertical line.
            if self.isEmpty(matrix.getX(6, y: i)) {
                matrix.setX(6, y: i, boolValue: bit != 0)
            }
        }
    }
    // Embed the lonely dark dot at left bottom corner. JISX0510:2004 (p.46)
    @objc
    static func embedDarkDotAtLeftBottomCorner(_ matrix: ZXByteMatrix!) -> Bool {
        if matrix.getX(8, y: matrix.height - 8) == 0 {
            return false
        }

        matrix.setX(8, y: matrix.height - 8, intValue: 1)

        return true
    }
    @objc
    static func embedHorizontalSeparationPattern(_ xStart: CInt, yStart: CInt, matrix: ZXByteMatrix!) -> Bool {
        var x: CInt = 0

        while x < 8 {
            defer {
                x += 1
            }

            if !self.isEmpty(matrix.getX(xStart + x, y: yStart)) {
                return false
            }

            matrix.setX(xStart + x, y: yStart, intValue: 0)
        }

        return true
    }
    @objc
    static func embedVerticalSeparationPattern(_ xStart: CInt, yStart: CInt, matrix: ZXByteMatrix!) -> Bool {
        var y: CInt = 0

        while y < 7 {
            defer {
                y += 1
            }

            if !self.isEmpty(matrix.getX(xStart, y: yStart + y)) {
                return false
            }

            matrix.setX(xStart, y: yStart + y, intValue: 0)
        }

        return true
    }
    // Note that we cannot unify the function with embedPositionDetectionPattern() despite they are
    // almost identical, since we cannot write a function that takes 2D arrays in different sizes in
    // C/C++. We should live with the fact.
    @objc
    static func embedPositionAdjustmentPattern(_ xStart: CInt, yStart: CInt, matrix: ZXByteMatrix!) {
        var y: CInt = 0

        while y < 5 {
            defer {
                y += 1
            }

            var x: CInt = 0

            while x < 5 {
                defer {
                    x += 1
                }

                matrix.setX(xStart + x, y: yStart + y, intValue: ZX_POSITION_ADJUSTMENT_PATTERN[y][x])
            }
        }
    }
    @objc
    static func embedPositionDetectionPattern(_ xStart: CInt, yStart: CInt, matrix: ZXByteMatrix!) {
        var y: CInt = 0

        while y < 7 {
            defer {
                y += 1
            }

            var x: CInt = 0

            while x < 7 {
                defer {
                    x += 1
                }

                matrix.setX(xStart + x, y: yStart + y, intValue: ZX_POSITION_DETECTION_PATTERN[y][x])
            }
        }
    }
    // Embed position detection patterns and surrounding vertical/horizontal separators.
    @objc
    static func embedPositionDetectionPatternsAndSeparators(_ matrix: ZXByteMatrix!) -> Bool {
        // Embed three big squares at corners.
        let pdpWidth: CInt = CInt(MemoryLayout.size(ofValue: ZX_POSITION_DETECTION_PATTERN[0]) / MemoryLayout<CInt>.size)

        // Left top corner.
        self.embedPositionDetectionPattern(0, yStart: 0, matrix: matrix)
        // Right top corner.
        self.embedPositionDetectionPattern(matrix.width - pdpWidth, yStart: 0, matrix: matrix)
        // Left bottom corner.
        self.embedPositionDetectionPattern(0, yStart: matrix.width - pdpWidth, matrix: matrix)

        // Embed horizontal separation patterns around the squares.
        let hspWidth: CInt = 8

        // Left top corner.
        self.embedHorizontalSeparationPattern(0, yStart: hspWidth - 1, matrix: matrix)
        // Right top corner.
        self.embedHorizontalSeparationPattern(matrix.width - hspWidth, yStart: hspWidth - 1, matrix: matrix)
        // Left bottom corner.
        self.embedHorizontalSeparationPattern(0, yStart: matrix.width - hspWidth, matrix: matrix)

        // Embed vertical separation patterns around the squares.
        let vspSize: CInt = 7

        // Left top corner.
        if !self.embedVerticalSeparationPattern(vspSize, yStart: 0, matrix: matrix) {
            return false
        }

        // Right top corner.
        if !self.embedVerticalSeparationPattern(matrix.height - vspSize - 1, yStart: 0, matrix: matrix) {
            return false
        }

        // Left bottom corner.
        if !self.embedVerticalSeparationPattern(vspSize, yStart: matrix.height - vspSize, matrix: matrix) {
            return false
        }

        return true
    }
    // Embed position adjustment patterns if need be.
    @objc
    static func maybeEmbedPositionAdjustmentPatterns(_ version: ZXQRCodeVersion!, matrix: ZXByteMatrix!) {
        if version.versionNumber < 2 {
            // The patterns appear if version >= 2
            return
        }

        let index = version.versionNumber - 1
        let numCoordinates: CInt = CInt(MemoryLayout.size(ofValue: ZX_POSITION_ADJUSTMENT_PATTERN_COORDINATE_TABLE[index]) / MemoryLayout<CInt>.size)
        var i: CInt = 0

        while i < numCoordinates {
            defer {
                i += 1
            }

            var j: CInt = 0

            while j < numCoordinates {
                defer {
                    j += 1
                }

                let y: CInt = ZX_POSITION_ADJUSTMENT_PATTERN_COORDINATE_TABLE[index][i]
                let x: CInt = ZX_POSITION_ADJUSTMENT_PATTERN_COORDINATE_TABLE[index][j]

                if x == 1 || y == 1 {
                    continue
                }

                // If the cell is unset, we embed the position adjustment pattern here.
                if self.isEmpty(matrix.getX(x, y: y)) {
                    // -2 is necessary since the x/y coordinates point to the center of the pattern, not the
                    // left top corner.
                    self.embedPositionAdjustmentPattern(x - 2, yStart: y - 2, matrix: matrix)
                }
            }
        }
    }
}