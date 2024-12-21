import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXQRCodeErrorCorrectionLevel.h"
var FOR_BITS: NSArray! = nil

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
 * See ISO 18004:2006, 6.5.1. This enum encapsulates the four error correction levels
 * defined by the QR code standard.
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
 * See ISO 18004:2006, 6.5.1. This enum encapsulates the four error correction levels
 * defined by the QR code standard.
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
class ZXQRCodeErrorCorrectionLevel: NSObject {
    private var _bits: CInt = 0
    private var _name: String!
    private var _ordinal: CInt = 0
    @objc var bits: CInt {
        return self._bits
    }
    @objc var name: String! {
        return self._name
    }
    @objc var ordinal: CInt {
        return self._ordinal
    }

    @objc
    init(ordinal: CInt, bits: CInt, name: String!) {
        if self = super.init() {
            _ordinal = ordinal
            _bits = bits
            _name = name
        }

        return self
    }

    @objc
    func description() -> String? {
        return self.name
    }
    /**
 * @param bits int containing the two bits encoding a QR Code's error correction level
 * @return ErrorCorrectionLevel representing the encoded error correction level
 */
    /**
 * @param bits int containing the two bits encoding a QR Code's error correction level
 * @return ErrorCorrectionLevel representing the encoded error correction level
 */
    @objc
    static func forBits(_ bits: CInt) -> ZXQRCodeErrorCorrectionLevel? {
        if !FOR_BITS {
            FOR_BITS = [ZXQRCodeErrorCorrectionLevel.errorCorrectionLevelM(), ZXQRCodeErrorCorrectionLevel.errorCorrectionLevelL(), ZXQRCodeErrorCorrectionLevel.errorCorrectionLevelH(), ZXQRCodeErrorCorrectionLevel.errorCorrectionLevelQ()]
        }

        if bits < 0 || bits >= FOR_BITS.count {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"Invalid bits"userInfo:nil];
            */
        }

        return FOR_BITS[Int(bits)]
    }
    /**
 * L = ~7% correction
 */
    /**
 * L = ~7% correction
 */
    @objc
    static func errorCorrectionLevelL() -> ZXQRCodeErrorCorrectionLevel? {
        var thisLevel: ZXQRCodeErrorCorrectionLevel! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisLevel = ZXQRCodeErrorCorrectionLevel(ordinal: 0, bits: 0x1, name: "L")
        }

        return thisLevel
    }
    /**
 * M = ~15% correction
 */
    /**
 * M = ~15% correction
 */
    @objc
    static func errorCorrectionLevelM() -> ZXQRCodeErrorCorrectionLevel? {
        var thisLevel: ZXQRCodeErrorCorrectionLevel! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisLevel = ZXQRCodeErrorCorrectionLevel(ordinal: 1, bits: 0x0, name: "M")
        }

        return thisLevel
    }
    /**
 * Q = ~25% correction
 */
    /**
 * Q = ~25% correction
 */
    @objc
    static func errorCorrectionLevelQ() -> ZXQRCodeErrorCorrectionLevel? {
        var thisLevel: ZXQRCodeErrorCorrectionLevel! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisLevel = ZXQRCodeErrorCorrectionLevel(ordinal: 2, bits: 0x3, name: "Q")
        }

        return thisLevel
    }
    /**
 * H = ~30% correction
 */
    /**
 * H = ~30% correction
 */
    @objc
    static func errorCorrectionLevelH() -> ZXQRCodeErrorCorrectionLevel? {
        var thisLevel: ZXQRCodeErrorCorrectionLevel! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisLevel = ZXQRCodeErrorCorrectionLevel(ordinal: 3, bits: 0x2, name: "H")
        }

        return thisLevel
    }
}