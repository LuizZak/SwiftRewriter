import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #include "ZXDecimal.h"
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
 * Drop-in replacement for `NSDecimalNumber`.
 * @see ZXPDF417DecodedBitStreamParser.m#L696
 */
@objc
class ZXDecimal: NSObject {
    private var _value: String!
    @objc var value: String! {
        return self._value
    }

    @objc
    init(value: String!) {
        if self = super.init() {
            self.value = value
        }

        return self
    }

    @objc
    static func zero() -> ZXDecimal? {
        return self.init(value: "0")
    }
    @objc
    static func decimalWithInt(_ integer: CInt) -> ZXDecimal? {
        return self.init(value: String(format: "%d", integer))
    }
    @objc
    static func decimalWithString(_ string: String!) -> ZXDecimal {
        if string.length == 0 {
            return self.init(value: "0")
        } else {
            return self.init(value: string)
        }
    }
    @objc
    static func decimalWithDecimalNumber(_ decimalNumber: NSDecimalNumber!) -> ZXDecimal {
        return self.decimalWithString(decimalNumber.stringValue())
    }
    @objc
    func isEqual(_ object: AnyObject) -> Bool {
        if object == self {
            return true
        }

        if !object || !object.isKindOfClass(type(of: self)) {
            return false
        }

        let other = object as? ZXDecimal

        return other?.value.isEqual(self.value)
    }
    // @see https://stackoverflow.com/a/22610446/5173688
    @objc
    func reversedString(_ string: String!) -> String? {
        let length: UInt = string.length()

        if length < 2 {
            return string
        }

        let encoding: NSStringEncoding = (NSHostByteOrder() == NS_BigEndian) ? NSUTF32BigEndianStringEncoding : NSUTF32LittleEndianStringEncoding
        let utf32ByteCount: UInt = string.lengthOfBytesUsingEncoding(encoding)
        var characters: UnsafeMutablePointer<uint32_t>! = malloc(utf32ByteCount)

        string.getBytes(characters, maxLength: utf32ByteCount, usedLength: nil, encoding: encoding, options: 0, range: NSMakeRange(0, length), remainingRange: nil)

        let utf32Length: UInt = utf32ByteCount / UInt(MemoryLayout.size(ofValue: uint32_t))
        let halfwayPoint = utf32Length / 2
        var i: UInt = 0

        while i < halfwayPoint {
            defer {
                i += 1
            }

            let character: uint32_t = characters[utf32Length - i - 1]

            characters[utf32Length - i - 1] = characters[i]
            characters[i] = character
        }

        return String(bytesNoCopy: characters, length: utf32ByteCount, encoding: encoding, freeWhenDone: true)
    }
    @objc
    func intArrayFromString(_ string: String!) -> UnsafeMutablePointer<int8_t> {
        let length: UInt = string.length()

        if length < 2 {
            var result: UnsafeMutablePointer<int8_t>! = malloc(length * MemoryLayout.size(ofValue: int8_t))

            result[0] = string.intValue()

            return result
        }

        let encoding: NSStringEncoding = (NSHostByteOrder() == NS_BigEndian) ? NSUTF32BigEndianStringEncoding : NSUTF32LittleEndianStringEncoding
        let utf32ByteCount: UInt = string.lengthOfBytesUsingEncoding(encoding)
        let characters: UnsafeMutablePointer<uint32_t>! = malloc(utf32ByteCount)

        string.getBytes(characters, maxLength: utf32ByteCount, usedLength: nil, encoding: encoding, options: 0, range: NSMakeRange(0, length), remainingRange: nil)

        var result: UnsafeMutablePointer<int8_t>! = malloc(length * MemoryLayout.size(ofValue: int8_t))
        let utf32Length: UInt = utf32ByteCount / UInt(MemoryLayout.size(ofValue: uint32_t))
        var i: UInt = 0

        while i < utf32Length {
            defer {
                i += 1
            }

            result[i] = CInt(characters[i]) - '0'
        }

        return result
    }
    @objc
    func decimalByMultiplyingBy(_ number: ZXDecimal!) -> ZXDecimal {
        let leftLength: CInt = CInt(_value.length)
        let rightLength: CInt = CInt(number.value.length)
        let left = self.intArrayFromString(self.reversedString(_value))
        let right = self.intArrayFromString(self.reversedString(number.value))
        let length: CInt = CInt(_value.length) + CInt(number.value.length)
        var result: UnsafeMutablePointer<int8_t>! = calloc(length, MemoryLayout.size(ofValue: int8_t))
        var leftIndex: CInt = 0

        while leftIndex < leftLength {
            defer {
                leftIndex += 1
            }

            var rightIndex: CInt = 0

            while rightIndex < rightLength {
                defer {
                    rightIndex += 1
                }

                let resultIndex = leftIndex + rightIndex
                let leftValue: CInt = left[leftIndex]
                let rightValue: CInt = right[rightIndex]

                result[resultIndex] = leftValue * rightValue + ((resultIndex >= length) ? 0 : result[resultIndex])

                if result[resultIndex] > 9 {
                    result[resultIndex + 1] = (result[resultIndex] / 10) + ((resultIndex + 1 >= length) ? 0 : result[resultIndex + 1])
                    result[resultIndex] -= (result[resultIndex] / 10) * 10
                }
            }
        }

        free(left)
        free(right)

        var retVal = NSMutableString()
        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            if result[i] == 0 {
                retVal.append("0")
            } else {
                retVal.appendFormat("%d", result[i])
            }
        }

        retVal = self.reversedString(retVal).mutableCopy()

        // remove '0' prefixes
        while retVal.length > 0 && retVal.substringWithRange(NSMakeRange(0, 1)) == "0" {
            retVal = retVal.substringFromIndex(1).mutableCopy()
        }

        free(result)

        if retVal.length == 0 {
            return ZXDecimal.decimalWithString("0")
        }

        return ZXDecimal.decimalWithString(retVal)
    }
    @objc
    func decimalByAdding(_ number: ZXDecimal!) -> ZXDecimal {
        let leftLength: CInt = CInt(_value.length)
        let rightLength: CInt = CInt(number.value.length)
        let left = self.intArrayFromString(self.reversedString(_value))
        let right = self.intArrayFromString(self.reversedString(number.value))
        var length = rightLength + 1

        if leftLength > rightLength {
            length = leftLength + 1
        }

        var result: UnsafeMutablePointer<int8_t>! = calloc(length, MemoryLayout.size(ofValue: int8_t))
        var i: CInt = 0

        while i < length - 1 {
            defer {
                i += 1
            }

            let leftValue: CInt = (leftLength > i) ? left[i] : 0
            let rightValue: CInt = (rightLength > i) ? right[i] : 0
            let add: CInt = leftValue + rightValue + result[i]

            if add >= 10 {
                result[i] = (add % 10)
                result[i + 1] = 1
            } else {
                result[i] = add
            }
        }

        free(left)
        free(right)

        var retVal = NSMutableString()
        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            retVal.appendFormat("%d", result[i])
        }

        retVal = self.reversedString(retVal).mutableCopy()

        // remove '0' prefixes
        while retVal.length > 0 && retVal.substringWithRange(NSMakeRange(0, 1)) == "0" {
            retVal = retVal.substringFromIndex(1).mutableCopy()
        }

        free(result)

        if retVal.length == 0 {
            return ZXDecimal.decimalWithString("0")
        }

        return ZXDecimal.decimalWithString(retVal)
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
extension ZXDecimal {
    @objc var value: String! {
        get {
            return self._value
        }
        set {
            self._value = newValue
        }
    }
}