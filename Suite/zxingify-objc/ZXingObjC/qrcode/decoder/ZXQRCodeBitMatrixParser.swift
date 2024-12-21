// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXByteArray.h"
// #import "ZXErrors.h"
// #import "ZXQRCodeBitMatrixParser.h"
// #import "ZXQRCodeDataMask.h"
// #import "ZXQRCodeFormatInformation.h"
// #import "ZXQRCodeVersion.h"
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
class ZXQRCodeBitMatrixParser: NSObject {
    private var _bitMatrix: ZXBitMatrix!
    private var _parsedFormatInfo: ZXQRCodeFormatInformation!
    private var _parsedVersion: ZXQRCodeVersion!
    @objc var shouldMirror: Bool = false

    @objc
    init?(bitMatrix: ZXBitMatrix!, error: UnsafeMutablePointer<Error?>!) {
        let dimension = bitMatrix.height

        if dimension < 21 || (dimension & 0x3) != 1 {
            if error {
                *error = ZXFormatErrorInstance()
            }

            return nil
        }

        if self = super.init() {
            _bitMatrix = bitMatrix
            _parsedFormatInfo = nil
            _parsedVersion = nil
        }

        return self
    }

    /**
 * Reads format information from one of its two locations within the QR Code.
 *
 * @return ZXFormatInformation encapsulating the QR Code's format info
 * @return nil if both format information locations cannot be parsed as
 * the valid encoding of format information
 */
    @objc
    func readFormatInformationWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXQRCodeFormatInformation? {
        if self.parsedFormatInfo != nil {
            return self.parsedFormatInfo
        }

        var formatInfoBits1: CInt = 0
        var i: CInt = 0

        while i < 6 {
            defer {
                i += 1
            }

            formatInfoBits1 = self.copyBit(i, j: 8, versionBits: formatInfoBits1)
        }

        formatInfoBits1 = self.copyBit(7, j: 8, versionBits: formatInfoBits1)
        formatInfoBits1 = self.copyBit(8, j: 8, versionBits: formatInfoBits1)
        formatInfoBits1 = self.copyBit(8, j: 7, versionBits: formatInfoBits1)

        var j: CInt = 5

        while j >= 0 {
            defer {
                j -= 1
            }

            formatInfoBits1 = self.copyBit(8, j: j, versionBits: formatInfoBits1)
        }

        let dimension = self.bitMatrix.height ?? 0
        var formatInfoBits2: CInt = 0
        let jMin = dimension - 7
        var j = dimension - 1

        while j >= jMin {
            defer {
                j -= 1
            }

            formatInfoBits2 = self.copyBit(8, j: j, versionBits: formatInfoBits2)
        }

        var i = dimension - 8

        while i < dimension {
            defer {
                i += 1
            }

            formatInfoBits2 = self.copyBit(i, j: 8, versionBits: formatInfoBits2)
        }

        self.parsedFormatInfo = ZXQRCodeFormatInformation.decodeFormatInformation(formatInfoBits1, maskedFormatInfo2: formatInfoBits2)

        if self.parsedFormatInfo != nil {
            return self.parsedFormatInfo
        }

        if error {
            *error = ZXFormatErrorInstance()
        }

        return nil
    }
    /**
 * Reads version information from one of its two locations within the QR Code.
 *
 * @return ZXQRCodeVersion encapsulating the QR Code's version or nil
 *  if both version information locations cannot be parsed as
 *  the valid encoding of version information
 */
    @objc
    func readVersionWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXQRCodeVersion? {
        if self.parsedVersion != nil {
            return self.parsedVersion
        }

        let dimension = self.bitMatrix.height ?? 0
        let provisionalVersion = (dimension - 17) / 4

        if provisionalVersion <= 6 {
            return ZXQRCodeVersion.versionForNumber(provisionalVersion)
        }

        var versionBits: CInt = 0
        let ijMin = dimension - 11
        var j: CInt = 5

        while j >= 0 {
            defer {
                j -= 1
            }

            var i = dimension - 9

            while i >= ijMin {
                defer {
                    i -= 1
                }

                versionBits = self.copyBit(i, j: j, versionBits: versionBits)
            }
        }

        var theParsedVersion = ZXQRCodeVersion.decodeVersionInformation(versionBits)

        if theParsedVersion != nil && theParsedVersion?.dimensionForVersion == dimension {
            self.parsedVersion = theParsedVersion

            return self.parsedVersion
        }

        versionBits = 0

        var i: CInt = 5

        while i >= 0 {
            defer {
                i -= 1
            }

            var j = dimension - 9

            while j >= ijMin {
                defer {
                    j -= 1
                }

                versionBits = self.copyBit(i, j: j, versionBits: versionBits)
            }
        }

        theParsedVersion = ZXQRCodeVersion.decodeVersionInformation(versionBits)

        if theParsedVersion != nil && theParsedVersion?.dimensionForVersion == dimension {
            self.parsedVersion = theParsedVersion

            return self.parsedVersion
        }

        if error {
            *error = ZXFormatErrorInstance()
        }

        return nil
    }
    @objc
    func copyBit(_ i: CInt, j: CInt, versionBits: CInt) -> CInt {
        let bit = self.shouldMirror ? self.bitMatrix.getX(j, y: i) : self.bitMatrix.getX(i, y: j) == true

        return (bit == true) ? (versionBits << 1) | 0x1 : versionBits << 1
    }
    /**
 * Reads the bits in the ZXBitMatrix representing the finder pattern in the
 * correct order in order to reconstruct the codewords bytes contained within the
 * QR Code.
 *
 * @return bytes encoded within the QR Code or nil if the exact number of bytes expected is not read
 */
    @objc
    func readCodewordsWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXByteArray {
        let formatInfo = self.readFormatInformationWithError(error)

        if formatInfo == nil {
            return nil
        }

        let version = self.readVersionWithError(error)

        if version == nil {
            return nil
        }

        // Get the data mask for the format used in this QR Code. This will exclude
        // some bits from reading as we wind through the bit matrix.
        let dataMask = ZXQRCodeDataMask.forReference(formatInfo?.dataMask())
        let dimension = self.bitMatrix.height ?? 0

        dataMask?.unmaskBitMatrix(self.bitMatrix, dimension: dimension)

        let functionPattern = version?.buildFunctionPattern()
        var readingUp = true
        let result = ZXByteArray(length: CUnsignedInt(CUnsignedInt(version?.totalCodewords ?? 0)))
        var resultOffset: CInt = 0
        var currentByte: CInt = 0
        var bitsRead: CInt = 0
        var j = dimension - 1

        while j > 0 {
            defer {
                j -= 2
            }

            if j == 6 {
                // Skip whole column with vertical alignment pattern;
                // saves time and makes the other code proceed more cleanly
                j -= 1
            }

            var count: CInt = 0

            while count < dimension {
                defer {
                    count += 1
                }

                let i = readingUp ? dimension - 1 - count : count
                var col: CInt = 0

                while col < 2 {
                    defer {
                        col += 1
                    }

                    // Ignore bits covered by the function pattern
                    if !functionPattern.getX(j - col, y: i) {
                        // Read a bit
                        bitsRead += 1
                        currentByte <<= 1

                        if self.bitMatrix.getX(j - col, y: i) == true {
                            currentByte |= 1
                        }

                        // If we've made a whole byte, save it off
                        if bitsRead == 8 {
                            result.array[resultOffset += 1] = currentByte as? int8_t
                            bitsRead = 0
                            currentByte = 0
                        }
                    }
                }
            }

            readingUp ^= true // readingUp = !readingUp; // switch directions
        }

        if resultOffset != version?.totalCodewords {
            if error {
                *error = ZXFormatErrorInstance()
            }

            return nil
        }

        return result
    }
    /**
 * Revert the mask removal done while reading the code words. The bit matrix should revert to its original state.
 */
    @objc
    func remask() {
        if !self.parsedFormatInfo {
            return // We have no format information, and have no data mask
        }

        let dataMask = ZXQRCodeDataMask.forReference(self.parsedFormatInfo.dataMask)
        let dimension = self.bitMatrix.height ?? 0

        dataMask?.unmaskBitMatrix(self.bitMatrix, dimension: dimension)
    }
    /**
 * Prepare the parser for a mirrored operation.
 * This flag has effect only on the readFormatInformation and the
 * readVersion. Before proceeding with readCodewords the
 * mirror method should be called.
 *
 * @param mirror Whether to read version and format information mirrored.
 */
    @objc
    func setMirror(_ mirror: Bool) {
        self.parsedVersion = nil
        self.parsedFormatInfo = nil
        self.shouldMirror = mirror
    }
    /** Mirror the bit matrix in order to attempt a second reading. */
    @objc
    func mirror() {
        var x: CInt = 0

        while x < (self.bitMatrix.width ?? 0) {
            defer {
                x += 1
            }

            var y = x + 1

            while y < (self.bitMatrix.height ?? 0) {
                defer {
                    y += 1
                }

                if self.bitMatrix.getX(x, y: y) != self.bitMatrix.getX(y, y: x) {
                    self.bitMatrix.flipX(y, y: x)
                    self.bitMatrix.flipX(x, y: y)
                }
            }
        }
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
extension ZXQRCodeBitMatrixParser {
    @objc var bitMatrix: ZXBitMatrix! {
        return self._bitMatrix
    }
    @objc var parsedFormatInfo: ZXQRCodeFormatInformation! {
        get {
            return self._parsedFormatInfo
        }
        set {
            self._parsedFormatInfo = newValue
        }
    }
    @objc var parsedVersion: ZXQRCodeVersion! {
        get {
            return self._parsedVersion
        }
        set {
            self._parsedVersion = newValue
        }
    }
}