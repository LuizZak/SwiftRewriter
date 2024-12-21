// Preprocessor directives found in file:
// #import "ZXUPCEANWriter.h"
// #import "ZXUPCEWriter.h"
// #import "ZXUPCEANReader.h"
// #import "ZXUPCEReader.h"
// #import "ZXBoolArray.h"
let ZX_UPCE_CODE_WIDTH: CInt = 3 + (7 * 6) + 6

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
class ZXUPCEWriter: ZXUPCEANWriter {
    @objc
    override func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if format != ZXBarcodeFormat.kBarcodeFormatUPCE {
            NSException.raise(NSInvalidArgumentException, format: "Can only encode UPC_E")
        }

        return super.encode(contents, format: format, width: width, height: height, hints: hints, error: error)
    }
    @objc
    func encode(_ contents: String!) -> ZXBoolArray {
        let length: CInt = CInt(contents.length())

        switch length {
        case 7:
            // No check digit present, calculate it and add it
            contents = contents.stringByAppendingString(String(format: "%d", ZXUPCEANReader.standardUPCEANChecksum(ZXUPCEReader.convertUPCEtoUPCA(contents))))
        case 8:
            if !ZXUPCEReader.checkStandardUPCEANChecksum(contents) {
                /*
                @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"Contents do not pass checksum"userInfo:nil];
                */
            }
        default:
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:[NSStringstringWithFormat:@"Requested contents should be 7 or 8 digits long, but got %d",(int)[contentslength]]userInfo:nil];
            */
        }

        if !self.isNumeric(contents) {
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"Input should only contain digits 0-9"userInfo:nil];
            */
        }

        let firstDigit: CInt = contents.substringWithRange(NSMakeRange(0, 1)).intValue()

        if firstDigit != 0 && firstDigit != 1 {
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"Number system must be 0 or 1"userInfo:nil];
            */
        }

        let checkDigit: CInt = contents.substringWithRange(NSMakeRange(7, 1)).intValue()
        let parities: CInt = ZX_UCPE_NUMSYS_AND_CHECK_DIGIT_PATTERNS[firstDigit][checkDigit]
        let result = ZXBoolArray(length: CUnsignedInt(ZX_UPCE_CODE_WIDTH))
        var pos: CInt = 0

        pos += self.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_START_END_PATTERN, patternLen: ZX_UPC_EAN_START_END_PATTERN_LEN, startColor: true)

        var i: CInt = 1

        while i <= 6 {
            defer {
                i += 1
            }

            var digit: CInt = contents.substringWithRange(NSMakeRange(i, 1)).intValue()

            if (parities >> (6 - i) & 1) == 1 {
                digit += 10
            }

            pos += self.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_L_AND_G_PATTERNS[digit], patternLen: ZX_UPC_EAN_L_PATTERNS_SUB_LEN, startColor: false)
        }

        self.appendPattern(result, pos: pos, pattern: ZX_UPCE_MIDDLE_END_PATTERN, patternLen: ZX_UPCE_MIDDLE_END_PATTERN_LEN, startColor: false)

        return result
    }
}