import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXPDF417ResultMetadata.h"
/*
 * Copyright 2013 ZXing authors
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
 * Copyright 2013 ZXing authors
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
 * Copyright 2013 ZXing authors
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
class ZXPDF417ResultMetadata: NSObject {
    private var _segmentCount: CInt = 0
    private var _fileSize: CLongLong = 0
    private var _timestamp: CLongLong = 0
    private var _checksum: CInt = 0
    @objc var segmentIndex: CInt = 0
    @objc var fileId: String!
    @objc var lastSegment: Bool = false
    @objc var segmentCount: CInt {
        get {
            return self._segmentCount
        }
        set {
            self._segmentCount = newValue
        }
    }
    @objc var sender: String!
    @objc var addressee: String!
    @objc var fileName: String!
    @objc var fileSize: CLongLong {
        get {
            return self._fileSize
        }
        set {
            self._fileSize = newValue
        }
    }
    @objc var timestamp: CLongLong {
        get {
            return self._timestamp
        }
        set {
            self._timestamp = newValue
        }
    }
    @objc var checksum: CInt {
        get {
            return self._checksum
        }
        set {
            self._checksum = newValue
        }
    }
    @objc var optionalData: NSArray!

    @objc
    override init() {
        if self = super.init() {
            _segmentCount = 1

            _fileSize = 1

            _timestamp = 1

            _checksum = 1
        }

        return self
    }
}