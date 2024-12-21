// Preprocessor directives found in file:
// #import "ZXByteArray.h"
// #import "ZXPDF417BarcodeRow.h"
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
class ZXPDF417BarcodeRow: NSObject {
    private var _currentLocation: CInt = 0
    private var _row: ZXByteArray!
    @objc var row: ZXByteArray! {
        return self._row
    }

    @objc
    init(width: CInt) {
        if self = super.init() {
            _row = ZXByteArray(length: CUnsignedInt(width))
            _currentLocation = 0
        }

        return self
    }

    /**
 * Creates a Barcode row of the width
 */
    @objc
    static func barcodeRowWithWidth(_ width: CInt) -> ZXPDF417BarcodeRow? {
        return ZXPDF417BarcodeRow(width: width)
    }
    /**
 * Sets a specific location in the bar
 *
 * @param x The location in the bar
 * @param value Black if true, white if false;
 */
    @objc
    func setX(_ x: CInt, value: int8_t) {
        self.row.array[x] = value
    }
    /**
 * Sets a specific location in the bar
 *
 * @param x The location in the bar
 * @param black Black if true, white if false;
 */
    @objc
    func setX(_ x: CInt, black: Bool) {
        self.row.array[x] = (black ? 1 : 0) as? int8_t
    }
    /**
 * @param black A boolean which is true if the bar black false if it is white
 * @param width How many spots wide the bar is.
 */
    @objc
    func addBar(_ black: Bool, width: CInt) {
        var ii: CInt = 0

        while ii < width {
            defer {
                ii += 1
            }

            self.setX(self.currentLocation += 1, black: black)
        }
    }
    /**
 * This function scales the row
 *
 * @param scale How much you want the image to be scaled, must be greater than or equal to 1.
 * @return the scaled row
 */
    @objc
    func scaledRow(_ scale: CInt) -> ZXByteArray {
        let output = ZXByteArray(length: (self.row.length ?? 0) * CUnsignedInt(scale))
        var i: CInt = 0

        while i < output.length {
            defer {
                i += 1
            }

            output.array[i] = self.row.array[i / scale]
        }

        return output
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
extension ZXPDF417BarcodeRow {
    //A tacker for position in the bar
    @objc var currentLocation: CInt {
        get {
            return self._currentLocation
        }
        set {
            self._currentLocation = newValue
        }
    }
}