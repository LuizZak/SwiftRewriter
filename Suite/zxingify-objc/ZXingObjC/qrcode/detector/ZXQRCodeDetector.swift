// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXDecodeHints.h"
// #import "ZXDetectorResult.h"
// #import "ZXErrors.h"
// #import "ZXGridSampler.h"
// #import "ZXIntArray.h"
// #import "ZXMathUtils.h"
// #import "ZXPerspectiveTransform.h"
// #import "ZXQRCodeAlignmentPattern.h"
// #import "ZXQRCodeAlignmentPatternFinder.h"
// #import "ZXQRCodeDetector.h"
// #import "ZXQRCodeFinderPattern.h"
// #import "ZXQRCodeFinderPatternFinder.h"
// #import "ZXQRCodeFinderPatternInfo.h"
// #import "ZXQRCodeVersion.h"
// #import "ZXResultPoint.h"
// #import "ZXResultPointCallback.h"
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
 * Encapsulates logic that can detect a QR Code in an image, even if the QR Code
 * is rotated or skewed, or partially obscured.
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
 * Encapsulates logic that can detect a QR Code in an image, even if the QR Code
 * is rotated or skewed, or partially obscured.
 */
@objc
class ZXQRCodeDetector: NSObject {
    private var _image: ZXBitMatrix!
    @objc var image: ZXBitMatrix! {
        return self._image
    }
    @objc weak var resultPointCallback: ZXResultPointCallback?

    @objc
    init(image: ZXBitMatrix!) {
        if self = super.init() {
            _image = image
        }

        return self
    }

