// Preprocessor directives found in file:
// #import "ZXUPCEANWriter.h"
// #import "ZXBarcodeFormat.h"
// #import "ZXBoolArray.h"
// #import "ZXEAN13Reader.h"
// #import "ZXEAN13Writer.h"
// #import "ZXUPCEANReader.h"
let ZX_EAN13_CODE_WIDTH: CInt = 3 + (7 * 6) + 5 + (7 * 6) + 3

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
 * This object renders an EAN13 code as a ZXBitMatrix.
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
 * This object renders an EAN13 code as a ZXBitMatrix.
 */
// start guard
// left bars
// middle guard
// right bars
// end guard
@objc
class ZXEAN13Writer: ZXUPCEANWriter {
    @objc
    override func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if format != ZXBarcodeFormat.kBarcodeFormatEan13 {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:[NSStringstringWithFormat:@"Can only encode EAN_13, but got %d",format]userInfo:nil];
            */
        }

        return super.encode(contents, format: format, width: width, height: height, hints: hints, error: error)
    }
    @objc
    func encode(_ contents: String!) -> ZXBoolArray {
        let length: CInt = CInt(contents.length())

        switch length {
        case 12:
            // No check digit present, calculate it and add it
            contents = contents.stringByAppendingString(String(format: "%d", ZXUPCEANReader.standardUPCEANChecksum(contents)))
        case 13:
            if !ZXUPCEANReader.checkStandardUPCEANChecksum(contents) {
                /*
                @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"Contents do not pass checksum"userInfo:nil];
                */
            }
        default:
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:[NSStringstringWithFormat:@"Requested contents should be 12 or 13 digits long, but got %d",(int)[contentslength]]userInfo:nil];
            */
        }

        if !self.isNumeric(contents) {
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"Input should only contain digits 0-9"userInfo:nil];
            */
        }

        let firstDigit: CInt = contents.substringToIndex(1).intValue()
        let parities: CInt = ZX_EAN13_FIRST_DIGIT_ENCODINGS[firstDigit]
        let result = ZXBoolArray(length: CUnsignedInt(ZX_EAN13_CODE_WIDTH))
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

            pos += self.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_L_AND_G_PATTERNS[digit], patternLen: ZX_UPC_EAN_L_PATTERNS_SUB_LEN, startColor: FALSE)
        }

        pos += self.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_MIDDLE_PATTERN, patternLen: ZX_UPC_EAN_MIDDLE_PATTERN_LEN, startColor: FALSE)

        var i: CInt = 7

        while i <= 12 {
            defer {
                i += 1
            }

            var digit: CInt = contents.substringWithRange(NSMakeRange(i, 1)).intValue()

            pos += self.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_L_PATTERNS[digit], patternLen: ZX_UPC_EAN_L_PATTERNS_SUB_LEN, startColor: true)
        }

        self.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_START_END_PATTERN, patternLen: ZX_UPC_EAN_START_END_PATTERN_LEN, startColor: true)

        return result
    }
}