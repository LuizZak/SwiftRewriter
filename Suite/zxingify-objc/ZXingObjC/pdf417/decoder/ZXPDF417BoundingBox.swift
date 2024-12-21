import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXBitMatrix.h"
// #import "ZXPDF417BoundingBox.h"
// #import "ZXResultPoint.h"
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
class ZXPDF417BoundingBox: NSObject {
    private var _image: ZXBitMatrix!
    private var _topLeft: ZXResultPoint!
    private var _topRight: ZXResultPoint!
    private var _bottomLeft: ZXResultPoint!
    private var _bottomRight: ZXResultPoint!
    @objc var minX: CInt = 0
    @objc var maxX: CInt = 0
    @objc var minY: CInt = 0
    @objc var maxY: CInt = 0
    @objc var topLeft: ZXResultPoint! {
        return self._topLeft
    }
    @objc var topRight: ZXResultPoint! {
        return self._topRight
    }
    @objc var bottomLeft: ZXResultPoint! {
        return self._bottomLeft
    }
    @objc var bottomRight: ZXResultPoint! {
        return self._bottomRight
    }

    @objc
    init?(image: ZXBitMatrix!, topLeft: ZXResultPoint!, bottomLeft: ZXResultPoint!, topRight: ZXResultPoint!, bottomRight: ZXResultPoint!) {
        if (!topLeft && !topRight) || (!bottomLeft && !bottomRight) || (topLeft && !bottomLeft) || (topRight && !bottomRight) {
            return nil
        }

        self = super.init()

        if self {
            _image = image

            _topLeft = topLeft

            _bottomLeft = bottomLeft

            _topRight = topRight

            _bottomRight = bottomRight

            self.calculateMinMaxValues()
        }

        return self
    }
    @objc
    init(boundingBox: ZXPDF417BoundingBox!) {
        return self.init(image: boundingBox.image, topLeft: boundingBox.topLeft, bottomLeft: boundingBox.bottomLeft, topRight: boundingBox.topRight, bottomRight: boundingBox.bottomRight)
    }

    @objc
    static func mergeLeftBox(_ leftBox: ZXPDF417BoundingBox!, rightBox: ZXPDF417BoundingBox!) -> ZXPDF417BoundingBox? {
        if !leftBox {
            return rightBox
        }

        if !rightBox {
            return leftBox
        }

        return self.init(image: leftBox.image, topLeft: leftBox.topLeft, bottomLeft: leftBox.bottomLeft, topRight: rightBox.topRight, bottomRight: rightBox.bottomRight)
    }
    @objc
    func addMissingRows(_ missingStartRows: CInt, missingEndRows: CInt, isLeft: Bool) -> ZXPDF417BoundingBox? {
        var newTopLeft = self.topLeft
        var newBottomLeft = self.bottomLeft
        var newTopRight = self.topRight
        var newBottomRight = self.bottomRight

        if missingStartRows > 0 {
            let top = isLeft ? self.topLeft : self.topRight
            var newMinY: CInt = CInt(top?.y ?? 0.0) - missingStartRows

            if newMinY < 0 {
                newMinY = 0
            }

            // TODO use existing points to better interpolate the new x positions
            let newTop = ZXResultPoint(x: top?.x ?? 0.0, y: CFloat(newMinY))

            if isLeft {
                newTopLeft = newTop
            } else {
                newTopRight = newTop
            }
        }

        if missingEndRows > 0 {
            let bottom = isLeft ? self.bottomLeft : self.bottomRight
            var newMaxY: CInt = CInt(bottom?.y ?? 0.0) + missingEndRows

            if newMaxY >= (self.image.height ?? 0) {
                newMaxY = (self.image.height ?? 0) - 1
            }

            // TODO use existing points to better interpolate the new x positions
            let newBottom = ZXResultPoint(x: bottom?.x ?? 0.0, y: CFloat(newMaxY))

            if isLeft {
                newBottomLeft = newBottom
            } else {
                newBottomRight = newBottom
            }
        }

        self.calculateMinMaxValues()

        return ZXPDF417BoundingBox(image: self.image, topLeft: newTopLeft, bottomLeft: newBottomLeft, topRight: newTopRight, bottomRight: newBottomRight)
    }
    @objc
    func calculateMinMaxValues() {
        if !self.topLeft {
            _topLeft = ZXResultPoint(x: 0, y: self.topRight.y ?? 0.0)
            _bottomLeft = ZXResultPoint(x: 0, y: self.bottomRight.y ?? 0.0)
        } else if !self.topRight {
            _topRight = ZXResultPoint(x: CFloat((self.image.width ?? 0) - 1), y: self.topLeft.y ?? 0.0)
            _bottomRight = ZXResultPoint(x: CFloat((self.image.width ?? 0) - 1), y: self.bottomLeft.y ?? 0.0)
        }

        self.minX = CInt(min(self.topLeft.x ?? 0.0, self.bottomLeft.x ?? 0.0))

        self.maxX = CInt(max(self.topRight.x ?? 0.0, self.bottomRight.x ?? 0.0))

        self.minY = CInt(min(self.topLeft.y ?? 0.0, self.topRight.y ?? 0.0))

        self.maxY = CInt(max(self.bottomLeft.y ?? 0.0, self.bottomRight.y ?? 0.0))
    }
}

// MARK: -
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
extension ZXPDF417BoundingBox {
    @objc var image: ZXBitMatrix! {
        return self._image
    }
}