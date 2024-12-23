// Preprocessor directives found in file:
// #import "ZXDataMatrixC40Encoder.h"
// #import "ZXDataMatrixEncoderContext.h"
// #import "ZXDataMatrixHighLevelEncoder.h"
// #import "ZXDataMatrixSymbolInfo.h"
// #import "ZXDataMatrixX12Encoder.h"
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
class ZXDataMatrixX12Encoder: ZXDataMatrixC40Encoder {
    @objc
    func encodingMode() -> CInt {
        return ZXDataMatrixHighLevelEncoder.x12Encodation()
    }
    @objc
    func encode(_ context: ZXDataMatrixEncoderContext!) {
        //step C
        let buffer = NSMutableString()

        while context.hasMoreCharacters() {
            let c = context.currentChar()

            context.pos += 1
            self.encodeChar(c, buffer: buffer)

            let count: UInt = buffer.length

            if (count % 3) == 0 {
                self.writeNextTriplet(context, buffer: buffer)

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
    func encodeChar(_ c: unichar, buffer sb: NSMutableString!) -> CInt {
        if c == "\\r" {
            sb.append("\\0")
        } else if c == "*" {
            sb.append("\\1")
        } else if c == ">" {
            sb.append("\\2")
        } else if c == " " {
            sb.append("\\3")
        } else if c >= "0" && c <= "9" {
            sb.appendFormat("%C", (c - 48 + 4) as? unichar)
        } else if c >= "A" && c <= "Z" {
            sb.appendFormat("%C", (c - 65 + 14) as? unichar)
        } else {
            ZXDataMatrixHighLevelEncoder.illegalCharacter(c)
        }

        return 1
    }
    @objc
    func handleEOD(_ context: ZXDataMatrixEncoderContext!, buffer: NSMutableString!) {
        context.updateSymbolInfo()

        let available = (context.symbolInfo.dataCapacity ?? 0) - context.codewordCount()
        let count: CInt = CInt(buffer.length)

        context.pos -= count

        if context.remainingCharacters > 1 || available > 1 || context.remainingCharacters != available {
            context.writeCodeword(ZXDataMatrixHighLevelEncoder.x12Unlatch())
        }

        if context.newEncoding < 0 {
            context.signalEncoderChange(ZXDataMatrixHighLevelEncoder.asciiEncodation())
        }
    }
}