import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXPDF417BarcodeMatrix.h"
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
/**
 * Holds all of the information for a barcode in a format where it can be easily accessable
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
 * Holds all of the information for a barcode in a format where it can be easily accessable
 */
@objc
class ZXPDF417BarcodeMatrix: NSObject {
    private var _currentRowIndex: CInt = 0
    private var _rowMatrix: NSArray!
    private var _height: CInt = 0
    private var _width: CInt = 0
    @objc var height: CInt {
        return self._height
    }
    @objc var width: CInt {
        return self._width
    }

    @objc
    init(height: CInt, width: CInt) {
        if self = super.init() {
            let matrix = NSMutableArray()
            var i: CInt = 0, matrixLength = height

            while i < matrixLength {
                defer {
                    i += 1
                }

                matrix.add(ZXPDF417BarcodeRow.barcodeRowWithWidth((width + 4) * 17 + 1))
            }

            _rowMatrix = matrix

            _width = width * 17

            _height = height

            _currentRowIndex = 1
        }

        return self
    }

    @objc
    func setX(_ x: CInt, y: CInt, value: int8_t) {
        self.rowMatrix[Int(y)].setX(x, value: value)
    }
    /*
- (void)setMatrixX:(int)x y:(int)y black:(BOOL)black {
  [self setX:x y:y value:(int8_t)(black ? 1 : 0)];
}
*/
    @objc
    func startRow() {
        self.currentRowIndex += 1
    }
    @objc
    func currentRow() -> ZXPDF417BarcodeRow? {
        return self.rowMatrix[Int(self.currentRowIndex)]
    }
    @objc
    func matrix() -> NSArray {
        return self.scaledMatrixWithXScale(1, yScale: 1)
    }
    //- (NSArray *)scaledMatrix:(int)scale;
    //- (NSArray *)scaledMatrix:(int)scale;
    /*
- (NSArray *)scaledMatrix:(int)scale {
  return [self scaledMatrixWithXScale:scale yScale:scale];
}
*/
    @objc
    func scaledMatrixWithXScale(_ xScale: CInt, yScale: CInt) -> NSArray {
        let yMax = self.height * yScale
        let matrixOut = NSMutableArray()
        var i: CInt = 0

        while i < yMax {
            defer {
                i += 1
            }

            matrixOut.add(NSNull.null())
        }

        var i: CInt = 0

        while i < yMax {
            defer {
                i += 1
            }

            matrixOut[Int(yMax - i - 1)] = (self.rowMatrix[Int(i / yScale)] as? ZXPDF417BarcodeRow)?.scaledRow(xScale)
        }

        return matrixOut
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
extension ZXPDF417BarcodeMatrix {
    @objc var currentRowIndex: CInt {
        get {
            return self._currentRowIndex
        }
        set {
            self._currentRowIndex = newValue
        }
    }
    @objc var rowMatrix: NSArray! {
        return self._rowMatrix
    }
}