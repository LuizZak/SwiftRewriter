// Preprocessor directives found in file:
// #import "ZXOneDimensionalCodeWriter.h"
// #import "ZXBoolArray.h"
// #import "ZXCodaBarReader.h"
// #import "ZXCodaBarWriter.h"
var ZX_CODA_START_END_CHARS: UnsafePointer<unichar>!
var ZX_CODA_ALT_START_END_CHARS: UnsafePointer<unichar>!
var ZX_CHARS_WHICH_ARE_TEN_LENGTH_EACH_AFTER_DECODED: UnsafePointer<unichar>!
var ZX_CODA_DEFAULT_GUARD: unichar

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
 * This class renders CodaBar as ZXBoolArray.
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
 * This class renders CodaBar as ZXBoolArray.
 */
@objc
class ZXCodaBarWriter: ZXOneDimensionalCodeWriter {
    @objc
    static func initialize() {
        if self.self != ZXCodaBarWriter.self {
            return
        }

        ZX_CODA_DEFAULT_GUARD = ZX_CODA_START_END_CHARS[0]
    }
    @objc
    func encode(_ contents: String!) -> ZXBoolArray {
        if contents.length() < 2 {
            // Can't have a start/end guard, so tentatively add default guards
            contents = String(format: "%C%@%C", ZX_CODA_DEFAULT_GUARD, contents, ZX_CODA_DEFAULT_GUARD)
        } else {
            // Verify input and calculate decoded length.
            let firstChar: unichar = contents.uppercaseString().characterAtIndex(0)
            let lastChar: unichar = contents.uppercaseString().characterAtIndex(contents.length - 1)
            let startsNormal = ZXCodaBarReader.arrayContains(ZX_CODA_START_END_CHARS, length: CUnsignedInt(MemoryLayout.size(ofValue: ZX_CODA_START_END_CHARS) / MemoryLayout.size(ofValue: unichar)), key: firstChar)
            let endsNormal = ZXCodaBarReader.arrayContains(ZX_CODA_START_END_CHARS, length: CUnsignedInt(MemoryLayout.size(ofValue: ZX_CODA_START_END_CHARS) / MemoryLayout.size(ofValue: unichar)), key: lastChar)
            let startsAlt = ZXCodaBarReader.arrayContains(ZX_CODA_ALT_START_END_CHARS, length: CUnsignedInt(MemoryLayout.size(ofValue: ZX_CODA_ALT_START_END_CHARS) / MemoryLayout.size(ofValue: unichar)), key: firstChar)
            let endsAlt = ZXCodaBarReader.arrayContains(ZX_CODA_ALT_START_END_CHARS, length: CUnsignedInt(MemoryLayout.size(ofValue: ZX_CODA_ALT_START_END_CHARS) / MemoryLayout.size(ofValue: unichar)), key: lastChar)

            if startsNormal {
                if !endsNormal {
                    /*
                    @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:[NSStringstringWithFormat:@"Invalid start/end guards: %@",contents]userInfo:nil];
                    */
                }
            } else if startsAlt {
                if !endsAlt {
                    /*
                    @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:[NSStringstringWithFormat:@"Invalid start/end guards: %@",contents]userInfo:nil];
                    */
                }
            } else {
                // else already has valid start/end
                // Doesn't start with a guard
                if endsNormal || endsAlt {
                    /*
                    @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:[NSStringstringWithFormat:@"Invalid start/end guards: %@",contents]userInfo:nil];
                    */
                }

                // else doesn't end with guard either, so add a default
                contents = String(format: "%C%@%C", ZX_CODA_DEFAULT_GUARD, contents, ZX_CODA_DEFAULT_GUARD)
            }
        }

        // The start character and the end character are decoded to 10 length each.
        var resultLength: CInt = 20
        var i: CInt = 1

        while i < contents.length - 1 {
            defer {
                i += 1
            }

            if (contents.characterAtIndex(i) >= '0' && contents.characterAtIndex(i) <= '9') || contents.characterAtIndex(i) == '-' || contents.characterAtIndex(i) == '$' {
                resultLength += 9
            } else if ZXCodaBarReader.arrayContains(ZX_CHARS_WHICH_ARE_TEN_LENGTH_EACH_AFTER_DECODED, length: 4, key: contents.characterAtIndex(i)) {
                resultLength += 10
            } else {
                /*
                @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:[NSStringstringWithFormat:@"Cannot encode : '%C'",[contentscharacterAtIndex:i]]userInfo:nil];
                */
            }
        }

        // A blank is placed between each character.
        resultLength += contents.length - 1

        let result = ZXBoolArray(length: CUnsignedInt(resultLength))
        var position: CInt = 0
        var index: CInt = 0

        while index < contents.length {
            defer {
                index += 1
            }

            var c: unichar = contents.uppercaseString().characterAtIndex(index)

            if index == 0 || index == contents.length - 1 {
                // The start/end chars are not in the CodaBarReader.ALPHABET.
                switch c {
                case 'T':
                    c = 'A'
                case 'N':
                    c = 'B'
                case '*':
                    c = 'C'
                case 'E':
                    c = 'D'
                default:
                    break
                }
            }

            var code: CInt = 0
            var i: CInt = 0

            while i < ZX_CODA_ALPHABET_LEN {
                defer {
                    i += 1
                }

                // Found any, because I checked above.
                if c == ZX_CODA_ALPHABET[i] {
                    code = ZX_CODA_CHARACTER_ENCODINGS[i]

                    break
                }
            }

            var color = true
            var counter: CInt = 0
            var bit: CInt = 0

            while bit < 7 {
                // A character consists of 7 digit.
                result.array[position] = color
                position += 1

                if ((code >> (6 - bit)) & 1) == 0 || counter == 1 {
                    color = !color // Flip the color.
                    bit += 1
                    counter = 0
                } else {
                    counter += 1
                }
            }

            if index < contents.length - 1 {
                result.array[position] = false
                position += 1
            }
        }

        return result
    }
}