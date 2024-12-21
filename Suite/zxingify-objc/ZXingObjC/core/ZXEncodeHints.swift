import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXEncodeHints.h"
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
 * Enumeration for DataMatrix symbol shape hint. It can be used to force square or rectangular
 * symbols.
 */
@objc
enum ZXDataMatrixSymbolShapeHint: CInt {
    case ZXDataMatrixSymbolShapeHintForceNone
    case ZXDataMatrixSymbolShapeHintForceSquare
    case ZXDataMatrixSymbolShapeHintForceRectangle
}
@objc
enum ZXPDF417Compaction: CInt {
    case ZXPDF417CompactionAuto
    case ZXPDF417CompactionText
    case ZXPDF417CompactionByte
    case ZXPDF417CompactionNumeric
}

/**
 * These are a set of hints that you may pass to Writers to specify their behavior.
 */
/**
 * These are a set of hints that you may pass to Writers to specify their behavior.
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
class ZXEncodeHints: NSObject {
    /**
 * Specifies what character encoding to use where applicable.
 */
    @objc var encoding: NSStringEncoding
    /**
 * Specifies the matrix shape for Data Matrix.
 */
    @objc var dataMatrixShape: ZXDataMatrixSymbolShapeHint = ZXDataMatrixSymbolShapeHint.ZXDataMatrixSymbolShapeHintForceNone
    /**
 * Specifies a minimum barcode size. Only applicable to Data Matrix now.
 *
 * @deprecated use width/height params in
 * ZXDataMatrixWriter encode:format:width:height:error:
 */
    @objc var minSize: ZXDimension!
    /**
 * Specifies a maximum barcode size. Only applicable to Data Matrix now.
 *
 * @deprecated without replacement
 */
    @objc var maxSize: ZXDimension!
    /**
 * Specifies what degree of error correction to use, for example in QR Codes.
 * For Aztec it represents the minimal percentage of error correction words.
 * Note: an Aztec symbol should have a minimum of 25% EC words.
 */
    @objc var errorCorrectionLevel: ZXQRCodeErrorCorrectionLevel!
    /**
 * Specifies what degree of error correction to use, for example in PDF417 Codes.
 * For PDF417 valid values are 0 to 8.
 */
    @objc var errorCorrectionLevelPDF417: NSNumber!
    /**
 * Specifies what percent of error correction to use.
 * For Aztec it represents the minimal percentage of error correction words.
 * Note: an Aztec symbol should have a minimum of 25% EC words.
 */
    @objc var errorCorrectionPercent: NSNumber!
    /**
 * Specifies margin, in pixels, to use when generating the barcode. The meaning can vary
 * by format; for example it controls margin before and after the barcode horizontally for
 * most 1D formats.
 */
    @objc var margin: NSNumber!
    /**
 * Specifies if long lines should be drawn, only applies to {`ean13`, `ean8`}.
 */
    @objc var showLongLines: Bool = false
    /**
 * Specifies whether to use compact mode for PDF417.
 */
    @objc var pdf417Compact: Bool = false
    /**
 * Specifies what compaction mode to use for PDF417.
 */
    @objc var pdf417Compaction: ZXPDF417Compaction = ZXPDF417Compaction.ZXPDF417CompactionAuto
    /**
 * Specifies the minimum and maximum number of rows and columns for PDF417.
 */
    @objc var pdf417Dimensions: ZXPDF417Dimensions!
    /**
 * Specifies the required number of layers for an Aztec code:
 *   a negative number (-1, -2, -3, -4) specifies a compact Aztec code
 *   0 indicates to use the minimum number of layers (the default)
 *   a positive number (1, 2, .. 32) specifies a normaol (non-compact) Aztec code
 */
    @objc var aztecLayers: NSNumber!
    /**
 * Specifies the exact version of QR code to be encoded. An integer. If the data specified
 * cannot fit within the required version, nil we be returned.
 */
    @objc var qrVersion: NSNumber!
    /**
 * Specifies whether the data should be encoded to the GS1 standard.
 */
    @objc var gs1Format: Bool = false

    @objc
    static func hints() -> AnyObject? {
        return self.init()
    }
}