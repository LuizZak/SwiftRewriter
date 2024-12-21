// Preprocessor directives found in file:
// #import "ZXPDF417BoundingBox.h"
// #import "ZXPDF417Codeword.h"
// #import "ZXPDF417DetectionResultColumn.h"
let ZX_PDF417_MAX_NEARBY_DISTANCE: CInt = 5

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
class ZXPDF417DetectionResultColumn: NSObject {
    private var _boundingBox: ZXPDF417BoundingBox!
    private var _codewords: NSMutableArray!
    @objc var boundingBox: ZXPDF417BoundingBox! {
        return self._boundingBox
    }
    @objc var codewords: NSMutableArray! {
        return self._codewords
    }

    @objc
    init(boundingBox: ZXPDF417BoundingBox!) {
        _boundingBox = ZXPDF417BoundingBox(boundingBox: boundingBox)
        _codewords = NSMutableArray()

        var i: CInt = 0

        while i < boundingBox.maxY - boundingBox.minY + 1 {
            defer {
                i += 1
            }

            _codewords.add(NSNull.null())
        }

        super.init()
    }

    @objc
    func codewordNearby(_ imageRow: CInt) -> ZXPDF417Codeword? {
        var codeword = self.codeword(imageRow)

        if codeword != nil {
            return codeword
        }

        var i: CInt = 1

        while i < ZX_PDF417_MAX_NEARBY_DISTANCE {
            defer {
                i += 1
            }

            var nearImageRow = self.imageRowToCodewordIndex(imageRow) - i

            if nearImageRow >= 0 {
                codeword = self.codewords[Int(nearImageRow)]

                if codeword as? AnyObject != NSNull.null() {
                    return codeword
                }
            }

            nearImageRow = self.imageRowToCodewordIndex(imageRow) + i

            if nearImageRow < (self.codewords.count ?? 0) {
                codeword = self.codewords[Int(nearImageRow)]

                if codeword as? AnyObject != NSNull.null() {
                    return codeword
                }
            }
        }

        return nil
    }
    @objc
    func imageRowToCodewordIndex(_ imageRow: CInt) -> CInt {
        return (imageRow - (self.boundingBox.minY ?? 0)) ?? 0
    }
    @objc
    func setCodeword(_ imageRow: CInt, codeword: ZXPDF417Codeword!) {
        _codewords[Int(self.imageRowToCodewordIndex(imageRow))] = codeword
    }
    @objc
    func codeword(_ imageRow: CInt) -> ZXPDF417Codeword? {
        let index: UInt = UInt(self.imageRowToCodewordIndex(imageRow))

        if _codewords[Int(index)] == NSNull.null() {
            return nil
        }

        return _codewords[Int(index)]
    }
    @objc
    func description() -> String? {
        let result = NSMutableString()
        var row: CInt = 0

        for codeword in self.codewords {
            if codeword as? AnyObject == NSNull.null() {
                result.appendFormat("%3d:    |   \\n", row += 1)

                continue
            }

            result.appendFormat("%3d: %3d|%3d\\n", row += 1, codeword.rowNumber, codeword.value)
        }

        return String.stringWithString(result)
    }
}