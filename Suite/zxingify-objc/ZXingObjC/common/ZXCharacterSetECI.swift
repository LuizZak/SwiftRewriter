import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXCharacterSetECI.h"
// #import "ZXErrors.h"
var VALUE_TO_ECI: NSMutableDictionary! = nil
var ENCODING_TO_ECI: NSMutableDictionary! = nil

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
 * Encapsulates a Character Set ECI, according to "Extended Channel Interpretations" 5.3.1.1
 * of ISO 18004.
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
 * Encapsulates a Character Set ECI, according to "Extended Channel Interpretations" 5.3.1.1
 * of ISO 18004.
 */
@objc
class ZXCharacterSetECI: NSObject {
    private var _encoding: NSStringEncoding
    private var _value: CInt = 0
    @objc var encoding: NSStringEncoding {
        return self._encoding
    }
    @objc var value: CInt {
        return self._value
    }

    @objc
    init(value: CInt, encoding: NSStringEncoding) {
        if self = super.init() {
            _value = value
            _encoding = encoding
        }

        return self
    }

    @objc
    static func initialize() {
        if self.self != ZXCharacterSetECI.self {
            return
        }

        VALUE_TO_ECI = NSMutableDictionary(capacity: 29)

        ENCODING_TO_ECI = NSMutableDictionary(capacity: 29)

        self.addCharacterSet(0, encoding: 0x80000400 as? NSStringEncoding)
        self.addCharacterSet(1, encoding: NSISOLatin1StringEncoding)
        self.addCharacterSet(2, encoding: 0x80000400 as? NSStringEncoding)
        self.addCharacterSet(3, encoding: NSISOLatin1StringEncoding)
        self.addCharacterSet(4, encoding: NSISOLatin2StringEncoding)
        self.addCharacterSet(5, encoding: 0x80000203 as? NSStringEncoding)
        self.addCharacterSet(6, encoding: 0x80000204 as? NSStringEncoding)
        self.addCharacterSet(7, encoding: 0x80000205 as? NSStringEncoding)
        self.addCharacterSet(8, encoding: 0x80000206 as? NSStringEncoding)
        self.addCharacterSet(9, encoding: 0x80000207 as? NSStringEncoding)
        self.addCharacterSet(10, encoding: 0x80000208 as? NSStringEncoding)
        self.addCharacterSet(11, encoding: 0x80000209 as? NSStringEncoding)
        self.addCharacterSet(12, encoding: 0x8000020a as? NSStringEncoding)
        self.addCharacterSet(13, encoding: 0x8000020b as? NSStringEncoding)
        self.addCharacterSet(15, encoding: 0x8000020d as? NSStringEncoding)
        self.addCharacterSet(16, encoding: 0x8000020e as? NSStringEncoding)
        self.addCharacterSet(17, encoding: 0x8000020f as? NSStringEncoding)
        self.addCharacterSet(18, encoding: 0x80000210 as? NSStringEncoding)
        self.addCharacterSet(20, encoding: NSShiftJISStringEncoding)
        self.addCharacterSet(21, encoding: NSWindowsCP1250StringEncoding)
        self.addCharacterSet(22, encoding: NSWindowsCP1251StringEncoding)
        self.addCharacterSet(23, encoding: NSWindowsCP1252StringEncoding)
        self.addCharacterSet(24, encoding: 0x80000505 as? NSStringEncoding)
        self.addCharacterSet(25, encoding: NSUTF16BigEndianStringEncoding)
        self.addCharacterSet(26, encoding: NSUTF8StringEncoding)
        self.addCharacterSet(27, encoding: NSASCIIStringEncoding)
        self.addCharacterSet(28, encoding: 0x80000a03 as? NSStringEncoding)
        self.addCharacterSet(29, encoding: 0x80000632 as? NSStringEncoding)
        self.addCharacterSet(30, encoding: 0x80000940 as? NSStringEncoding)
        self.addCharacterSet(170, encoding: NSASCIIStringEncoding)
    }
    @objc
    static func addCharacterSet(_ value: CInt, encoding: NSStringEncoding) {
        let eci = ZXCharacterSetECI(value: value, encoding: encoding)

        VALUE_TO_ECI[value] = eci
        ENCODING_TO_ECI[encoding] = eci
    }
    /**
 * @param value character set ECI value
 * @return CharacterSetECI representing ECI of given value, or nil if it is legal but
 *   unsupported
 */
    /**
 * @param value character set ECI value
 * @return CharacterSetECI representing ECI of given value, or nil if it is legal but
 *   unsupported
 */
    @objc
    static func characterSetECIByValue(_ value: CInt) -> ZXCharacterSetECI? {
        if VALUE_TO_ECI == nil {
            self.initialize()
        }

        if value < 0 || value >= 900 {
            return nil
        }

        return VALUE_TO_ECI[value]
    }
    /**
 * @param encoding character set ECI encoding name
 * @return CharacterSetECI representing ECI for character encoding, or nil if it is legal
 *   but unsupported
 */
    /**
 * @param encoding character set ECI encoding name
 * @return CharacterSetECI representing ECI for character encoding, or nil if it is legal
 *   but unsupported
 */
    @objc
    static func characterSetECIByEncoding(_ encoding: NSStringEncoding) -> ZXCharacterSetECI? {
        if ENCODING_TO_ECI == nil {
            self.initialize()
        }

        return ENCODING_TO_ECI[encoding]
    }
}