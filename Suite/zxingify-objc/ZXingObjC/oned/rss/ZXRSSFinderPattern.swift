// Preprocessor directives found in file:
// #import "ZXResultPoint.h"
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
class ZXRSSFinderPattern: NSObject {
    private var _value: CInt = 0
    private var _startEnd: ZXIntArray!
    private var _resultPoints: NSMutableArray!
    @objc var value: CInt {
        return self._value
    }
    @objc var startEnd: ZXIntArray! {
        return self._startEnd
    }
    @objc var resultPoints: NSMutableArray! {
        return self._resultPoints
    }

    @objc
    init(value: CInt, startEnd: ZXIntArray!, start: CInt, end: CInt, rowNumber: CInt) {
        if self = super.init() {
            _value = value
            _startEnd = startEnd
            _resultPoints = [ZXResultPoint(x: CFloat(start), y: CFloat(rowNumber)), ZXResultPoint(x: CFloat(end), y: CFloat(rowNumber))].mutableCopy()
        }

        return self
    }

    @objc
    func isEqual(_ object: AnyObject) -> Bool {
        if !object.isKindOfClass(ZXRSSFinderPattern.self) {
            return false
        }

        let that = object as? ZXRSSFinderPattern

        return self.value == that?.value
    }
    @objc
    func hash() -> UInt {
        return UInt(self.value)
    }
}