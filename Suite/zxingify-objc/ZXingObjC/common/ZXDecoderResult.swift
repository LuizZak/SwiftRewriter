// Preprocessor directives found in file:
// #import "ZXByteArray.h"
// #import "ZXDecoderResult.h"
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
 * Encapsulates the result of decoding a matrix of bits. This typically
 * applies to 2D barcode formats. For now it contains the raw bytes obtained,
 * as well as a String interpretation of those bytes, if applicable.
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
 * Encapsulates the result of decoding a matrix of bits. This typically
 * applies to 2D barcode formats. For now it contains the raw bytes obtained,
 * as well as a String interpretation of those bytes, if applicable.
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
class ZXDecoderResult: NSObject {
    private var _rawBytes: ZXByteArray!
    private var _numBits: CInt = 0
    private var _text: String!
    private var _byteSegments: NSMutableArray!
    private var _ecLevel: String!
    private var _structuredAppendParity: CInt = 0
    private var _structuredAppendSequenceNumber: CInt = 0
    @objc var rawBytes: ZXByteArray! {
        return self._rawBytes
    }
    @objc var numBits: CInt {
        get {
            return self._numBits
        }
        set {
            self._numBits = newValue
        }
    }
    @objc var text: String! {
        return self._text
    }
    @objc var byteSegments: NSMutableArray! {
        return self._byteSegments
    }
    @objc var ecLevel: String! {
        return self._ecLevel
    }
    @objc var errorsCorrected: NSNumber!
    @objc var erasures: NSNumber!
    @objc var other: AnyObject!
    @objc var structuredAppendParity: CInt {
        return self._structuredAppendParity
    }
    @objc var structuredAppendSequenceNumber: CInt {
        return self._structuredAppendSequenceNumber
    }

    @objc
    init(rawBytes: ZXByteArray!, text: String!, byteSegments: NSMutableArray!, ecLevel: String!) {
        return self.init(rawBytes: rawBytes, text: text, byteSegments: byteSegments, ecLevel: ecLevel, saSequence: 1, saParity: 1)
    }
    @objc
    init(rawBytes: ZXByteArray!, text: String!, byteSegments: NSMutableArray!, ecLevel: String!, saSequence: CInt, saParity: CInt) {
        if self = super.init() {
            _rawBytes = rawBytes

            _numBits = (rawBytes == nil) ? 0 : 8 * rawBytes.length

            _text = text

            _byteSegments = byteSegments

            _ecLevel = ecLevel

            _structuredAppendParity = saParity

            _structuredAppendSequenceNumber = saSequence
        }

        return self
    }

    @objc
    func hasStructuredAppend() -> Bool {
        return self.structuredAppendParity >= 0 && self.structuredAppendSequenceNumber >= 0
    }
}