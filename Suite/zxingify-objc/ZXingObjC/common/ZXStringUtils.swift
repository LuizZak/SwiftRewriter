// Preprocessor directives found in file:
// #import "ZXByteArray.h"
// #import "ZXDecodeHints.h"
// #import "ZXStringUtils.h"
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
 * Common string-related functions.
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
 * Common string-related functions.
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
class ZXStringUtils: NSObject {
    /**
 * @param bytes bytes encoding a string, whose encoding should be guessed
 * @param hints decode hints if applicable
 * @return name of guessed encoding; at the moment will only guess one of:
 *  NSShiftJISStringEncoding, NSUTF8StringEncoding, NSISOLatin1StringEncoding, or the platform
 *  default encoding if none of these can possibly be correct
 */
    /**
 * @param bytes bytes encoding a string, whose encoding should be guessed
 * @param hints decode hints if applicable
 * @return name of guessed encoding; at the moment will only guess one of:
 *  NSShiftJISStringEncoding, NSUTF8StringEncoding, NSISOLatin1StringEncoding, or the platform
 *  default encoding if none of these can possibly be correct
 */
    @objc
    static func guessEncoding(_ bytes: ZXByteArray!, hints: ZXDecodeHints!) -> NSStringEncoding {
        let systemEncoding: NSStringEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringGetSystemEncoding())
        let assumeShiftJIS = systemEncoding == NSShiftJISStringEncoding || systemEncoding == NSJapaneseEUCStringEncoding

        if hints != nil {
            let encoding = hints.encoding

            if encoding > 0 {
                return encoding
            }
        }

        // For now, merely tries to distinguish ISO-8859-1, UTF-8 and Shift_JIS,
        // which should be by far the most common encodings.
        let length: CInt = CInt(bytes.length)
        var canBeISO88591 = true
        var canBeShiftJIS = true
        var canBeUTF8 = true
        var utf8BytesLeft: CInt = 0
        //int utf8LowChars = 0;
        var utf2BytesChars: CInt = 0
        var utf3BytesChars: CInt = 0
        var utf4BytesChars: CInt = 0
        var sjisBytesLeft: CInt = 0
        //int sjisLowChars = 0;
        var sjisKatakanaChars: CInt = 0
        //int sjisDoubleBytesChars = 0;
        var sjisCurKatakanaWordLength: CInt = 0
        var sjisCurDoubleBytesWordLength: CInt = 0
        var sjisMaxKatakanaWordLength: CInt = 0
        var sjisMaxDoubleBytesWordLength: CInt = 0
        //int isoLowChars = 0;
        //int isoHighChars = 0;
        var isoHighOther: CInt = 0
        let utf8bom = length > 3 && bytes.array[0] == 0xef as? int8_t && bytes.array[1] == 0xbb as? int8_t && bytes.array[2] == 0xbf as? int8_t
        var i: CInt = 0

        while i < length && (canBeISO88591 || canBeShiftJIS || canBeUTF8) {
            defer {
                i += 1
            }

            let value: CInt = bytes.array[i] & 0xff

            // UTF-8 stuff
            if canBeUTF8 {
                if utf8BytesLeft > 0 {
                    if (value & 0x80) == 0 {
                        canBeUTF8 = false
                    } else {
                        utf8BytesLeft -= 1
                    }
                } else if (value & 0x80) != 0 {
                    if (value & 0x40) == 0 {
                        canBeUTF8 = false
                    } else {
                        utf8BytesLeft += 1

                        if (value & 0x20) == 0 {
                            utf2BytesChars += 1
                        } else {
                            utf8BytesLeft += 1

                            if (value & 0x10) == 0 {
                                utf3BytesChars += 1
                            } else {
                                utf8BytesLeft += 1

                                if (value & 0x8) == 0 {
                                    utf4BytesChars += 1
                                } else {
                                    canBeUTF8 = false
                                }
                            }
                        }
                    }
                }
            }

            //utf8LowChars++;
            //}
            // ISO-8859-1 stuff
            if canBeISO88591 {
                if value > 0x7f && value < 0xa0 {
                    canBeISO88591 = false
                } else if value > 0x9f {
                    if value < 0xc0 || value == 0xd7 || value == 0xf7 {
                        isoHighOther += 1
                    } //else {
                }
            }

            //isoHighChars++;
            //}
            //isoLowChars++;
            //}
            // Shift_JIS stuff
            if canBeShiftJIS {
                if sjisBytesLeft > 0 {
                    if value < 0x40 || value == 0x7f || value > 0xfc {
                        canBeShiftJIS = false
                    } else {
                        sjisBytesLeft -= 1
                    }
                } else if value == 0x80 || value == 0xa0 || value > 0xef {
                    canBeShiftJIS = false
                } else if value > 0xa0 && value < 0xe0 {
                    sjisKatakanaChars += 1
                    sjisCurDoubleBytesWordLength = 0
                    sjisCurKatakanaWordLength += 1

                    if sjisCurKatakanaWordLength > sjisMaxKatakanaWordLength {
                        sjisMaxKatakanaWordLength = sjisCurKatakanaWordLength
                    }
                } else if value > 0x7f {
                    sjisBytesLeft += 1
                    //sjisDoubleBytesChars++;
                    sjisCurKatakanaWordLength = 0
                    sjisCurDoubleBytesWordLength += 1

                    if sjisCurDoubleBytesWordLength > sjisMaxDoubleBytesWordLength {
                        sjisMaxDoubleBytesWordLength = sjisCurDoubleBytesWordLength
                    }
                } else {
                    //sjisLowChars++;
                    sjisCurKatakanaWordLength = 0
                    sjisCurDoubleBytesWordLength = 0
                }
            }
        }

        if canBeUTF8 && utf8BytesLeft > 0 {
            canBeUTF8 = false
        }

        if canBeShiftJIS && sjisBytesLeft > 0 {
            canBeShiftJIS = false
        }

        // Easy -- if there is BOM or at least 1 valid not-single byte character (and no evidence it can't be UTF-8), done
        if canBeUTF8 && (utf8bom || utf2BytesChars + utf3BytesChars + utf4BytesChars > 0) {
            return NSUTF8StringEncoding
        }

        // Easy -- if assuming Shift_JIS or at least 3 valid consecutive not-ascii characters (and no evidence it can't be), done
        if canBeShiftJIS && (assumeShiftJIS || sjisMaxKatakanaWordLength >= 3 || sjisMaxDoubleBytesWordLength >= 3) {
            return NSShiftJISStringEncoding
        }

        // Distinguishing Shift_JIS and ISO-8859-1 can be a little tough for short words. The crude heuristic is:
        // - If we saw
        //   - only two consecutive katakana chars in the whole text, or
        //   - at least 10% of bytes that could be "upper" not-alphanumeric Latin1,
        // - then we conclude Shift_JIS, else ISO-8859-1
        if canBeISO88591 && canBeShiftJIS {
            return ((sjisMaxKatakanaWordLength == 2 && sjisKatakanaChars == 2) || isoHighOther * 10 >= length) ? NSShiftJISStringEncoding : NSISOLatin1StringEncoding
        }

        // Otherwise, try in order ISO-8859-1, Shift JIS, UTF-8 and fall back to default platform encoding
        if canBeISO88591 {
            return NSISOLatin1StringEncoding
        }

        if canBeShiftJIS {
            return NSShiftJISStringEncoding
        }

        if canBeUTF8 {
            return NSUTF8StringEncoding
        }

        // Otherwise, we take a wild guess with platform encoding
        return systemEncoding
    }
}