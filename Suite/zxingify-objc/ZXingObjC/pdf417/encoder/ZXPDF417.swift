// Preprocessor directives found in file:
// #import "ZXEncodeHints.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXPDF417.h"
// #import "ZXPDF417BarcodeMatrix.h"
// #import "ZXPDF417BarcodeRow.h"
// #import "ZXPDF417ErrorCorrection.h"
// #import "ZXPDF417HighLevelEncoder.h"
// #define ZX_PDF417_CODEWORD_TABLE_LEN 3
// #define ZX_PDF417_CODEWORD_TABLE_SUB_LEN 929
let ZX_PDF417_START_PATTERN: CInt = 0x1fea8
let ZX_PDF417_STOP_PATTERN: CInt = 0x3fa29
var ZX_PDF417_CODEWORD_TABLE: UnsafePointer<CInt>!
let ZX_PDF417_PREFERRED_RATIO: CFloat = 3.0
let ZX_PDF417_DEFAULT_MODULE_WIDTH: CFloat = 0.357
let ZX_PDF417_HEIGHT: CFloat = 2.0
private let ZX_PDF417_CODEWORD_TABLE_LEN: Int = 3
private let ZX_PDF417_CODEWORD_TABLE_SUB_LEN: Int = 929

/*
 * Copyright 2006 Jeremias Maerki in part, and ZXing Authors in part
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Top-level class for the logic part of the PDF417 implementation.
 */
/*
 * Copyright 2006 Jeremias Maerki in part, and ZXing Authors in part
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Top-level class for the logic part of the PDF417 implementation.
 */
@objc
class ZXPDF417: NSObject {
    private var _minCols: CInt = 0
    private var _maxCols: CInt = 0
    private var _minRows: CInt = 0
    private var _maxRows: CInt = 0
    private var _compact: Bool = false
    private var _compaction: ZXPDF417Compaction = ZXPDF417Compaction.ZXPDF417CompactionAuto
    private var _encoding: NSStringEncoding
    @objc var barcodeMatrix: ZXPDF417BarcodeMatrix!
    @objc var compact: Bool {
        get {
            return self._compact
        }
        set {
            self._compact = newValue
        }
    }
    @objc var compaction: ZXPDF417Compaction {
        get {
            return self._compaction
        }
        set {
            self._compaction = newValue
        }
    }
    @objc var encoding: NSStringEncoding {
        get {
            return self._encoding
        }
        set {
            self._encoding = newValue
        }
    }

    @objc
    override init() {
        return self.init(compact: false)
    }
    @objc
    init(compact: Bool) {
        if self = super.init() {
            _compact = compact

            _compaction = ZXPDF417Compaction.ZXPDF417CompactionAuto

            _encoding = ZX_PDF417_DEFAULT_ENCODING

            _minCols = 2

            _maxCols = 30

            _maxRows = 30

            _minRows = 2
        }

        return self
    }

