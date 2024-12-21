// Preprocessor directives found in file:
// #import "ZXWriter.h"
// #import "ZXBitMatrix.h"
// #import "ZXByteMatrix.h"
// #import "ZXEncodeHints.h"
// #import "ZXQRCode.h"
// #import "ZXQRCodeEncoder.h"
// #import "ZXQRCodeErrorCorrectionLevel.h"
// #import "ZXQRCodeWriter.h"
let ZX_QUIET_ZONE_SIZE: CInt = 4

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
 * This object renders a QR Code as a BitMatrix 2D array of greyscale values.
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
 * This object renders a QR Code as a BitMatrix 2D array of greyscale values.
 */
@objc
class ZXQRCodeWriter: NSObject, ZXWriter {
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        return self.encode(contents, format: format, width: width, height: height, hints: nil, error: error)
    }
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        if contents.length() == 0 {
            NSException.raise(NSInvalidArgumentException, format: "Found empty contents")
        }

        if format != ZXBarcodeFormat.kBarcodeFormatQRCode {
            NSException.raise(NSInvalidArgumentException, format: "Can only encode QR_CODE")
        }

        if width < 0 || height < 0 {
            NSException.raise(NSInvalidArgumentException, format: "Requested dimensions are too small: %dx%d", width, height)
        }

        var errorCorrectionLevel = ZXQRCodeErrorCorrectionLevel.errorCorrectionLevelL()
        var quietZone = ZX_QUIET_ZONE_SIZE

        if hints != nil {
            if hints.errorCorrectionLevel {
                errorCorrectionLevel = hints.errorCorrectionLevel
            }

            if hints.margin {
                quietZone = hints.margin.intValue()
            }
        }

        let code = ZXQRCodeEncoder.encode(contents, ecLevel: errorCorrectionLevel, hints: hints, error: error)

        return self.renderResult(code, width: width, height: height, quietZone: quietZone)
    }
    @objc
    func renderResult(_ code: ZXQRCode!, width: CInt, height: CInt, quietZone: CInt) -> ZXBitMatrix {
        let input = code.matrix

        if input == nil {
            return nil
        }

        let inputWidth = input?.width ?? 0
        let inputHeight = input?.height ?? 0
        let qrWidth = inputWidth + (quietZone * 2)
        let qrHeight = inputHeight + (quietZone * 2)
        let outputWidth = max(width, qrWidth)
        let outputHeight = max(height, qrHeight)
        let multiple = min(outputWidth / qrWidth, outputHeight / qrHeight)
        // Padding includes both the quiet zone and the extra white pixels to accommodate the requested
        // dimensions. For example, if input is 25x25 the QR will be 33x33 including the quiet zone.
        // If the requested size is 200x160, the multiple will be 4, for a QR of 132x132. These will
        // handle all the padding from 100x100 (the actual QR) up to 200x160.
        let leftPadding = (outputWidth - (inputWidth * multiple)) / 2
        let topPadding = (outputHeight - (inputHeight * multiple)) / 2
        let output = ZXBitMatrix(width: outputWidth, height: outputHeight)
        var inputY: CInt = 0, outputY = topPadding

        while inputY < inputHeight {
            defer {
                inputY += 1
                outputY += multiple
            }

            var inputX: CInt = 0, outputX = leftPadding

            while inputX < inputWidth {
                defer {
                    inputX += 1
                    outputX += multiple
                }

                if input?.getX(inputX, y: inputY) == 1 {
                    output.setRegionAtLeft(outputX, top: outputY, width: multiple, height: multiple)
                }
            }
        }

        return output
    }
}