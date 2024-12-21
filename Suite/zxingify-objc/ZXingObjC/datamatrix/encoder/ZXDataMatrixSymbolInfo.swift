// Preprocessor directives found in file:
// #import "ZXEncodeHints.h"
// #import "ZXDataMatrixSymbolInfo.h"
// #import "ZXDataMatrixSymbolInfo144.h"
// #import "ZXDimension.h"
var PROD_SYMBOLS: NSArray! = nil
var symbols: NSArray! = nil

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
 * Symbol info table for DataMatrix.
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
 * Symbol info table for DataMatrix.
 */
@objc
class ZXDataMatrixSymbolInfo: NSObject {
    private var _rectangular: Bool = false
    private var _errorCodewords: CInt = 0
    private var _dataCapacity: CInt = 0
    private var _dataRegions: CInt = 0
    private var _matrixWidth: CInt = 0
    private var _matrixHeight: CInt = 0
    private var _rsBlockData: CInt = 0
    private var _rsBlockError: CInt = 0
    @objc var rectangular: Bool {
        return self._rectangular
    }
    @objc var errorCodewords: CInt {
        return self._errorCodewords
    }
    @objc var dataCapacity: CInt {
        return self._dataCapacity
    }
    @objc var dataRegions: CInt {
        return self._dataRegions
    }
    @objc var matrixWidth: CInt {
        return self._matrixWidth
    }
    @objc var matrixHeight: CInt {
        return self._matrixHeight
    }
    @objc var rsBlockData: CInt {
        return self._rsBlockData
    }
    @objc var rsBlockError: CInt {
        return self._rsBlockError
    }

    @objc
    init(rectangular: Bool, dataCapacity: CInt, errorCodewords: CInt, matrixWidth: CInt, matrixHeight: CInt, dataRegions: CInt) {
        return self.init(rectangular: rectangular, dataCapacity: dataCapacity, errorCodewords: errorCodewords, matrixWidth: matrixWidth, matrixHeight: matrixHeight, dataRegions: dataRegions, rsBlockData: dataCapacity, rsBlockError: errorCodewords)
    }
    @objc
    init(rectangular: Bool, dataCapacity: CInt, errorCodewords: CInt, matrixWidth: CInt, matrixHeight: CInt, dataRegions: CInt, rsBlockData: CInt, rsBlockError: CInt) {
        if self = super.init() {
            _rectangular = rectangular

            _dataCapacity = dataCapacity

            _errorCodewords = errorCodewords

            _matrixWidth = matrixWidth

            _matrixHeight = matrixHeight

            _dataRegions = dataRegions

            _rsBlockData = rsBlockData

            _rsBlockError = rsBlockError
        }

        return self
    }

