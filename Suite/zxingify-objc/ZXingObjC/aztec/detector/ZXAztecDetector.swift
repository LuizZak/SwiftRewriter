import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXAztecDetector.h"
// #import "ZXAztecDetectorResult.h"
// #import "ZXErrors.h"
// #import "ZXGenericGF.h"
// #import "ZXGridSampler.h"
// #import "ZXIntArray.h"
// #import "ZXMathUtils.h"
// #import "ZXReedSolomonDecoder.h"
// #import "ZXResultPoint.h"
// #import "ZXWhiteRectangleDetector.h"
var expectedCornerBits: UnsafeMutablePointer<CInt>!

// 07340  XXX .XX X.. ...
// 00734  ... XXX .XX X..
// 04073  X.. ... XXX .XX
// 03407 .XX X.. ... XXX
func bitCount(_ i: uint32_t) -> CInt {
    i = i - ((i >> 1) & 0x55555555)
    i = (i & 0x33333333) + ((i >> 2) & 0x33333333)

    return (((i + (i >> 4)) & 0xf0f0f0f) * 0x1010101) >> 24
}

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
class ZXAztecPoint: NSObject {
    private var _x: CInt = 0
    private var _y: CInt = 0
    @objc var x: CInt {
        return self._x
    }
    @objc var y: CInt {
        return self._y
    }

    @objc
    init(x: CInt, y: CInt) {
        if self = super.init() {
            _x = x
            _y = y
        }

        return self
    }

    @objc
    func toResultPoint() -> ZXResultPoint? {
        return ZXResultPoint(x: CFloat(self.x), y: CFloat(self.y))
    }
    @objc
    func description() -> String? {
        return String(format: "<%d %d>", self.x, self.y)
    }
}
/**
 * Encapsulates logic that can detect an Aztec Code in an image, even if the Aztec Code
 * is rotated or skewed, or partially obscured.
 */
/**
 * Encapsulates logic that can detect an Aztec Code in an image, even if the Aztec Code
 * is rotated or skewed, or partially obscured.
 */
@objc
class ZXAztecDetector: NSObject {
    private var _image: ZXBitMatrix!
    @objc var compact: Bool = false
    @objc var nbCenterLayers: CInt = 0
    @objc var nbDataBlocks: CInt = 0
    @objc var nbLayers: CInt = 0
    @objc var shift: CInt = 0

    @objc
    init(image: ZXBitMatrix!) {
        if self = super.init() {
            _image = image
        }

        return self
    }

