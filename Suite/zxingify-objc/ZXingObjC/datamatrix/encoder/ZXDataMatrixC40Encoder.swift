// Preprocessor directives found in file:
// #import "ZXDataMatrixEncoder.h"
// #import "ZXDataMatrixC40Encoder.h"
// #import "ZXDataMatrixEncoderContext.h"
// #import "ZXDataMatrixHighLevelEncoder.h"
// #import "ZXDataMatrixSymbolInfo.h"
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
 * Copyright 2013 9 authors
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
class ZXDataMatrixC40Encoder: NSObject, ZXDataMatrixEncoder {
    @objc
    func encodingMode() -> CInt {
        return ZXDataMatrixHighLevelEncoder.c40Encodation()
    }
    @objc
    func encode(_ context: ZXDataMatrixEncoderContext!) {
        //step C
        let buffer = NSMutableString()

        while context.hasMoreCharacters() {
            let c = context.currentChar()

            context.pos += 1

            var lastCharSize = self.encodeChar(c, buffer: buffer)
            let unwritten: CInt = (CInt(buffer.length) / 3) * 2
            let curCodewordCount = context.codewordCount + unwritten

            context.updateSymbolInfoWithLength(curCodewordCount)

            let available = (context.symbolInfo.dataCapacity ?? 0) - curCodewordCount

            if !context.hasMoreCharacters() {
                //Avoid having a single C40 value in the last triplet
                let removed = NSMutableString()

                if (buffer.length % 3) == 2 {
                    if available < 2 || available > 2 {
                        lastCharSize = self.backtrackOneCharacter(context, buffer: buffer, removed: removed, lastCharSize: lastCharSize)
                    }
                }

                while (buffer.length % 3) == 1 && (lastCharSize > 3 || available != 1) {
                    lastCharSize = self.backtrackOneCharacter(context, buffer: buffer, removed: removed, lastCharSize: lastCharSize)
                }

                break
            }

            let count: UInt = buffer.length

            if (count % 3) == 0 {
                let newMode = ZXDataMatrixHighLevelEncoder.lookAheadTest(context.message, startpos: context.pos, currentMode: self.encodingMode())

                if newMode != self.encodingMode() {
                    // Return to ASCII encodation, which will actually handle latch to new mode
                    context.signalEncoderChange(ZXDataMatrixHighLevelEncoder.asciiEncodation())

                    break
                }
            }
        }

        self.handleEOD(context, buffer: buffer)
    }
    @objc
    func backtrackOneCharacter(_ context: ZXDataMatrixEncoderContext!, buffer: NSMutableString!, removed: NSMutableString!, lastCharSize: CInt) -> CInt {
        let count: UInt = buffer.length

        buffer.deleteCharacters(in: NSMakeRange(count - UInt(lastCharSize), lastCharSize))
        context.pos -= 1

        let c: unichar = context.currentChar

        lastCharSize = self.encodeChar(c, buffer: removed)
        context.resetSymbolInfo() //Deal with possible reduction in symbol size

        return lastCharSize
    }
    @objc
    func writeNextTriplet(_ context: ZXDataMatrixEncoderContext!, buffer: NSMutableString!) {
        context.writeCodewords(self.encodeToCodewords(buffer, startpos: 0))
        buffer.deleteCharacters(in: NSMakeRange(0, 3))
    }
    /**
 * Handle "end of data" situations
 */
    @objc
    func handleEOD(_ context: ZXDataMatrixEncoderContext!, buffer: NSMutableString!) {
        let unwritten: CInt = (CInt(buffer.length) / 3) * 2
        let rest: CInt = buffer.length % 3
        let curCodewordCount = context.codewordCount + unwritten

        context.updateSymbolInfoWithLength(curCodewordCount)

        let available = (context.symbolInfo.dataCapacity ?? 0) - curCodewordCount

        if rest == 2 {
            buffer.append("\\0") //Shift 1

            while buffer.length >= 3 {
                self.writeNextTriplet(context, buffer: buffer)
            }

            if context.hasMoreCharacters() {
                context.writeCodeword(ZXDataMatrixHighLevelEncoder.c40Unlatch())
            }
        } else if available == 1 && rest == 1 {
            while buffer.length >= 3 {
                self.writeNextTriplet(context, buffer: buffer)
            }

            if context.hasMoreCharacters() {
                context.writeCodeword(ZXDataMatrixHighLevelEncoder.c40Unlatch())
            }

            // else no latch
            context.pos -= 1
        } else if rest == 0 {
            while buffer.length >= 3 {
                self.writeNextTriplet(context, buffer: buffer)
            }

            if available > 0 || context.hasMoreCharacters() {
                context.writeCodeword(ZXDataMatrixHighLevelEncoder.c40Unlatch())
            }
        } else {
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalStateException"reason:@"Unexpected case. Please report!"userInfo:nil];
            */
        }

        context.signalEncoderChange(ZXDataMatrixHighLevelEncoder.asciiEncodation())
    }
    @objc
    func encodeChar(_ c: unichar, buffer sb: NSMutableString!) -> CInt {
        if c == " " {
            sb.append("\\3")

            return 1
        } else if c >= "0" && c <= "9" {
            sb.appendFormat("%C", (c - 48 + 4) as? unichar)

            return 1
        } else if c >= "A" && c <= "Z" {
            sb.appendFormat("%C", (c - 65 + 14) as? unichar)

            return 1
        } else if c >= "\\0" && c <= 0x1f as? unichar {
            sb.append("\\0") //Shift 1 Set
            sb.appendFormat("%C", c)

            return 2
        } else if c >= "!" && c <= "/" {
            sb.append("\\1") //Shift 2 Set
            sb.appendFormat("%C", (c - 33) as? unichar)

            return 2
        } else if c >= ":" && c <= "@" {
            sb.append("\\1") //Shift 2 Set
            sb.appendFormat("%C", (c - 58 + 15) as? unichar)

            return 2
        } else if c >= "[" && c <= "_" {
            sb.append("\\1") //Shift 2 Set
            sb.appendFormat("%C", (c - 91 + 22) as? unichar)

            return 2
        } else if c >= "\\u0060" && c <= 0x7f as? unichar {
            sb.append("\\2") //Shift 3 Set
            sb.appendFormat("%C", (c - 96) as? unichar)

            return 2
        } else if c >= 0x80 as? unichar {
            sb.appendFormat("\\1%C", 0x1e as? unichar) //Shift 2, Upper Shift

            var len: CInt = 2

            len += self.encodeChar((c - 128) as? unichar, buffer: sb)

            return len
        } else {
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalStateException"reason:[NSStringstringWithFormat:@"Illegal character: %C",c]userInfo:nil];
            */
        }
    }
    @objc
    func encodeToCodewords(_ sb: String!, startpos startPos: CInt) -> String? {
        let c1: unichar = sb.characterAtIndex(startPos)
        let c2: unichar = sb.characterAtIndex(startPos + 1)
        let c3: unichar = sb.characterAtIndex(startPos + 2)
        let v = (1600 * c1) + (40 * c2) + c3 + 1
        let cw1 = (v / 256) as? unichar
        let cw2 = (v % 256) as? unichar

        return String(format: "%C%C", cw1, cw2)
    }
}