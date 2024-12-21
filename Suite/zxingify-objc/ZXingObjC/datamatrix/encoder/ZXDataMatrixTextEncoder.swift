// Preprocessor directives found in file:
// #import "ZXDataMatrixC40Encoder.h"
// #import "ZXDataMatrixHighLevelEncoder.h"
// #import "ZXDataMatrixTextEncoder.h"
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
class ZXDataMatrixTextEncoder: ZXDataMatrixC40Encoder {
    @objc
    func encodingMode() -> CInt {
        return ZXDataMatrixHighLevelEncoder.textEncodation()
    }
    @objc
    func encodeChar(_ c: unichar, buffer sb: NSMutableString!) -> CInt {
        if c == ' ' {
            sb.append("\\3")

            return 1
        }

        if c >= '0' && c <= '9' {
            sb.appendFormat("%C", (c - 48 + 4) as? unichar)

            return 1
        }

        if c >= 'a' && c <= 'z' {
            sb.appendFormat("%C", (c - 97 + 14) as? unichar)

            return 1
        }

        if c >= '\0' && c <= 0x1f as? unichar {
            sb.append("\\0") //Shift 1 Set
            sb.appendFormat("%C", c)

            return 2
        }

        if c >= '!' && c <= '/' {
            sb.append("\\1") //Shift 2 Set
            sb.appendFormat("%C", (c - 33) as? unichar)

            return 2
        }

        if c >= ':' && c <= '@' {
            sb.append("\\1") //Shift 2 Set
            sb.appendFormat("%C", (c - 58 + 15) as? unichar)

            return 2
        }

        if c >= '[' && c <= '_' {
            sb.append("\\1") //Shift 2 Set
            sb.appendFormat("%C", (c - 91 + 22) as? unichar)

            return 2
        }

        if c == '\u0060' {
            sb.append("\\2") //Shift 3 Set
            sb.appendFormat("%C", (c - 96) as? unichar)

            return 2
        }

        if c >= 'A' && c <= 'Z' {
            sb.append("\\2") //Shift 3 Set
            sb.appendFormat("%C", (c - 65 + 1) as? unichar)

            return 2
        }

        if c >= '{' && c <= 0x7f as? unichar {
            sb.append("\\2") //Shift 3 Set
            sb.appendFormat("%C", (c - 123 + 27) as? unichar)

            return 2
        }

        if c >= 0x80 as? unichar {
            sb.appendFormat("\\1%C", 0x1e as? unichar) //Shift 2, Upper Shift

            var len: CInt = 2

            len += self.encodeChar((c - 128) as? unichar, buffer: sb)

            return len
        }

        ZXDataMatrixHighLevelEncoder.illegalCharacter(c)

        return 1
    }
}