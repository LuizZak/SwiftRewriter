// Preprocessor directives found in file:
// #import "ZXResultPoint.h"
// #import "ZXBitMatrix.h"
// #import "ZXErrors.h"
// #import "ZXMathUtils.h"
// #import "ZXWhiteRectangleDetector.h"
let ZX_INIT_SIZE: CInt = 10
let ZX_CORR: CInt = 1

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
 * Detects a candidate barcode-like rectangular region within an image. It
 * starts around the center of the image, increases the size of the candidate
 * region until it finds a white rectangular region. By keeping track of the
 * last black points it encountered, it determines the corners of the barcode.
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
 * Detects a candidate barcode-like rectangular region within an image. It
 * starts around the center of the image, increases the size of the candidate
 * region until it finds a white rectangular region. By keeping track of the
 * last black points it encountered, it determines the corners of the barcode.
 */
@objc
class ZXWhiteRectangleDetector: NSObject {
    private var _image: ZXBitMatrix!
    private var _height: CInt = 0
    private var _width: CInt = 0
    private var _leftInit: CInt = 0
    private var _rightInit: CInt = 0
    private var _downInit: CInt = 0
    private var _upInit: CInt = 0

    @objc
    init(image: ZXBitMatrix!, error: UnsafeMutablePointer<Error?>!) {
        return self.init(image: image, initSize: ZX_INIT_SIZE, x: image.width / 2, y: image.height / 2, error: error)
    }
    @objc
    init?(image: ZXBitMatrix!, initSize: CInt, x: CInt, y: CInt, error: UnsafeMutablePointer<Error?>!) {
        if self = super.init() {
            _image = image
            _height = image.height
            _width = image.width

            let halfsize = initSize / 2

            _leftInit = x - halfsize

            _rightInit = x + halfsize

            _upInit = y - halfsize

            _downInit = y + halfsize

            if _upInit < 0 || _leftInit < 0 || _downInit >= _height || _rightInit >= _width {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
                }

                return nil
            }
        }

