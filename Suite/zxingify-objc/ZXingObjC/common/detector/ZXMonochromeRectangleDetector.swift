// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXErrors.h"
// #import "ZXMonochromeRectangleDetector.h"
// #import "ZXResultPoint.h"
let ZX_MONOCHROME_MAX_MODULES: CInt = 32

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
 * A somewhat generic detector that looks for a barcode-like rectangular region within an image.
 * It looks within a mostly white region of an image for a region of black and white, but mostly
 * black. It returns the four corners of the region, as best it can determine.
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
 * A somewhat generic detector that looks for a barcode-like rectangular region within an image.
 * It looks within a mostly white region of an image for a region of black and white, but mostly
 * black. It returns the four corners of the region, as best it can determine.
 */
@objc
class ZXMonochromeRectangleDetector: NSObject {
    private var _image: ZXBitMatrix!

    @objc
    init(image: ZXBitMatrix!) {
        if self = super.init() {
            _image = image
        }

        return self
    }

    /**
 * Detects a rectangular region of black and white -- mostly black -- with a region of mostly
 * white, in an image.
 *
 * @return ZXResultPoint array describing the corners of the rectangular region. The first and
 *  last points are opposed on the diagonal, as are the second and third. The first point will be
 *  the topmost point and the last, the bottommost. The second point will be leftmost and the
 *  third, the rightmost
 * @return nil if no Data Matrix Code can be found
 */
    /**
 * Detects a rectangular region of black and white -- mostly black -- with a region of mostly
 * white, in an image.
 *
 * @return ZXResultPoint array describing the corners of the rectangular region. The first and
 *  last points are opposed on the diagonal, as are the second and third. The first point will be
 *  the topmost point and the last, the bottommost. The second point will be leftmost and the
 *  third, the rightmost
 * @return nil if no Data Matrix Code can be found
 */
    @objc
    func detectWithError(_ error: UnsafeMutablePointer<Error?>!) -> NSArray? {
        let height = self.image.height ?? 0
        let width = self.image.width ?? 0
        let halfHeight = height / 2
        let halfWidth = width / 2
        let deltaY: CInt = CInt(max(1, height / (ZX_MONOCHROME_MAX_MODULES * 8) > 1))
        let deltaX: CInt = CInt(max(1, width / (ZX_MONOCHROME_MAX_MODULES * 8) > 1))
        var top: CInt = 0
        var bottom = height
        var left: CInt = 0
        var right = width
        var pointA = self.findCornerFromCenter(halfWidth, deltaX: 0, left: left, right: right, centerY: halfHeight, deltaY: -deltaY, top: top, bottom: bottom, maxWhiteRun: halfWidth / 2)

        if pointA == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        top = CInt(pointA?.y ?? 0.0) - 1

        let pointB = self.findCornerFromCenter(halfWidth, deltaX: -deltaX, left: left, right: right, centerY: halfHeight, deltaY: 0, top: top, bottom: bottom, maxWhiteRun: halfHeight / 2)

        if pointB == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        left = CInt(pointB?.x ?? 0.0) - 1

        let pointC = self.findCornerFromCenter(halfWidth, deltaX: deltaX, left: left, right: right, centerY: halfHeight, deltaY: 0, top: top, bottom: bottom, maxWhiteRun: halfHeight / 2)

        if pointC == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        right = CInt(pointC?.x ?? 0.0) + 1

        let pointD = self.findCornerFromCenter(halfWidth, deltaX: 0, left: left, right: right, centerY: halfHeight, deltaY: deltaY, top: top, bottom: bottom, maxWhiteRun: halfWidth / 2)

        if pointD == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        bottom = CInt(pointD?.y ?? 0.0) + 1
        pointA = self.findCornerFromCenter(halfWidth, deltaX: 0, left: left, right: right, centerY: halfHeight, deltaY: -deltaY, top: top, bottom: bottom, maxWhiteRun: halfWidth / 4)

        if pointA == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        return [pointA, pointB, pointC, pointD]
    }
    /**
 * Attempts to locate a corner of the barcode by scanning up, down, left or right from a center
 * point which should be within the barcode.
 *
 * @param centerX center's x component (horizontal)
 * @param deltaX same as deltaY but change in x per step instead
 * @param left minimum value of x
 * @param right maximum value of x
 * @param centerY center's y component (vertical)
 * @param deltaY change in y per step. If scanning up this is negative; down, positive;
 *  left or right, 0
 * @param top minimum value of y to search through (meaningless when di == 0)
 * @param bottom maximum value of y
 * @param maxWhiteRun maximum run of white pixels that can still be considered to be within
 *  the barcode
 * @return a ZXResultPoint encapsulating the corner that was found
 *  or nil if such a point cannot be found
 */
    @objc
    func findCornerFromCenter(_ centerX: CInt, deltaX: CInt, left: CInt, right: CInt, centerY: CInt, deltaY: CInt, top: CInt, bottom: CInt, maxWhiteRun: CInt) -> ZXResultPoint? {
        var lastRange: NSArray! = nil
        var y = centerY, x = centerX

        while y < bottom && y >= top && x < right && x >= left {
            defer {
                y += deltaY
                x += deltaX
            }

            var range: NSArray!

            if deltaX == 0 {
                range = self.blackWhiteRange(y, maxWhiteRun: maxWhiteRun, minDim: left, maxDim: right, horizontal: true)
            } else {
                range = self.blackWhiteRange(x, maxWhiteRun: maxWhiteRun, minDim: top, maxDim: bottom, horizontal: false)
            }

            if range == nil {
                if lastRange == nil {
                    return nil
                }

                if deltaX == 0 {
                    let lastY = y - deltaY

                    if lastRange?[0].intValue() < centerX {
                        if lastRange?[0].intValue() > centerX {
                            return ZXResultPoint(x: (deltaY > 0) ? lastRange?[0].intValue() : lastRange?[1].intValue(), y: CFloat(lastY))
                        }

                        return ZXResultPoint(x: lastRange?[0].intValue(), y: CFloat(lastY))
                    } else {
                        return ZXResultPoint(x: lastRange?[1].intValue(), y: CFloat(lastY))
                    }
                } else {
                    let lastX = x - deltaX

                    if lastRange?[0].intValue() < centerY {
                        if lastRange?[1].intValue() > centerY {
                            return ZXResultPoint(x: CFloat(lastX), y: (deltaX < 0) ? lastRange?[0].intValue() : lastRange?[1].intValue())
                        }

                        return ZXResultPoint(x: CFloat(lastX), y: lastRange?[0].intValue())
                    } else {
                        return ZXResultPoint(x: CFloat(lastX), y: lastRange?[1].intValue())
                    }
                }
            }

            lastRange = range
        }

        return nil
    }
    /**
 * Computes the start and end of a region of pixels, either horizontally or vertically, that could
 * be part of a Data Matrix barcode.
 *
 * @param fixedDimension if scanning horizontally, this is the row (the fixed vertical location)
 *  where we are scanning. If scanning vertically it's the column, the fixed horizontal location
 * @param maxWhiteRun largest run of white pixels that can still be considered part of the
 *  barcode region
 * @param minDim minimum pixel location, horizontally or vertically, to consider
 * @param maxDim maximum pixel location, horizontally or vertically, to consider
 * @param horizontal if true, we're scanning left-right, instead of up-down
 * @return int[] with start and end of found range, or nil if no such range is found
 *  (e.g. only white was found)
 */
    @objc
    func blackWhiteRange(_ fixedDimension: CInt, maxWhiteRun: CInt, minDim: CInt, maxDim: CInt, horizontal: Bool) -> NSArray? {
        let center = (minDim + maxDim) / 2
        var start = center

        while start >= minDim {
            if horizontal ? self.image.getX(start, y: fixedDimension) : self.image.getX(fixedDimension, y: start) == true {
                start -= 1
            } else {
                let whiteRunStart = start

                repeat {
                    start -= 1
                } while start >= minDim && ((horizontal ? self.image.getX(start, y: fixedDimension) : self.image.getX(fixedDimension, y: start) == true) != true)

                let whiteRunSize = whiteRunStart - start

                if start < minDim || whiteRunSize > maxWhiteRun {
                    start = whiteRunStart

                    break
                }
            }
        }

        start += 1

        var end = center

        while end < maxDim {
            if horizontal ? self.image.getX(end, y: fixedDimension) : self.image.getX(fixedDimension, y: end) == true {
                end += 1
            } else {
                let whiteRunStart = end

                repeat {
                    end += 1
                } while end < maxDim && ((horizontal ? self.image.getX(end, y: fixedDimension) : self.image.getX(fixedDimension, y: end) == true) != true)

                let whiteRunSize = end - whiteRunStart

                if end >= maxDim || whiteRunSize > maxWhiteRun {
                    end = whiteRunStart

                    break
                }
            }
        }

        end -= 1

        return (end > start) ? [start, end] : nil
    }
}

// MARK: -
@objc
extension ZXMonochromeRectangleDetector {
    @objc var image: ZXBitMatrix! {
        return self._image
    }
}