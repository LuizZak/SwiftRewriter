import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXQRCodeMode.h"
// #import "ZXQRCodeVersion.h"
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
 * See ISO 18004:2006, 6.4.1, Tables 2 and 3. This enum encapsulates the various modes in which
 * data can be encoded to bits in the QR code standard.
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
 * See ISO 18004:2006, 6.4.1, Tables 2 and 3. This enum encapsulates the various modes in which
 * data can be encoded to bits in the QR code standard.
 */
@objc
class ZXQRCodeMode: NSObject {
    private var _characterCountBitsForVersions: NSArray!
    private var _bits: CInt = 0
    private var _name: String!
    @objc var bits: CInt {
        return self._bits
    }
    @objc var name: String! {
        return self._name
    }

    @objc
    init(characterCountBitsForVersions: NSArray!, bits: CInt, name: String!) {
        if self = super.init() {
            _characterCountBitsForVersions = characterCountBitsForVersions
            _bits = bits
            _name = name
        }

        return self
    }

    /**
 * @param bits four bits encoding a QR Code data mode
 * @return Mode encoded by these bits or nil if bits do not correspond to a known mode
 */
    /**
 * @param bits four bits encoding a QR Code data mode
 * @return Mode encoded by these bits or nil if bits do not correspond to a known mode
 */
    @objc
    static func forBits(_ bits: CInt) -> ZXQRCodeMode {
        switch bits {
        case 0x0:
            return ZXQRCodeMode.terminatorMode()
        case 0x1:
            return ZXQRCodeMode.numericMode()
        case 0x2:
            return ZXQRCodeMode.alphanumericMode()
        case 0x3:
            return ZXQRCodeMode.structuredAppendMode()
        case 0x4:
            return ZXQRCodeMode.byteMode()
        case 0x5:
            return ZXQRCodeMode.fnc1FirstPositionMode()
        case 0x7:
            return ZXQRCodeMode.eciMode()
        case 0x8:
            return ZXQRCodeMode.kanjiMode()
        case 0x9:
            return ZXQRCodeMode.fnc1SecondPositionMode()
        case 0xd:
            return ZXQRCodeMode.hanziMode()
        default:
            return nil
        }
    }
    /**
 * @param version version in question
 * @return number of bits used, in this QR Code symbol `ZXQRCodeVersion`, to encode the
 *   count of characters that will follow encoded in this Mode
 */
    /**
 * @param version version in question
 * @return number of bits used, in this QR Code symbol `ZXQRCodeVersion`, to encode the
 *   count of characters that will follow encoded in this Mode
 */
    @objc
    func characterCountBits(_ version: ZXQRCodeVersion!) -> CInt {
        let number = version.versionNumber
        var offset: CInt

        if number <= 9 {
            offset = 0
        } else if number <= 26 {
            offset = 1
        } else {
            offset = 2
        }

        return self.characterCountBitsForVersions[Int(offset)].intValue()
    }
    @objc
    func description() -> String? {
        return self.name
    }
    @objc
    static func terminatorMode() -> ZXQRCodeMode? {
        var thisMode: ZXQRCodeMode! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisMode = ZXQRCodeMode(characterCountBitsForVersions: [0, 0, 0], bits: 0x0, name: "TERMINATOR")
        }

        return thisMode
    }
    // Not really a mode...
    // Not really a mode...
    @objc
    static func numericMode() -> ZXQRCodeMode? {
        var thisMode: ZXQRCodeMode! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisMode = ZXQRCodeMode(characterCountBitsForVersions: [10, 12, 14], bits: 0x1, name: "NUMERIC")
        }

        return thisMode
    }
    @objc
    static func alphanumericMode() -> ZXQRCodeMode? {
        var thisMode: ZXQRCodeMode! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisMode = ZXQRCodeMode(characterCountBitsForVersions: [9, 11, 13], bits: 0x2, name: "ALPHANUMERIC")
        }

        return thisMode
    }
    @objc
    static func structuredAppendMode() -> ZXQRCodeMode? {
        var thisMode: ZXQRCodeMode! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisMode = ZXQRCodeMode(characterCountBitsForVersions: [0, 0, 0], bits: 0x3, name: "STRUCTURED_APPEND")
        }

        return thisMode
    }
    // Not supported
    // Not supported
    @objc
    static func byteMode() -> ZXQRCodeMode? {
        var thisMode: ZXQRCodeMode! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisMode = ZXQRCodeMode(characterCountBitsForVersions: [8, 16, 16], bits: 0x4, name: "BYTE")
        }

        return thisMode
    }
    @objc
    static func eciMode() -> ZXQRCodeMode? {
        var thisMode: ZXQRCodeMode! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisMode = ZXQRCodeMode(characterCountBitsForVersions: [0, 0, 0], bits: 0x7, name: "ECI")
        }

        return thisMode
    }
    // character counts don't apply
    // character counts don't apply
    @objc
    static func kanjiMode() -> ZXQRCodeMode? {
        var thisMode: ZXQRCodeMode! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisMode = ZXQRCodeMode(characterCountBitsForVersions: [8, 10, 12], bits: 0x8, name: "KANJI")
        }

        return thisMode
    }
    @objc
    static func fnc1FirstPositionMode() -> ZXQRCodeMode? {
        var thisMode: ZXQRCodeMode! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisMode = ZXQRCodeMode(characterCountBitsForVersions: [0, 0, 0], bits: 0x5, name: "FNC1_FIRST_POSITION")
        }

        return thisMode
    }
    @objc
    static func fnc1SecondPositionMode() -> ZXQRCodeMode? {
        var thisMode: ZXQRCodeMode! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisMode = ZXQRCodeMode(characterCountBitsForVersions: [0, 0, 0], bits: 0x9, name: "FNC1_SECOND_POSITION")
        }

        return thisMode
    }
    /** See GBT 18284-2000; "Hanzi" is a transliteration of this mode name. */
    /** See GBT 18284-2000; "Hanzi" is a transliteration of this mode name. */
    @objc
    static func hanziMode() -> ZXQRCodeMode? {
        var thisMode: ZXQRCodeMode! = nil
        var onceToken: dispatch_once_t

        dispatch_once(&onceToken) { () -> Void in
            thisMode = ZXQRCodeMode(characterCountBitsForVersions: [8, 10, 12], bits: 0xd, name: "HANZI")
        }

        return thisMode
    }
}

// MARK: -
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
extension ZXQRCodeMode {
    @objc var characterCountBitsForVersions: NSArray! {
        return self._characterCountBitsForVersions
    }
}