    @objc
    func detectWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXAztecDetectorResult? {
        return self.detectWithMirror(false, error: error)
    }
    /**
 * Detects an Aztec Code in an image.
 *
 * @param isMirror if true, image is a mirror-image of original
 * @return ZXAztecDetectorResult encapsulating results of detecting an Aztec Code, or nil if no
 *   Aztec Code can be found
 */
    /**
 * Detects an Aztec Code in an image.
 *
 * @param isMirror if true, image is a mirror-image of original
 * @return ZXAztecDetectorResult encapsulating results of detecting an Aztec Code, or nil if no
 *   Aztec Code can be found
 */
    @objc
    func detectWithMirror(_ isMirror: Bool, error: UnsafeMutablePointer<Error?>!) -> ZXAztecDetectorResult? {
        // 1. Get the center of the aztec matrix
        let pCenter = self.matrixCenter()

        if pCenter == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        // 2. Get the center points of the four diagonal points just outside the bull's eye
        //  [topRight, bottomRight, bottomLeft, topLeft]
        let bullsEyeCorners = self.bullsEyeCorners(pCenter)

        if bullsEyeCorners == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        if isMirror {
            let temp: ZXResultPoint! = bullsEyeCorners?[0]

            bullsEyeCorners?[0] = bullsEyeCorners?[2]
            bullsEyeCorners?[2] = temp
        }

        // 3. Get the size of the matrix and other parameters from the bull's eye
        if !self.extractParameters(bullsEyeCorners) {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        // 4. Sample the grid
        let bits = self.sampleGrid(self.image, topLeft: bullsEyeCorners?[Int(self.shift % 4)], topRight: bullsEyeCorners?[Int((self.shift + 1) % 4)], bottomRight: bullsEyeCorners?[Int((self.shift + 2) % 4)], bottomLeft: bullsEyeCorners?[Int((self.shift + 3) % 4)])

        if !bits {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        // 5. Get the corners of the matrix.
        let corners = self.matrixCornerPoints(bullsEyeCorners)

        if corners == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        return ZXAztecDetectorResult(bits: bits, points: corners, compact: self.compact, nbDatablocks: self.nbDataBlocks, nbLayers: self.nbLayers)
    }
    /**
 * Extracts the number of data layers and data blocks from the layer around the bull's eye
 */
    @objc
    func extractParameters(_ bullsEyeCorners: NSArray!) -> Bool {
        let p0: ZXResultPoint = bullsEyeCorners[0]
        let p1: ZXResultPoint = bullsEyeCorners[1]
        let p2: ZXResultPoint = bullsEyeCorners[2]
        let p3: ZXResultPoint = bullsEyeCorners[3]

        if !self.isValid(p0) || !self.isValid(p1) || !self.isValid(p2) || !self.isValid(p3) {
            return false
        }

        let length = 2 * self.nbCenterLayers
        // Get the bits around the bull's eye
        let sides: UnsafeMutablePointer<CInt>!
        // Right side
        // Bottom
        // Left side
        // Top
        // bullsEyeCorners[shift] is the corner of the bulls'eye that has three
        // orientation marks.
        // sides[shift] is the row/column that goes from the corner with three
        // orientation marks to the corner with two.
        let shift = self.rotationForSides(sides, length: length)

        if shift == 1 {
            return false
        }

        self.shift = shift

        // Flatten the parameter bits into a single 28- or 40-bit long
        var parameterData: CLong = 0
        var i: CInt = 0

        while i < 4 {
            defer {
                i += 1
            }

            let side: CInt = sides[(self.shift + i) % 4]

            if self.isCompact {
                // Each side of the form ..XXXXXXX. where Xs are parameter data
                parameterData <<= 7
                parameterData += (side >> 1) & 0x7f
            } else {
                // Each side of the form ..XXXXX.XXXXX. where Xs are parameter data
                parameterData <<= 10
                parameterData += ((side >> 2) & (0x1f << 5)) + ((side >> 1) & 0x1f)
            }
        }

        // Corrects parameter data using RS.  Returns just the data portion
        // without the error correction.
        let correctedData = self.correctedParameterData(parameterData, compact: self.isCompact)

        if correctedData == 1 {
            return false
        }

        if self.isCompact {
            // 8 bits:  2 bits layers and 6 bits data blocks
            self.nbLayers = (correctedData >> 6) + 1
            self.nbDataBlocks = (correctedData & 0x3f) + 1
        } else {
            // 16 bits:  5 bits layers and 11 bits data blocks
            self.nbLayers = (correctedData >> 11) + 1
            self.nbDataBlocks = (correctedData & 0x7ff) + 1
        }

        return true
    }
    @objc
    func rotationForSides(_ sides: UnsafePointer<CInt>!, length: CInt) -> CInt {
        // In a normal pattern, we expect to See
        //   **    .*             D       A
        //   *      *
        //
        //   .      *
        //   ..    ..             C       B
        //
        // Grab the 3 bits from each of the sides the form the locator pattern and concatenate
        // into a 12-bit integer.  Start with the bit at A
        var cornerBits: CInt = 0
        var i: CInt = 0

        while i < 4 {
            defer {
                i += 1
            }

            let side: CInt = sides[i]
            // XX......X where X's are orientation marks
            let t = ((side >> (length - 2)) << 1) + (side & 1)

            cornerBits = (cornerBits << 3) + t
        }

        // Mov the bottom bit to the top, so that the three bits of the locator pattern at A are
        // together.  cornerBits is now:
        //  3 orientation bits at A || 3 orientation bits at B || ... || 3 orientation bits at D
        cornerBits = ((cornerBits & 1) << 11) + (cornerBits >> 1)

        var shift: CInt = 0

        while shift < 4 {
            defer {
                shift += 1
            }

            if bitCount(cornerBits ^ expectedCornerBits[shift]) <= 2 {
                return shift
            }
        }

        return 1
    }
    /**
 * Corrects the parameter bits using Reed-Solomon algorithm.
 *
 * @param parameterData parameter bits
 * @param compact true if this is a compact Aztec code
 * @return -1 if the array contains too many errors
 */
    @objc
    func correctedParameterData(_ parameterData: CLong, compact: Bool) -> CInt {
        var numCodewords: CInt
        var numDataCodewords: CInt

        if compact {
            numCodewords = 7
            numDataCodewords = 2
        } else {
            numCodewords = 10
            numDataCodewords = 4
        }

        let numECCodewords = numCodewords - numDataCodewords
        let parameterWords = ZXIntArray(length: CUnsignedInt(numCodewords))
        var i = numCodewords - 1

        while i >= 0 {
            defer {
                i -= 1
            }

            parameterWords.array[i] = parameterData as? int32_t & 0xf
            parameterData >>= 4
        }

        let rsDecoder = ZXReedSolomonDecoder(field: ZXGenericGF.AztecParam())

        if !rsDecoder.decode(parameterWords, twoS: numECCodewords, error: nil) {
            return false
        }

        // Toss the error correction.  Just return the data as an integer
        var result: CInt = 0
        var i: CInt = 0

        while i < numDataCodewords {
            defer {
                i += 1
            }

            result = (result << 4) + parameterWords.array[i]
        }

        return result
    }
    /**
 * Finds the corners of a bull-eye centered on the passed point.
 * This returns the centers of the diagonal points just outside the bull's eye
 * Returns [topRight, bottomRight, bottomLeft, topLeft]
 *
 * @param pCenter Center point
 * @return The corners of the bull-eye, or nil if no valid bull-eye can be found
 */
    @objc
    func bullsEyeCorners(_ pCenter: ZXAztecPoint!) -> NSMutableArray? {
        var pina = pCenter
        var pinb = pCenter
        var pinc = pCenter
        var pind = pCenter
        var color = true

        self.nbCenterLayers = 1

        while self.nbCenterLayers < 9 {
            defer {
                self.nbCenterLayers += 1
            }

            let pouta = self.firstDifferent(pina, color: color, dx: 1, dy: 1)
            let poutb = self.firstDifferent(pinb, color: color, dx: 1, dy: 1)
            let poutc = self.firstDifferent(pinc, color: color, dx: 1, dy: 1)
            let poutd = self.firstDifferent(pind, color: color, dx: 1, dy: 1)

            //d      a
            //
            //c      b
            if self.nbCenterLayers > 2 {
                let q: CFloat = self.distance(poutd, b: pouta) * CFloat(self.nbCenterLayers) / (self.distance(pind, b: pina) * CFloat(self.nbCenterLayers + 2))

                if q < 0.75 || q > 1.25 || !self.isWhiteOrBlackRectangle(pouta, p2: poutb, p3: poutc, p4: poutd) {
                    break
                }
            }

            pina = pouta

            pinb = poutb

            pinc = poutc

            pind = poutd

            color = !color
        }

        if self.nbCenterLayers != 5 && self.nbCenterLayers != 7 {
            return nil
        }

        self.compact = self.nbCenterLayers == 5

        // Expand the square by .5 pixel in each direction so that we're on the border
        // between the white square and the black square
        let pinax = ZXResultPoint(x: (pina?.x ?? 0) + 0.5, y: (pina?.y ?? 0) - 0.5)
        let pinbx = ZXResultPoint(x: (pinb?.x ?? 0) + 0.5, y: (pinb?.y ?? 0) + 0.5)
        let pincx = ZXResultPoint(x: (pinc?.x ?? 0) - 0.5, y: (pinc?.y ?? 0) + 0.5)
        let pindx = ZXResultPoint(x: (pind?.x ?? 0) - 0.5, y: (pind?.y ?? 0) - 0.5)

        // Expand the square so that its corners are the centers of the points
        // just outside the bull's eye.
        return self.expandSquare([pinax, pinbx, pincx, pindx], oldSide: CFloat(2 * self.nbCenterLayers - 3), newSide: CFloat(2 * self.nbCenterLayers)).mutableCopy()
    }
    /**
 * Finds a candidate center point of an Aztec code from an image
 */
    @objc
    func matrixCenter() -> ZXAztecPoint? {
        var pointA: ZXResultPoint!
        var pointB: ZXResultPoint!
        var pointC: ZXResultPoint!
        var pointD: ZXResultPoint!
        var detector = ZXWhiteRectangleDetector(image: self.image, error: nil)
        var cornerPoints = detector.detectWithError(nil)

        if cornerPoints {
            pointA = cornerPoints[0]

            pointB = cornerPoints[1]

            pointC = cornerPoints[2]

            pointD = cornerPoints[3]
        } else {
            // This exception can be in case the initial rectangle is white
            // In that case, surely in the bull's eye, we try to expand the rectangle.
            var cx = (self.image.width ?? 0) / 2
            var cy = (self.image.height ?? 0) / 2

            pointA = self.firstDifferent(ZXAztecPoint(x: cx + 7, y: cy - 7), color: false, dx: 1, dy: 1).toResultPoint()

            pointB = self.firstDifferent(ZXAztecPoint(x: cx + 7, y: cy + 7), color: false, dx: 1, dy: 1).toResultPoint()

            pointC = self.firstDifferent(ZXAztecPoint(x: cx - 7, y: cy + 7), color: false, dx: 1, dy: 1).toResultPoint()

            pointD = self.firstDifferent(ZXAztecPoint(x: cx - 7, y: cy - 7), color: false, dx: 1, dy: 1).toResultPoint()
        }

        //Compute the center of the rectangle
        var cx = ZXMathUtils.round((pointA.x + pointD.x + pointB.x + pointC.x) / 4.0)
        var cy = ZXMathUtils.round((pointA.y + pointD.y + pointB.y + pointC.y) / 4.0)

        // Redetermine the white rectangle starting from previously computed center.
        // This will ensure that we end up with a white rectangle in center bull's eye
        // in order to compute a more accurate center.
        detector = ZXWhiteRectangleDetector(image: self.image, initSize: 15, x: cx, y: cy, error: nil)
        cornerPoints = detector.detectWithError(nil)

        if cornerPoints {
            pointA = cornerPoints[0]

            pointB = cornerPoints[1]

            pointC = cornerPoints[2]

            pointD = cornerPoints[3]
        } else {
            // This exception can be in case the initial rectangle is white
            // In that case we try to expand the rectangle.
            pointA = self.firstDifferent(ZXAztecPoint(x: cx + 7, y: cy - 7), color: false, dx: 1, dy: 1).toResultPoint()

            pointB = self.firstDifferent(ZXAztecPoint(x: cx + 7, y: cy + 7), color: false, dx: 1, dy: 1).toResultPoint()

            pointC = self.firstDifferent(ZXAztecPoint(x: cx - 7, y: cy + 7), color: false, dx: 1, dy: 1).toResultPoint()

            pointD = self.firstDifferent(ZXAztecPoint(x: cx - 7, y: cy - 7), color: false, dx: 1, dy: 1).toResultPoint()
        }

        cx = ZXMathUtils.round((pointA.x + pointD.x + pointB.x + pointC.x) / 4)
        cy = ZXMathUtils.round((pointA.y + pointD.y + pointB.y + pointC.y) / 4)

        // Recompute the center of the rectangle
        return ZXAztecPoint(x: cx, y: cy)
    }
    /**
 * Gets the Aztec code corners from the bull's eye corners and the parameters.
 *
 * @param bullsEyeCorners the array of bull's eye corners
 * @return the array of aztec code corners, or nil if the corner points do not fit in the image
 */
    @objc
    func matrixCornerPoints(_ bullsEyeCorners: NSArray!) -> NSArray? {
        return self.expandSquare(bullsEyeCorners, oldSide: CFloat(2 * self.nbCenterLayers), newSide: CFloat(self.dimension()))
    }
    /**
 * Creates a BitMatrix by sampling the provided image.
 * topLeft, topRight, bottomRight, and bottomLeft are the centers of the squares on the
 * diagonal just outside the bull's eye.
 */
    @objc
    func sampleGrid(_ anImage: ZXBitMatrix!, topLeft: ZXResultPoint!, topRight: ZXResultPoint!, bottomRight: ZXResultPoint!, bottomLeft: ZXResultPoint!) -> ZXBitMatrix {
        let sampler = ZXGridSampler.instance()
        let dimension = self.dimension()
        let low = dimension / 2.0 - self.nbCenterLayers
        let high = dimension / 2.0 + self.nbCenterLayers

        return sampler?.sampleGrid(anImage, dimensionX: dimension, dimensionY: dimension, p1ToX: low, p1ToY: low, p2ToX: high, p2ToY: low, p3ToX: high, p3ToY: high, p4ToX: low, p4ToY: high, p1FromX: topLeft.x, p1FromY: topLeft.y, p2FromX: topRight.x, p2FromY: topRight.y, p3FromX: bottomRight.x, p3FromY: bottomRight.y, p4FromX: bottomLeft.x, p4FromY: bottomLeft.y, error: nil)
    }
    /**
 * Samples a line.
 *
 * @param p1   start point (inclusive)
 * @param p2   end point (exclusive)
 * @param size number of bits
 * @return the array of bits as an int (first bit is high-order bit of result)
 */
    @objc
    func sampleLine(_ p1: ZXResultPoint!, p2: ZXResultPoint!, size: CInt) -> CInt {
        var result: CInt = 0
        let d = self.resultDistance(p1, b: p2)
        let moduleSize: CFloat = d / CFloat(size)
        let px = p1.x
        let py = p1.y
        let dx = moduleSize * (p2.x - p1.x) / d
        let dy = moduleSize * (p2.y - p1.y) / d
        var i: CInt = 0

        while i < size {
            defer {
                i += 1
            }

            if self.image.getX(ZXMathUtils.round(px + CFloat(i) * dx), y: ZXMathUtils.round(py + CFloat(i) * dy)) == true {
                result |= 1 << (size - i - 1)
            }
        }

        return result
    }
    /**
 * @return true if the border of the rectangle passed in parameter is compound of white points only
 *         or black points only
 */
    @objc
    func isWhiteOrBlackRectangle(_ p1: ZXAztecPoint!, p2: ZXAztecPoint!, p3: ZXAztecPoint!, p4: ZXAztecPoint!) -> Bool {
        let corr: CInt = 3

        p1 = ZXAztecPoint(x: p1.x - corr, y: p1.y + corr)

        p2 = ZXAztecPoint(x: p2.x - corr, y: p2.y - corr)

        p3 = ZXAztecPoint(x: p3.x + corr, y: p3.y - corr)

        p4 = ZXAztecPoint(x: p4.x + corr, y: p4.y + corr)

        let cInit = self.color(p4, p2: p1)

        if cInit == 0 {
            return false
        }

        var c = self.color(p1, p2: p2)

        if c != cInit {
            return false
        }

        c = self.color(p2, p2: p3)

        if c != cInit {
            return false
        }

        c = self.color(p3, p2: p4)

        return c == cInit
    }
    /**
 * Gets the color of a segment
 *
 * @return 1 if segment more than 90% black, -1 if segment is more than 90% white, 0 else
 */
    @objc
    func color(_ p1: ZXAztecPoint!, p2: ZXAztecPoint!) -> CInt {
        let d = self.distance(p1, b: p2)
        let dx: CFloat = CFloat(CFloat(p2.x - p1.x)) / d
        let dy: CFloat = CFloat(CFloat(p2.y - p1.y)) / d
        var error: CInt = 0
        var px: CFloat = CFloat(p1.x)
        var py: CFloat = CFloat(p1.y)
        let colorModel = self.image.getX(p1.x, y: p1.y) == true
        var i: CInt = 0

        while i < d {
            defer {
                i += 1
            }

            px += dx
            py += dy

            if self.image.getX(ZXMathUtils.round(px), y: ZXMathUtils.round(py)) != colorModel {
                error += 1
            }
        }

        let errRatio: CFloat = CFloat(error) / d

        if errRatio > 0.1 && errRatio < 0.9 {
            return 0
        }

        return ((errRatio <= 0.1) == colorModel) ? 1 : 1
    }
    /**
 * Gets the coordinate of the first point with a different color in the given direction
 */
    @objc
    func firstDifferent(_ init: ZXAztecPoint!, color: Bool, dx: CInt, dy: CInt) -> ZXAztecPoint? {
        var x = init.x + dx
        var y = init.y + dy

        while self.isValidX(x, y: y) && self.image.getX(x, y: y) == color {
            x += dx
            y += dy
        }

        x -= dx
        y -= dy

        while self.isValidX(x, y: y) && self.image.getX(x, y: y) == color {
            x += dx
        }

        x -= dx

        while self.isValidX(x, y: y) && self.image.getX(x, y: y) == color {
            y += dy
        }

        y -= dy

        return ZXAztecPoint(x: x, y: y)
    }
    /**
 * Expand the square represented by the corner points by pushing out equally in all directions
 *
 * @param cornerPoints the corners of the square, which has the bull's eye at its center
 * @param oldSide the original length of the side of the square in the target bit matrix
 * @param newSide the new length of the size of the square in the target bit matrix
 * @return the corners of the expanded square
 */
    @objc
    func expandSquare(_ cornerPoints: NSArray!, oldSide: CFloat, newSide: CFloat) -> NSArray? {
        let cornerPoints0 = cornerPoints[0] as? ZXResultPoint
        let cornerPoints1 = cornerPoints[1] as? ZXResultPoint
        let cornerPoints2 = cornerPoints[2] as? ZXResultPoint
        let cornerPoints3 = cornerPoints[3] as? ZXResultPoint
        let ratio = newSide / (2 * oldSide)
        var dx = (cornerPoints0?.x ?? 0.0) - (cornerPoints2?.x ?? 0.0)
        var dy = (cornerPoints0?.y ?? 0.0) - (cornerPoints2?.y ?? 0.0)
        var centerx = ((cornerPoints0?.x ?? 0.0) + (cornerPoints2?.x ?? 0.0)) / 2.0
        var centery = ((cornerPoints0?.y ?? 0.0) + (cornerPoints2?.y ?? 0.0)) / 2.0
        let result0 = ZXResultPoint(x: centerx + ratio * dx, y: centery + ratio * dy)
        let result2 = ZXResultPoint(x: centerx - ratio * dx, y: centery - ratio * dy)

        dx = (cornerPoints1?.x ?? 0.0) - (cornerPoints3?.x ?? 0.0)

        dy = (cornerPoints1?.y ?? 0.0) - (cornerPoints3?.y ?? 0.0)

        centerx = ((cornerPoints1?.x ?? 0.0) + (cornerPoints3?.x ?? 0.0)) / 2.0

        centery = ((cornerPoints1?.y ?? 0.0) + (cornerPoints3?.y ?? 0.0)) / 2.0

        let result1 = ZXResultPoint(x: centerx + ratio * dx, y: centery + ratio * dy)
        let result3 = ZXResultPoint(x: centerx - ratio * dx, y: centery - ratio * dy)

        return [result0, result1, result2, result3]
    }
    @objc
    func isValidX(_ x: CInt, y: CInt) -> Bool {
        return x >= 0 && x < (self.image.width ?? 0) && y > 0 && y < (self.image.height ?? 0)
    }
    @objc
    func isValid(_ point: ZXResultPoint!) -> Bool {
        let x = ZXMathUtils.round(point.x)
        let y = ZXMathUtils.round(point.y)

        return self.isValidX(x, y: y)
    }
    @objc
    func distance(_ a: ZXAztecPoint!, b: ZXAztecPoint!) -> CFloat {
        return ZXMathUtils.distance(CFloat(a.x), aY: CFloat(a.y), bX: CFloat(b.x), bY: CFloat(b.y))
    }
    @objc
    func resultDistance(_ a: ZXResultPoint!, b: ZXResultPoint!) -> CFloat {
        return ZXMathUtils.distance(a.x, aY: a.y, bX: b.x, bY: b.y)
    }
    @objc
    func dimension() -> CInt {
        if self.compact {
            return 4 * self.nbLayers + 11
        }

        if self.nbLayers <= 4 {
            return 4 * self.nbLayers + 15
        }

        return 4 * self.nbLayers + 2 * ((self.nbLayers - 4) / 8 + 1) + 15
    }
}

// MARK: -
@objc
extension ZXAztecDetector {
    @objc var image: ZXBitMatrix! {
        get {
            return self._image
        }
        set {
            self._image = newValue
        }
    }
}