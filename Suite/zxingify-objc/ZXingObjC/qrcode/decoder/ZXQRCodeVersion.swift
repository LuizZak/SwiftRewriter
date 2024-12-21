// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXIntArray.h"
// #import "ZXQRCodeErrorCorrectionLevel.h"
// #import "ZXQRCodeFormatInformation.h"
// #import "ZXQRCodeVersion.h"
var ZX_VERSION_DECODE_INFO: UnsafePointer<CInt>!
var ZX_VERSIONS: NSArray! = nil

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
 * See ISO 18004:2006 Annex D
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
 * See ISO 18004:2006 Annex D
 */
@objc
class ZXQRCodeVersion: NSObject {
    private var _versionNumber: CInt = 0
    private var _alignmentPatternCenters: ZXIntArray!
    private var _ecBlocks: NSArray!
    private var _totalCodewords: CInt = 0
    @objc var versionNumber: CInt {
        return self._versionNumber
    }
    @objc var alignmentPatternCenters: ZXIntArray! {
        return self._alignmentPatternCenters
    }
    @objc var ecBlocks: NSArray! {
        return self._ecBlocks
    }
    @objc var totalCodewords: CInt {
        return self._totalCodewords
    }
    @objc var dimensionForVersion: CInt {
        return 17 + 4 * self.versionNumber
    }

    @objc
    init(versionNumber: CInt, alignmentPatternCenters: ZXIntArray!, ecBlocks1: ZXQRCodeECBlocks!, ecBlocks2: ZXQRCodeECBlocks!, ecBlocks3: ZXQRCodeECBlocks!, ecBlocks4: ZXQRCodeECBlocks!) {
        if self = super.init() {
            _versionNumber = versionNumber
            _alignmentPatternCenters = alignmentPatternCenters
            _ecBlocks = [ecBlocks1, ecBlocks2, ecBlocks3, ecBlocks4]

            var total: CInt = 0
            let ecCodewords = ecBlocks1.ecCodewordsPerBlock

            for ecBlock in ecBlocks1.ecBlocks {
                total += ecBlock.count * (ecBlock.dataCodewords + ecCodewords)
            }

            _totalCodewords = total
        }

        return self
    }

