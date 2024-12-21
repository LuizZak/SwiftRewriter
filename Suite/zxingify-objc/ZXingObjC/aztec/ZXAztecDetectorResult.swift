// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXDetectorResult.h"
// #import "ZXAztecDetectorResult.h"
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
class ZXAztecDetectorResult: ZXDetectorResult {
    private var _compact: Bool = false
    private var _nbDatablocks: CInt = 0
    private var _nbLayers: CInt = 0
    @objc var compact: Bool {
        return self._compact
    }
    @objc var nbDatablocks: CInt {
        return self._nbDatablocks
    }
    @objc var nbLayers: CInt {
        return self._nbLayers
    }

    @objc
    init(bits: ZXBitMatrix!, points: NSArray!, compact: Bool, nbDatablocks: CInt, nbLayers: CInt) {
        if self = super.init(bits: bits, points: points) {
            _compact = compact
            _nbDatablocks = nbDatablocks
            _nbLayers = nbLayers
        }

        return self
    }
}