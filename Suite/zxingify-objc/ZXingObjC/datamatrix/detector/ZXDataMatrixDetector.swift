import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXDataMatrixDetector.h"
// #import "ZXDetectorResult.h"
// #import "ZXErrors.h"
// #import "ZXGridSampler.h"
// #import "ZXMathUtils.h"
// #import "ZXResultPoint.h"
// #import "ZXWhiteRectangleDetector.h"
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
 * Encapsulates logic that can detect a Data Matrix Code in an image, even if the Data Matrix Code
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
 * Encapsulates logic that can detect a Data Matrix Code in an image, even if the Data Matrix Code
 * is rotated or skewed, or partially obscured.
 */
@objc
class ZXDataMatrixDetector: NSObject {
    private var _image: ZXBitMatrix!
    private var _rectangleDetector: ZXWhiteRectangleDetector!

    @objc
    init?(image: ZXBitMatrix!, error: UnsafeMutablePointer<Error?>!) {
        if self = super.init() {
            _image = image
            _rectangleDetector = ZXWhiteRectangleDetector(image: _image, error: error)

            if !_rectangleDetector {
                return nil
            }
        }

        return self
    }

    /**
 * Detects a Data Matrix Code in an image.
 *
 * @return ZXDetectorResult encapsulating results of detecting a Data Matrix Code or nil
 *  if no Data Matrix Code can be found
 */
    /**
 * Detects a Data Matrix Code in an image.
 *
 * @return ZXDetectorResult encapsulating results of detecting a Data Matrix Code or nil
 *  if no Data Matrix Code can be found
 */
    @objc
    func detectWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXDetectorResult? {
        let cornerPoints = self.rectangleDetector.detectWithError(error)

        if cornerPoints == nil {
            return nil
        }

        var points: NSMutableArray! = self.detectSolid1(cornerPoints?.mutableCopy())

        points = self.detectSolid2(points)

        let correctedTopRight = self.correctTopRight(points)

        if !correctedTopRight {
            return nil
        }

        points[3] = correctedTopRight
        points = self.shiftToModuleCenter(points)

        let topLeft: ZXResultPoint = points[0]
        let bottomLeft: ZXResultPoint = points[1]
        let bottomRight: ZXResultPoint = points[2]
        let topRight: ZXResultPoint = points[3]
        var dimensionTop = self.transitionsBetween(topLeft, to: topRight) + 1
        var dimensionRight = self.transitionsBetween(bottomRight, to: topRight) + 1

        if (dimensionTop & 0x1) == 1 {
            dimensionTop += 1
        }

        if (dimensionRight & 0x1) == 1 {
            dimensionRight += 1
        }

        if 4 * dimensionTop < 7 * dimensionRight && 4 * dimensionRight < 7 * dimensionTop {
            // The matrix is square
            dimensionRight = max(dimensionTop, dimensionRight)
            dimensionTop = dimensionRight
        }

        let bits = self.sampleGrid(self.image, topLeft: topLeft, bottomLeft: bottomLeft, bottomRight: bottomRight, topRight: topRight, dimensionX: dimensionTop, dimensionY: dimensionRight, error: error)

        return ZXDetectorResult(bits: bits, points: [topLeft, bottomLeft, bottomRight, topRight])
    }
    @objc
    func shiftPoint(_ point: ZXResultPoint!, to: ZXResultPoint!, div: CInt) -> ZXResultPoint? {
        let x: CFloat = (to.x - point.x) / CFloat(CFloat(div + 1))
        let y: CFloat = (to.y - point.y) / CFloat(CFloat(div + 1))

        return ZXResultPoint(x: point.x + x, y: point.y + y)
    }
    @objc
    func moveAway(_ point: ZXResultPoint!, fromX: CFloat, fromY: CFloat) -> ZXResultPoint? {
        var x = point.x
        var y = point.y

        if x < fromX {
            x -= 1
        } else {
            x += 1
        }

        if y < fromY {
            y -= 1
        } else {
            y += 1
        }

        return ZXResultPoint(x: x, y: y)
    }
    /**
 * Detect a solid side which has minimum transition.
 */
    @objc
    func detectSolid1(_ cornerPoints: NSMutableArray!) -> NSMutableArray {
        // 0  2
        // 1  3
        let pointA: ZXResultPoint = cornerPoints[0]
        let pointB: ZXResultPoint = cornerPoints[1]
        let pointC: ZXResultPoint = cornerPoints[3]
        let pointD: ZXResultPoint = cornerPoints[2]
        let trAB = self.transitionsBetween(pointA, to: pointB)
        let trBC = self.transitionsBetween(pointB, to: pointC)
        let trCD = self.transitionsBetween(pointC, to: pointD)
        let trDA = self.transitionsBetween(pointD, to: pointA)
        // 0..3
        // :  :
        // 1--2
        var min = trAB
        let points: NSMutableArray! = [pointD, pointA, pointB, pointC].mutableCopy()

        if min > trBC {
            min = trBC

            points[0] = pointA
            points[1] = pointB
            points[2] = pointC
            points[3] = pointD
        }

        if min > trCD {
            min = trCD

            points[0] = pointB
            points[1] = pointC
            points[2] = pointD
            points[3] = pointA
        }

        if min > trDA {
            points[0] = pointC
            points[1] = pointD
            points[2] = pointA
            points[3] = pointB
        }

        return points
    }
    /**
 * Detect a second solid side next to first solid side.
 */
    @objc
    func detectSolid2(_ points: NSMutableArray!) -> NSMutableArray? {
        // A..D
        // :  :
        // B--C
        let pointA: ZXResultPoint = points[0]
        let pointB: ZXResultPoint = points[1]
        let pointC: ZXResultPoint = points[2]
        let pointD: ZXResultPoint = points[3]
        // Transition detection on the edge is not stable.
        // To safely detect, shift the points to the module center.
        let tr = self.transitionsBetween(pointA, to: pointD)
        let pointBs = self.shiftPoint(pointB, to: pointC, div: (tr + 1) * 4)
        let pointCs = self.shiftPoint(pointC, to: pointB, div: (tr + 1) * 4)
        let trBA = self.transitionsBetween(pointBs, to: pointA)
        let trCD = self.transitionsBetween(pointCs, to: pointD)

        // 0..3
        // |  :
        // 1--2
        if trBA < trCD {
            // solid sides: A-B-C
            points[0] = pointA
            points[1] = pointB
            points[2] = pointC
            points[3] = pointD
        } else {
            // solid sides: B-C-D
            points[0] = pointB
            points[1] = pointC
            points[2] = pointD
            points[3] = pointA
        }

        return points
    }
    /**
 * Calculates the corner position of the white top right module.
 */
    @objc
    func correctTopRight(_ points: NSMutableArray!) -> ZXResultPoint {
        // A..D
        // |  :
        // B--C
        let pointA: ZXResultPoint = points[0]
        let pointB: ZXResultPoint = points[1]
        let pointC: ZXResultPoint = points[2]
        let pointD: ZXResultPoint = points[3]
        // shift points for safe transition detection.
        var trTop = self.transitionsBetween(pointA, to: pointD)
        var trRight = self.transitionsBetween(pointB, to: pointD)
        let pointAs = self.shiftPoint(pointA, to: pointB, div: (trRight + 1) * 4)
        let pointCs = self.shiftPoint(pointC, to: pointB, div: (trTop + 1) * 4)

        trTop = self.transitionsBetween(pointAs, to: pointD)
        trRight = self.transitionsBetween(pointCs, to: pointD)

        let candidate1 = ZXResultPoint(x: pointD.x + (pointC.x - pointB.x) / CFloat(trTop + 1), y: pointD.y + (pointC.y - pointB.y) / CFloat(trTop + 1))
        let candidate2 = ZXResultPoint(x: pointD.x + (pointA.x - pointB.x) / CFloat(trRight + 1), y: pointD.y + (pointA.y - pointB.y) / CFloat(trRight + 1))

        if !self.isValid(candidate1) {
            if self.isValid(candidate2) {
                return candidate2
            }

            return nil
        }

        if !self.isValid(candidate2) {
            return candidate1
        }

        let sumc1 = self.transitionsBetween(pointAs, to: candidate1) + self.transitionsBetween(pointCs, to: candidate1)
        let sumc2 = self.transitionsBetween(pointAs, to: candidate2) + self.transitionsBetween(pointCs, to: candidate2)

        if sumc1 > sumc2 {
            return candidate1
        } else {
            return candidate2
        }
    }
    @objc
    func isValid(_ p: ZXResultPoint!) -> Bool {
        return p.x >= 0 && p.x < (self.image.width ?? 0) && p.y > 0 && p.y < (self.image.height ?? 0)
    }
    /**
 * Shift the edge points to the module center.
 */
    @objc
    func shiftToModuleCenter(_ points: NSMutableArray!) -> NSMutableArray? {
        // A..D
        // |  :
        // B--C
        var pointA: ZXResultPoint! = points[0]
        var pointB: ZXResultPoint! = points[1]
        var pointC: ZXResultPoint! = points[2]
        var pointD: ZXResultPoint! = points[3]
        // calculate pseudo dimensions
        var dimH = self.transitionsBetween(pointA, to: pointD) + 1
        var dimV = self.transitionsBetween(pointC, to: pointD) + 1
        // shift points for safe dimension detection
        var pointAs = self.shiftPoint(pointA, to: pointB, div: dimV * 4)
        var pointCs = self.shiftPoint(pointC, to: pointB, div: dimH * 4)

        //  calculate more precise dimensions
        dimH = self.transitionsBetween(pointAs, to: pointD) + 1
        dimV = self.transitionsBetween(pointCs, to: pointD) + 1

        if (dimH & 0x1) == 1 {
            dimH += 1
        }

        if (dimV & 0x1) == 1 {
            dimV += 1
        }

        // WhiteRectangleDetector returns points inside of the rectangle.
        // I want points on the edges.
        let centerX = (pointA.x + pointB.x + pointC.x + pointD.x) / 4
        let centerY = (pointA.y + pointB.y + pointC.y + pointD.y) / 4

        pointA = self.moveAway(pointA, fromX: centerX, fromY: centerY)

        pointB = self.moveAway(pointB, fromX: centerX, fromY: centerY)

        pointC = self.moveAway(pointC, fromX: centerX, fromY: centerY)

        pointD = self.moveAway(pointD, fromX: centerX, fromY: centerY)

        var pointBs: ZXResultPoint!
        var pointDs: ZXResultPoint!

        // shift points to the center of each modules
        pointAs = self.shiftPoint(pointA, to: pointB, div: dimV * 4)
        pointAs = self.shiftPoint(pointAs, to: pointD, div: dimH * 4)

        pointBs = self.shiftPoint(pointB, to: pointA, div: dimV * 4)
        pointBs = self.shiftPoint(pointBs, to: pointC, div: dimH * 4)

        pointCs = self.shiftPoint(pointC, to: pointD, div: dimV * 4)
        pointCs = self.shiftPoint(pointCs, to: pointB, div: dimH * 4)

        pointDs = self.shiftPoint(pointD, to: pointC, div: dimV * 4)
        pointDs = self.shiftPoint(pointDs, to: pointA, div: dimH * 4)

        return [pointAs, pointBs, pointCs, pointDs].mutableCopy()
    }
    @objc
    func sampleGrid(_ image: ZXBitMatrix!, topLeft: ZXResultPoint!, bottomLeft: ZXResultPoint!, bottomRight: ZXResultPoint!, topRight: ZXResultPoint!, dimensionX: CInt, dimensionY: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        let sampler = ZXGridSampler.instance()

        return sampler?.sampleGrid(image, dimensionX: dimensionX, dimensionY: dimensionY, p1ToX: 0.5, p1ToY: 0.5, p2ToX: dimensionX - 0.5, p2ToY: 0.5, p3ToX: dimensionX - 0.5, p3ToY: dimensionY - 0.5, p4ToX: 0.5, p4ToY: dimensionY - 0.5, p1FromX: topLeft.x(), p1FromY: topLeft.y(), p2FromX: topRight.x(), p2FromY: topRight.y(), p3FromX: bottomRight.x(), p3FromY: bottomRight.y(), p4FromX: bottomLeft.x(), p4FromY: bottomLeft.y(), error: error)
    }
    /**
 * Counts the number of black/white transitions between two points, using something like Bresenham's algorithm.
 */
    @objc
    func transitionsBetween(_ from: ZXResultPoint!, to: ZXResultPoint!) -> CInt {
        var fromX: CInt = CInt(from.x)
        var fromY: CInt = CInt(from.y)
        var toX: CInt = CInt(to.x)
        var toY: CInt = CInt(to.y)
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
        let ystep: CInt = (fromY < toY) ? 1 : 1
        let xstep: CInt = (fromX < toX) ? 1 : 1
        var transitions: CInt = 0
        var inBlack = self.image.getX(steep ? fromY : fromX, y: steep ? fromX : fromY) == true
        var x = fromX, y = fromY

        while x != toX {
            defer {
                x += xstep
            }

            let isBlack = self.image.getX(steep ? y : x, y: steep ? x : y) == true

            if isBlack != inBlack {
                transitions += 1
                inBlack = isBlack
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

        return transitions
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
extension ZXDataMatrixDetector {
    @objc var image: ZXBitMatrix! {
        return self._image
    }
    @objc var rectangleDetector: ZXWhiteRectangleDetector! {
        return self._rectangleDetector
    }
}