    /**
 * Detects a QR Code in an image.
 *
 * @return ZXDetectorResult encapsulating results of detecting a QR Code or nil if:
 *   - no QR Code can be found
 *   - a QR Code cannot be decoded
 */
    /**
 * Detects a QR Code in an image.
 *
 * @return ZXDetectorResult encapsulating results of detecting a QR Code or nil if:
 *   - no QR Code can be found
 *   - a QR Code cannot be decoded
 */
    @objc
    func detectWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXDetectorResult? {
        return self.detect(nil, error: error)
    }
    /**
 * Detects a QR Code in an image.
 *
 * @param hints optional hints to detector
 * @return ZXDetectorResult encapsulating results of detecting a QR Code or nil if:
 *   - QR Code cannot be found
 *   - a QR Code cannot be decoded
 */
    /**
 * Detects a QR Code in an image.
 *
 * @param hints optional hints to detector
 * @return ZXDetectorResult encapsulating results of detecting a QR Code or nil if:
 *   - QR Code cannot be found
 *   - a QR Code cannot be decoded
 */
    @objc
    func detect(_ hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXDetectorResult? {
        self.resultPointCallback = (hints == nil) ? nil : hints.resultPointCallback

        let finder = ZXQRCodeFinderPatternFinder(image: self.image, resultPointCallback: self.resultPointCallback)
        let info = finder.find(hints, error: error)

        if info == nil {
            return nil
        }

        return self.processFinderPatternInfo(info, error: error)
    }
    @objc
    func processFinderPatternInfo(_ info: ZXQRCodeFinderPatternInfo!, error: UnsafeMutablePointer<Error?>!) -> ZXDetectorResult? {
        let topLeft = info.topLeft
        let topRight = info.topRight
        let bottomLeft = info.bottomLeft
        let moduleSize = self.calculateModuleSize(topLeft, topRight: topRight, bottomLeft: bottomLeft)

        if moduleSize < 1.0 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let dimension = ZXQRCodeDetector.computeDimension(topLeft, topRight: topRight, bottomLeft: bottomLeft, moduleSize: moduleSize, error: error)

        if dimension == 1 {
            return nil
        }

        let provisionalVersion = ZXQRCodeVersion.provisionalVersionForDimension(dimension)

        if provisionalVersion == nil {
            if error != nil {
                error.pointee = ZXFormatErrorInstance()
            }

            return nil
        }

        let modulesBetweenFPCenters = (provisionalVersion?.dimensionForVersion ?? 0) - 7
        var alignmentPattern: ZXQRCodeAlignmentPattern! = nil

        if (provisionalVersion?.alignmentPatternCenters.length ?? 0) > 0 {
            let bottomRightX = ((topRight?.x ?? 0.0) - (topLeft?.x ?? 0.0) + (bottomLeft?.x ?? 0.0)) ?? 0.0
            let bottomRightY = ((topRight?.y ?? 0.0) - (topLeft?.y ?? 0.0) + (bottomLeft?.y ?? 0.0)) ?? 0.0
            let correctionToTopLeft: CFloat = 1.0 - 3.0 / CFloat(modulesBetweenFPCenters)
            let estAlignmentX: CInt = CInt((topLeft?.x ?? 0.0) + (correctionToTopLeft * ((bottomRightX - (topLeft?.x ?? 0.0)) ?? 0.0)) ?? 0.0)
            let estAlignmentY: CInt = CInt((topLeft?.y ?? 0.0) + (correctionToTopLeft * ((bottomRightY - (topLeft?.y ?? 0.0)) ?? 0.0)) ?? 0.0)
            var i: CInt = 4

            while i <= 16 {
                defer {
                    i <<= 1
                }

                var alignmentError: Error! = nil

                alignmentPattern = self.findAlignmentInRegion(moduleSize, estAlignmentX: estAlignmentX, estAlignmentY: estAlignmentY, allowanceFactor: CFloat(i), error: &alignmentError)

                if alignmentPattern != nil {
                    break
                } else if alignmentError?.code != ZXNotFoundError {
                    if error != nil {
                        error.pointee = alignmentError
                    }

                    return nil
                }
            }
        }

        let transform = ZXQRCodeDetector.createTransform(topLeft, topRight: topRight, bottomLeft: bottomLeft, alignmentPattern: alignmentPattern, dimension: dimension)
        let bits = self.sampleGrid(self.image, transform: transform, dimension: dimension, error: error)

        if !bits {
            return nil
        }

        var points: NSArray!

        if alignmentPattern == nil {
            points = [bottomLeft, topLeft, topRight]
        } else {
            points = [bottomLeft, topLeft, topRight, alignmentPattern]
        }

        return ZXDetectorResult(bits: bits, points: points)
    }
    @objc
    static func createTransform(_ topLeft: ZXResultPoint!, topRight: ZXResultPoint!, bottomLeft: ZXResultPoint!, alignmentPattern: ZXResultPoint!, dimension: CInt) -> ZXPerspectiveTransform? {
        let dimMinusThree: CFloat = CFloat(dimension) - 3.5
        var bottomRightX: CFloat
        var bottomRightY: CFloat
        var sourceBottomRightX: CFloat
        var sourceBottomRightY: CFloat

        if alignmentPattern != nil {
            bottomRightX = alignmentPattern.x

            bottomRightY = alignmentPattern.y

            sourceBottomRightX = dimMinusThree - 3.0

            sourceBottomRightY = sourceBottomRightX
        } else {
            bottomRightX = (topRight.x - topLeft.x) + bottomLeft.x

            bottomRightY = (topRight.y - topLeft.y) + bottomLeft.y

            sourceBottomRightX = dimMinusThree

            sourceBottomRightY = dimMinusThree
        }

        return ZXPerspectiveTransform.quadrilateralToQuadrilateral(3.5, y0: 3.5, x1: dimMinusThree, y1: 3.5, x2: sourceBottomRightX, y2: sourceBottomRightY, x3: 3.5, y3: dimMinusThree, x0p: topLeft.x, y0p: topLeft.y, x1p: topRight.x, y1p: topRight.y, x2p: bottomRightX, y2p: bottomRightY, x3p: bottomLeft.x, y3p: bottomLeft.y)
    }
    @objc
    func sampleGrid(_ anImage: ZXBitMatrix!, transform: ZXPerspectiveTransform!, dimension: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        let sampler = ZXGridSampler.instance()

        return sampler?.sampleGrid(anImage, dimensionX: dimension, dimensionY: dimension, transform: transform, error: error)
    }
    /**
 * Computes the dimension (number of modules on a size) of the QR Code based on the position
 * of the finder patterns and estimated module size. Returns -1 on an error.
 */
    @objc
    static func computeDimension(_ topLeft: ZXResultPoint!, topRight: ZXResultPoint!, bottomLeft: ZXResultPoint!, moduleSize: CFloat, error: UnsafeMutablePointer<Error?>!) -> CInt {
        let tltrCentersDimension = ZXMathUtils.round(ZXResultPoint.distance(topLeft, pattern2: topRight) / moduleSize)
        let tlblCentersDimension = ZXMathUtils.round(ZXResultPoint.distance(topLeft, pattern2: bottomLeft) / moduleSize)
        var dimension = ((tltrCentersDimension + tlblCentersDimension) / 2) + 7

        switch dimension & 0x3 {
        case 0:
            dimension += 1
        case 2:
            dimension -= 1
        case 3:
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return 1
        default:
            break
        }

        return dimension
    }
    /**
 * Computes an average estimated module size based on estimated derived from the positions
 * of the three finder patterns.
 *
 * @param topLeft detected top-left finder pattern center
 * @param topRight detected top-right finder pattern center
 * @param bottomLeft detected bottom-left finder pattern center
 * @return estimated module size
 */
    /**
 * Computes an average estimated module size based on estimated derived from the positions
 * of the three finder patterns.
 *
 * @param topLeft detected top-left finder pattern center
 * @param topRight detected top-right finder pattern center
 * @param bottomLeft detected bottom-left finder pattern center
 * @return estimated module size
 */
    /**
 * Computes an average estimated module size based on estimated derived from the positions
 * of the three finder patterns.
 */
    @objc
    func calculateModuleSize(_ topLeft: ZXResultPoint!, topRight: ZXResultPoint!, bottomLeft: ZXResultPoint!) -> CFloat {
        return (self.calculateModuleSizeOneWay(topLeft, otherPattern: topRight) + self.calculateModuleSizeOneWay(topLeft, otherPattern: bottomLeft)) / 2.0
    }
    /**
 * Estimates module size based on two finder patterns -- it uses
 * sizeOfBlackWhiteBlackRunBothWays:fromY:toX:toY: to figure the
 * width of each, measuring along the axis between their centers.
 */
    @objc
    func calculateModuleSizeOneWay(_ pattern: ZXResultPoint!, otherPattern: ZXResultPoint!) -> CFloat {
        let moduleSizeEst1 = self.sizeOfBlackWhiteBlackRunBothWays(CInt(pattern.x), fromY: CInt(pattern.y), toX: CInt(otherPattern.x), toY: CInt(otherPattern.y))
        let moduleSizeEst2 = self.sizeOfBlackWhiteBlackRunBothWays(CInt(otherPattern.x), fromY: CInt(otherPattern.y), toX: CInt(pattern.x), toY: CInt(pattern.y))

        if isnan(moduleSizeEst1) {
            return moduleSizeEst2 / 7.0
        }

        if isnan(moduleSizeEst2) {
            return moduleSizeEst1 / 7.0
        }

        return (moduleSizeEst1 + moduleSizeEst2) / 14.0
    }
    /**
 * See sizeOfBlackWhiteBlackRun:fromY:toX:toY: <p>computes the total width of
 * a finder pattern by looking for a black-white-black run from the center in the direction
 * of another point (another finder pattern center), and in the opposite direction too.</p>
 */
    @objc
    func sizeOfBlackWhiteBlackRunBothWays(_ fromX: CInt, fromY: CInt, toX: CInt, toY: CInt) -> CFloat {
        var result = self.sizeOfBlackWhiteBlackRun(fromX, fromY: fromY, toX: toX, toY: toY)
        // Now count other way -- don't run off image though of course
        var scale: CFloat = 1.0
        var otherToX = fromX - (toX - fromX)

        if otherToX < 0 {
            scale = CFloat(fromX) / CFloat(fromX - otherToX)
            otherToX = 0
        } else if otherToX >= (self.image.width ?? 0) {
            scale = CFloat((self.image.width ?? 0) - 1 - fromX) / CFloat(otherToX - fromX)
            otherToX = (self.image.width ?? 0) - 1
        }

        var otherToY: CInt = CInt(fromY - CFloat(toY - fromY) * scale)

        scale = 1.0

        if otherToY < 0 {
            scale = CFloat(fromY) / CFloat(fromY - otherToY)
            otherToY = 0
        } else if otherToY >= (self.image.height ?? 0) {
            scale = CFloat((self.image.height ?? 0) - 1 - fromY) / CFloat(otherToY - fromY)
            otherToY = (self.image.height ?? 0) - 1
        }

        otherToX = CInt(fromX + CFloat(otherToX - fromX) * scale)
        result += self.sizeOfBlackWhiteBlackRun(fromX, fromY: fromY, toX: otherToX, toY: otherToY)

        // Middle pixel is double-counted this way; subtract 1
        return result - 1.0
    }
    /**
 * This method traces a line from a point in the image, in the direction towards another point.
 * It begins in a black region, and keeps going until it finds white, then black, then white again.
 * It reports the distance from the start to this point.
 *
 * This is used when figuring out how wide a finder pattern is, when the finder pattern
 * may be skewed or rotated.
 */
    @objc
    func sizeOfBlackWhiteBlackRun(_ fromX: CInt, fromY: CInt, toX: CInt, toY: CInt) -> CFloat {
        // Mild variant of Bresenham's algorithm;
        // see http://en.wikipedia.org/wiki/Bresenham's_line_algorithm
        let steep = abs(toY - fromY) > abs(toX - fromX)

        if steep {
            var temp = fromX

            fromX = fromY

            fromY = temp

            temp = toX

            toX = toY

            toY = temp
        }

        let dx = abs(toX - fromX)
        let dy = abs(toY - fromY)
        var error = -dx / 2
        let xstep: CInt = (fromX < toX) ? 1 : 1
        let ystep: CInt = (fromY < toY) ? 1 : 1
        // In black pixels, looking for white, first or second time.
        var state: CInt = 0
        // Loop up until x == toX, but not beyond
        let xLimit = toX + xstep
        var x = fromX, y = fromY

        while x != xLimit {
            defer {
                x += xstep
            }

            let realX = steep ? y : x
            let realY = steep ? x : y

            // Does current pixel mean we have moved white to black or vice versa?
            // Scanning black in state 0,2 and white in state 1, so if we find the wrong
            // color, advance to next state or end if we are in state 2 already
            if (state == 1) == self.image.getX(realX, y: realY) {
                if state == 2 {
                    return ZXMathUtils.distanceInt(x, aY: y, bX: fromX, bY: fromY)
                }

                state += 1
            }

            error += dy

            if error > 0 {
                if y == toY {
                    break
                }

                y += ystep
                error -= dx
            }
        }

        // Found black-white-black; give the benefit of the doubt that the next pixel outside the image
        // is "white" so this last point at (toX+xStep,toY) is the right ending. This is really a
        // small approximation; (toX+xStep,toY+yStep) might be really correct. Ignore this.
        if state == 2 {
            return ZXMathUtils.distanceInt(toX + xstep, aY: toY, bX: fromX, bY: fromY)
        }

        // else we didn't find even black-white-black; no estimate is really possible
        return NAN
    }
    /**
 * Attempts to locate an alignment pattern in a limited region of the image, which is
 * guessed to contain it. This method uses ZXAlignmentPattern.
 *
 * @param overallEstModuleSize estimated module size so far
 * @param estAlignmentX x coordinate of center of area probably containing alignment pattern
 * @param estAlignmentY y coordinate of above
 * @param allowanceFactor number of pixels in all directions to search from the center
 * @return ZXAlignmentPattern if found, or nil if an unexpected error occurs during detection
 */
    /**
 * Attempts to locate an alignment pattern in a limited region of the image, which is
 * guessed to contain it. This method uses ZXAlignmentPattern.
 *
 * @param overallEstModuleSize estimated module size so far
 * @param estAlignmentX x coordinate of center of area probably containing alignment pattern
 * @param estAlignmentY y coordinate of above
 * @param allowanceFactor number of pixels in all directions to search from the center
 * @return ZXAlignmentPattern if found, or nil if an unexpected error occurs during detection
 */
    @objc
    func findAlignmentInRegion(_ overallEstModuleSize: CFloat, estAlignmentX: CInt, estAlignmentY: CInt, allowanceFactor: CFloat, error: UnsafeMutablePointer<Error?>!) -> ZXQRCodeAlignmentPattern? {
        let allowance: CInt = CInt(allowanceFactor * overallEstModuleSize)
        let alignmentAreaLeftX = max(0, estAlignmentX - allowance)
        let alignmentAreaRightX = min((self.image.width ?? 0) - 1, estAlignmentX + allowance)

        if alignmentAreaRightX - alignmentAreaLeftX < overallEstModuleSize * 3 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let alignmentAreaTopY = max(0, estAlignmentY - allowance)
        let alignmentAreaBottomY = min((self.image.height ?? 0) - 1, estAlignmentY + allowance)

        if alignmentAreaBottomY - alignmentAreaTopY < overallEstModuleSize * 3 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let alignmentFinder = ZXQRCodeAlignmentPatternFinder(image: self.image, startX: alignmentAreaLeftX, startY: alignmentAreaTopY, width: alignmentAreaRightX - alignmentAreaLeftX, height: alignmentAreaBottomY - alignmentAreaTopY, moduleSize: overallEstModuleSize, resultPointCallback: self.resultPointCallback)

        return alignmentFinder.findWithError(error)
    }
}