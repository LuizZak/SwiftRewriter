// Preprocessor directives found in file:
// #import "ZXQRCodeFinderPattern.h"
// #import "ZXQRCodeFinderPatternInfo.h"
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
 * Encapsulates information about finder patterns in an image, including the location of
 * the three finder patterns, and their estimated module size.
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
 * Encapsulates information about finder patterns in an image, including the location of
 * the three finder patterns, and their estimated module size.
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
class ZXQRCodeFinderPatternInfo: NSObject {
    private var _bottomLeft: ZXQRCodeFinderPattern!
    private var _topLeft: ZXQRCodeFinderPattern!
    private var _topRight: ZXQRCodeFinderPattern!
    @objc var bottomLeft: ZXQRCodeFinderPattern! {
        return self._bottomLeft
    }
    @objc var topLeft: ZXQRCodeFinderPattern! {
        return self._topLeft
    }
    @objc var topRight: ZXQRCodeFinderPattern! {
        return self._topRight
    }

    @objc
    init(patternCenters: NSArray!) {
        if self = super.init() {
            _bottomLeft = patternCenters[0]
            _topLeft = patternCenters[1]
            _topRight = patternCenters[2]
        }

        return self
    }
}