import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "ZXPerspectiveTransform.h"
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
 * This class implements a perspective transform in two dimensions. Given four source and four
 * destination points, it will compute the transformation implied between them. The code is based
 * directly upon section 3.4.2 of George Wolberg's "Digital Image Warping"; see pages 54-56.
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
 * This class implements a perspective transform in two dimensions. Given four source and four
 * destination points, it will compute the transformation implied between them. The code is based
 * directly upon section 3.4.2 of George Wolberg's "Digital Image Warping"; see pages 54-56.
 */
@objc
class ZXPerspectiveTransform: NSObject {
    private var _a11: CFloat = 0.0
    private var _a12: CFloat = 0.0
    private var _a13: CFloat = 0.0
    private var _a21: CFloat = 0.0
    private var _a22: CFloat = 0.0
    private var _a23: CFloat = 0.0
    private var _a31: CFloat = 0.0
    private var _a32: CFloat = 0.0
    private var _a33: CFloat = 0.0

    @objc
    init(a11: CFloat, a21: CFloat, a31: CFloat, a12: CFloat, a22: CFloat, a32: CFloat, a13: CFloat, a23: CFloat, a33: CFloat) {
        if self = super.init() {
            _a11 = a11

            _a12 = a12

            _a13 = a13

            _a21 = a21

            _a22 = a22

            _a23 = a23

            _a31 = a31

            _a32 = a32

            _a33 = a33
        }

        return self
    }

    @objc
    static func quadrilateralToQuadrilateral(_ x0: CFloat, y0: CFloat, x1: CFloat, y1: CFloat, x2: CFloat, y2: CFloat, x3: CFloat, y3: CFloat, x0p: CFloat, y0p: CFloat, x1p: CFloat, y1p: CFloat, x2p: CFloat, y2p: CFloat, x3p: CFloat, y3p: CFloat) -> ZXPerspectiveTransform? {
        let qToS = self.quadrilateralToSquare(x0, y0: y0, x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3)
        let sToQ = self.squareToQuadrilateral(x0p, y0: y0p, x1: x1p, y1: y1p, x2: x2p, y2: y2p, x3: x3p, y3: y3p)

        return sToQ.times(qToS)
    }
    @objc
    func transformPoints(_ points: UnsafeMutablePointer<CFloat>!, pointsLen: CInt) {
        let max = pointsLen
        var i: CInt = 0

        while i < max {
            defer {
                i += 2
            }

            let x: CFloat = points[i]
            let y: CFloat = points[i + 1]
            let denominator = self.a13 * x + self.a23 * y + self.a33

            points[i] = (self.a11 * x + self.a21 * y + self.a31) / denominator
            points[i + 1] = (self.a12 * x + self.a22 * y + self.a32) / denominator
        }
    }
    @objc
    func transformPoints(_ xValues: UnsafeMutablePointer<CFloat>!, yValues: UnsafeMutablePointer<CFloat>!, pointsLen: CInt) {
        let n = pointsLen
        var i: CInt = 0

        while i < n {
            defer {
                i += 1
            }

            let x: CFloat = xValues[i]
            let y: CFloat = yValues[i]
            let denominator = self.a13 * x + self.a23 * y + self.a33

            xValues[i] = (self.a11 * x + self.a21 * y + self.a31) / denominator
            yValues[i] = (self.a12 * x + self.a22 * y + self.a32) / denominator
        }
    }
    @objc
    static func squareToQuadrilateral(_ x0: CFloat, y0: CFloat, x1: CFloat, y1: CFloat, x2: CFloat, y2: CFloat, x3: CFloat, y3: CFloat) -> ZXPerspectiveTransform {
        let dx3 = x0 - x1 + x2 - x3
        let dy3 = y0 - y1 + y2 - y3

        if dx3 == 0.0 && dy3 == 0.0 {
            // Affine
            return ZXPerspectiveTransform(a11: x1 - x0, a21: x2 - x1, a31: x0, a12: y1 - y0, a22: y2 - y1, a32: y0, a13: 0.0, a23: 0.0, a33: 1.0)
        } else {
            let dx1 = x1 - x2
            let dx2 = x3 - x2
            let dy1 = y1 - y2
            let dy2 = y3 - y2
            let denominator = dx1 * dy2 - dx2 * dy1
            let a13 = (dx3 * dy2 - dx2 * dy3) / denominator
            let a23 = (dx1 * dy3 - dx3 * dy1) / denominator

            return ZXPerspectiveTransform(a11: x1 - x0 + a13 * x1, a21: x3 - x0 + a23 * x3, a31: x0, a12: y1 - y0 + a13 * y1, a22: y3 - y0 + a23 * y3, a32: y0, a13: a13, a23: a23, a33: 1.0)
        }
    }
    @objc
    static func quadrilateralToSquare(_ x0: CFloat, y0: CFloat, x1: CFloat, y1: CFloat, x2: CFloat, y2: CFloat, x3: CFloat, y3: CFloat) -> ZXPerspectiveTransform? {
        return self.squareToQuadrilateral(x0, y0: y0, x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3).buildAdjoint()
    }
    @objc
    func buildAdjoint() -> ZXPerspectiveTransform? {
        return ZXPerspectiveTransform(a11: self.a22 * self.a33 - self.a23 * self.a32, a21: self.a23 * self.a31 - self.a21 * self.a33, a31: self.a21 * self.a32 - self.a22 * self.a31, a12: self.a13 * self.a32 - self.a12 * self.a33, a22: self.a11 * self.a33 - self.a13 * self.a31, a32: self.a12 * self.a31 - self.a11 * self.a32, a13: self.a12 * self.a23 - self.a13 * self.a22, a23: self.a13 * self.a21 - self.a11 * self.a23, a33: self.a11 * self.a22 - self.a12 * self.a21)
    }
    @objc
    func times(_ other: ZXPerspectiveTransform!) -> ZXPerspectiveTransform? {
        return ZXPerspectiveTransform(a11: self.a11 * other.a11 + self.a21 * other.a12 + self.a31 * other.a13, a21: self.a11 * other.a21 + self.a21 * other.a22 + self.a31 * other.a23, a31: self.a11 * other.a31 + self.a21 * other.a32 + self.a31 * other.a33, a12: self.a12 * other.a11 + self.a22 * other.a12 + self.a32 * other.a13, a22: self.a12 * other.a21 + self.a22 * other.a22 + self.a32 * other.a23, a32: self.a12 * other.a31 + self.a22 * other.a32 + self.a32 * other.a33, a13: self.a13 * other.a11 + self.a23 * other.a12 + self.a33 * other.a13, a23: self.a13 * other.a21 + self.a23 * other.a22 + self.a33 * other.a23, a33: self.a13 * other.a31 + self.a23 * other.a32 + self.a33 * other.a33)
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
extension ZXPerspectiveTransform {
    @objc var a11: CFloat {
        return self._a11
    }
    @objc var a12: CFloat {
        return self._a12
    }
    @objc var a13: CFloat {
        return self._a13
    }
    @objc var a21: CFloat {
        return self._a21
    }
    @objc var a22: CFloat {
        return self._a22
    }
    @objc var a23: CFloat {
        return self._a23
    }
    @objc var a31: CFloat {
        return self._a31
    }
    @objc var a32: CFloat {
        return self._a32
    }
    @objc var a33: CFloat {
        return self._a33
    }
}