    @objc
    static func ZXQRCodeVersionWithVersionNumber(_ versionNumber: CInt, alignmentPatternCenters: ZXIntArray!, ecBlocks1: ZXQRCodeECBlocks!, ecBlocks2: ZXQRCodeECBlocks!, ecBlocks3: ZXQRCodeECBlocks!, ecBlocks4: ZXQRCodeECBlocks!) -> ZXQRCodeVersion? {
        return ZXQRCodeVersion(versionNumber: versionNumber, alignmentPatternCenters: alignmentPatternCenters, ecBlocks1: ecBlocks1, ecBlocks2: ecBlocks2, ecBlocks3: ecBlocks3, ecBlocks4: ecBlocks4)
    }
    @objc
    func ecBlocksForLevel(_ ecLevel: ZXQRCodeErrorCorrectionLevel!) -> ZXQRCodeECBlocks? {
        return self.ecBlocks[ecLevel.ordinal()]
    }
    /**
 * Deduces version information purely from QR Code dimensions.
 *
 * @param dimension dimension in modules
 * @return Version for a QR Code of that dimension or nil if dimension is not 1 mod 4
 */
    @objc
    static func provisionalVersionForDimension(_ dimension: CInt) -> ZXQRCodeVersion? {
        if dimension % 4 != 1 {
            return nil
        }

        return self.versionForNumber((dimension - 17) / 4)
    }
    @objc
    static func versionForNumber(_ versionNumber: CInt) -> ZXQRCodeVersion? {
        if versionNumber < 1 || versionNumber > 40 {
            return nil
        }

        return ZX_VERSIONS[Int(versionNumber - 1)]
    }
    @objc
    static func decodeVersionInformation(_ versionBits: CInt) -> ZXQRCodeVersion? {
        var bestDifference: CInt = INT_MAX
        var bestVersion: CInt = 0
        var i: CInt = 0

        while i < MemoryLayout.size(ofValue: ZX_VERSION_DECODE_INFO) / MemoryLayout<CInt>.size {
            defer {
                i += 1
            }

            let targetVersion: CInt = ZX_VERSION_DECODE_INFO[i]

            if targetVersion == versionBits {
                return self.versionForNumber(i + 7)
            }

            let bitsDifference = ZXQRCodeFormatInformation.numBitsDiffering(versionBits, b: targetVersion)

            if bitsDifference < bestDifference {
                bestVersion = i + 7
                bestDifference = bitsDifference
            }
        }

        if bestDifference <= 3 {
            return self.versionForNumber(bestVersion)
        }

        return nil
    }
    /**
 * See ISO 18004:2006 Annex E
 */
    @objc
    func buildFunctionPattern() -> ZXBitMatrix {
        let dimension = self.dimensionForVersion
        let bitMatrix = ZXBitMatrix(dimension: dimension)

        bitMatrix.setRegionAtLeft(0, top: 0, width: 9, height: 9)
        bitMatrix.setRegionAtLeft(dimension - 8, top: 0, width: 8, height: 9)
        bitMatrix.setRegionAtLeft(0, top: dimension - 8, width: 9, height: 8)

        let max: CInt = CInt(CInt(self.alignmentPatternCenters.length ?? 0))
        var x: CInt = 0

        while x < max {
            defer {
                x += 1
            }

            let i: CInt = self.alignmentPatternCenters.array[x] - 2
            var y: CInt = 0

            while y < max {
                defer {
                    y += 1
                }

                if (x == 0 && (y == 0 || y == max - 1)) || (x == max - 1 && y == 0) {
                    continue
                }

                bitMatrix.setRegionAtLeft(self.alignmentPatternCenters.array[y] - 2, top: i, width: 5, height: 5)
            }
        }

        bitMatrix.setRegionAtLeft(6, top: 9, width: 1, height: dimension - 17)
        bitMatrix.setRegionAtLeft(9, top: 6, width: dimension - 17, height: 1)

        if self.versionNumber > 6 {
            bitMatrix.setRegionAtLeft(dimension - 11, top: 0, width: 3, height: 6)
            bitMatrix.setRegionAtLeft(0, top: dimension - 11, width: 6, height: 3)
        }

        return bitMatrix
    }
    @objc
    func description() -> String? {
        return self.versionNumber.stringValue()
    }
    /**
 * See ISO 18004:2006 6.5.1 Table 9
 */
    @objc
    static func initialize() {
        if self.self != ZXQRCodeVersion.self {
            return
        }

        ZX_VERSIONS = [ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(1, alignmentPatternCenters: ZXIntArray(length: 0), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(7, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 19)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(10, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 16)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(13, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 13)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(17, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 9))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(2, alignmentPatternCenters: ZXIntArray(ints: 6, 18, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(10, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 34)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(16, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 28)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(22, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 22)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(3, alignmentPatternCenters: ZXIntArray(ints: 6, 22, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(15, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 55)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 44)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(18, ecBlocks: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 17)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(22, ecBlocks: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 13))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(4, alignmentPatternCenters: ZXIntArray(ints: 6, 26, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(20, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 80)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(18, ecBlocks: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 32)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 24)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(16, ecBlocks: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 9))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(5, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 108)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 43)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(18, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 16)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(22, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 11), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 12))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(6, alignmentPatternCenters: ZXIntArray(ints: 6, 34, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(18, ecBlocks: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 68)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(16, ecBlocks: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 27)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 19)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 15))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(7, alignmentPatternCenters: ZXIntArray(ints: 6, 22, 38, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(20, ecBlocks: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 78)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(18, ecBlocks: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 31)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(18, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 14), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 15)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 13), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 14))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(8, alignmentPatternCenters: ZXIntArray(ints: 6, 24, 42, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 97)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(22, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 38), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 39)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(22, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 18), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 19)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 14), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 15))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(9, alignmentPatternCenters: ZXIntArray(ints: 6, 26, 46, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 116)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(22, ecBlocks1: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 36), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 37)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(20, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 16), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 17)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 12), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 13))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(10, alignmentPatternCenters: ZXIntArray(ints: 6, 28, 50, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(18, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 68), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 69)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 43), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 44)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 19), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 20)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(11, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 54, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(20, ecBlocks: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 81)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 50), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 51)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 22), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 23)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 12), ecBlocks2: ZXQRCodeECB.ecbWithCount(8, dataCodewords: 13))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(12, alignmentPatternCenters: ZXIntArray(ints: 6, 32, 58, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 92), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 93)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(22, ecBlocks1: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 36), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 37)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 20), ecBlocks2: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 21)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 14), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 15))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(13, alignmentPatternCenters: ZXIntArray(ints: 6, 34, 62, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 107)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(22, ecBlocks1: ZXQRCodeECB.ecbWithCount(8, dataCodewords: 37), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 38)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(8, dataCodewords: 20), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 21)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(22, ecBlocks1: ZXQRCodeECB.ecbWithCount(12, dataCodewords: 11), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 12))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(14, alignmentPatternCenters: ZXIntArray(ints: 6, 26, 46, 66, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 115), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 116)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 40), ecBlocks2: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 41)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(20, ecBlocks1: ZXQRCodeECB.ecbWithCount(11, dataCodewords: 16), ecBlocks2: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 17)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(11, dataCodewords: 12), ecBlocks2: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 13))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(15, alignmentPatternCenters: ZXIntArray(ints: 6, 26, 48, 70, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(22, ecBlocks1: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 87), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 88)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 41), ecBlocks2: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 42)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(11, dataCodewords: 12), ecBlocks2: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 13))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(16, alignmentPatternCenters: ZXIntArray(ints: 6, 26, 50, 74, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 98), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 99)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 45), ecBlocks2: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 46)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks1: ZXQRCodeECB.ecbWithCount(15, dataCodewords: 19), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 20)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(13, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(17, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 54, 78, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 107), ecBlocks2: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 108)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 46), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 47)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 22), ecBlocks2: ZXQRCodeECB.ecbWithCount(15, dataCodewords: 23)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 14), ecBlocks2: ZXQRCodeECB.ecbWithCount(17, dataCodewords: 15))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(18, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 56, 82, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 120), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 121)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks1: ZXQRCodeECB.ecbWithCount(9, dataCodewords: 43), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 44)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(17, dataCodewords: 22), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 23)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 14), ecBlocks2: ZXQRCodeECB.ecbWithCount(19, dataCodewords: 15))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(19, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 58, 86, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 113), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 114)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks1: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 44), ecBlocks2: ZXQRCodeECB.ecbWithCount(11, dataCodewords: 45)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks1: ZXQRCodeECB.ecbWithCount(17, dataCodewords: 21), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 22)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks1: ZXQRCodeECB.ecbWithCount(9, dataCodewords: 13), ecBlocks2: ZXQRCodeECB.ecbWithCount(16, dataCodewords: 14))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(20, alignmentPatternCenters: ZXIntArray(ints: 6, 34, 62, 90, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 107), ecBlocks2: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 108)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks1: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 41), ecBlocks2: ZXQRCodeECB.ecbWithCount(13, dataCodewords: 42)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(15, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(15, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(21, alignmentPatternCenters: ZXIntArray(ints: 6, 28, 50, 72, 94, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 116), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 117)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks: ZXQRCodeECB.ecbWithCount(17, dataCodewords: 42)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(17, dataCodewords: 22), ecBlocks2: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 23)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(19, dataCodewords: 16), ecBlocks2: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 17))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(22, alignmentPatternCenters: ZXIntArray(ints: 6, 26, 50, 72, 98, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 111), ecBlocks2: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 112)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks: ZXQRCodeECB.ecbWithCount(17, dataCodewords: 46)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(16, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(24, ecBlocks: ZXQRCodeECB.ecbWithCount(34, dataCodewords: 13))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(23, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 54, 78, 102, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 121), ecBlocks2: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 122)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 47), ecBlocks2: ZXQRCodeECB.ecbWithCount(14, dataCodewords: 48)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(11, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(14, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(16, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(14, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(24, alignmentPatternCenters: ZXIntArray(ints: 6, 28, 54, 80, 106, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 117), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 118)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 45), ecBlocks2: ZXQRCodeECB.ecbWithCount(14, dataCodewords: 46)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(11, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(16, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(30, dataCodewords: 16), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 17))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(25, alignmentPatternCenters: ZXIntArray(ints: 6, 32, 58, 84, 110, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(26, ecBlocks1: ZXQRCodeECB.ecbWithCount(8, dataCodewords: 106), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 107)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(8, dataCodewords: 47), ecBlocks2: ZXQRCodeECB.ecbWithCount(13, dataCodewords: 48)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(22, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(22, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(13, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(26, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 58, 86, 114, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 114), ecBlocks2: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 115)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(19, dataCodewords: 46), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 47)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(28, dataCodewords: 22), ecBlocks2: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 23)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(33, dataCodewords: 16), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 17))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(27, alignmentPatternCenters: ZXIntArray(ints: 6, 34, 62, 90, 118, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(8, dataCodewords: 122), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 123)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(22, dataCodewords: 45), ecBlocks2: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 46)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(8, dataCodewords: 23), ecBlocks2: ZXQRCodeECB.ecbWithCount(26, dataCodewords: 24)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(12, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(28, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(28, alignmentPatternCenters: ZXIntArray(ints: 6, 26, 50, 74, 98, 122, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 117), ecBlocks2: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 118)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 45), ecBlocks2: ZXQRCodeECB.ecbWithCount(23, dataCodewords: 46)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(31, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(11, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(31, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(29, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 54, 78, 102, 126, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 116), ecBlocks2: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 117)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(21, dataCodewords: 45), ecBlocks2: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 46)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 23), ecBlocks2: ZXQRCodeECB.ecbWithCount(37, dataCodewords: 24)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(19, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(26, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(30, alignmentPatternCenters: ZXIntArray(ints: 6, 26, 52, 78, 104, 130, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(5, dataCodewords: 115), ecBlocks2: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 116)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(19, dataCodewords: 47), ecBlocks2: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 48)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(15, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(25, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(23, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(25, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(31, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 56, 82, 108, 134, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(13, dataCodewords: 115), ecBlocks2: ZXQRCodeECB.ecbWithCount(3, dataCodewords: 116)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 46), ecBlocks2: ZXQRCodeECB.ecbWithCount(29, dataCodewords: 47)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(42, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(23, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(28, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(32, alignmentPatternCenters: ZXIntArray(ints: 6, 34, 60, 86, 112, 138, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks: ZXQRCodeECB.ecbWithCount(17, dataCodewords: 115)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 46), ecBlocks2: ZXQRCodeECB.ecbWithCount(23, dataCodewords: 47)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(35, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(19, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(35, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(33, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 58, 86, 114, 142, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(17, dataCodewords: 115), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 116)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(14, dataCodewords: 46), ecBlocks2: ZXQRCodeECB.ecbWithCount(21, dataCodewords: 47)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(29, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(19, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(11, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(46, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(34, alignmentPatternCenters: ZXIntArray(ints: 6, 34, 62, 90, 118, 146, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(13, dataCodewords: 115), ecBlocks2: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 116)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(14, dataCodewords: 46), ecBlocks2: ZXQRCodeECB.ecbWithCount(23, dataCodewords: 47)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(44, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(59, dataCodewords: 16), ecBlocks2: ZXQRCodeECB.ecbWithCount(1, dataCodewords: 17))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(35, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 54, 78, 102, 126, 150, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(12, dataCodewords: 121), ecBlocks2: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 122)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(12, dataCodewords: 47), ecBlocks2: ZXQRCodeECB.ecbWithCount(26, dataCodewords: 48)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(39, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(14, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(22, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(41, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(36, alignmentPatternCenters: ZXIntArray(ints: 6, 24, 50, 76, 102, 128, 154, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 121), ecBlocks2: ZXQRCodeECB.ecbWithCount(14, dataCodewords: 122)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 47), ecBlocks2: ZXQRCodeECB.ecbWithCount(34, dataCodewords: 48)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(46, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(2, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(64, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(37, alignmentPatternCenters: ZXIntArray(ints: 6, 28, 54, 80, 106, 132, 158, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(17, dataCodewords: 122), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 123)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(29, dataCodewords: 46), ecBlocks2: ZXQRCodeECB.ecbWithCount(14, dataCodewords: 47)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(49, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(24, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(46, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(38, alignmentPatternCenters: ZXIntArray(ints: 6, 32, 58, 84, 110, 136, 162, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 122), ecBlocks2: ZXQRCodeECB.ecbWithCount(18, dataCodewords: 123)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(13, dataCodewords: 46), ecBlocks2: ZXQRCodeECB.ecbWithCount(32, dataCodewords: 47)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(48, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(14, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(42, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(32, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(39, alignmentPatternCenters: ZXIntArray(ints: 6, 26, 54, 82, 110, 138, 166, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(20, dataCodewords: 117), ecBlocks2: ZXQRCodeECB.ecbWithCount(4, dataCodewords: 118)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(40, dataCodewords: 47), ecBlocks2: ZXQRCodeECB.ecbWithCount(7, dataCodewords: 48)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(43, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(22, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(10, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(67, dataCodewords: 16))), ZXQRCodeVersion.ZXQRCodeVersionWithVersionNumber(40, alignmentPatternCenters: ZXIntArray(ints: 6, 30, 58, 86, 114, 142, 170, 1), ecBlocks1: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(19, dataCodewords: 118), ecBlocks2: ZXQRCodeECB.ecbWithCount(6, dataCodewords: 119)), ecBlocks2: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(28, ecBlocks1: ZXQRCodeECB.ecbWithCount(18, dataCodewords: 47), ecBlocks2: ZXQRCodeECB.ecbWithCount(31, dataCodewords: 48)), ecBlocks3: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(34, dataCodewords: 24), ecBlocks2: ZXQRCodeECB.ecbWithCount(34, dataCodewords: 25)), ecBlocks4: ZXQRCodeECBlocks.ecBlocksWithEcCodewordsPerBlock(30, ecBlocks1: ZXQRCodeECB.ecbWithCount(20, dataCodewords: 15), ecBlocks2: ZXQRCodeECB.ecbWithCount(61, dataCodewords: 16)))]
    }
}
/**
 * Encapsulates a set of error-correction blocks in one symbol version. Most versions will
 * use blocks of differing sizes within one version, so, this encapsulates the parameters for
 * each set of blocks. It also holds the number of error-correction codewords per block since it
 * will be the same across all blocks within one version.
 */
/**
 * Encapsulates a set of error-correction blocks in one symbol version. Most versions will
 * use blocks of differing sizes within one version, so, this encapsulates the parameters for
 * each set of blocks. It also holds the number of error-correction codewords per block since it
 * will be the same across all blocks within one version.
 */
@objc
class ZXQRCodeECBlocks: NSObject {
    private var _ecCodewordsPerBlock: CInt = 0
    private var _ecBlocks: NSArray!
    @objc var ecCodewordsPerBlock: CInt {
        return self._ecCodewordsPerBlock
    }
    @objc var numBlocks: CInt {
        var total: CInt = 0

        for ecb in self.ecBlocks {
            total += ecb.count()
        }

        return total
    }
    @objc var totalECCodewords: CInt {
        return self.ecCodewordsPerBlock * self.numBlocks
    }
    @objc var ecBlocks: NSArray! {
        return self._ecBlocks
    }

    @objc
    init(ecCodewordsPerBlock: CInt, ecBlocks: ZXQRCodeECB!) {
        if self = super.init() {
            _ecCodewordsPerBlock = ecCodewordsPerBlock
            _ecBlocks = [ecBlocks]
        }

        return self
    }
    @objc
    init(ecCodewordsPerBlock: CInt, ecBlocks1: ZXQRCodeECB!, ecBlocks2: ZXQRCodeECB!) {
        if self = super.init() {
            _ecCodewordsPerBlock = ecCodewordsPerBlock
            _ecBlocks = [ecBlocks1, ecBlocks2]
        }

        return self
    }

    @objc
    static func ecBlocksWithEcCodewordsPerBlock(_ ecCodewordsPerBlock: CInt, ecBlocks: ZXQRCodeECB!) -> ZXQRCodeECBlocks? {
        return ZXQRCodeECBlocks(ecCodewordsPerBlock: ecCodewordsPerBlock, ecBlocks: ecBlocks)
    }
    @objc
    static func ecBlocksWithEcCodewordsPerBlock(_ ecCodewordsPerBlock: CInt, ecBlocks1: ZXQRCodeECB!, ecBlocks2: ZXQRCodeECB!) -> ZXQRCodeECBlocks? {
        return ZXQRCodeECBlocks(ecCodewordsPerBlock: ecCodewordsPerBlock, ecBlocks1: ecBlocks1, ecBlocks2: ecBlocks2)
    }
}
/**
 * Encapsualtes the parameters for one error-correction block in one symbol version.
 * This includes the number of data codewords, and the number of times a block with these
 * parameters is used consecutively in the QR code version's format.
 */
/**
 * Encapsualtes the parameters for one error-correction block in one symbol version.
 * This includes the number of data codewords, and the number of times a block with these
 * parameters is used consecutively in the QR code version's format.
 */
@objc
class ZXQRCodeECB: NSObject {
    private var _count: CInt = 0
    private var _dataCodewords: CInt = 0
    @objc var count: CInt {
        return self._count
    }
    @objc var dataCodewords: CInt {
        return self._dataCodewords
    }

    @objc
    init(count: CInt, dataCodewords: CInt) {
        if self = super.init() {
            _count = count
            _dataCodewords = dataCodewords
        }

        return self
    }

    @objc
    static func ecbWithCount(_ count: CInt, dataCodewords: CInt) -> ZXQRCodeECB? {
        return ZXQRCodeECB(count: count, dataCodewords: dataCodewords)
    }
}