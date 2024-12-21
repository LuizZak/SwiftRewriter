// Preprocessor directives found in file:
// #import "ZXLuminanceSource.h"
// #import "ZXByteArray.h"
// #import "ZXInvertedLuminanceSource.h"
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
/**
 * A wrapper implementation of ZXLuminanceSource which inverts the luminances it returns -- black becomes
 * white and vice versa, and each value becomes (255-value).
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
/**
 * A wrapper implementation of ZXLuminanceSource which inverts the luminances it returns -- black becomes
 * white and vice versa, and each value becomes (255-value).
 */
@objc
class ZXInvertedLuminanceSource: ZXLuminanceSource {
    private weak var _delegate: ZXLuminanceSource?

    @objc
    init(delegate: ZXLuminanceSource!) {
        _delegate = delegate
        super.init(width: delegate.width, height: delegate.height)
    }

    @objc
    func rowAtY(_ y: CInt, row: ZXByteArray!) -> ZXByteArray? {
        row = self.delegate?.rowAtY(y, row: row)

        let width = self.width
        var rowArray = row.array
        var i: CInt = 0

        while i < width {
            defer {
                i += 1
            }

            rowArray?[i] = (255 - (rowArray?[i] & 0xff)) as? int8_t
        }

        return row
    }
    @objc
    func matrix() -> ZXByteArray {
        let matrix = self.delegate?.matrix()
        let length = self.width * self.height
        let invertedMatrix = ZXByteArray(length: CUnsignedInt(length))
        var invertedMatrixArray = invertedMatrix.array
        let matrixArray = matrix?.array
        var i: CInt = 0

        while i < length {
            defer {
                i += 1
            }

            invertedMatrixArray?[i] = (255 - (matrixArray?[i] & 0xff)) as? int8_t
        }

        return invertedMatrix
    }
    @objc
    func cropSupported() -> Bool {
        return self.delegate?.cropSupported == true
    }
    @objc
    func crop(_ left: CInt, top: CInt, width aWidth: CInt, height aHeight: CInt) -> ZXLuminanceSource? {
        return ZXInvertedLuminanceSource(delegate: self.delegate?.crop(left, top: top, width: aWidth, height: aHeight))
    }
    @objc
    func rotateSupported() -> Bool {
        return self.delegate?.rotateSupported == true
    }
    /**
 * @return original delegate ZXLuminanceSource since invert undoes itself
 */
    @objc
    func invert() -> ZXLuminanceSource? {
        return self.delegate
    }
    @objc
    func rotateCounterClockwise() -> ZXLuminanceSource? {
        return ZXInvertedLuminanceSource(delegate: self.delegate?.rotateCounterClockwise())
    }
    @objc
    func rotateCounterClockwise45() -> ZXLuminanceSource? {
        return ZXInvertedLuminanceSource(delegate: self.delegate?.rotateCounterClockwise45())
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
extension ZXInvertedLuminanceSource {
    @objc weak var delegate: ZXLuminanceSource? {
        return self._delegate
    }
}