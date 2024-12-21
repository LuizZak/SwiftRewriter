// Preprocessor directives found in file:
// #import "ZXQRCodeFinderPatternFinder.h"
// #import "ZXBitMatrix.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXMultiFinderPatternFinder.h"
// #import "ZXQRCodeFinderPattern.h"
// #import "ZXQRCodeFinderPatternInfo.h"
let ZX_MAX_MODULE_COUNT_PER_EDGE: CFloat = 180
let ZX_MIN_MODULE_COUNT_PER_EDGE: CFloat = 9
let ZX_DIFF_MODSIZE_CUTOFF_PERCENT: CFloat = 0.05
let ZX_DIFF_MODSIZE_CUTOFF: CFloat = 0.5

/**
 * A comparator that orders FinderPatterns by their estimated module size.
 */
func moduleSizeCompare(_ center1: AnyObject!, _ center2: AnyObject!, _ context: UnsafeMutableRawPointer!) -> Int {
    let value = ((center2 as? ZXQRCodeFinderPattern)?.estimatedModuleSize ?? 0.0) - ((center1 as? ZXQRCodeFinderPattern)?.estimatedModuleSize ?? 0.0)

    return (value < 0.0) ? 1 : (value > 0.0) ? 1 : 0
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
/**
 * This class attempts to find finder patterns in a QR Code. Finder patterns are the square
 * markers at three corners of a QR Code.
 *
 * This class is thread-safe but not reentrant. Each thread must allocate its own object.
 *
 * In contrast to ZXFinderPatternFinder, this class will return an array of all possible
 * QR code locations in the image.
 *
 * Use the tryHarder hint to ask for a more thorough detection.
 */
@objc
class ZXMultiFinderPatternFinder: ZXQRCodeFinderPatternFinder {
    /**
 * Returns the 3 best `ZXFinderPattern`s from our list of candidates. The "best" are
 * those that have been detected at least ZXCENTER_QUORUM times, and whose module
 * size differs from the average among those patterns the least
 */
    @objc
    func selectBestPatternsWithError(_ error: UnsafeMutablePointer<Error?>!) -> NSArray? {
        let _possibleCenters: NSMutableArray! = NSMutableArray.arrayWithArray(self.possibleCenters())
        let size: UInt = UInt(_possibleCenters.count)

        if size < 3 {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        /*
   * Begin HE modifications to safely detect multiple codes of equal size
   */
        if size == 3 {
            return [[_possibleCenters[0], _possibleCenters[1], _possibleCenters[2]].mutableCopy()]
        }

        _possibleCenters.sortUsingFunction(moduleSizeCompare, context: nil)

        /*
   * Now lets start: build a list of tuples of three finder locations that
   *  - feature similar module sizes
   *  - are placed in a distance so the estimated module count is within the QR specification
   *  - have similar distance between upper left/right and left top/bottom finder patterns
   *  - form a triangle with 90° angle (checked by comparing top right/bottom left distance
   *    with pythagoras)
   *
   * Note: we allow each point to be used for more than one code region: this might seem
   * counterintuitive at first, but the performance penalty is not that big. At this point,
   * we cannot make a good quality decision whether the three finders actually represent
   * a QR code, or are just by chance layouted so it looks like there might be a QR code there.
   * So, if the layout seems right, lets have the decoder try to decode.
   */
        let results = NSMutableArray()
        var i1: CInt = 0

        while i1 < (size - 2) {
            defer {
                i1 += 1
            }

            let p1: ZXQRCodeFinderPattern! = self.possibleCenters[Int(i1)]

            if p1 == nil {
                continue
            }

            var i2 = i1 + 1

            while i2 < (size - 1) {
                defer {
                    i2 += 1
                }

                let p2: ZXQRCodeFinderPattern! = self.possibleCenters[Int(i2)]

                if p2 == nil {
                    continue
                }

                let vModSize12: CFloat = ((p1?.estimatedModuleSize ?? 0.0) - (p2?.estimatedModuleSize ?? 0.0)) / CFloat(min(p1?.estimatedModuleSize(), p2?.estimatedModuleSize()))
                let vModSize12A = fabsf((p1?.estimatedModuleSize ?? 0.0) - (p2?.estimatedModuleSize ?? 0.0))

                if vModSize12A > ZX_DIFF_MODSIZE_CUTOFF && vModSize12 >= ZX_DIFF_MODSIZE_CUTOFF_PERCENT {
                    break
                }

                var i3 = i2 + 1

                while i3 < size {
                    defer {
                        i3 += 1
                    }

                    let p3: ZXQRCodeFinderPattern! = self.possibleCenters[Int(i3)]

                    if p3 == nil {
                        continue
                    }

                    let vModSize23: CFloat = ((p2?.estimatedModuleSize ?? 0.0) - (p3?.estimatedModuleSize ?? 0.0)) / CFloat(min(p2?.estimatedModuleSize(), p3?.estimatedModuleSize()))
                    let vModSize23A = fabsf((p2?.estimatedModuleSize ?? 0.0) - (p3?.estimatedModuleSize ?? 0.0))

                    if vModSize23A > ZX_DIFF_MODSIZE_CUTOFF && vModSize23 >= ZX_DIFF_MODSIZE_CUTOFF_PERCENT {
                        break
                    }

                    let test: NSMutableArray! = NSMutableArray.arrayWithObjects(p1, p2, p3, nil)

                    ZXResultPoint.orderBestPatterns(test)

                    let info = ZXQRCodeFinderPatternInfo(patternCenters: test)
                    let dA = ZXResultPoint.distance(info.topLeft(), pattern2: info.bottomLeft())
                    let dC = ZXResultPoint.distance(info.topRight(), pattern2: info.bottomLeft())
                    let dB = ZXResultPoint.distance(info.topLeft(), pattern2: info.topRight())
                    let estimatedModuleCount = (dA + dB) / ((p1?.estimatedModuleSize ?? 0.0) * 2.0)

                    if estimatedModuleCount > ZX_MAX_MODULE_COUNT_PER_EDGE || estimatedModuleCount < ZX_MIN_MODULE_COUNT_PER_EDGE {
                        continue
                    }

                    let vABBC = fabsf((dA - dB) / min(dA, dB))

                    if vABBC >= 0.1 {
                        continue
                    }

                    let dCpy: CFloat = CFloat(sqrt(CGFloat(dA * dA + dB * dB)))
                    let vPyC = fabsf((dC - dCpy) / min(dC, dCpy))

                    if vPyC >= 0.1 {
                        continue
                    }

                    results.add(test)
                }
            }
        }

        if results.count > 0 {
            return results
        }

        if error {
            *error = ZXNotFoundErrorInstance()
        }

        return nil
    }
    @objc
    func findMulti(_ hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> NSArray {
        let tryHarder = hints != nil && hints.tryHarder
        let maxI = self.image.height ?? 0
        let maxJ = self.image.width ?? 0
        // We are looking for black/white/black/white/black modules in
        // 1:1:3:1:1 ratio; this tracks the number of such modules seen so far
        // Let's assume that the maximum version QR Code we support takes up 1/4 the height of the
        // image, and then account for the center being 3 modules in size. This gives the smallest
        // number of pixels the center could be, so skip this often. When trying harder, look for all
        // QR versions regardless of how dense they are.
        var iSkip = (3 * maxI) / (4 * ZX_FINDER_PATTERN_MAX_MODULES)

        if iSkip < ZX_FINDER_PATTERN_MIN_SKIP || tryHarder {
            iSkip = ZX_FINDER_PATTERN_MIN_SKIP
        }

        var stateCount: (CInt, CInt, CInt, CInt, CInt)
        var i = iSkip - 1

        while i < maxI {
            defer {
                i += iSkip
            }

            stateCount[0] = 0
            stateCount[1] = 0
            stateCount[2] = 0
            stateCount[3] = 0
            stateCount[4] = 0

            var currentState: CInt = 0
            var j: CInt = 0

            while j < maxJ {
                defer {
                    j += 1
                }

                if self.image.getX(j, y: i) == true {
                    if (currentState & 1) == 1 {
                        currentState += 1
                    }

                    stateCount[currentState] += 1
                } else if (currentState & 1) == 0 {
                    if currentState == 4 {
                        if ZXQRCodeFinderPatternFinder.foundPatternCross(stateCount) && self.handlePossibleCenter(stateCount, i: i, j: j) {
                            currentState = 0

                            stateCount[0] = 0
                            stateCount[1] = 0
                            stateCount[2] = 0
                            stateCount[3] = 0
                            stateCount[4] = 0
                        } else {
                            stateCount[0] = stateCount[2]
                            stateCount[1] = stateCount[3]
                            stateCount[2] = stateCount[4]
                            stateCount[3] = 1
                            stateCount[4] = 0

                            currentState = 3
                        }
                    } else {
                        stateCount[currentState += 1] += 1
                    }
                } else {
                    stateCount[currentState] += 1
                }
            }

            if ZXQRCodeFinderPatternFinder.foundPatternCross(stateCount) {
                self.handlePossibleCenter(stateCount, i: i, j: maxJ)
            }
        }

        let patternInfo = self.selectBestPatternsWithError(error)

        if patternInfo == nil {
            return nil
        }

        let result = NSMutableArray()

        for pattern in patternInfo {
            ZXResultPoint.orderBestPatterns(pattern)
            result.add(ZXQRCodeFinderPatternInfo(patternCenters: pattern))
        }

        return result
    }
}