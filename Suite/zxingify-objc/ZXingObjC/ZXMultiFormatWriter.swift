import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXWriter.h"
// #import "ZXBitMatrix.h"
// #import "ZXErrors.h"
// #import "ZXMultiFormatWriter.h"
// #if defined(ZXINGOBJC_AZTEC) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXAztecWriter.h"
// #endif
// #if defined(ZXINGOBJC_ONED) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXCodaBarWriter.h"
// #import "ZXCode39Writer.h"
// #import "ZXCode93Writer.h"
// #import "ZXCode128Writer.h"
// #import "ZXEAN8Writer.h"
// #import "ZXEAN13Writer.h"
// #import "ZXITFWriter.h"
// #import "ZXUPCAWriter.h"
// #import "ZXUPCEWriter.h"
// #endif
// #if defined(ZXINGOBJC_DATAMATRIX) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXDataMatrixWriter.h"
// #endif
// #if defined(ZXINGOBJC_PDF417) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXPDF417Writer.h"
// #endif
// #if defined(ZXINGOBJC_QRCODE) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #import "ZXQRCodeWriter.h"
// #endif
// #if defined(ZXINGOBJC_ONED) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_QRCODE) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_PDF417) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_DATAMATRIX) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
// #if defined(ZXINGOBJC_AZTEC) || !defined(ZXINGOBJC_USE_SUBSPECS)
// #endif
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
 * This is a factory class which finds the appropriate Writer subclass for the BarcodeFormat
 * requested and encodes the barcode with the supplied contents.
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
 * This is a factory class which finds the appropriate Writer subclass for the BarcodeFormat
 * requested and encodes the barcode with the supplied contents.
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
class ZXMultiFormatWriter: NSObject, ZXWriter {
    @objc
    static func writer() -> AnyObject? {
        return ZXMultiFormatWriter()
    }
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        return self.encode(contents, format: format, width: width, height: height, hints: nil, error: error)
    }
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        var writer: ZXWriter!

        switch format {
        case ZXBarcodeFormat.kBarcodeFormatEan8:
            writer = ZXEAN8Writer()
        case ZXBarcodeFormat.kBarcodeFormatEan13:
            writer = ZXEAN13Writer()
        case ZXBarcodeFormat.kBarcodeFormatUPCA:
            writer = ZXUPCAWriter()
        case ZXBarcodeFormat.kBarcodeFormatUPCE:
            writer = ZXUPCEWriter()
        case ZXBarcodeFormat.kBarcodeFormatCode39:
            writer = ZXCode39Writer()
        case ZXBarcodeFormat.kBarcodeFormatCode93:
            writer = ZXCode93Writer()
        case ZXBarcodeFormat.kBarcodeFormatCode128:
            writer = ZXCode128Writer()
        case ZXBarcodeFormat.kBarcodeFormatITF:
            writer = ZXITFWriter()
        case ZXBarcodeFormat.kBarcodeFormatCodabar:
            writer = ZXCodaBarWriter()
        case ZXBarcodeFormat.kBarcodeFormatQRCode:
            writer = ZXQRCodeWriter()
        case ZXBarcodeFormat.kBarcodeFormatPDF417:
            writer = ZXPDF417Writer()
        case ZXBarcodeFormat.kBarcodeFormatDataMatrix:
            writer = ZXDataMatrixWriter()
        case ZXBarcodeFormat.kBarcodeFormatAztec:
            writer = ZXAztecWriter()
        default:
            if error {
                *error = Error.errorWithDomain(ZXErrorDomain, code: ZXWriterError, userInfo: [NSLocalizedDescriptionKey: "No encoder available for format"])
            }

            return nil
        }

        /*
        @try{return[writerencode:contentsformat:formatwidth:widthheight:heighthints:hintserror:error];}@catch(NSException*exception){if(error){*error=[NSErrorerrorWithDomain:ZXErrorDomaincode:ZXWriterErroruserInfo:@{NSLocalizedDescriptionKey:exception.reason}];}returnnil;}
        */
    }
}