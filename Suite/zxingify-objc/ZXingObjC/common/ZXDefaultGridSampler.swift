// Preprocessor directives found in file:
// #import "ZXGridSampler.h"
// #import "ZXBitMatrix.h"
// #import "ZXDefaultGridSampler.h"
// #import "ZXErrors.h"
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
class ZXDefaultGridSampler: ZXGridSampler {
    @objc
    func sampleGrid(_ image: ZXBitMatrix!, dimensionX: CInt, dimensionY: CInt, p1ToX: CFloat, p1ToY: CFloat, p2ToX: CFloat, p2ToY: CFloat, p3ToX: CFloat, p3ToY: CFloat, p4ToX: CFloat, p4ToY: CFloat, p1FromX: CFloat, p1FromY: CFloat, p2FromX: CFloat, p2FromY: CFloat, p3FromX: CFloat, p3FromY: CFloat, p4FromX: CFloat, p4FromY: CFloat, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        let transform = ZXPerspectiveTransform.quadrilateralToQuadrilateral(p1ToX, y0: p1ToY, x1: p2ToX, y1: p2ToY, x2: p3ToX, y2: p3ToY, x3: p4ToX, y3: p4ToY, x0p: p1FromX, y0p: p1FromY, x1p: p2FromX, y1p: p2FromY, x2p: p3FromX, y2p: p3FromY, x3p: p4FromX, y3p: p4FromY)

        return self.sampleGrid(image, dimensionX: dimensionX, dimensionY: dimensionY, transform: transform, error: error)
    }
    @objc
    func sampleGrid(_ image: ZXBitMatrix!, dimensionX: CInt, dimensionY: CInt, transform: ZXPerspectiveTransform!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        if dimensionX <= 0 || dimensionY <= 0 {
            if error != nil {
                error.pointee = ZXNotFoundErrorInstance()
            }

            return nil
        }

        let bits = ZXBitMatrix(width: dimensionX, height: dimensionY)
        let pointsLen = 2 * dimensionX
        var pointsf: UnsafeMutablePointer<CFloat>!

        memset(pointsf, 0, Int(pointsLen) * MemoryLayout<CFloat>.size)

        var y: CInt = 0

        while y < dimensionY {
            defer {
                y += 1
            }

            let max = dimensionX << 1
            let iValue: CFloat = CFloat(y) + 0.5
            var x: CInt = 0

            while x < max {
                defer {
                    x += 2
                }

                pointsf[x] = CFloat(x / 2) + 0.5
                pointsf[x + 1] = iValue
            }

            transform.transformPoints(pointsf, pointsLen: pointsLen)

            if !ZXGridSampler.checkAndNudgePoints(image, points: pointsf, pointsLen: pointsLen, error: error) {
                return nil
            }

            var x: CInt = 0

            while x < max {
                defer {
                    x += 2
                }

                let xx: CInt = CInt(pointsf[x])
                let yy: CInt = CInt(pointsf[x + 1])

                if xx < 0 || yy < 0 || xx >= image.width || yy >= image.height {
                    if error != nil {
                        error.pointee = ZXNotFoundErrorInstance()
                    }

                    return nil
                }

                if image.getX(xx, y: yy) {
                    bits.setX(x / 2, y: y)
                }
            }
        }

        return bits
    }
}