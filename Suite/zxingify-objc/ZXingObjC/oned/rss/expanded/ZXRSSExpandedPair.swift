// Preprocessor directives found in file:
// #import "ZXRSSDataCharacter.h"
// #import "ZXRSSExpandedPair.h"
// #import "ZXRSSFinderPattern.h"
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
class ZXRSSExpandedPair: NSObject {
    private var _leftChar: ZXRSSDataCharacter!
    private var _rightChar: ZXRSSDataCharacter!
    private var _finderPattern: ZXRSSFinderPattern!
    private var _mayBeLast: Bool = false
    @objc var leftChar: ZXRSSDataCharacter! {
        return self._leftChar
    }
    @objc var rightChar: ZXRSSDataCharacter! {
        return self._rightChar
    }
    @objc var finderPattern: ZXRSSFinderPattern! {
        return self._finderPattern
    }
    @objc var mayBeLast: Bool {
        return self._mayBeLast
    }
    @objc var mustBeLast: Bool {
        return self.rightChar == nil
    }

    @objc
    init(leftChar: ZXRSSDataCharacter!, rightChar: ZXRSSDataCharacter!, finderPattern: ZXRSSFinderPattern!, mayBeLast: Bool) {
        if self = super.init() {
            _leftChar = leftChar

            _rightChar = rightChar

            _finderPattern = finderPattern

            _mayBeLast = mayBeLast
        }

        return self
    }

    @objc
    func description() -> String? {
        return String(format: "[ %@, %@ : %@ ]", self.leftChar, self.rightChar, (self.finderPattern == nil) ? "null" : String(format: "%d", self.finderPattern.value ?? 0))
    }
    @objc
    func isEqual(_ object: AnyObject) -> Bool {
        if !object.isKindOfClass(ZXRSSExpandedPair.self) {
            return false
        }

        let that = object as? ZXRSSExpandedPair

        return ZXRSSExpandedPair.isEqualOrNil(self.leftChar, toObject: that?.leftChar) && ZXRSSExpandedPair.isEqualOrNil(self.rightChar, toObject: that?.rightChar) && ZXRSSExpandedPair.isEqualOrNil(self.finderPattern, toObject: that?.finderPattern)
    }
    @objc
    static func isEqualOrNil(_ o1: AnyObject!, toObject o2: AnyObject!) -> Bool {
        return (o1 == nil) ? o2 == nil : o1.isEqual(o2)
    }
    @objc
    func hash() -> UInt {
        return self.hashNotNil(self.leftChar) ^ self.hashNotNil(self.rightChar) ^ self.hashNotNil(self.finderPattern)
    }
    @objc
    func hashNotNil(_ o: NSObject!) -> UInt {
        return (o == nil) ? 0 : o.hash
    }
}