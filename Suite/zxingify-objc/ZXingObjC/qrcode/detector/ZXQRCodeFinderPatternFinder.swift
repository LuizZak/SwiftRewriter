// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXQRCodeFinderPattern.h"
// #import "ZXQRCodeFinderPatternInfo.h"
// #import "ZXQRCodeFinderPatternFinder.h"
// #import "ZXResultPoint.h"
// #import "ZXResultPointCallback.h"
let ZX_CENTER_QUORUM: CInt = 2
let ZX_FINDER_PATTERN_MIN_SKIP: CInt = 3
let ZX_FINDER_PATTERN_MAX_MODULES: CInt = 97

/**
 * Orders by ZXFinderPattern count, descending.
 */
func centerCompare(_ center1: AnyObject!, _ center2: AnyObject!, _ context: UnsafeMutableRawPointer!) -> Int {
    let average: CFloat = (context as? NSNumber)?.floatValue()

    if (center2 as? ZXQRCodeFinderPattern)?.count == (center1 as? ZXQRCodeFinderPattern)?.count {
        let dA = fabsf(((center2 as? ZXQRCodeFinderPattern)?.estimatedModuleSize ?? 0.0) - average)
        let dB = fabsf(((center1 as? ZXQRCodeFinderPattern)?.estimatedModuleSize ?? 0.0) - average)

        return (dA < dB) ? 1 : (dA == dB) ? 0 : 1
    } else {
        return Int(((center2 as? ZXQRCodeFinderPattern)?.count ?? 0) - ((center1 as? ZXQRCodeFinderPattern)?.count ?? 0))
    }
}
/**
 * Orders by furthest from average
 */
func furthestFromAverageCompare(_ center1: AnyObject!, _ center2: AnyObject!, _ context: UnsafeMutableRawPointer!) -> Int {
    let average: CFloat = (context as? NSNumber)?.floatValue()
    let dA = fabsf(((center2 as? ZXQRCodeFinderPattern)?.estimatedModuleSize ?? 0.0) - average)
    let dB = fabsf(((center1 as? ZXQRCodeFinderPattern)?.estimatedModuleSize ?? 0.0) - average)

    return (dA < dB) ? 1 : (dA == dB) ? 0 : 1
}

/**
 * This class attempts to find finder patterns in a QR Code. Finder patterns are the square
 * markers at three corners of a QR Code.
 *
 * This class is thread-safe but not reentrant. Each thread must allocate its own object.
 */
/**
 * This class attempts to find finder patterns in a QR Code. Finder patterns are the square
 * markers at three corners of a QR Code.
 *
 * This class is thread-safe but not reentrant. Each thread must allocate its own object.
 */
@objc
class ZXQRCodeFinderPatternFinder: NSObject {
    private weak var _resultPointCallback: ZXResultPointCallback?
    private var _possibleCenters: NSMutableArray!
    private var _image: ZXBitMatrix!
    @objc var image: ZXBitMatrix! {
        return self._image
    }
    @objc var possibleCenters: NSMutableArray! {
        return self._possibleCenters
    }
    @objc var hasSkipped: Bool = false

    @objc
    init(image: ZXBitMatrix!) {
        return self.init(image: image, resultPointCallback: nil)
    }
    @objc
    init(image: ZXBitMatrix!, resultPointCallback: ZXResultPointCallback!) {
        if self = super.init() {
            _image = image
            _possibleCenters = NSMutableArray()
            _resultPointCallback = resultPointCallback
        }

        return self
    }

