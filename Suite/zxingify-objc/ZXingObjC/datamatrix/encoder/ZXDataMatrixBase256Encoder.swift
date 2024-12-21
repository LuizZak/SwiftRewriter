// Preprocessor directives found in file:
// #import "ZXDataMatrixEncoder.h"
// #import "ZXDataMatrixBase256Encoder.h"
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
class ZXDataMatrixBase256Encoder: NSObject, ZXDataMatrixEncoder {
    @objc
    func encodingMode() -> CInt {
        return ZXDataMatrixHighLevelEncoder.base256Encodation()
    }
    @objc
    func encode(_ context: ZXDataMatrixEncoderContext!) {
        let buffer = NSMutableString()

        buffer.append("\\0") //Initialize length field

        while context.hasMoreCharacters() {
            let c = context.currentChar()

            buffer.appendFormat("%C", c)
            context.pos += 1

            let newMode = ZXDataMatrixHighLevelEncoder.lookAheadTest(context.message, startpos: context.pos, currentMode: self.encodingMode())

            if newMode != self.encodingMode() {
                // Return to ASCII encodation, which will actually handle latch to new mode
                context.signalEncoderChange(ZXDataMatrixHighLevelEncoder.asciiEncodation())

                break
            }
        }

        let dataCount: CInt = CInt(buffer.length) - 1
        let lengthFieldSize: CInt = 1
        let currentSize = context.codewordCount() + dataCount + lengthFieldSize

        context.updateSymbolInfoWithLength(currentSize)

        let mustPad = ((context.symbolInfo.dataCapacity ?? 0) - currentSize) > 0

        if context.hasMoreCharacters() || mustPad {
            if dataCount <= 249 {
                buffer.replaceCharacters(in: NSMakeRange(0, 1), with: String(format: "%C", dataCount as? unichar))
            } else if dataCount > 249 && dataCount <= 1555 {
                buffer.replaceCharacters(in: NSMakeRange(0, 1), with: String(format: "%C", ((dataCount / 250) + 249) as? unichar))
                buffer.insert(String(format: "%C", (dataCount % 250) as? unichar), at: 1)
            } else {
                /*
                @throw[NSExceptionexceptionWithName:@"IllegalStateException"reason:[NSStringstringWithFormat:@"Message length not in valid ranges: %d",dataCount]userInfo:nil];
                */
            }
        }

        var i: CInt = 0, c: CInt = CInt(buffer.length)

        while i < c {
            defer {
                i += 1
            }

            context.writeCodeword(self.randomize255State(buffer.characterAtIndex(i), codewordPosition: context.codewordCount + 1))
        }
    }
    @objc
    func randomize255State(_ ch: unichar, codewordPosition: CInt) -> unichar {
        let pseudoRandom = ((149 * codewordPosition) % 255) + 1
        let tempVariable = ch + pseudoRandom

        if tempVariable <= 255 {
            return tempVariable as? unichar
        } else {
            return (tempVariable - 256) as? unichar
        }
    }
}