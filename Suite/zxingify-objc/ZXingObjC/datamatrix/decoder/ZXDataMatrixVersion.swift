import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXDataMatrixVersion.h"
var VERSIONS: NSArray! = nil

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
 * Encapsulates a set of error-correction blocks in one symbol version. Most versions will
 * use blocks of differing sizes within one version, so, this encapsulates the parameters for
 * each set of blocks. It also holds the number of error-correction codewords per block since it
 * will be the same across all blocks within one version.
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
 * Encapsulates a set of error-correction blocks in one symbol version. Most versions will
 * use blocks of differing sizes within one version, so, this encapsulates the parameters for
 * each set of blocks. It also holds the number of error-correction codewords per block since it
 * will be the same across all blocks within one version.
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
@objc
class ZXDataMatrixECBlocks: NSObject {
    private var _ecBlocks: NSArray!
    private var _ecCodewords: CInt = 0
    @objc var ecBlocks: NSArray! {
        return self._ecBlocks
    }
    @objc var ecCodewords: CInt {
        return self._ecCodewords
    }

    @objc
    init(codewords ecCodewords: CInt, ecBlocks: ZXDataMatrixECB!) {
        if self = super.init() {
            _ecCodewords = ecCodewords
            _ecBlocks = [ecBlocks]
        }

        return self
    }
    @objc
    init(codewords ecCodewords: CInt, ecBlocks1: ZXDataMatrixECB!, ecBlocks2: ZXDataMatrixECB!) {
        if self = super.init() {
            _ecCodewords = ecCodewords
            _ecBlocks = [ecBlocks1, ecBlocks2]
        }

        return self
    }
}
/**
 * Encapsualtes the parameters for one error-correction block in one symbol version.
 * This includes the number of data codewords, and the number of times a block with these
 * parameters is used consecutively in the Data Matrix code version's format.
 */
/**
 * Encapsualtes the parameters for one error-correction block in one symbol version.
 * This includes the number of data codewords, and the number of times a block with these
 * parameters is used consecutively in the Data Matrix code version's format.
 */
@objc
class ZXDataMatrixECB: NSObject {
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
}
/**
 * The Version object encapsulates attributes about a particular
 * size Data Matrix Code.
 */
/**
 * The Version object encapsulates attributes about a particular
 * size Data Matrix Code.
 */
@objc
class ZXDataMatrixVersion: NSObject {
    private var _ecBlocks: ZXDataMatrixECBlocks!
    private var _dataRegionSizeColumns: CInt = 0
    private var _dataRegionSizeRows: CInt = 0
    private var _symbolSizeColumns: CInt = 0
    private var _symbolSizeRows: CInt = 0
    private var _totalCodewords: CInt = 0
    private var _versionNumber: CInt = 0
    @objc var ecBlocks: ZXDataMatrixECBlocks! {
        return self._ecBlocks
    }
    @objc var dataRegionSizeColumns: CInt {
        return self._dataRegionSizeColumns
    }
    @objc var dataRegionSizeRows: CInt {
        return self._dataRegionSizeRows
    }
    @objc var symbolSizeColumns: CInt {
        return self._symbolSizeColumns
    }
    @objc var symbolSizeRows: CInt {
        return self._symbolSizeRows
    }
    @objc var totalCodewords: CInt {
        return self._totalCodewords
    }
    @objc var versionNumber: CInt {
        return self._versionNumber
    }

    @objc
    init(versionNumber: CInt, symbolSizeRows: CInt, symbolSizeColumns: CInt, dataRegionSizeRows: CInt, dataRegionSizeColumns: CInt, ecBlocks: ZXDataMatrixECBlocks!) {
        if self = super.init() {
            _versionNumber = versionNumber

            _symbolSizeRows = symbolSizeRows

            _symbolSizeColumns = symbolSizeColumns

            _dataRegionSizeRows = dataRegionSizeRows

            _dataRegionSizeColumns = dataRegionSizeColumns

            _ecBlocks = ecBlocks

            var total: CInt = 0
            let ecCodewords = ecBlocks.ecCodewords
            let ecbArray = ecBlocks.ecBlocks

            for ecBlock in ecbArray {
                total += ecBlock.count * (ecBlock.dataCodewords + ecCodewords)
            }

            _totalCodewords = total
        }

        return self
    }