    /**
 * Calculates the necessary number of rows as described in annex Q of ISO/IEC 15438:2001(E).
 *
 * @param m the number of source codewords prior to the additional of the Symbol Length
 *          Descriptor and any pad codewords
 * @param k the number of error correction codewords
 * @param c the number of columns in the symbol in the data region (excluding start, stop and
 *          row indicator codewords)
 * @return the number of rows in the symbol (r)
 */
    @objc
    func calculateNumberOfRowsM(_ m: CInt, k: CInt, c: CInt) -> CInt {
        var r = ((m + 1 + k) / c) + 1

        if c * r >= (m + 1 + k + c) {
            r -= 1
        }

        return r
    }
    /**
 * Calculates the number of pad codewords as described in 4.9.2 of ISO/IEC 15438:2001(E).
 *
 * @param m the number of source codewords prior to the additional of the Symbol Length
 *          Descriptor and any pad codewords
 * @param k the number of error correction codewords
 * @param c the number of columns in the symbol in the data region (excluding start, stop and
 *          row indicator codewords)
 * @param r the number of rows in the symbol
 * @return the number of pad codewords
 */
    @objc
    func numberOfPadCodewordsM(_ m: CInt, k: CInt, c: CInt, r: CInt) -> CInt {
        let n = c * r - k

        return (n > m + 1) ? n - m - 1 : 0
    }
    @objc
    func encodeCharPattern(_ pattern: CInt, len: CInt, logic: ZXPDF417BarcodeRow!) {
        var map = 1 << (len - 1)
        var last = (pattern & map) != 0 //Initialize to inverse of first bit
        var width: CInt = 0
        var i: CInt = 0

        while i < len {
            defer {
                i += 1
            }

            let black = (pattern & map) != 0

            if last == black {
                width += 1
            } else {
                logic.addBar(last, width: width)
                last = black
                width = 1
            }

            map >>= 1
        }

        logic.addBar(last, width: width)
    }
    @objc
    func encodeLowLevel(_ fullCodewords: String!, c: CInt, r: CInt, errorCorrectionLevel: CInt, logic: ZXPDF417BarcodeMatrix!) {
        var idx: CInt = 0
        var y: CInt = 0

        while y < r {
            defer {
                y += 1
            }

            let cluster = y % 3

            logic.startRow()
            self.encodeCharPattern(ZX_PDF417_START_PATTERN, len: 17, logic: logic.currentRow)

            var left: CInt
            var right: CInt

            if cluster == 0 {
                left = (30 * (y / 3)) + ((r - 1) / 3)
                right = (30 * (y / 3)) + (c - 1)
            } else if cluster == 1 {
                left = (30 * (y / 3)) + (errorCorrectionLevel * 3) + ((r - 1) % 3)
                right = (30 * (y / 3)) + ((r - 1) / 3)
            } else {
                left = (30 * (y / 3)) + (c - 1)
                right = (30 * (y / 3)) + (errorCorrectionLevel * 3) + ((r - 1) % 3)
            }

            var pattern: CInt = ZX_PDF417_CODEWORD_TABLE[cluster][left]

            self.encodeCharPattern(pattern, len: 17, logic: logic.currentRow)

            var x: CInt = 0

            while x < c {
                defer {
                    x += 1
                }

                pattern = ZX_PDF417_CODEWORD_TABLE[cluster][fullCodewords.characterAtIndex(idx)]
                self.encodeCharPattern(pattern, len: 17, logic: logic.currentRow)
                idx += 1
            }

            if self.compact {
                self.encodeCharPattern(ZX_PDF417_STOP_PATTERN, len: 1, logic: logic.currentRow)
            } else {
                pattern = ZX_PDF417_CODEWORD_TABLE[cluster][right]
                self.encodeCharPattern(pattern, len: 17, logic: logic.currentRow)
                self.encodeCharPattern(ZX_PDF417_STOP_PATTERN, len: 18, logic: logic.currentRow)
            }
        }
    }
    /**
 * @param msg message to encode
 * @param errorCorrectionLevel PDF417 error correction level to use or nil if the contents cannot be
 *   encoded in this format
 */
    /**
 * @param msg message to encode
 * @param errorCorrectionLevel PDF417 error correction level to use or nil if the contents cannot be
 *   encoded in this format
 */
    @objc
    func generateBarcodeLogic(_ msg: String!, errorCorrectionLevel anErrorCorrectionLevel: CInt, error: UnsafeMutablePointer<Error?>!) -> Bool {
        //1. step: High-level encoding
        let errorCorrectionCodeWords = ZXPDF417ErrorCorrection.errorCorrectionCodewordCount(anErrorCorrectionLevel)
        let highLevel = ZXPDF417HighLevelEncoder.encodeHighLevel(msg, compaction: self.compaction, encoding: self.encoding, error: error)

        if highLevel == nil {
            return false
        }

        let sourceCodeWords: CInt = CInt(highLevel?.length)
        let dimension = self.determineDimensions(sourceCodeWords, errorCorrectionCodeWords: errorCorrectionCodeWords, error: error)

        if dimension == nil {
            return false
        }

        let cols: CInt = dimension?.array[0]
        let rows: CInt = dimension?.array[1]
        let pad = self.numberOfPadCodewordsM(sourceCodeWords, k: errorCorrectionCodeWords, c: cols, r: rows)

        //2. step: construct data codewords
        if sourceCodeWords + errorCorrectionCodeWords + 1 > 929 {
            // +1 for symbol length CW
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: String(format: "Encoded message contains to many code words, message to big (%d bytes)", CInt(msg.length))]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return false
        }

        let n = sourceCodeWords + pad + 1
        let sb = NSMutableString(capacity: Int(n))

