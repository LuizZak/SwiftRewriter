// Preprocessor directives found in file:
// #import "ZXBitArray.h"
// #import "ZXErrors.h"
// #import "ZXRSSExpandedBlockParsedResult.h"
// #import "ZXRSSExpandedCurrentParsingState.h"
// #import "ZXRSSExpandedDecodedChar.h"
// #import "ZXRSSExpandedDecodedInformation.h"
// #import "ZXRSSExpandedDecodedNumeric.h"
// #import "ZXRSSExpandedFieldParser.h"
// #import "ZXRSSExpandedGeneralAppIdDecoder.h"
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
class ZXRSSExpandedGeneralAppIdDecoder: NSObject {
    private var _information: ZXBitArray!
    private var _current: ZXRSSExpandedCurrentParsingState!
    private var _buffer: NSMutableString!

    @objc
    init(information: ZXBitArray!) {
        if self = super.init() {
            _current = ZXRSSExpandedCurrentParsingState()
            _buffer = NSMutableString()
            _information = information
        }

        return self
    }

    @objc
    func decodeAllCodes(_ buff: NSMutableString!, initialPosition: CInt, error: UnsafeMutablePointer<Error?>!) -> String? {
        var currentPosition = initialPosition
        var remaining: String! = nil

        repeat {
            let info = self.decodeGeneralPurposeField(currentPosition, remaining: remaining)

            if info == nil {
                if error {
                    *error = ZXFormatErrorInstance()
                }

                return nil
            }

            let parsedFields = ZXRSSExpandedFieldParser.parseFieldsInGeneralPurpose(info?.theNewString(), error: error)

            if parsedFields == nil {
                return nil
            } else if parsedFields?.length > 0 {
                if let parsedFields = parsedFields {
                    buff.append(parsedFields)
                }
            }

            if info?.remaining == true {
                remaining = (info?.remainingValue ?? 0).stringValue()
            } else {
                remaining = nil
            }

            if currentPosition == info?.theNewPosition {
                // No step forward!
                break
            }

            currentPosition = (info?.theNewPosition ?? 0)
        } while true

        return buff
    }
    @objc
    func isStillNumeric(_ pos: CInt) -> Bool {
        // It's numeric if it still has 7 positions
        // and one of the first 4 bits is "1".
        if pos + 7 > (self.information.size ?? 0) {
            return pos + 4 <= (self.information.size ?? 0)
        }

        var i = pos

        while i < pos + 3 {
            defer {
                i += 1
            }

            if self.information.get(i) == true {
                return true
            }
        }

        return self.information.get(pos + 3) == true
    }
    @objc
    func decodeNumeric(_ pos: CInt) -> ZXRSSExpandedDecodedNumeric? {
        if pos + 7 > (self.information.size ?? 0) {
            let numeric = self.extractNumericValueFromBitArray(pos, bits: 4)

            if numeric == 0 {
                return ZXRSSExpandedDecodedNumeric(newPosition: self.information.size ?? 0, firstDigit: ZX_FNC1_INT, secondDigit: ZX_FNC1_INT)
            }

            return ZXRSSExpandedDecodedNumeric(newPosition: self.information.size ?? 0, firstDigit: numeric - 1, secondDigit: ZX_FNC1_INT)
        }

        let numeric = self.extractNumericValueFromBitArray(pos, bits: 7)
        let digit1 = (numeric - 8) / 11
        let digit2 = (numeric - 8) % 11

        return ZXRSSExpandedDecodedNumeric(newPosition: pos + 7, firstDigit: digit1, secondDigit: digit2)
    }
    @objc
    func extractNumericValueFromBitArray(_ pos: CInt, bits: CInt) -> CInt {
        return ZXRSSExpandedGeneralAppIdDecoder.extractNumericValueFromBitArray(self.information, pos: pos, bits: bits)
    }
    @objc
    static func extractNumericValueFromBitArray(_ information: ZXBitArray!, pos: CInt, bits: CInt) -> CInt {
        if bits > 32 {
            NSException.raise(NSInvalidArgumentException, format: "extractNumberValueFromBitArray can\'t handle more than 32 bits")
        }

        var value: CInt = 0
        var i: CInt = 0

        while i < bits {
            defer {
                i += 1
            }

            if information.get(pos + i) {
                value |= 1 << (bits - i - 1)
            }
        }

        return value
    }
    @objc
    func decodeGeneralPurposeField(_ pos: CInt, remaining: String!) -> ZXRSSExpandedDecodedInformation? {
        self.buffer.setString("")

        if remaining != nil {
            self.buffer.append(remaining)
        }

        self.current.position = pos

        var error: Error!
        let lastDecoded = self.parseBlocksWithError(&error)

        if error {
            return nil
        }

        if lastDecoded != nil && (lastDecoded?.remaining == true) {
            return ZXRSSExpandedDecodedInformation(newPosition: self.current.position ?? 0, newString: self.buffer, remainingValue: lastDecoded?.remainingValue ?? 0)
        }

        return ZXRSSExpandedDecodedInformation(newPosition: self.current.position ?? 0, newString: self.buffer)
    }
    @objc
    func parseBlocksWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXRSSExpandedDecodedInformation? {
        var isFinished: Bool
        var result: ZXRSSExpandedBlockParsedResult!

        repeat {
            let initialPosition = self.current.position ?? 0
            var localError: Error!

            if self.current.alpha != nil {
                result = self.parseAlphaBlock()
                isFinished = result.finished
            } else if self.current.isoIec646 != nil {
                result = self.parseIsoIec646BlockWithError(&localError)
                isFinished = result.finished
            } else {
                result = self.parseNumericBlockWithError(&localError)
                isFinished = result.finished
            }

            if localError {
                if error {
                    *error = localError
                }

                return nil
            }

            let positionChanged = initialPosition != self.current.position

            if !positionChanged && !isFinished {
                break
            }
        } while !isFinished

        return result.decodedInformation
    }
    @objc
    func parseNumericBlockWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXRSSExpandedBlockParsedResult? {
        while self.isStillNumeric(self.current.position ?? 0) {
            let numeric = self.decodeNumeric(self.current.position ?? 0)

            if numeric == nil {
                if error {
                    *error = ZXFormatErrorInstance()
                }

                return nil
            }

            self.current.position = numeric?.theNewPosition

            if numeric?.firstDigitFNC1() == true {
                var information: ZXRSSExpandedDecodedInformation!

                if numeric?.secondDigitFNC1() == true {
                    information = ZXRSSExpandedDecodedInformation(newPosition: self.current.position ?? 0, newString: self.buffer)
                } else {
                    information = ZXRSSExpandedDecodedInformation(newPosition: self.current.position ?? 0, newString: self.buffer, remainingValue: numeric?.secondDigit ?? 0)
                }

                return ZXRSSExpandedBlockParsedResult(information: information, finished: true)
            }

            self.buffer.appendFormat("%d", numeric?.firstDigit ?? 0)

            if numeric?.secondDigitFNC1 != nil {
                var information = ZXRSSExpandedDecodedInformation(newPosition: self.current.position ?? 0, newString: self.buffer)

                return ZXRSSExpandedBlockParsedResult(information: information, finished: true)
            }

            self.buffer.appendFormat("%d", numeric?.secondDigit ?? 0)
        }

        if self.isNumericToAlphaNumericLatch(self.current.position ?? 0) {
            self.current.setAlpha()
            self.current.position += 4
        }

        return ZXRSSExpandedBlockParsedResult(finished: false)
    }
    @objc
    func parseIsoIec646BlockWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXRSSExpandedBlockParsedResult? {
        while self.isStillIsoIec646(self.current.position ?? 0) {
            let iso = self.decodeIsoIec646(self.current.position ?? 0)

            if iso == nil {
                if error {
                    *error = ZXFormatErrorInstance()
                }

                return nil
            }

            self.current.position = iso?.theNewPosition

            if iso?.fnc1 != nil {
                let information = ZXRSSExpandedDecodedInformation(newPosition: self.current.position ?? 0, newString: self.buffer)

                return ZXRSSExpandedBlockParsedResult(information: information, finished: true)
            }

            self.buffer.appendFormat("%C", iso?.value)
        }

        if self.isAlphaOr646ToNumericLatch(self.current.position ?? 0) {
            self.current.position += 3
            self.current.setNumeric()
        } else if self.isAlphaTo646ToAlphaLatch(self.current.position ?? 0) {
            if (self.current.position ?? 0) + 5 < (self.information.size ?? 0) {
                self.current.position += 5
            } else {
                self.current.position = self.information.size
            }

            self.current.setAlpha()
        }

        return ZXRSSExpandedBlockParsedResult(finished: false)
    }
    @objc
    func parseAlphaBlock() -> ZXRSSExpandedBlockParsedResult? {
        while self.isStillAlpha(self.current.position ?? 0) {
            let alpha = self.decodeAlphanumeric(self.current.position ?? 0)

            self.current.position = alpha?.theNewPosition

            if alpha?.fnc1 != nil {
                let information = ZXRSSExpandedDecodedInformation(newPosition: self.current.position ?? 0, newString: self.buffer)

                return ZXRSSExpandedBlockParsedResult(information: information, finished: true)
            }

            self.buffer.appendFormat("%C", alpha?.value)
        }

        if self.isAlphaOr646ToNumericLatch(self.current.position ?? 0) {
            self.current.position += 3
            self.current.setNumeric()
        } else if self.isAlphaTo646ToAlphaLatch(self.current.position ?? 0) {
            if (self.current.position ?? 0) + 5 < (self.information.size ?? 0) {
                self.current.position += 5
            } else {
                self.current.position = self.information.size
            }

            self.current.setIsoIec646()
        }

        return ZXRSSExpandedBlockParsedResult(finished: false)
    }
    @objc
    func isStillIsoIec646(_ pos: CInt) -> Bool {
        if pos + 5 > (self.information.size ?? 0) {
            return false
        }

        let fiveBitValue = self.extractNumericValueFromBitArray(pos, bits: 5)

        if fiveBitValue >= 5 && fiveBitValue < 16 {
            return true
        }

        if pos + 7 > (self.information.size ?? 0) {
            return false
        }

        let sevenBitValue = self.extractNumericValueFromBitArray(pos, bits: 7)

        if sevenBitValue >= 64 && sevenBitValue < 116 {
            return true
        }

        if pos + 8 > (self.information.size ?? 0) {
            return false
        }

        let eightBitValue = self.extractNumericValueFromBitArray(pos, bits: 8)

        return eightBitValue >= 232 && eightBitValue < 253
    }
    @objc
    func decodeIsoIec646(_ pos: CInt) -> ZXRSSExpandedDecodedChar? {
        let fiveBitValue = self.extractNumericValueFromBitArray(pos, bits: 5)

        if fiveBitValue == 15 {
            return ZXRSSExpandedDecodedChar(newPosition: pos + 5, value: ZX_FNC1_CHAR)
        }

        if fiveBitValue >= 5 && fiveBitValue < 15 {
            return ZXRSSExpandedDecodedChar(newPosition: pos + 5, value: ('0' + fiveBitValue - 5) as? unichar)
        }

        let sevenBitValue = self.extractNumericValueFromBitArray(pos, bits: 7)

        if sevenBitValue >= 64 && sevenBitValue < 90 {
            return ZXRSSExpandedDecodedChar(newPosition: pos + 7, value: (sevenBitValue + 1) as? unichar)
        }

        if sevenBitValue >= 90 && sevenBitValue < 116 {
            return ZXRSSExpandedDecodedChar(newPosition: pos + 7, value: (sevenBitValue + 7) as? unichar)
        }

        let eightBitValue = self.extractNumericValueFromBitArray(pos, bits: 8)
        var c: unichar

        switch eightBitValue {
        case 232:
            c = '!'
        case 233:
            c = '"'
        case 234:
            c = '%'
        case 235:
            c = '&'
        case 236:
            c = '\''
        case 237:
            c = '('
        case 238:
            c = ')'
        case 239:
            c = '*'
        case 240:
            c = '+'
        case 241:
            c = ','
        case 242:
            c = '-'
        case 243:
            c = '.'
        case 244:
            c = '/'
        case 245:
            c = ':'
        case 246:
            c = ';'
        case 247:
            c = '<'
        case 248:
            c = '='
        case 249:
            c = '>'
        case 250:
            c = '?'
        case 251:
            c = '_'
        case 252:
            c = ' '
        default:
            return nil
        }

        return ZXRSSExpandedDecodedChar(newPosition: pos + 8, value: c)
    }
    @objc
    func isStillAlpha(_ pos: CInt) -> Bool {
        if pos + 5 > (self.information.size ?? 0) {
            return false
        }

        let fiveBitValue = self.extractNumericValueFromBitArray(pos, bits: 5)

        if fiveBitValue >= 5 && fiveBitValue < 16 {
            return true
        }

        if pos + 6 > (self.information.size ?? 0) {
            return false
        }

        let sixBitValue = self.extractNumericValueFromBitArray(pos, bits: 6)

        return sixBitValue >= 16 && sixBitValue < 63
    }
    @objc
    func decodeAlphanumeric(_ pos: CInt) -> ZXRSSExpandedDecodedChar? {
        let fiveBitValue = self.extractNumericValueFromBitArray(pos, bits: 5)

        if fiveBitValue == 15 {
            return ZXRSSExpandedDecodedChar(newPosition: pos + 5, value: ZX_FNC1_CHAR)
        }

        if fiveBitValue >= 5 && fiveBitValue < 15 {
            return ZXRSSExpandedDecodedChar(newPosition: pos + 5, value: ('0' + fiveBitValue - 5) as? unichar)
        }

        let sixBitValue = self.extractNumericValueFromBitArray(pos, bits: 6)

        if sixBitValue >= 32 && sixBitValue < 58 {
            return ZXRSSExpandedDecodedChar(newPosition: pos + 6, value: (sixBitValue + 33) as? unichar)
        }

        var c: unichar

        switch sixBitValue {
        case 58:
            c = '*'
        case 59:
            c = ','
        case 60:
            c = '-'
        case 61:
            c = '.'
        case 62:
            c = '/'
        default:
            /*
            @throw[NSExceptionexceptionWithName:@"RuntimeException"reason:[NSStringstringWithFormat:@"Decoding invalid alphanumeric value: %d",sixBitValue]userInfo:nil];
            */
        }

        return ZXRSSExpandedDecodedChar(newPosition: pos + 6, value: c)
    }
    @objc
    func isAlphaTo646ToAlphaLatch(_ pos: CInt) -> Bool {
        if pos + 1 > (self.information.size ?? 0) {
            return false
        }

        var i: CInt = 0

        while i < 5 && i + pos < (self.information.size ?? 0) {
            defer {
                i += 1
            }

            if i == 2 {
                if self.information.get(pos + 2) != true {
                    return false
                }
            } else if self.information.get(pos + i) == true {
                return false
            }
        }

        return true
    }
    @objc
    func isAlphaOr646ToNumericLatch(_ pos: CInt) -> Bool {
        if pos + 3 > (self.information.size ?? 0) {
            return false
        }

        var i = pos

        while i < pos + 3 {
            defer {
                i += 1
            }

            if self.information.get(i) == true {
                return false
            }
        }

        return true
    }
    @objc
    func isNumericToAlphaNumericLatch(_ pos: CInt) -> Bool {
        if pos + 1 > (self.information.size ?? 0) {
            return false
        }

        var i: CInt = 0

        while i < 4 && i + pos < (self.information.size ?? 0) {
            defer {
                i += 1
            }

            if self.information.get(pos + i) == true {
                return false
            }
        }

        return true
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
extension ZXRSSExpandedGeneralAppIdDecoder {
    @objc var information: ZXBitArray! {
        return self._information
    }
    @objc var current: ZXRSSExpandedCurrentParsingState! {
        return self._current
    }
    @objc var buffer: NSMutableString! {
        return self._buffer
    }
}