        return self
    }

    /**
 * Detects a candidate barcode-like rectangular region within an image. It
 * starts around the center of the image, increases the size of the candidate
 * region until it finds a white rectangular region.
 *
 * @return NSArray of `ZXResultPoint`s describing the corners of the rectangular
 *         region. The first and last points are opposed on the diagonal, as
 *         are the second and third. The first point will be the topmost
 *         point and the last, the bottommost. The second point will be
 *         leftmost and the third, the rightmost
 * @return nil if no Data Matrix Code can be found
 */
    /**
 * Detects a candidate barcode-like rectangular region within an image. It
 * starts around the center of the image, increases the size of the candidate
 * region until it finds a white rectangular region.
 *
 * @return NSArray of `ZXResultPoint`s describing the corners of the rectangular
 *         region. The first and last points are opposed on the diagonal, as
 *         are the second and third. The first point will be the topmost
 *         point and the last, the bottommost. The second point will be
 *         leftmost and the third, the rightmost
 * @return nil if no Data Matrix Code can be found
 */
    @objc
    func detectWithError(_ error: UnsafeMutablePointer<Error?>!) -> NSArray {
        var left = self.leftInit
        var right = self.rightInit
        var up = self.upInit
        var down = self.downInit
        var sizeExceeded = false
        var aBlackPointFoundOnBorder = true
        var atLeastOneBlackPointFoundOnBorder = false
        var atLeastOneBlackPointFoundOnRight = false
        var atLeastOneBlackPointFoundOnBottom = false
        var atLeastOneBlackPointFoundOnLeft = false
        var atLeastOneBlackPointFoundOnTop = false

        while aBlackPointFoundOnBorder {
            aBlackPointFoundOnBorder = false

            // .....
            // .   |
            // .....
            var rightBorderNotWhite = true

            while (rightBorderNotWhite || !atLeastOneBlackPointFoundOnRight) && right < self.width {
                rightBorderNotWhite = self.containsBlackPoint(up, b: down, fixed: right, horizontal: false)

                if rightBorderNotWhite {
                    right += 1
                    aBlackPointFoundOnBorder = true
                    atLeastOneBlackPointFoundOnRight = true
                } else if !atLeastOneBlackPointFoundOnRight {
                    right += 1
                }
            }

            if right >= self.width {
                sizeExceeded = true

                break
            }

            // .....
            // .   .
            // .___.
            var bottomBorderNotWhite = true

            while (bottomBorderNotWhite || !atLeastOneBlackPointFoundOnBottom) && down < self.height {
                bottomBorderNotWhite = self.containsBlackPoint(left, b: right, fixed: down, horizontal: true)

                if bottomBorderNotWhite {
                    down += 1
                    aBlackPointFoundOnBorder = true
                    atLeastOneBlackPointFoundOnBottom = true
                } else if !atLeastOneBlackPointFoundOnBottom {
                    down += 1
                }
            }

            if down >= self.height {
                sizeExceeded = true

                break
            }

            // .....
            // |   .
            // .....
            var leftBorderNotWhite = true

            while (leftBorderNotWhite || !atLeastOneBlackPointFoundOnLeft) && left >= 0 {
                leftBorderNotWhite = self.containsBlackPoint(up, b: down, fixed: left, horizontal: false)

                if leftBorderNotWhite {
                    left -= 1
                    aBlackPointFoundOnBorder = true
                    atLeastOneBlackPointFoundOnLeft = true
                } else if !atLeastOneBlackPointFoundOnLeft {
                    left -= 1
                }
            }

            if left < 0 {
                sizeExceeded = true

                break
            }

            // .___.
            // .   .
            // .....
            var topBorderNotWhite = true

            while (topBorderNotWhite || !atLeastOneBlackPointFoundOnTop) && up >= 0 {
                topBorderNotWhite = self.containsBlackPoint(left, b: right, fixed: up, horizontal: true)

                if topBorderNotWhite {
                    up -= 1
                    aBlackPointFoundOnBorder = true
                    atLeastOneBlackPointFoundOnTop = true
                } else if !atLeastOneBlackPointFoundOnTop {
                    up -= 1
                }
            }

            if up < 0 {
                sizeExceeded = true

                break
            }

            if aBlackPointFoundOnBorder {
                atLeastOneBlackPointFoundOnBorder = true
            }
        }

        if !sizeExceeded && atLeastOneBlackPointFoundOnBorder {
            let maxSize = right - left
            var z: ZXResultPoint! = nil
            var i: CInt = 1

            while i < maxSize {
                defer {
                    i += 1
                }

                z = self.blackPointOnSegment(CFloat(left), aY: CFloat(down - i), bX: CFloat(left + i), bY: CFloat(down))

                if z != nil {
                    break
                }
            }

            if z == nil {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
                }

                return nil
            }

            var t: ZXResultPoint! = nil
            var i: CInt = 1

            while i < maxSize {
                defer {
                    i += 1
                }

                t = self.blackPointOnSegment(CFloat(left), aY: CFloat(up + i), bX: CFloat(left + i), bY: CFloat(up))

                if t != nil {
                    break
                }
            }

            if t == nil {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
                }

                return nil
            }

            var x: ZXResultPoint! = nil
            var i: CInt = 1

            while i < maxSize {
                defer {
                    i += 1
                }

                x = self.blackPointOnSegment(CFloat(right), aY: CFloat(up + i), bX: CFloat(right - i), bY: CFloat(up))

                if x != nil {
                    break
                }
            }

            if x == nil {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
                }

                return nil
            }

            var y: ZXResultPoint! = nil
            var i: CInt = 1

            while i < maxSize {
                defer {
                    i += 1
                }

                y = self.blackPointOnSegment(CFloat(right), aY: CFloat(down - i), bX: CFloat(right - i), bY: CFloat(down))

                if y != nil {
                    break
                }
            }

            if y == nil {
                if error != nil {
                    error.pointee = ZXNotFoundErrorInstance()
                }

                return nil
            }

            return self.centerEdges(y, z: z, x: x, t: t)
        } else {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }
    }
    @objc
    func blackPointOnSegment(_ aX: CFloat, aY: CFloat, bX: CFloat, bY: CFloat) -> ZXResultPoint? {
        let dist = ZXMathUtils.round(ZXMathUtils.distance(aX, aY: aY, bX: bX, bY: bY))
        let xStep: CFloat = (bX - aX) / CFloat(dist)
        let yStep: CFloat = (bY - aY) / CFloat(dist)
        var i: CInt = 0

        while i < dist {
            defer {
                i += 1
            }

            let x = ZXMathUtils.round(aX + CFloat(i) * xStep)
            let y = ZXMathUtils.round(aY + CFloat(i) * yStep)

            if self.image.getX(x, y: y) == true {
                return ZXResultPoint(x: CFloat(x), y: CFloat(y))
            }
        }

        return nil
    }
    /**
 * recenters the points of a constant distance towards the center
 *
 * @param y bottom most point
 * @param z left most point
 * @param x right most point
 * @param t top most point
 * @return ZXResultPoint array describing the corners of the rectangular
 *         region. The first and last points are opposed on the diagonal, as
 *         are the second and third. The first point will be the topmost
 *         point and the last, the bottommost. The second point will be
 *         leftmost and the third, the rightmost
 */
    @objc
    func centerEdges(_ y: ZXResultPoint!, z: ZXResultPoint!, x: ZXResultPoint!, t: ZXResultPoint!) -> NSArray {
        //
        //       t            t
        //  z                      x
        //        x    OR    z
        //   y                    y
        //
        let yi = y.x
        let yj = y.y
        let zi = z.x
        let zj = z.y
        let xi = x.x
        let xj = x.y
        let ti = t.x
        let tj = t.y

        if yi < self.width / 2.0 {
            return [ZXResultPoint(x: ti - CFloat(ZX_CORR), y: tj + CFloat(ZX_CORR)), ZXResultPoint(x: zi + CFloat(ZX_CORR), y: zj + CFloat(ZX_CORR)), ZXResultPoint(x: xi - CFloat(ZX_CORR), y: xj - CFloat(ZX_CORR)), ZXResultPoint(x: yi + CFloat(ZX_CORR), y: yj - CFloat(ZX_CORR))]
        } else {
            return [ZXResultPoint(x: ti + CFloat(ZX_CORR), y: tj + CFloat(ZX_CORR)), ZXResultPoint(x: zi + CFloat(ZX_CORR), y: zj - CFloat(ZX_CORR)), ZXResultPoint(x: xi - CFloat(ZX_CORR), y: xj + CFloat(ZX_CORR)), ZXResultPoint(x: yi - CFloat(ZX_CORR), y: yj - CFloat(ZX_CORR))]
        }
    }
    /**
 * Determines whether a segment contains a black point
 *
 * @param a          min value of the scanned coordinate
 * @param b          max value of the scanned coordinate
 * @param fixed      value of fixed coordinate
 * @param horizontal set to true if scan must be horizontal, false if vertical
 * @return true if a black point has been found, else false.
 */
    @objc
    func containsBlackPoint(_ a: CInt, b: CInt, fixed: CInt, horizontal: Bool) -> Bool {
        if horizontal {
            var x = a

            while x <= b {
                defer {
                    x += 1
                }

                if self.image.getX(x, y: fixed) == true {
                    return true
                }
            }
        } else {
            var y = a

            while y <= b {
                defer {
                    y += 1
                }

                if self.image.getX(fixed, y: y) == true {
                    return true
                }
            }
        }

        return false
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
extension ZXWhiteRectangleDetector {
    @objc var image: ZXBitMatrix! {
        return self._image
    }
    @objc var height: CInt {
        return self._height
    }
    @objc var width: CInt {
        return self._width
    }
    @objc var leftInit: CInt {
        return self._leftInit
    }
    @objc var rightInit: CInt {
        return self._rightInit
    }
    @objc var downInit: CInt {
        return self._downInit
    }
    @objc var upInit: CInt {
        return self._upInit
    }
}