        sb.appendFormat("%C", n as? unichar)
        sb.appendFormat("%@", highLevel)

        var i: CInt = 0

        while i < pad {
            defer {
                i += 1
            }

            sb.appendFormat("%C", 900 as? unichar) //PAD characters
        }

        let dataCodewords = sb
        //3. step: Error correction
        let ec = ZXPDF417ErrorCorrection.generateErrorCorrection(dataCodewords, errorCorrectionLevel: anErrorCorrectionLevel)
        let fullCodewords: String! = dataCodewords.stringByAppendingString(ec)

        //4. step: low-level encoding
        self.barcodeMatrix = ZXPDF417BarcodeMatrix(height: rows, width: cols)
        self.encodeLowLevel(fullCodewords, c: cols, r: rows, errorCorrectionLevel: anErrorCorrectionLevel, logic: self.barcodeMatrix)

        return true
    }
    /**
 * Determine optimal nr of columns and rows for the specified number of
 * codewords.
 *
 * @param sourceCodeWords number of code words
 * @param errorCorrectionCodeWords number of error correction code words
 * @return dimension object containing cols as width and rows as height
 */
    /**
 * Determine optimal nr of columns and rows for the specified number of
 * codewords.
 *
 * @param sourceCodeWords number of code words
 * @param errorCorrectionCodeWords number of error correction code words
 * @return dimension object containing cols as width and rows as height
 */
    @objc
    func determineDimensions(_ sourceCodeWords: CInt, errorCorrectionCodeWords: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXIntArray? {
        var ratio: CFloat = 0.0
        var dimension: ZXIntArray! = nil
        var cols = self.minCols

        while cols <= self.maxCols {
            defer {
                cols += 1
            }

            let rows = self.calculateNumberOfRowsM(sourceCodeWords, k: errorCorrectionCodeWords, c: cols)

            if rows < self.minRows {
                break
            }

            if rows > self.maxRows {
                continue
            }

            let newRatio: CFloat = (CFloat(17 * cols + 69) * ZX_PDF417_DEFAULT_MODULE_WIDTH) / (CFloat(rows) * ZX_PDF417_HEIGHT)

            // ignore if previous ratio is closer to preferred ratio
            if (dimension != nil) && fabsf(newRatio - ZX_PDF417_PREFERRED_RATIO) > fabsf(ratio - ZX_PDF417_PREFERRED_RATIO) {
                continue
            }

            ratio = newRatio
            dimension = ZXIntArray(ints: cols, rows, 1)
        }

        // Handle case when min values were larger than necessary
        if dimension == nil {
            let rows = self.calculateNumberOfRowsM(sourceCodeWords, k: errorCorrectionCodeWords, c: self.minCols)

            if rows < self.minRows {
                dimension = ZXIntArray(ints: self.minCols, self.minRows, 1)
            }
        }

        if dimension == nil {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Unable to fit message in columns"]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return nil
        }

        return dimension
    }
    /**
 * Sets max/min row/col values
 *
 * @param maxCols maximum allowed columns
 * @param minCols minimum allowed columns
 * @param maxRows maximum allowed rows
 * @param minRows minimum allowed rows
 */
    /**
 * Sets max/min row/col values
 *
 * @param maxCols maximum allowed columns
 * @param minCols minimum allowed columns
 * @param maxRows maximum allowed rows
 * @param minRows minimum allowed rows
 */
    @objc
    func setDimensionsWithMaxCols(_ maxCols: CInt, minCols: CInt, maxRows: CInt, minRows: CInt) {
        self.maxCols = maxCols

        self.minCols = minCols

        self.maxRows = maxRows

        self.minRows = minRows
    }
}

// MARK: -
//mm
@objc
extension ZXPDF417 {
    @objc var minCols: CInt {
        get {
            return self._minCols
        }
        set {
            self._minCols = newValue
        }
    }
    @objc var maxCols: CInt {
        get {
            return self._maxCols
        }
        set {
            self._maxCols = newValue
        }
    }
    @objc var minRows: CInt {
        get {
            return self._minRows
        }
        set {
            self._minRows = newValue
        }
    }
    @objc var maxRows: CInt {
        get {
            return self._maxRows
        }
        set {
            self._maxRows = newValue
        }
    }
}