    @objc
    func find(_ hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXQRCodeFinderPatternInfo? {
        let tryHarder = hints != nil && hints.tryHarder
        let maxI = self.image.height ?? 0
        let maxJ = self.image.width ?? 0
        var iSkip = (3 * maxI) / (4 * ZX_FINDER_PATTERN_MAX_MODULES)

        if iSkip < ZX_FINDER_PATTERN_MIN_SKIP || tryHarder {
            iSkip = ZX_FINDER_PATTERN_MIN_SKIP
        }

        var done = false
        var stateCount: (CInt, CInt, CInt, CInt, CInt)
        var i = iSkip - 1

        while i < maxI && !done {
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
                        if ZXQRCodeFinderPatternFinder.foundPatternCross(stateCount) {
                            let confirmed = self.handlePossibleCenter(stateCount, i: i, j: j)

                            if confirmed {
                                iSkip = 2

                                if self.hasSkipped {
                                    done = self.haveMultiplyConfirmedCenters()
                                } else {
                                    let rowSkip = self.findRowSkip()

                                    if rowSkip > stateCount[2] {
                                        i += rowSkip - stateCount[2] - iSkip
                                        j = maxJ - 1
                                    }
                                }
                            } else {
                                stateCount[0] = stateCount[2]
                                stateCount[1] = stateCount[3]
                                stateCount[2] = stateCount[4]
                                stateCount[3] = 1
                                stateCount[4] = 0

                                currentState = 3

                                continue
                            }

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
                let confirmed = self.handlePossibleCenter(stateCount, i: i, j: maxJ)

                if confirmed {
                    iSkip = stateCount[0]

                    if self.hasSkipped {
                        done = self.haveMultiplyConfirmedCenters()
                    }
                }
            }
        }

        let patternInfo = self.selectBestPatterns()

        if patternInfo == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        ZXResultPoint.orderBestPatterns(patternInfo)

        return ZXQRCodeFinderPatternInfo(patternCenters: patternInfo)
    }
    /**
 * Given a count of black/white/black/white/black pixels just seen and an end position,
 * figures the location of the center of this run.
 */
    @objc
    func centerFromEnd(_ stateCount: UnsafePointer<CInt>!, end: CInt) -> CFloat {
        return CFloat(end - stateCount[4] - stateCount[3]) - stateCount[2] / 2.0
    }
    /**
 * @param stateCount count of black/white/black/white/black pixels just read
 * @return true iff the proportions of the counts is close enough to the 1/1/3/1/1 ratios
 *         used by finder patterns to be considered a match
 */
    /**
 * @param stateCount count of black/white/black/white/black pixels just read
 * @return true iff the proportions of the counts is close enough to the 1/1/3/1/1 ratios
 *         used by finder patterns to be considered a match
 */
    /**
 * @param stateCount count of black/white/black/white/black pixels just read
 * @return true iff the proportions of the counts is close enough to the 1/1/3/1/1 ratios
 *         used by finder patterns to be considered a match
 */
    @objc
    static func foundPatternCross(_ stateCount: UnsafePointer<CInt>!) -> Bool {
        var totalModuleSize: CInt = 0
        var i: CInt = 0

        while i < 5 {
            defer {
                i += 1
            }

            let count: CInt = stateCount[i]

            if count == 0 {
                return false
            }

            totalModuleSize += count
        }

        if totalModuleSize < 7 {
            return false
        }

        let moduleSize = totalModuleSize / 7.0
        let maxVariance = moduleSize / 2.0

        // Allow less than 50% variance from 1-1-3-1-1 proportions
        return ABS(moduleSize - stateCount[0]) < maxVariance && ABS(moduleSize - stateCount[1]) < maxVariance && ABS(3.0 * moduleSize - stateCount[2]) < 3 * maxVariance && ABS(moduleSize - stateCount[3]) < maxVariance && ABS(moduleSize - stateCount[4]) < maxVariance
    }
    /**
 * @param stateCount count of black/white/black/white/black pixels just read
 * @return true iff the proportions of the counts is close enough to the 1/1/3/1/1 ratios
 *         used by finder patterns to be considered a match
 */
    @objc
    static func foundPatternDiagonal(_ stateCount: UnsafePointer<CInt>!) -> Bool {
        var totalModuleSize: CInt = 0
        var i: CInt = 0

        while i < 5 {
            defer {
                i += 1
            }

            let count: CInt = stateCount[i]

            if count == 0 {
                return false
            }

            totalModuleSize += count
        }

        if totalModuleSize < 7 {
            return false
        }

        let moduleSize = totalModuleSize / 7.0
        let maxVariance = moduleSize / 1.333

        // Allow less than 75% variance from 1-1-3-1-1 proportions
        return ABS(moduleSize - stateCount[0]) < maxVariance && ABS(moduleSize - stateCount[1]) < maxVariance && ABS(3.0 * moduleSize - stateCount[2]) < 3 * maxVariance && ABS(moduleSize - stateCount[3]) < maxVariance && ABS(moduleSize - stateCount[4]) < maxVariance
    }
    /**
 * After a vertical and horizontal scan finds a potential finder pattern, this method
 * "cross-cross-cross-checks" by scanning down diagonally through the center of the possible
 * finder pattern to see if the same proportion is detected.
 *
 * @param centerI row where a finder pattern was detected
 * @param centerJ center of the section that appears to cross a finder pattern
 * @return true if proportions are withing expected limits
 */
    @objc
    func crossCheckDiagonal(_ centerI: CInt, centerJ: CInt) -> Bool {
        var stateCount: (CInt, CInt, CInt, CInt, CInt)
        // Start counting up, left from center finding black center mass
        var i: CInt = 0

        while centerI >= i && centerJ >= i && (self.image.getX(centerJ - i, y: centerI - i) == true) {
            stateCount[2] += 1
            i += 1
        }

        if stateCount[2] == 0 {
            return false
        }

        // Continue up, left finding white space
        while centerI >= i && centerJ >= i && (self.image.getX(centerJ - i, y: centerI - i) != true) {
            stateCount[1] += 1
            i += 1
        }

        if stateCount[1] == 0 {
            return false
        }

        // Continue up, left finding black border
        while centerI >= i && centerJ >= i && (self.image.getX(centerJ - i, y: centerI - i) == true) {
            stateCount[0] += 1
            i += 1
        }

        if stateCount[0] == 0 {
            return false
        }

        let maxI = self.image.height ?? 0
        let maxJ = self.image.width ?? 0

        // Now also count down, right from center
        i = 1

        while centerI + i < maxI && centerJ + i < maxJ && (self.image.getX(centerJ + i, y: centerI + i) == true) {
            stateCount[2] += 1
            i += 1
        }

        while centerI + i < maxI && centerJ + i < maxJ && (self.image.getX(centerJ + i, y: centerI + i) != true) {
            stateCount[3] += 1
            i += 1
        }

        if stateCount[3] == 0 {
            return false
        }

        while centerI + i < maxI && centerJ + i < maxJ && (self.image.getX(centerJ + i, y: centerI + i) == true) {
            stateCount[4] += 1
            i += 1
        }

        if stateCount[4] == 0 {
            return false
        }

        return ZXQRCodeFinderPatternFinder.foundPatternDiagonal(stateCount)
    }
    /**
 * After a horizontal scan finds a potential finder pattern, this method
 * "cross-checks" by scanning down vertically through the center of the possible
 * finder pattern to see if the same proportion is detected.
 *
 * @param startI row where a finder pattern was detected
 * @param centerJ center of the section that appears to cross a finder pattern
 * @param maxCount maximum reasonable number of modules that should be
 * observed in any reading state, based on the results of the horizontal scan
 * @return vertical center of finder pattern, or `NAN` if not found
 */
    @objc
    func crossCheckVertical(_ startI: CInt, centerJ: CInt, maxCount: CInt, originalStateCountTotal: CInt) -> CFloat {
        let maxI = self.image.height ?? 0
        var stateCount: (CInt, CInt, CInt, CInt, CInt)
        var i = startI

        while i >= 0 && (self.image.getX(centerJ, y: i) == true) {
            stateCount[2] += 1
            i -= 1
        }

        if i < 0 {
            return NAN
        }

        while i >= 0 && (self.image.getX(centerJ, y: i) != true) && stateCount[1] <= maxCount {
            stateCount[1] += 1
            i -= 1
        }

        if i < 0 || stateCount[1] > maxCount {
            return NAN
        }

        while i >= 0 && (self.image.getX(centerJ, y: i) == true) && stateCount[0] <= maxCount {
            stateCount[0] += 1
            i -= 1
        }

        if stateCount[0] > maxCount {
            return NAN
        }

        i = startI + 1

        while i < maxI && (self.image.getX(centerJ, y: i) == true) {
            stateCount[2] += 1
            i += 1
        }

        if i == maxI {
            return NAN
        }

        while i < maxI && (self.image.getX(centerJ, y: i) != true) && stateCount[3] < maxCount {
            stateCount[3] += 1
            i += 1
        }

        if i == maxI || stateCount[3] >= maxCount {
            return NAN
        }

        while i < maxI && (self.image.getX(centerJ, y: i) == true) && stateCount[4] < maxCount {
            stateCount[4] += 1
            i += 1
        }

        if stateCount[4] >= maxCount {
            return NAN
        }

        let stateCountTotal: CInt = stateCount[0] + stateCount[1] + stateCount[2] + stateCount[3] + stateCount[4]

        if 5 * abs(stateCountTotal - originalStateCountTotal) >= 2 * originalStateCountTotal {
            return NAN
        }

        return ZXQRCodeFinderPatternFinder.foundPatternCross(stateCount) ? self.centerFromEnd(stateCount, end: i) : NAN
    }
    /**
 * Like crossCheckVertical, and in fact is basically identical,
 * except it reads horizontally instead of vertically. This is used to cross-cross
 * check a vertical cross check and locate the real center of the alignment pattern.
 */
    @objc
    func crossCheckHorizontal(_ startJ: CInt, centerI: CInt, maxCount: CInt, originalStateCountTotal: CInt) -> CFloat {
        let maxJ = self.image.width ?? 0
        var stateCount: (CInt, CInt, CInt, CInt, CInt)
        var j = startJ

        while j >= 0 && (self.image.getX(j, y: centerI) == true) {
            stateCount[2] += 1
            j -= 1
        }

        if j < 0 {
            return NAN
        }

        while j >= 0 && (self.image.getX(j, y: centerI) != true) && stateCount[1] <= maxCount {
            stateCount[1] += 1
            j -= 1
        }

        if j < 0 || stateCount[1] > maxCount {
            return NAN
        }

        while j >= 0 && (self.image.getX(j, y: centerI) == true) && stateCount[0] <= maxCount {
            stateCount[0] += 1
            j -= 1
        }

        if stateCount[0] > maxCount {
            return NAN
        }

        j = startJ + 1

        while j < maxJ && (self.image.getX(j, y: centerI) == true) {
            stateCount[2] += 1
            j += 1
        }

        if j == maxJ {
            return NAN
        }

        while j < maxJ && (self.image.getX(j, y: centerI) != true) && stateCount[3] < maxCount {
            stateCount[3] += 1
            j += 1
        }

        if j == maxJ || stateCount[3] >= maxCount {
            return NAN
        }

        while j < maxJ && (self.image.getX(j, y: centerI) == true) && stateCount[4] < maxCount {
            stateCount[4] += 1
            j += 1
        }

        if stateCount[4] >= maxCount {
            return NAN
        }

        let stateCountTotal: CInt = stateCount[0] + stateCount[1] + stateCount[2] + stateCount[3] + stateCount[4]

        if 5 * abs(stateCountTotal - originalStateCountTotal) >= originalStateCountTotal {
            return NAN
        }

        return ZXQRCodeFinderPatternFinder.foundPatternCross(stateCount) ? self.centerFromEnd(stateCount, end: j) : NAN
    }
    /**
 * This is called when a horizontal scan finds a possible alignment pattern. It will
 * cross check with a vertical scan, and if successful, will, ah, cross-cross-check
 * with another horizontal scan. This is needed primarily to locate the real horizontal
 * center of the pattern in cases of extreme skew.
 * And then we cross-cross-cross check with another diagonal scan.
 *
 * If that succeeds the finder pattern location is added to a list that tracks
 * the number of times each location has been nearly-matched as a finder pattern.
 * Each additional find is more evidence that the location is in fact a finder
 * pattern center
 *
 * @param stateCount reading state module counts from horizontal scan
 * @param i row where finder pattern may be found
 * @param j end of possible finder pattern in row
 * @return true if a finder pattern candidate was found this time
 */
    /**
 * This is called when a horizontal scan finds a possible alignment pattern. It will
 * cross check with a vertical scan, and if successful, will, ah, cross-cross-check
 * with another horizontal scan. This is needed primarily to locate the real horizontal
 * center of the pattern in cases of extreme skew.
 * And then we cross-cross-cross check with another diagonal scan.
 *
 * If that succeeds the finder pattern location is added to a list that tracks
 * the number of times each location has been nearly-matched as a finder pattern.
 * Each additional find is more evidence that the location is in fact a finder
 * pattern center
 *
 * @param stateCount reading state module counts from horizontal scan
 * @param i row where finder pattern may be found
 * @param j end of possible finder pattern in row
 * @return true if a finder pattern candidate was found this time
 */
    @objc
    func handlePossibleCenter(_ stateCount: UnsafePointer<CInt>!, i: CInt, j: CInt) -> Bool {
        let stateCountTotal: CInt = stateCount[0] + stateCount[1] + stateCount[2] + stateCount[3] + stateCount[4]
        var centerJ = self.centerFromEnd(stateCount, end: j)
        let centerI = self.crossCheckVertical(i, centerJ: CInt(centerJ), maxCount: stateCount[2], originalStateCountTotal: stateCountTotal)

        if !isnan(centerI) {
            centerJ = self.crossCheckHorizontal(CInt(centerJ), centerI: CInt(centerI), maxCount: stateCount[2], originalStateCountTotal: stateCountTotal)

            if !isnan(centerJ) && self.crossCheckDiagonal(CInt(centerI), centerJ: CInt(centerJ)) {
                let estimatedModuleSize: CFloat = CFloat(stateCountTotal) / 7.0
                var found = false
                let max: CInt = CInt(self.possibleCenters.count ?? 0)
                var index: CInt = 0

                while index < max {
                    defer {
                        index += 1
                    }

                    let center: ZXQRCodeFinderPattern! = self.possibleCenters[Int(index)]

                    if center?.aboutEquals(estimatedModuleSize, i: centerI, j: centerJ) == true {
                        self.possibleCenters[Int(index)] = center?.combineEstimateI(centerI, j: centerJ, newModuleSize: estimatedModuleSize)
                        found = true

                        break
                    }
                }

                if !found {
                    let point = ZXQRCodeFinderPattern(posX: centerJ, posY: centerI, estimatedModuleSize: estimatedModuleSize)

                    self.possibleCenters.add(point)

                    if self.resultPointCallback != nil {
                        self.resultPointCallback?.foundPossibleResultPoint(point)
                    }
                }

                return true
            }
        }

        return false
    }
    /**
 * @return number of rows we could safely skip during scanning, based on the first
 *         two finder patterns that have been located. In some cases their position will
 *         allow us to infer that the third pattern must lie below a certain point farther
 *         down in the image.
 */
    @objc
    func findRowSkip() -> CInt {
        let max: CInt = CInt(self.possibleCenters.count ?? 0)

        if max <= 1 {
            return 0
        }

        var firstConfirmedCenter: ZXResultPoint! = nil
        var i: CInt = 0

        while i < max {
            defer {
                i += 1
            }

            let center: ZXQRCodeFinderPattern! = self.possibleCenters[Int(i)]

            if (center?.count ?? 0) >= ZX_CENTER_QUORUM {
                if firstConfirmedCenter == nil {
                    firstConfirmedCenter = center
                } else {
                    self.hasSkipped = true

                    return CInt(fabsf((firstConfirmedCenter?.x ?? 0.0) - (center?.x ?? 0.0)) - fabsf((firstConfirmedCenter?.y ?? 0.0) - (center?.y ?? 0.0))) / 2
                }
            }
        }

        return 0
    }
    /**
 * @return true iff we have found at least 3 finder patterns that have been detected
 *         at least ZX_CENTER_QUORUM times each, and, the estimated module size of the
 *         candidates is "pretty similar"
 */
    @objc
    func haveMultiplyConfirmedCenters() -> Bool {
        var confirmedCount: CInt = 0
        var totalModuleSize: CFloat = 0.0
        let max: CInt = CInt(self.possibleCenters.count ?? 0)
        var i: CInt = 0

        while i < max {
            defer {
                i += 1
            }

            let pattern: ZXQRCodeFinderPattern! = self.possibleCenters[Int(i)]

            if (pattern?.count ?? 0) >= ZX_CENTER_QUORUM {
                confirmedCount += 1
                totalModuleSize += (pattern?.estimatedModuleSize ?? 0.0)
            }
        }

        if confirmedCount < 3 {
            return false
        }

        let average: CFloat = totalModuleSize / CFloat(max)
        var totalDeviation: CFloat = 0.0
        var i: CInt = 0

        while i < max {
            defer {
                i += 1
            }

            let pattern: ZXQRCodeFinderPattern! = self.possibleCenters[Int(i)]

            totalDeviation += fabsf((pattern?.estimatedModuleSize ?? 0.0) - average)
        }

        return totalDeviation <= 0.05 * totalModuleSize
    }
    /**
 * @return the 3 best ZXFinderPatterns from our list of candidates. The "best" are
 *         those that have been detected at least ZXCENTER_QUORUM times, and whose module
 *         size differs from the average among those patterns the least
 * @return nil if 3 such finder patterns do not exist
 */
    @objc
    func selectBestPatterns() -> NSMutableArray? {
        let startSize: CInt = CInt(self.possibleCenters.count ?? 0)

        if startSize < 3 {
            return nil
        }

        if startSize > 3 {
            var totalModuleSize: CFloat = 0.0
            var square: CFloat = 0.0
            var i: CInt = 0

            while i < startSize {
                defer {
                    i += 1
                }

                let size: CFloat = self.possibleCenters[Int(i)].estimatedModuleSize()

                totalModuleSize += size
                square += size * size
            }

            let average: CFloat = totalModuleSize / CFloat(startSize)
            let stdDev: CFloat = CFloat(sqrt(square / CFloat(startSize) - average * average))

            self.possibleCenters.sortUsingFunction(furthestFromAverageCompare, context: average as? UnsafeMutableRawPointer)

            let limit = max(0.2 * average, stdDev)
            var i: CInt = 0

            while i < (self.possibleCenters.count ?? 0) && (self.possibleCenters.count ?? 0) > 3 {
                defer {
                    i += 1
                }

                let pattern: ZXQRCodeFinderPattern! = self.possibleCenters[Int(i)]

                if fabsf((pattern?.estimatedModuleSize ?? 0.0) - average) > limit {
                    self.possibleCenters.removeObjectAtIndex(i)
                    i -= 1
                }
            }
        }

        if (self.possibleCenters.count ?? 0) > 3 {
            var totalModuleSize: CFloat = 0.0
            var i: CInt = 0

            while i < (self.possibleCenters.count ?? 0) {
                defer {
                    i += 1
                }

                totalModuleSize += self.possibleCenters[Int(i)].estimatedModuleSize()
            }

            let average: CFloat = totalModuleSize / CFloat(self.possibleCenters.count ?? 0)

            self.possibleCenters.sortUsingFunction(centerCompare, context: (average) as? UnsafeMutableRawPointer)
            self.possibleCenters = NSMutableArray(array: self.possibleCenters.subarrayWithRange(NSMakeRange(0, 3)))
        }

        return [self.possibleCenters[0], self.possibleCenters[1], self.possibleCenters[2]].mutableCopy()
    }
}

// MARK: -
@objc
extension ZXQRCodeFinderPatternFinder {
    @objc weak var resultPointCallback: ZXResultPointCallback? {
        return self._resultPointCallback
    }
    @objc var possibleCenters: NSMutableArray! {
        get {
            return self._possibleCenters
        }
        set {
            self._possibleCenters = newValue
        }
    }
}