    /**
 * <p>Deduces version information from Data Matrix dimensions.</p>
 *
 * @param numRows Number of rows in modules
 * @param numColumns Number of columns in modules
 * @return Version for a Data Matrix Code of those dimensions or nil
 *  if dimensions do correspond to a valid Data Matrix size
 */
    /**
 * <p>Deduces version information from Data Matrix dimensions.</p>
 *
 * @param numRows Number of rows in modules
 * @param numColumns Number of columns in modules
 * @return Version for a Data Matrix Code of those dimensions or nil
 *  if dimensions do correspond to a valid Data Matrix size
 */
    @objc
    static func versionForDimensions(_ numRows: CInt, numColumns: CInt) -> ZXDataMatrixVersion? {
        if (numRows & 0x1) != 0 || (numColumns & 0x1) != 0 {
            return nil
        }

        for version in VERSIONS {
            if version.symbolSizeRows == numRows && version.symbolSizeColumns == numColumns {
                return version
            }
        }

        return nil
    }
    @objc
    func description() -> String? {
        return self.versionNumber.stringValue()
    }
    /**
 * See ISO 16022:2006 5.5.1 Table 7
 */
    @objc
    static func initialize() {
        if self.self != ZXDataMatrixVersion.self {
            return
        }

        VERSIONS = [ZXDataMatrixVersion(versionNumber: 1, symbolSizeRows: 10, symbolSizeColumns: 10, dataRegionSizeRows: 8, dataRegionSizeColumns: 8, ecBlocks: ZXDataMatrixECBlocks(codewords: 5, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 3))), ZXDataMatrixVersion(versionNumber: 2, symbolSizeRows: 12, symbolSizeColumns: 12, dataRegionSizeRows: 10, dataRegionSizeColumns: 10, ecBlocks: ZXDataMatrixECBlocks(codewords: 7, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 5))), ZXDataMatrixVersion(versionNumber: 3, symbolSizeRows: 14, symbolSizeColumns: 14, dataRegionSizeRows: 12, dataRegionSizeColumns: 12, ecBlocks: ZXDataMatrixECBlocks(codewords: 10, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 8))), ZXDataMatrixVersion(versionNumber: 4, symbolSizeRows: 16, symbolSizeColumns: 16, dataRegionSizeRows: 14, dataRegionSizeColumns: 14, ecBlocks: ZXDataMatrixECBlocks(codewords: 12, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 12))), ZXDataMatrixVersion(versionNumber: 5, symbolSizeRows: 18, symbolSizeColumns: 18, dataRegionSizeRows: 16, dataRegionSizeColumns: 16, ecBlocks: ZXDataMatrixECBlocks(codewords: 14, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 18))), ZXDataMatrixVersion(versionNumber: 6, symbolSizeRows: 20, symbolSizeColumns: 20, dataRegionSizeRows: 18, dataRegionSizeColumns: 18, ecBlocks: ZXDataMatrixECBlocks(codewords: 18, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 22))), ZXDataMatrixVersion(versionNumber: 7, symbolSizeRows: 22, symbolSizeColumns: 22, dataRegionSizeRows: 20, dataRegionSizeColumns: 20, ecBlocks: ZXDataMatrixECBlocks(codewords: 20, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 30))), ZXDataMatrixVersion(versionNumber: 8, symbolSizeRows: 24, symbolSizeColumns: 24, dataRegionSizeRows: 22, dataRegionSizeColumns: 22, ecBlocks: ZXDataMatrixECBlocks(codewords: 24, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 36))), ZXDataMatrixVersion(versionNumber: 9, symbolSizeRows: 26, symbolSizeColumns: 26, dataRegionSizeRows: 24, dataRegionSizeColumns: 24, ecBlocks: ZXDataMatrixECBlocks(codewords: 28, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 44))), ZXDataMatrixVersion(versionNumber: 10, symbolSizeRows: 32, symbolSizeColumns: 32, dataRegionSizeRows: 14, dataRegionSizeColumns: 14, ecBlocks: ZXDataMatrixECBlocks(codewords: 36, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 62))), ZXDataMatrixVersion(versionNumber: 11, symbolSizeRows: 36, symbolSizeColumns: 36, dataRegionSizeRows: 16, dataRegionSizeColumns: 16, ecBlocks: ZXDataMatrixECBlocks(codewords: 42, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 86))), ZXDataMatrixVersion(versionNumber: 12, symbolSizeRows: 40, symbolSizeColumns: 40, dataRegionSizeRows: 18, dataRegionSizeColumns: 18, ecBlocks: ZXDataMatrixECBlocks(codewords: 48, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 114))), ZXDataMatrixVersion(versionNumber: 13, symbolSizeRows: 44, symbolSizeColumns: 44, dataRegionSizeRows: 20, dataRegionSizeColumns: 20, ecBlocks: ZXDataMatrixECBlocks(codewords: 56, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 144))), ZXDataMatrixVersion(versionNumber: 14, symbolSizeRows: 48, symbolSizeColumns: 48, dataRegionSizeRows: 22, dataRegionSizeColumns: 22, ecBlocks: ZXDataMatrixECBlocks(codewords: 68, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 174))), ZXDataMatrixVersion(versionNumber: 15, symbolSizeRows: 52, symbolSizeColumns: 52, dataRegionSizeRows: 24, dataRegionSizeColumns: 24, ecBlocks: ZXDataMatrixECBlocks(codewords: 42, ecBlocks: ZXDataMatrixECB(count: 2, dataCodewords: 102))), ZXDataMatrixVersion(versionNumber: 16, symbolSizeRows: 64, symbolSizeColumns: 64, dataRegionSizeRows: 14, dataRegionSizeColumns: 14, ecBlocks: ZXDataMatrixECBlocks(codewords: 56, ecBlocks: ZXDataMatrixECB(count: 2, dataCodewords: 140))), ZXDataMatrixVersion(versionNumber: 17, symbolSizeRows: 72, symbolSizeColumns: 72, dataRegionSizeRows: 16, dataRegionSizeColumns: 16, ecBlocks: ZXDataMatrixECBlocks(codewords: 36, ecBlocks: ZXDataMatrixECB(count: 4, dataCodewords: 92))), ZXDataMatrixVersion(versionNumber: 18, symbolSizeRows: 80, symbolSizeColumns: 80, dataRegionSizeRows: 18, dataRegionSizeColumns: 18, ecBlocks: ZXDataMatrixECBlocks(codewords: 48, ecBlocks: ZXDataMatrixECB(count: 4, dataCodewords: 114))), ZXDataMatrixVersion(versionNumber: 19, symbolSizeRows: 88, symbolSizeColumns: 88, dataRegionSizeRows: 20, dataRegionSizeColumns: 20, ecBlocks: ZXDataMatrixECBlocks(codewords: 56, ecBlocks: ZXDataMatrixECB(count: 4, dataCodewords: 144))), ZXDataMatrixVersion(versionNumber: 20, symbolSizeRows: 96, symbolSizeColumns: 96, dataRegionSizeRows: 22, dataRegionSizeColumns: 22, ecBlocks: ZXDataMatrixECBlocks(codewords: 68, ecBlocks: ZXDataMatrixECB(count: 4, dataCodewords: 174))), ZXDataMatrixVersion(versionNumber: 21, symbolSizeRows: 104, symbolSizeColumns: 104, dataRegionSizeRows: 24, dataRegionSizeColumns: 24, ecBlocks: ZXDataMatrixECBlocks(codewords: 56, ecBlocks: ZXDataMatrixECB(count: 6, dataCodewords: 136))), ZXDataMatrixVersion(versionNumber: 22, symbolSizeRows: 120, symbolSizeColumns: 120, dataRegionSizeRows: 18, dataRegionSizeColumns: 18, ecBlocks: ZXDataMatrixECBlocks(codewords: 68, ecBlocks: ZXDataMatrixECB(count: 6, dataCodewords: 175))), ZXDataMatrixVersion(versionNumber: 23, symbolSizeRows: 132, symbolSizeColumns: 132, dataRegionSizeRows: 20, dataRegionSizeColumns: 20, ecBlocks: ZXDataMatrixECBlocks(codewords: 62, ecBlocks: ZXDataMatrixECB(count: 8, dataCodewords: 163))), ZXDataMatrixVersion(versionNumber: 24, symbolSizeRows: 144, symbolSizeColumns: 144, dataRegionSizeRows: 22, dataRegionSizeColumns: 22, ecBlocks: ZXDataMatrixECBlocks(codewords: 62, ecBlocks1: ZXDataMatrixECB(count: 8, dataCodewords: 156), ecBlocks2: ZXDataMatrixECB(count: 2, dataCodewords: 155))), ZXDataMatrixVersion(versionNumber: 25, symbolSizeRows: 8, symbolSizeColumns: 18, dataRegionSizeRows: 6, dataRegionSizeColumns: 16, ecBlocks: ZXDataMatrixECBlocks(codewords: 7, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 5))), ZXDataMatrixVersion(versionNumber: 26, symbolSizeRows: 8, symbolSizeColumns: 32, dataRegionSizeRows: 6, dataRegionSizeColumns: 14, ecBlocks: ZXDataMatrixECBlocks(codewords: 11, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 10))), ZXDataMatrixVersion(versionNumber: 27, symbolSizeRows: 12, symbolSizeColumns: 26, dataRegionSizeRows: 10, dataRegionSizeColumns: 24, ecBlocks: ZXDataMatrixECBlocks(codewords: 14, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 16))), ZXDataMatrixVersion(versionNumber: 28, symbolSizeRows: 12, symbolSizeColumns: 36, dataRegionSizeRows: 10, dataRegionSizeColumns: 16, ecBlocks: ZXDataMatrixECBlocks(codewords: 18, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 22))), ZXDataMatrixVersion(versionNumber: 29, symbolSizeRows: 16, symbolSizeColumns: 36, dataRegionSizeRows: 14, dataRegionSizeColumns: 16, ecBlocks: ZXDataMatrixECBlocks(codewords: 24, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 32))), ZXDataMatrixVersion(versionNumber: 30, symbolSizeRows: 16, symbolSizeColumns: 48, dataRegionSizeRows: 14, dataRegionSizeColumns: 22, ecBlocks: ZXDataMatrixECBlocks(codewords: 28, ecBlocks: ZXDataMatrixECB(count: 1, dataCodewords: 49)))]
    }
}