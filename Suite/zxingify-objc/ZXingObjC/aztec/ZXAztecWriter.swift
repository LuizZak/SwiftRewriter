// Preprocessor directives found in file:
// #import "ZXWriter.h"
// #import "ZXAztecCode.h"
// #import "ZXAztecEncoder.h"
// #import "ZXAztecWriter.h"
// #import "ZXBitMatrix.h"
// #import "ZXByteArray.h"
// #import "ZXEncodeHints.h"
let ZX_AZTEC_DEFAULT_ENCODING: NSStringEncoding = NSISOLatin1StringEncoding

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
@objc
class ZXAztecWriter: NSObject, ZXWriter {
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        return self.encode(contents, format: format, width: width, height: height, hints: nil, error: error)
    }
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        let encoding = hints.encoding
        let eccPercent = hints.errorCorrectionPercent
        let layers = hints.aztecLayers

        return self.encode(contents, format: format, width: width, height: height, encoding: (encoding == 0) ? ZX_AZTEC_DEFAULT_ENCODING : encoding, eccPercent: (eccPercent == nil) ? ZX_AZTEC_DEFAULT_EC_PERCENT : eccPercent?.intValue(), layers: (layers == nil) ? ZX_AZTEC_DEFAULT_LAYERS : layers?.intValue())
    }
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, encoding: NSStringEncoding, eccPercent: CInt, layers: CInt) -> ZXBitMatrix {
        if format != ZXBarcodeFormat.kBarcodeFormatAztec {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:[NSStringstringWithFormat:@"Can only encode kBarcodeFormatAztec (%d), but got %d",kBarcodeFormatAztec,format]userInfo:nil];
            */
        }

        let data: NSData! = contents.dataUsingEncoding(encoding)
        let bytes = ZXByteArray(length: CUnsignedInt(data.length()))

        memcpy(bytes.array, data.bytes(), Int(bytes.length) * MemoryLayout.size(ofValue: int8_t))

        let aztec = ZXAztecEncoder.encode(bytes, minECCPercent: eccPercent, userSpecifiedLayers: layers)

        return self.renderResult(aztec, width: width, height: height)
    }
    @objc
    func renderResult(_ aztec: ZXAztecCode!, width: CInt, height: CInt) -> ZXBitMatrix {
        let input = aztec.matrix

        if input == nil {
            return nil
        }

        let inputWidth = input?.width ?? 0
        let inputHeight = input?.height ?? 0
        let outputWidth = max(width, inputWidth)
        let outputHeight = max(height, inputHeight)
        let multiple = min(outputWidth / inputWidth, outputHeight / inputHeight)
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

                if input?.getX(inputX, y: inputY) == true {
                    output.setRegionAtLeft(outputX, top: outputY, width: multiple, height: multiple)
                }
            }
        }

        return output
    }
}