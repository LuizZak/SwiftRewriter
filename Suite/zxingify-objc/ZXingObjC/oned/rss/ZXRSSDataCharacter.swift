import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXRSSDataCharacter.h"
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
class ZXRSSDataCharacter: NSObject {
    private var _value: CInt = 0
    private var _checksumPortion: CInt = 0
    @objc var value: CInt {
        return self._value
    }
    @objc var checksumPortion: CInt {
        return self._checksumPortion
    }

    @objc
    init(value: CInt, checksumPortion: CInt) {
        if self = super.init() {
            _value = value
            _checksumPortion = checksumPortion
        }

        return self
    }

    @objc
    func description() -> String? {
        return String(format: "%d(%d)", self.value, self.checksumPortion)
    }
    @objc
    func isEqual(_ object: AnyObject) -> Bool {
        if !object.isKindOfClass(ZXRSSDataCharacter.self) {
            return false
        }

        let that = object as? ZXRSSDataCharacter

        return (self.value == that?.value) && (self.checksumPortion == that?.checksumPortion)
    }
    @objc
    func hash() -> UInt {
        return UInt(self.value ^ self.checksumPortion)
    }
}