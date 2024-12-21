// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXQRCodeAlignmentPattern.h"
// #import "ZXQRCodeAlignmentPatternFinder.h"
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
 * This class attempts to find alignment patterns in a QR Code. Alignment patterns look like finder
 * patterns but are smaller and appear at regular intervals throughout the image.
 *
 * At the moment this only looks for the bottom-right alignment pattern.
 *
 * This is mostly a simplified copy of ZXFinderPatternFinder. It is copied,
 * pasted and stripped down here for maximum performance but does unfortunately duplicate
 * some code.
 *
 * This class is thread-safe but not reentrant. Each thread must allocate its own object.
 */
@objc
class ZXQRCodeAlignmentPatternFinder: NSObject {
    private var _image: ZXBitMatrix!
    private var _possibleCenters: NSMutableArray!
    private var _startX: CInt = 0
    private var _startY: CInt = 0
    private var _width: CInt = 0
    private var _height: CInt = 0
    private var _moduleSize: CFloat = 0.0
    private var _crossCheckStateCount: ZXIntArray!
    private weak var _resultPointCallback: ZXResultPointCallback?

    @objc
    init(image: ZXBitMatrix!, startX: CInt, startY: CInt, width: CInt, height: CInt, moduleSize: CFloat, resultPointCallback: ZXResultPointCallback!) {
        if self = super.init() {
            _image = image

            _possibleCenters = NSMutableArray.arrayWithCapacity(5)

            _startX = startX

            _startY = startY

            _width = width

            _height = height

            _moduleSize = moduleSize

            _crossCheckStateCount = ZXIntArray(length: 3)

            _resultPointCallback = resultPointCallback
        }

        return self
    }

