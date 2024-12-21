// Preprocessor directives found in file:
// #import "ZXUPCEANWriter.h"
// #import "ZXBarcodeFormat.h"
// #import "ZXBoolArray.h"
// #import "ZXEAN8Writer.h"
// #import "ZXUPCEANReader.h"
let ZX_EAN8_CODE_WIDTH: CInt = 3 + (7 * 4) + 5 + (7 * 4) + 3

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
 * This object renders an EAN8 code as a ZXBitMatrix.
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
 * This object renders an EAN8 code as a ZXBitMatrix.
 */
@objc
class ZXEAN8Writer: ZXUPCEANWriter {
    @objc
    override func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if format != ZXBarcodeFormat.kBarcodeFormatEan8 {
            NSException.raise(NSInvalidArgumentException, format: "Can only encode EAN_8")
        }

        return super.encode(contents, format: format, width: width, height: height, hints: hints, error: error)
    }
    /**
 * Returns a byte array of horizontal pixels (FALSE = white, TRUE = black)
 */
    @objc
    func encode(_ contents: String!) -> ZXBoolArray {
        let length: CInt = CInt(contents.length())

        switch length {
        case 7:
            // No check digit present, calculate it and add it
            contents = contents.stringByAppendingString(String(format: "%d", ZXUPCEANReader.standardUPCEANChecksum(contents)))
        case 8:
            if !ZXUPCEANReader.checkStandardUPCEANChecksum(contents) {
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

        let result = ZXBoolArray(length: CUnsignedInt(ZX_EAN8_CODE_WIDTH))
        var pos: CInt = 0

        pos += self.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_START_END_PATTERN, patternLen: ZX_UPC_EAN_START_END_PATTERN_LEN, startColor: true)

        var i: CInt = 0

        while i <= 3 {
            defer {
                i += 1
            }

            let digit: CInt = contents.substringWithRange(NSMakeRange(i, 1)).intValue()

            pos += self.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_L_PATTERNS[digit], patternLen: ZX_UPC_EAN_L_PATTERNS_SUB_LEN, startColor: FALSE)
        }

        pos += self.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_MIDDLE_PATTERN, patternLen: ZX_UPC_EAN_MIDDLE_PATTERN_LEN, startColor: FALSE)

        var i: CInt = 4

        while i <= 7 {
            defer {
                i += 1
            }

            let digit: CInt = contents.substringWithRange(NSMakeRange(i, 1)).intValue()

            pos += super.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_L_PATTERNS[digit], patternLen: ZX_UPC_EAN_L_PATTERNS_SUB_LEN, startColor: true)
        }

        self.appendPattern(result, pos: pos, pattern: ZX_UPC_EAN_START_END_PATTERN, patternLen: ZX_UPC_EAN_START_END_PATTERN_LEN, startColor: true)

        return result
    }
}