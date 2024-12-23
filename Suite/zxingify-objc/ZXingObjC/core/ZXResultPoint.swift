import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXMathUtils.h"
// #import "ZXResultPoint.h"
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
 * Encapsulates a point of interest in an image containing a barcode. Typically, this
 * would be the location of a finder pattern or the corner of the barcode, for example.
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
 * Encapsulates a point of interest in an image containing a barcode. Typically, this
 * would be the location of a finder pattern or the corner of the barcode, for example.
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
class ZXResultPoint: NSObject, NSCopying {
    private var _x: CFloat = 0.0
    private var _y: CFloat = 0.0
    @objc var x: CFloat {
        return self._x
    }
    @objc var y: CFloat {
        return self._y
    }

    @objc
    init(x: CFloat, y: CFloat) {
        if self = super.init() {
            _x = x
            _y = y
        }

        return self
    }

    @objc
    static func resultPointWithX(_ x: CFloat, y: CFloat) -> AnyObject? {
        return self.init(x: x, y: y)
    }
    @objc
    func copyWithZone(_ zone: UnsafeMutablePointer<NSZone>!) -> AnyObject? {
        return ZXResultPoint.allocWithZone(zone).init(x: self.x, y: self.y)
    }
    @objc
    func isEqual(_ other: AnyObject) -> Bool {
        if other.isKindOfClass(ZXResultPoint.self) {
            let otherPoint = other as? ZXResultPoint

            return self.x == otherPoint?.x && self.y == otherPoint?.y
        }

        return false
    }
    @objc
    func hash() -> UInt {
        return 31 * ((&_x) as? UnsafeMutablePointer<CInt>).pointee + ((&_y) as? UnsafeMutablePointer<CInt>).pointee
    }
    @objc
    func description() -> String? {
        return String(format: "(%f,%f)", self.x, self.y)
    }
    /**
 * Orders an array of three ResultPoints in an order [A,B,C] such that AB is less than AC
 * and BC is less than AC, and the angle between BC and BA is less than 180 degrees.
 *
 * @param patterns array of three ZXResultPoints to order
 */
    /**
 * Orders an array of three ResultPoints in an order [A,B,C] such that AB is less than AC
 * and BC is less than AC, and the angle between BC and BA is less than 180 degrees.
 *
 * @param patterns array of three ZXResultPoints to order
 */
    @objc
    static func orderBestPatterns(_ patterns: NSMutableArray!) {
        let zeroOneDistance = self.distance(patterns[0], pattern2: patterns[1])
        let oneTwoDistance = self.distance(patterns[1], pattern2: patterns[2])
        let zeroTwoDistance = self.distance(patterns[0], pattern2: patterns[2])
        var pointA: ZXResultPoint!
        var pointB: ZXResultPoint!
        var pointC: ZXResultPoint!

        if oneTwoDistance >= zeroOneDistance && oneTwoDistance >= zeroTwoDistance {
            pointB = patterns[0]
            pointA = patterns[1]
            pointC = patterns[2]
        } else if zeroTwoDistance >= oneTwoDistance && zeroTwoDistance >= zeroOneDistance {
            pointB = patterns[1]
            pointA = patterns[0]
            pointC = patterns[2]
        } else {
            pointB = patterns[2]
            pointA = patterns[0]
            pointC = patterns[1]
        }

        if self.crossProductZ(pointA, pointB: pointB, pointC: pointC) < 0.0 {
            let temp = pointA

            pointA = pointC
            pointC = temp
        }

        patterns[0] = pointA
        patterns[1] = pointB
        patterns[2] = pointC
    }
    /**
 * @param pattern1 first pattern
 * @param pattern2 second pattern
 * @return distance between two points
 */
    /**
 * @param pattern1 first pattern
 * @param pattern2 second pattern
 * @return distance between two points
 */
    @objc
    static func distance(_ pattern1: ZXResultPoint!, pattern2: ZXResultPoint!) -> CFloat {
        return ZXMathUtils.distance(pattern1.x, aY: pattern1.y, bX: pattern2.x, bY: pattern2.y)
    }
    /**
 * Returns the z component of the cross product between vectors BC and BA.
 */
    @objc
    static func crossProductZ(_ pointA: ZXResultPoint!, pointB: ZXResultPoint!, pointC: ZXResultPoint!) -> CFloat {
        let bX = pointB.x
        let bY = pointB.y

        return ((pointC.x - bX) * (pointA.y - bY)) - ((pointC.y - bY) * (pointA.x - bX))
    }
}