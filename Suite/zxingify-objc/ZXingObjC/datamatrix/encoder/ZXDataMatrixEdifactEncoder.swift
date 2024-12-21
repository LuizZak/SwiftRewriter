// Preprocessor directives found in file:
// #import "ZXDataMatrixEncoder.h"
// #import "ZXDataMatrixEdifactEncoder.h"
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
class ZXDataMatrixEdifactEncoder: NSObject, ZXDataMatrixEncoder {
    @objc
    func encodingMode() -> CInt {
        return ZXDataMatrixHighLevelEncoder.edifactEncodation()
    }
    @objc
    func encode(_ context: ZXDataMatrixEncoderContext!) {
        //step F
        let buffer = NSMutableString()

        while context.hasMoreCharacters() {
            let c = context.currentChar()

            self.encodeChar(c, buffer: buffer)
            context.pos += 1

            let count: UInt = buffer.length

            if count >= 4 {
                context.writeCodewords(self.encodeToCodewords(buffer, startpos: 0))
                buffer.deleteCharacters(in: NSMakeRange(0, 4))

                let newMode = ZXDataMatrixHighLevelEncoder.lookAheadTest(context.message, startpos: context.pos, currentMode: self.encodingMode())

                if newMode != self.encodingMode() {
                    // Return to ASCII encodation, which will actually handle latch to new mode
                    context.signalEncoderChange(ZXDataMatrixHighLevelEncoder.asciiEncodation())

                    break
                }
            }
        }

        buffer.appendFormat("%C", 31 as? unichar) //Unlatch
        self.handleEOD(context, buffer: buffer)
    }
    /**
 * Handle "end of data" situations
 *
 * @param context the encoder context
 * @param buffer  the buffer with the remaining encoded characters
 */
    @objc
    func handleEOD(_ context: ZXDataMatrixEncoderContext!, buffer: NSMutableString!) {
        /*
        @try{NSUIntegercount=buffer.length;if(count==0){return;}if(count==1){[contextupdateSymbolInfo];intavailable=context.symbolInfo.dataCapacity-context.codewordCount;intremaining=[contextremainingCharacters];if(remaining>available){[contextupdateSymbolInfoWithLength:context.codewordCount+1];available=context.symbolInfo.dataCapacity-context.codewordCount;}if(remaining<=available&&available<=2){return;}}if(count>4){@throw[NSExceptionexceptionWithName:@"IllegalStateException"reason:@"Count must not exceed 4"userInfo:nil];}intrestChars=(int)count-1;NSString*encoded=[selfencodeToCodewords:bufferstartpos:0];BOOLendOfSymbolReached=![contexthasMoreCharacters];BOOLrestInAscii=endOfSymbolReached&&restChars<=2;if(restChars<=2){[contextupdateSymbolInfoWithLength:context.codewordCount+restChars];intavailable=context.symbolInfo.dataCapacity-context.codewordCount;if(available>=3){restInAscii=NO;[contextupdateSymbolInfoWithLength:context.codewordCount+(int)encoded.length];}}if(restInAscii){[contextresetSymbolInfo];context.pos-=restChars;}else{[contextwriteCodewords:encoded];}}@finally{[contextsignalEncoderChange:[ZXDataMatrixHighLevelEncoderasciiEncodation]];}
        */
    }
    @objc
    func encodeChar(_ c: unichar, buffer sb: NSMutableString!) {
        if c >= ' ' && c <= '?' {
            sb.appendFormat("%C", c)
        } else if c >= '@' && c <= '^' {
            sb.appendFormat("%C", (c - 64) as? unichar)
        } else {
            ZXDataMatrixHighLevelEncoder.illegalCharacter(c)
        }
    }
    @objc
    func encodeToCodewords(_ sb: NSMutableString!, startpos startPos: CInt) -> String? {
        let len: CInt = CInt(sb.length) - startPos

        if len == 0 {
            /*
            @throw[NSExceptionexceptionWithName:@"IllegalStateException"reason:@"Buffer must not be empty"userInfo:nil];
            */
        }

        let c1: unichar = sb.characterAtIndex(startPos)
        let c2: unichar = (len >= 2) ? sb.characterAtIndex(startPos + 1) : 0
        let c3: unichar = (len >= 3) ? sb.characterAtIndex(startPos + 2) : 0
        let c4: unichar = (len >= 4) ? sb.characterAtIndex(startPos + 3) : 0
        let v = (c1 << 18) + (c2 << 12) + (c3 << 6) + c4
        let cw1 = ((v >> 16) & 255) as? unichar
        let cw2 = ((v >> 8) & 255) as? unichar
        let cw3 = (v & 255) as? unichar
        let res = NSMutableString(capacity: 3)

        res.appendFormat("%C", cw1)

        if len >= 2 {
            res.appendFormat("%C", cw2)
        }

        if len >= 3 {
            res.appendFormat("%C", cw3)
        }

        return String.stringWithString(res)
    }
}