    /**
 * This method attempts to find the bottom-right alignment pattern in the image. It is a bit messy since
 * it's pretty performance-critical and so is written to be fast foremost.
 *
 * @return ZXAlignmentPattern if found or nil if not found
 */
    @objc
    func findWithError(_ error: UnsafeMutablePointer<Error?>!) -> ZXQRCodeAlignmentPattern? {
        let maxJ = self.startX + self.width
        let middleI = self.startY + (self.height / 2)
        var stateCount: (CInt, CInt, CInt)
        var iGen: CInt = 0

        while iGen < self.height {
            defer {
                iGen += 1
            }

            let i = middleI + (((iGen & 0x1) == 0) ? (iGen + 1) / 2 : -((iGen + 1) / 2))

            stateCount[0] = 0
            stateCount[1] = 0
            stateCount[2] = 0

            var j = self.startX

            while j < maxJ && (self.image.getX(j, y: i) != true) {
                j += 1
            }

            var currentState: CInt = 0

            while j < maxJ {
                if self.image.getX(j, y: i) == true {
                    if currentState == 1 {
                        stateCount[currentState] += 1
                    } else if currentState == 2 {
                        if self.foundPatternCross(stateCount) {
                            let confirmed = self.handlePossibleCenter(stateCount, i: i, j: j)

                            if confirmed != nil {
                                return confirmed
                            }
                        }

                        stateCount[0] = stateCount[2]
                        stateCount[1] = 1
                        stateCount[2] = 0

                        currentState = 1
                    } else {
                        stateCount[currentState += 1] += 1
                    }
                } else {
                    if currentState == 1 {
                        currentState += 1
                    }

                    stateCount[currentState] += 1
                }

                j += 1
            }

            if self.foundPatternCross(stateCount) {
                let confirmed = self.handlePossibleCenter(stateCount, i: i, j: maxJ)

                if confirmed != nil {
                    return confirmed
                }
            }
        }

        if (self.possibleCenters.count ?? 0) > 0 {
            return self.possibleCenters[0]
        }

        if error {
            *error = ZXNotFoundErrorInstance()
        }

        return nil
    }
    /**
 * Given a count of black/white/black pixels just seen and an end position,
 * figures the location of the center of this black/white/black run.
 */
    @objc
    func centerFromEnd(_ stateCount: UnsafeMutablePointer<CInt>!, end: CInt) -> CFloat {
        return CFloat(end - stateCount[2]) - stateCount[1] / 2.0
    }
    /**
 * @param stateCount count of black/white/black pixels just read
 * @return true iff the proportions of the counts is close enough to the 1/1/1 ratios
 *         used by alignment patterns to be considered a match
 */
    @objc
    func foundPatternCross(_ stateCount: UnsafeMutablePointer<CInt>!) -> Bool {
        let maxVariance = self.moduleSize / 2.0
        var i: CInt = 0

        while i < 3 {
            defer {
                i += 1
            }

            if fabsf(self.moduleSize - stateCount[i]) >= maxVariance {
                return false
            }
        }

        return true
    }
    /**
 * After a horizontal scan finds a potential alignment pattern, this method
 * "cross-checks" by scanning down vertically through the center of the possible
 * alignment pattern to see if the same proportion is detected.
 *
 * @param startI row where an alignment pattern was detected
 * @param centerJ center of the section that appears to cross an alignment pattern
 * @param maxCount maximum reasonable number of modules that should be
 * observed in any reading state, based on the results of the horizontal scan
 * @return vertical center of alignment pattern, or `NAN` if not found
 */
    @objc
    func crossCheckVertical(_ startI: CInt, centerJ: CInt, maxCount: CInt, originalStateCountTotal: CInt) -> CFloat {
        let maxI = self.image.height ?? 0

        self.crossCheckStateCount.clear()

        var stateCount = self.crossCheckStateCount.array
        var i = startI

        while i >= 0 && (self.image.getX(centerJ, y: i) == true) && stateCount?[1] <= maxCount {
            stateCount?[1] += 1
            i -= 1
        }

        if i < 0 || stateCount?[1] > maxCount {
            return NAN
        }

        while i >= 0 && (self.image.getX(centerJ, y: i) != true) && stateCount?[0] <= maxCount {
            stateCount?[0] += 1
            i -= 1
        }

        if stateCount?[0] > maxCount {
            return NAN
        }

        i = startI + 1

        while i < maxI && (self.image.getX(centerJ, y: i) == true) && stateCount?[1] <= maxCount {
            stateCount?[1] += 1
            i += 1
        }

        if i == maxI || stateCount?[1] > maxCount {
            return NAN
        }

        while i < maxI && (self.image.getX(centerJ, y: i) != true) && stateCount?[2] <= maxCount {
            stateCount?[2] += 1
            i += 1
        }

        if stateCount?[2] > maxCount {
            return NAN
        }

        let stateCountTotal: CInt = stateCount?[0] + stateCount?[1] + stateCount?[2]

        if 5 * abs(stateCountTotal - originalStateCountTotal) >= 2 * originalStateCountTotal {
            return NAN
        }

        return self.foundPatternCross(stateCount) ? self.centerFromEnd(stateCount, end: i) : NAN
    }
    /**
 * This is called when a horizontal scan finds a possible alignment pattern. It will
 * cross check with a vertical scan, and if successful, will see if this pattern had been
 * found on a previous horizontal scan. If so, we consider it confirmed and conclude we have
 * found the alignment pattern.
 *
 * @param stateCount reading state module counts from horizontal scan
 * @param i row where alignment pattern may be found
 * @param j end of possible alignment pattern in row
 * @return ZXAlignmentPattern if we have found the same pattern twice, or null if not
 */
    @objc
    func handlePossibleCenter(_ stateCount: UnsafeMutablePointer<CInt>!, i: CInt, j: CInt) -> ZXQRCodeAlignmentPattern? {
        let stateCountTotal: CInt = stateCount[0] + stateCount[1] + stateCount[2]
        let centerJ = self.centerFromEnd(stateCount, end: j)
        let centerI = self.crossCheckVertical(i, centerJ: CInt(centerJ), maxCount: 2 * stateCount[1], originalStateCountTotal: stateCountTotal)

        if !isnan(centerI) {
            let estimatedModuleSize: CFloat = CFloat(stateCount[0] + stateCount[1] + stateCount[2]) / 3.0
            let max: CInt = CInt(self.possibleCenters.count ?? 0)
            var index: CInt = 0

            while index < max {
                defer {
                    index += 1
                }

                let center: ZXQRCodeAlignmentPattern! = self.possibleCenters[Int(index)]

                // Look for about the same center and module size:
                if center?.aboutEquals(estimatedModuleSize, i: centerI, j: centerJ) == true {
                    return center?.combineEstimateI(centerI, j: centerJ, newModuleSize: estimatedModuleSize)
                }
            }

            // Hadn't found this before; save it
            let point = ZXQRCodeAlignmentPattern(posX: centerJ, posY: centerI, estimatedModuleSize: estimatedModuleSize)

            self.possibleCenters.add(point)

            if self.resultPointCallback != nil {
                self.resultPointCallback?.foundPossibleResultPoint(point)
            }
        }

        return nil
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
extension ZXQRCodeAlignmentPatternFinder {
    @objc var image: ZXBitMatrix! {
        return self._image
    }
    @objc var possibleCenters: NSMutableArray! {
        return self._possibleCenters
    }
    @objc var startX: CInt {
        return self._startX
    }
    @objc var startY: CInt {
        return self._startY
    }
    @objc var width: CInt {
        return self._width
    }
    @objc var height: CInt {
        return self._height
    }
    @objc var moduleSize: CFloat {
        return self._moduleSize
    }
    @objc var crossCheckStateCount: ZXIntArray! {
        return self._crossCheckStateCount
    }
    @objc weak var resultPointCallback: ZXResultPointCallback? {
        return self._resultPointCallback
    }
}