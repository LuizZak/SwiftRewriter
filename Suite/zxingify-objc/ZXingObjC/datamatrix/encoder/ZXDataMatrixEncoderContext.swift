// Preprocessor directives found in file:
// #import "ZXEncodeHints.h"
// #import "ZXDataMatrixEncoderContext.h"
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
class ZXDataMatrixEncoderContext: NSObject {
    private var _codewords: NSMutableString!
    private var _message: String!
    private var _newEncoding: CInt = 0
    private var _symbolShape: ZXDataMatrixSymbolShapeHint = ZXDataMatrixSymbolShapeHint.ZXDataMatrixSymbolShapeHintForceNone
    @objc var codewords: NSMutableString! {
        return self._codewords
    }
    @objc var message: String! {
        return self._message
    }
    @objc var newEncoding: CInt {
        get {
            return self._newEncoding
        }
        set {
            self._newEncoding = newValue
        }
    }
    @objc var pos: CInt = 0
    @objc var skipAtEnd: CInt = 0
    @objc var symbolShape: ZXDataMatrixSymbolShapeHint {
        get {
            return self._symbolShape
        }
        set {
            self._symbolShape = newValue
        }
    }
    @objc var symbolInfo: ZXDataMatrixSymbolInfo!
    @objc var maxSize: ZXDimension!
    @objc var minSize: ZXDimension!

    @objc
    init(message msg: String!) {
        if self = super.init() {
            //From this point on Strings are not Unicode anymore!
            let msgData: NSData! = msg.dataUsingEncoding(NSISOLatin1StringEncoding)

            if !msgData {
                NSException.raise(NSInvalidArgumentException, format: "Message contains characters outside ISO-8859-1 encoding.")
            }

            let msgBinary: UnsafePointer<CChar>! = msgData.bytes()
            let sb = NSMutableString()
            var i: CInt = 0, c: CInt = CInt(msg.length)

            while i < c {
                defer {
                    i += 1
                }

                let ch: unichar = (msgBinary[i] & 0xff) as? unichar

                sb.appendFormat("%C", ch)
            }

            _message = String(string: sb)

            _symbolShape = ZXDataMatrixSymbolShapeHint.ZXDataMatrixSymbolShapeHintForceNone

            _codewords = NSMutableString(capacity: msg.length)

            _newEncoding = 1
        }

        return self
    }

    @objc
    func setSizeConstraints(_ minSize: ZXDimension!, maxSize: ZXDimension!) {
        self.minSize = minSize
        self.maxSize = maxSize
    }
    @objc
    func currentChar() -> unichar {
        return self.message.characterAtIndex(self.pos)
    }
    @objc
    func current() -> unichar {
        return self.message.characterAtIndex(self.pos)
    }
    @objc
    func writeCodewords(_ codewords: String!) {
        self.codewords.append(codewords)
    }
    @objc
    func writeCodeword(_ codeword: unichar) {
        self.codewords.appendFormat("%C", codeword)
    }
    @objc
    func codewordCount() -> CInt {
        return CInt(self.codewords.length)
    }
    @objc
    func signalEncoderChange(_ encoding: CInt) {
        self.newEncoding = encoding
    }
    @objc
    func resetEncoderSignal() {
        self.newEncoding = 1
    }
    @objc
    func hasMoreCharacters() -> Bool {
        return self.pos < self.totalMessageCharCount()
    }
    @objc
    func totalMessageCharCount() -> CInt {
        return CInt(self.message.length) - self.skipAtEnd
    }
    @objc
    func remainingCharacters() -> CInt {
        return self.totalMessageCharCount() - self.pos
    }
    @objc
    func updateSymbolInfo() {
        self.updateSymbolInfoWithLength(self.codewordCount())
    }
    @objc
    func updateSymbolInfoWithLength(_ len: CInt) {
        if self.symbolInfo == nil || len > (self.symbolInfo.dataCapacity ?? 0) {
            self.symbolInfo = ZXDataMatrixSymbolInfo.lookup(len, shape: self.symbolShape, minSize: self.minSize, maxSize: self.maxSize, fail: true)
        }
    }
    @objc
    func resetSymbolInfo() {
        self.symbolInfo = nil
    }
}