    @objc
    static func initialize() {
        if self.self != ZXDataMatrixSymbolInfo.self {
            return
        }

        PROD_SYMBOLS = [ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 3, errorCodewords: 5, matrixWidth: 8, matrixHeight: 8, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 5, errorCodewords: 7, matrixWidth: 10, matrixHeight: 10, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: true, dataCapacity: 5, errorCodewords: 7, matrixWidth: 16, matrixHeight: 6, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 8, errorCodewords: 10, matrixWidth: 12, matrixHeight: 12, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: true, dataCapacity: 10, errorCodewords: 11, matrixWidth: 14, matrixHeight: 6, dataRegions: 2), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 12, errorCodewords: 12, matrixWidth: 14, matrixHeight: 14, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: true, dataCapacity: 16, errorCodewords: 14, matrixWidth: 24, matrixHeight: 10, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 18, errorCodewords: 14, matrixWidth: 16, matrixHeight: 16, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 22, errorCodewords: 18, matrixWidth: 18, matrixHeight: 18, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: true, dataCapacity: 22, errorCodewords: 18, matrixWidth: 16, matrixHeight: 10, dataRegions: 2), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 30, errorCodewords: 20, matrixWidth: 20, matrixHeight: 20, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: true, dataCapacity: 32, errorCodewords: 24, matrixWidth: 16, matrixHeight: 14, dataRegions: 2), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 36, errorCodewords: 24, matrixWidth: 22, matrixHeight: 22, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 44, errorCodewords: 28, matrixWidth: 24, matrixHeight: 24, dataRegions: 1), ZXDataMatrixSymbolInfo(rectangular: true, dataCapacity: 49, errorCodewords: 28, matrixWidth: 22, matrixHeight: 14, dataRegions: 2), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 62, errorCodewords: 36, matrixWidth: 14, matrixHeight: 14, dataRegions: 4), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 86, errorCodewords: 42, matrixWidth: 16, matrixHeight: 16, dataRegions: 4), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 114, errorCodewords: 48, matrixWidth: 18, matrixHeight: 18, dataRegions: 4), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 144, errorCodewords: 56, matrixWidth: 20, matrixHeight: 20, dataRegions: 4), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 174, errorCodewords: 68, matrixWidth: 22, matrixHeight: 22, dataRegions: 4), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 204, errorCodewords: 84, matrixWidth: 24, matrixHeight: 24, dataRegions: 4, rsBlockData: 102, rsBlockError: 42), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 280, errorCodewords: 112, matrixWidth: 14, matrixHeight: 14, dataRegions: 16, rsBlockData: 140, rsBlockError: 56), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 368, errorCodewords: 144, matrixWidth: 16, matrixHeight: 16, dataRegions: 16, rsBlockData: 92, rsBlockError: 36), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 456, errorCodewords: 192, matrixWidth: 18, matrixHeight: 18, dataRegions: 16, rsBlockData: 114, rsBlockError: 48), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 576, errorCodewords: 224, matrixWidth: 20, matrixHeight: 20, dataRegions: 16, rsBlockData: 144, rsBlockError: 56), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 696, errorCodewords: 272, matrixWidth: 22, matrixHeight: 22, dataRegions: 16, rsBlockData: 174, rsBlockError: 68), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 816, errorCodewords: 336, matrixWidth: 24, matrixHeight: 24, dataRegions: 16, rsBlockData: 136, rsBlockError: 56), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 1050, errorCodewords: 408, matrixWidth: 18, matrixHeight: 18, dataRegions: 36, rsBlockData: 175, rsBlockError: 68), ZXDataMatrixSymbolInfo(rectangular: false, dataCapacity: 1304, errorCodewords: 496, matrixWidth: 20, matrixHeight: 20, dataRegions: 36, rsBlockData: 163, rsBlockError: 62), ZXDataMatrixSymbolInfo144()]
        /*rect*/
        /*rect*/
        /*rect*/
        /*rect*/
        /*rect*/
        /*rect*/
        symbols = PROD_SYMBOLS
    }
    @objc
    static func prodSymbols() -> NSArray? {
        return PROD_SYMBOLS
    }
    /**
 * Overrides the symbol info set used by this class. Used for testing purposes.
 *
 * @param override the symbol info set to use
 */
    /**
 * Overrides the symbol info set used by this class. Used for testing purposes.
 *
 * @param override the symbol info set to use
 */
    @objc
    static func overrideSymbolSet(_ override: NSArray!) {
        symbols = override
    }
    @objc
    static func lookup(_ dataCodewords: CInt) -> ZXDataMatrixSymbolInfo? {
        return self.lookup(dataCodewords, shape: ZXDataMatrixSymbolShapeHint.ZXDataMatrixSymbolShapeHintForceNone, fail: true)
    }
    @objc
    static func lookup(_ dataCodewords: CInt, shape: ZXDataMatrixSymbolShapeHint) -> ZXDataMatrixSymbolInfo? {
        return self.lookup(dataCodewords, shape: shape, fail: true)
    }
    @objc
    static func lookup(_ dataCodewords: CInt, allowRectangular: Bool, fail: Bool) -> ZXDataMatrixSymbolInfo? {
        let shape = allowRectangular ? ZXDataMatrixSymbolShapeHint.ZXDataMatrixSymbolShapeHintForceNone : ZXDataMatrixSymbolShapeHint.ZXDataMatrixSymbolShapeHintForceSquare

        return self.lookup(dataCodewords, shape: shape, fail: fail)
    }
    @objc
    static func lookup(_ dataCodewords: CInt, shape: ZXDataMatrixSymbolShapeHint, fail: Bool) -> ZXDataMatrixSymbolInfo? {
        return self.lookup(dataCodewords, shape: shape, minSize: nil, maxSize: nil, fail: fail)
    }
    @objc
    static func lookup(_ dataCodewords: CInt, shape: ZXDataMatrixSymbolShapeHint, minSize: ZXDimension!, maxSize: ZXDimension!, fail: Bool) -> ZXDataMatrixSymbolInfo? {
        for symbol in symbols {
            if shape == ZXDataMatrixSymbolShapeHint.ZXDataMatrixSymbolShapeHintForceSquare && symbol.rectangular {
                continue
            }

            if shape == ZXDataMatrixSymbolShapeHint.ZXDataMatrixSymbolShapeHintForceRectangle && !symbol.rectangular {
                continue
            }

            if minSize != nil && (symbol.symbolWidth() < minSize.width || symbol.symbolHeight() < minSize.height) {
                continue
            }

            if maxSize != nil && (symbol.symbolWidth() > maxSize.width || symbol.symbolHeight() > maxSize.height) {
                continue
            }

            if dataCodewords <= symbol.dataCapacity {
                return symbol
            }
        }

        if fail {
            NSException.raise(NSInvalidArgumentException, format: "Can\'t find a symbol arrangement that matches the message. Data codewords: %d", dataCodewords)
        }

        return nil
    }
    @objc
    func horizontalDataRegions() -> CInt {
        switch _dataRegions {
        case 1:
            return 1
        case 2:
            return 2
        case 4:
            return 2
        case 16:
            return 4
        case 36:
            return 6
        default:
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"Cannot handle this number of data regions"userInfo:nil];
            */
        }
    }
    @objc
    func verticalDataRegions() -> CInt {
        switch _dataRegions {
        case 1:
            return 1
        case 2:
            return 1
        case 4:
            return 2
        case 16:
            return 4
        case 36:
            return 6
        default:
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"Cannot handle this number of data regions"userInfo:nil];
            */
        }
    }
    @objc
    func symbolDataWidth() -> CInt {
        return self.horizontalDataRegions() * _matrixWidth
    }
    @objc
    func symbolDataHeight() -> CInt {
        return self.verticalDataRegions() * _matrixHeight
    }
    @objc
    func symbolWidth() -> CInt {
        return self.symbolDataWidth() + (self.horizontalDataRegions() * 2)
    }
    @objc
    func symbolHeight() -> CInt {
        return self.symbolDataHeight() + (self.verticalDataRegions() * 2)
    }
    @objc
    func codewordCount() -> CInt {
        return _dataCapacity + _errorCodewords
    }
    @objc
    func interleavedBlockCount() -> CInt {
        return _dataCapacity / _rsBlockData
    }
    @objc
    func dataLengthForInterleavedBlock(_ index: CInt) -> CInt {
        return _rsBlockData
    }
    @objc
    func errorLengthForInterleavedBlock(_ index: CInt) -> CInt {
        return _rsBlockError
    }
    @objc
    func description() -> String? {
        let sb = NSMutableString()

        sb.append(_rectangular ? "Rectangular Symbol:" : "Square Symbol:")
        sb.appendFormat(" data region %dx%d", _matrixWidth, _matrixHeight)
        sb.appendFormat(", symbol size %dx%d", self.symbolWidth(), self.symbolHeight())
        sb.appendFormat(", symbol data size %dx%d", self.symbolDataWidth(), self.symbolDataHeight())
        sb.appendFormat(", codewords %d+%d", _dataCapacity, _errorCodewords)

        return String.stringWithString(sb)
    }
}