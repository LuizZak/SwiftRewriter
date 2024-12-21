// Preprocessor directives found in file:
// #import "ZXOneDimensionalCodeWriter.h"
// #import "ZXBoolArray.h"
// #import "ZXITFReader.h"
// #import "ZXITFWriter.h"
var ZX_ITF_WRITER_START_PATTERN: UnsafePointer<CInt>!
var ZX_ITF_WRITER_END_PATTERN: UnsafePointer<CInt>!
let ZX_ITF_W3: CInt = 3
let ZX_ITF_N: CInt = 1
let ZX_ITF_WRITER_PATTERNS_LEN: CInt = 10
var ZX_ITF_WRITER_PATTERNS: (CInt, CInt, CInt, CInt, CInt)

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
 * This object renders a ITF code as a ZXBitMatrix.
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
 * This object renders a ITF code as a ZXBitMatrix.
 */
// 0
// 1
// 2
// 3
// 4
// 5
// 6
// 7
// 8
// 9
@objc
class ZXITFWriter: ZXOneDimensionalCodeWriter {
    @objc
    override func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix? {
        if format != ZXBarcodeFormat.kBarcodeFormatITF {
            NSException.raise(NSInvalidArgumentException, format: "Can only encode ITF")
        }

        return super.encode(contents, format: format, width: width, height: height, hints: hints, error: error)
    }
    @objc
    func encode(_ contents: String!) -> ZXBoolArray {
        let length: CInt = CInt(contents.length())

        if length % 2 != 0 {
            NSException.raise(NSInvalidArgumentException, format: "The length of the input should be even")
        }

        if length > 80 {
            NSException.raise(NSInvalidArgumentException, format: "Requested contents should be less than 80 digits long, but got %d", length)
        }

        if !self.isNumeric(contents) {
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"Input should only contain digits 0-9"userInfo:nil];
            */
        }

        let result = ZXBoolArray(length: CUnsignedInt(9 + 9 * length))
        var pos = self.appendPattern(result, pos: 0, pattern: ZX_ITF_WRITER_START_PATTERN, patternLen: CInt(MemoryLayout.size(ofValue: ZX_ITF_WRITER_START_PATTERN) / MemoryLayout<CInt>.size), startColor: true)
        var i: CInt = 0

        while i < length {
            defer {
                i += 2
            }

            let one: CInt = contents.substringWithRange(NSMakeRange(i, 1)).intValue()
            let two: CInt = contents.substringWithRange(NSMakeRange(i + 1, 1)).intValue()
            let encodingLen: CInt = 10
            var encoding: UnsafeMutablePointer<CInt>!

            memset(encoding, 0, Int(encodingLen) * MemoryLayout<CInt>.size)

            var j: CInt = 0

            while j < 5 {
                defer {
                    j += 1
                }

                encoding[2 * j] = ZX_ITF_WRITER_PATTERNS[one][j]
                encoding[2 * j + 1] = ZX_ITF_WRITER_PATTERNS[two][j]
            }

            pos += super.appendPattern(result, pos: pos, pattern: encoding, patternLen: encodingLen, startColor: true)
        }

        self.appendPattern(result, pos: pos, pattern: ZX_ITF_WRITER_END_PATTERN, patternLen: CInt(MemoryLayout.size(ofValue: ZX_ITF_WRITER_END_PATTERN) / MemoryLayout<CInt>.size), startColor: true)

        return result
    }
}