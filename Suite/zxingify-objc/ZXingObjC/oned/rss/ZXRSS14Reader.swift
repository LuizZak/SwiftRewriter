// Preprocessor directives found in file:
// #import "ZXAbstractRSSReader.h"
// #import "ZXBitArray.h"
// #import "ZXBarcodeFormat.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXResult.h"
// #import "ZXResultPointCallback.h"
// #import "ZXRSS14Reader.h"
// #import "ZXRSSFinderPattern.h"
// #import "ZXRSSPair.h"
// #import "ZXRSSUtils.h"
var ZX_RSS14_OUTSIDE_EVEN_TOTAL_SUBSET: (CInt, CInt, CInt, CInt, CInt)
var ZX_RSS14_INSIDE_ODD_TOTAL_SUBSET: (CInt, CInt, CInt, CInt)
var ZX_RSS14_OUTSIDE_GSUM: (CInt, CInt, CInt, CInt, CInt)
var ZX_RSS14_INSIDE_GSUM: (CInt, CInt, CInt, CInt)
var ZX_RSS14_OUTSIDE_ODD_WIDEST: (CInt, CInt, CInt, CInt, CInt)
var ZX_RSS14_INSIDE_ODD_WIDEST: (CInt, CInt, CInt, CInt)

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
 * Decodes RSS-14, including truncated and stacked variants. See ISO/IEC 24724:2006.
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
 * Decodes RSS-14, including truncated and stacked variants. See ISO/IEC 24724:2006.
 */
@objc
class ZXRSS14Reader: ZXAbstractRSSReader {
    private var _possibleLeftPairs: NSMutableArray!
    private var _possibleRightPairs: NSMutableArray!

    @objc
    override init() {
        if self = super.init() {
            _possibleLeftPairs = NSMutableArray()
            _possibleRightPairs = NSMutableArray()
        }

        return self
    }

    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let leftPair = self.decodePair(row, right: false, rowNumber: rowNumber, hints: hints)

        self.addOrTally(self.possibleLeftPairs, pair: leftPair)
        row.reverse()

        let rightPair = self.decodePair(row, right: true, rowNumber: rowNumber, hints: hints)

        self.addOrTally(self.possibleRightPairs, pair: rightPair)
        row.reverse()

        for left in self.possibleLeftPairs {
            if left.count() > 1 {
                for right in self.possibleRightPairs {
                    if right.count() > 1 {
                        if self.checkChecksum(left, rightPair: right) {
                            return self.constructResult(left, rightPair: right)
                        }
                    }
                }
            }
        }

        if error != nil {
            error.pointee = ZXNotFoundErrorInstance()
        }

        return nil
    }
    @objc
    func addOrTally(_ possiblePairs: NSMutableArray!, pair: ZXRSSPair!) {
        if pair == nil {
            return
        }

        var found = false

        for other in possiblePairs {
            if other.value == pair.value {
                other.incrementCount()
                found = true

                break
            }
        }

        if !found {
            possiblePairs.add(pair)
        }
    }
    @objc
    func reset() {
        self.possibleLeftPairs.removeAllObjects()
        self.possibleRightPairs.removeAllObjects()
    }
    @objc
    func constructResult(_ leftPair: ZXRSSPair!, rightPair: ZXRSSPair!) -> ZXResult? {
        let symbolValue: CLongLong = CLongLong(4537077 * leftPair.value + rightPair.value)
        let text: String! = symbolValue.stringValue()
        let buffer = NSMutableString(capacity: 14)
        var i: CInt = 13 - CInt(text.length())

        while i > 0 {
            defer {
                i -= 1
            }

            buffer.append("0")
        }

        buffer.append(text)

        var checkDigit: CInt = 0
        var i: CInt = 0

        while i < 13 {
            defer {
                i += 1
            }

            let digit: CInt = buffer.characterAtIndex(i) - "0"

            checkDigit += ((i & 0x1) == 0) ? 3 * digit : digit
        }

        checkDigit = 10 - (checkDigit % 10)

        if checkDigit == 10 {
            checkDigit = 0
        }

        buffer.appendFormat("%d", checkDigit)

        let leftPoints = leftPair.finderPattern.resultPoints
        let rightPoints = rightPair.finderPattern.resultPoints

        return ZXResult.resultWithText(buffer, rawBytes: nil, resultPoints: [leftPoints?[0], leftPoints?[1], rightPoints?[0], rightPoints?[1]], format: ZXBarcodeFormat.kBarcodeFormatRSS14)
    }
    @objc
    func checkChecksum(_ leftPair: ZXRSSPair!, rightPair: ZXRSSPair!) -> Bool {
        //  int leftFPValue = leftPair.finderPattern.value;
        //  int rightFPValue = rightPair.finderPattern.value;
        //  if ((leftFPValue == 0 && rightFPValue == 8) || (leftFPValue == 8 && rightFPValue == 0)) {
        //  }
        let checkValue = (leftPair.checksumPortion + 16 * rightPair.checksumPortion) % 79
        var targetCheckValue = 9 * (leftPair.finderPattern.value ?? 0) + (rightPair.finderPattern.value ?? 0)

        if targetCheckValue > 72 {
            targetCheckValue -= 1
        }

        if targetCheckValue > 8 {
            targetCheckValue -= 1
        }

        return checkValue == targetCheckValue
    }
    @objc
    func decodePair(_ row: ZXBitArray!, right: Bool, rowNumber: CInt, hints: ZXDecodeHints!) -> ZXRSSPair? {
        let startEnd = self.findFinderPattern(row, rowOffset: 0, rightFinderPattern: right)

        if startEnd == nil {
            return nil
        }

        let pattern = self.parseFoundFinderPattern(row, rowNumber: rowNumber, right: right, startEnd: startEnd)

        if pattern == nil {
            return nil
        }

        let resultPointCallback: ZXResultPointCallback! = (hints == nil) ? nil : hints.resultPointCallback

        if resultPointCallback != nil {
            var center: CFloat = (startEnd?.array[0] + startEnd?.array[1]) / 2.0

            if right {
                center = CFloat(row.size - 1) - center
            }

            resultPointCallback.foundPossibleResultPoint(ZXResultPoint(x: center, y: CFloat(rowNumber)))
        }

        let outside = self.decodeDataCharacter(row, pattern: pattern, outsideChar: true)
        let inside = self.decodeDataCharacter(row, pattern: pattern, outsideChar: false)

        if !outside || !inside {
            return nil
        }

        return ZXRSSPair(value: 1597 * outside.value + inside.value, checksumPortion: outside.checksumPortion + 4 * inside.checksumPortion, finderPattern: pattern)
    }
    @objc
    func decodeDataCharacter(_ row: ZXBitArray!, pattern: ZXRSSFinderPattern!, outsideChar: Bool) -> ZXRSSDataCharacter {
        let counters = self.dataCharacterCounters

        counters?.clear()

        var array = counters?.array

        if outsideChar {
            if !ZXOneDReader.recordPatternInReverse(row, start: pattern.startEnd().array[0], counters: counters) {
                return nil
            }
        } else {
            if !ZXOneDReader.recordPattern(row, start: pattern.startEnd().array[1], counters: counters) {
                return nil
            }

            var i: CInt = 0, j: CInt = CInt((counters?.length ?? 0) - 1)

            while i < j {
                defer {
                    i += 1
                    j -= 1
                }

                let temp: CInt = array?[i]

                array?[i] = array?[j]
                array?[j] = temp
            }
        }

        let numModules: CInt = outsideChar ? 16 : 15
        let elementWidth: CFloat = CFloat(ZXAbstractRSSReader.count(counters)) / CFloat(numModules)
        var i: CInt = 0

        while i < (counters?.length ?? 0) {
            defer {
                i += 1
            }

            let value: CFloat = CFloat(array?[i]) / elementWidth
            var count: CInt = CInt(value + 0.5)

            if count < 1 {
                count = 1
            } else if count > 8 {
                count = 8
            }

            let offset = i / 2

            if (i & 0x1) == 0 {
                self.oddCounts.array[offset] = count
                self.oddRoundingErrors[offset] = value - count
            } else {
                self.evenCounts.array[offset] = count
                self.evenRoundingErrors[offset] = value - count
            }
        }

        if !self.adjustOddEvenCounts(outsideChar, numModules: numModules) {
            return nil
        }

        var oddSum: CInt = 0
        var oddChecksumPortion: CInt = 0
        var i: CInt = CInt((self.oddCounts.length ?? 0) - 1)

        while i >= 0 {
            defer {
                i -= 1
            }

            oddChecksumPortion *= 9
            oddChecksumPortion += self.oddCounts.array[i]
            oddSum += self.oddCounts.array[i]
        }

        var evenChecksumPortion: CInt = 0
        var evenSum: CInt = 0
        var i: CInt = CInt((self.evenCounts.length ?? 0) - 1)

        while i >= 0 {
            defer {
                i -= 1
            }

            evenChecksumPortion *= 9
            evenChecksumPortion += self.evenCounts.array[i]
            evenSum += self.evenCounts.array[i]
        }

        let checksumPortion = oddChecksumPortion + 3 * evenChecksumPortion

        if outsideChar {
            if (oddSum & 0x1) != 0 || oddSum > 12 || oddSum < 4 {
                return nil
            }

            let group = (12 - oddSum) / 2
            let oddWidest: CInt = ZX_RSS14_OUTSIDE_ODD_WIDEST[group]
            let evenWidest = 9 - oddWidest
            let vOdd = ZXRSSUtils.rssValue(self.oddCounts, maxWidth: oddWidest, noNarrow: false)
            let vEven = ZXRSSUtils.rssValue(self.evenCounts, maxWidth: evenWidest, noNarrow: true)
            let tEven: CInt = ZX_RSS14_OUTSIDE_EVEN_TOTAL_SUBSET[group]
            let gSum: CInt = ZX_RSS14_OUTSIDE_GSUM[group]

            return ZXRSSDataCharacter(value: vOdd * tEven + vEven + gSum, checksumPortion: checksumPortion)
        } else {
            if (evenSum & 0x1) != 0 || evenSum > 10 || evenSum < 4 {
                return nil
            }

            let group = (10 - evenSum) / 2
            let oddWidest: CInt = ZX_RSS14_INSIDE_ODD_WIDEST[group]
            let evenWidest = 9 - oddWidest
            let vOdd = ZXRSSUtils.rssValue(self.oddCounts, maxWidth: oddWidest, noNarrow: true)
            let vEven = ZXRSSUtils.rssValue(self.evenCounts, maxWidth: evenWidest, noNarrow: false)
            let tOdd: CInt = ZX_RSS14_INSIDE_ODD_TOTAL_SUBSET[group]
            let gSum: CInt = ZX_RSS14_INSIDE_GSUM[group]

            return ZXRSSDataCharacter(value: vEven * tOdd + vOdd + gSum, checksumPortion: checksumPortion)
        }
    }
    @objc
    func findFinderPattern(_ row: ZXBitArray!, rowOffset: CInt, rightFinderPattern: Bool) -> ZXIntArray? {
        let counters = self.decodeFinderCounters

        counters?.clear()

        var array = counters?.array
        let width = row.size
        var isWhite = false

        while rowOffset < width {
            isWhite = !row.get(rowOffset)

            if rightFinderPattern == isWhite {
                break
            }

            rowOffset += 1
        }

        var counterPosition: CInt = 0
        var patternStart = rowOffset
        var x = rowOffset

        while x < width {
            defer {
                x += 1
            }

            if row.get(x) ^ isWhite {
                array?[counterPosition] += 1
            } else {
                if counterPosition == 3 {
                    if ZXAbstractRSSReader.isFinderPattern(counters) {
                        return ZXIntArray(ints: patternStart, x, 1)
                    }

                    patternStart += array?[0] + array?[1]

                    array?[0] = array?[2]
                    array?[1] = array?[3]
                    array?[2] = 0
                    array?[3] = 0

                    counterPosition -= 1
                } else {
                    counterPosition += 1
                }

                array?[counterPosition] = 1
                isWhite = !isWhite
            }
        }

        return nil
    }
    @objc
    func parseFoundFinderPattern(_ row: ZXBitArray!, rowNumber: CInt, right: Bool, startEnd: ZXIntArray!) -> ZXRSSFinderPattern? {
        let firstIsBlack = row.get(startEnd.array[0])
        var firstElementStart: CInt = startEnd.array[0] - 1

        while firstElementStart >= 0 && firstIsBlack ^ row.get(firstElementStart) {
            firstElementStart -= 1
        }

        firstElementStart += 1

        let firstCounter: CInt = startEnd.array[0] - firstElementStart
        let counters = self.decodeFinderCounters
        var array = counters?.array
        var i: CInt = CInt((counters?.length ?? 0) - 1)

        while i > 0 {
            defer {
                i -= 1
            }

            array?[i] = array?[i - 1]
        }

        array?[0] = firstCounter

        let value = ZXAbstractRSSReader.parseFinderValue(counters, finderPatternType: ZX_RSS_PATTERNS.ZX_RSS_PATTERNS_RSS14_PATTERNS)

        if value == 1 {
            return nil
        }

        var start = firstElementStart
        var end: CInt = startEnd.array[1]

        if right {
            start = row.size - 1 - start
            end = row.size - 1 - end
        }

        return ZXRSSFinderPattern(value: value, startEnd: ZXIntArray(ints: firstElementStart, startEnd.array[1], 1), start: start, end: end, rowNumber: rowNumber)
    }
    @objc
    func adjustOddEvenCounts(_ outsideChar: Bool, numModules: CInt) -> Bool {
        let oddSum = ZXAbstractRSSReader.count(self.oddCounts)
        let evenSum = ZXAbstractRSSReader.count(self.evenCounts)
        let mismatch = oddSum + evenSum - numModules
        let oddParityBad = (oddSum & 0x1) == (outsideChar ? 1 : 0)
        let evenParityBad = (evenSum & 0x1) == 1
        var incrementOdd = false
        var decrementOdd = false
        var incrementEven = false
        var decrementEven = false

        if outsideChar {
            if oddSum > 12 {
                decrementOdd = true
            } else if oddSum < 4 {
                incrementOdd = true
            }

            if evenSum > 12 {
                decrementEven = true
            } else if evenSum < 4 {
                incrementEven = true
            }
        } else {
            if oddSum > 11 {
                decrementOdd = true
            } else if oddSum < 5 {
                incrementOdd = true
            }

            if evenSum > 10 {
                decrementEven = true
            } else if evenSum < 4 {
                incrementEven = true
            }
        }

        if mismatch == 1 {
            if oddParityBad {
                if evenParityBad {
                    return false
                }

                decrementOdd = true
            } else {
                if !evenParityBad {
                    return false
                }

                decrementEven = true
            }
        } else if mismatch == 1 {
            if oddParityBad {
                if evenParityBad {
                    return false
                }

                incrementOdd = true
            } else {
                if !evenParityBad {
                    return false
                }

                incrementEven = true
            }
        } else if mismatch == 0 {
            if oddParityBad {
                if !evenParityBad {
                    return false
                }

                if oddSum < evenSum {
                    incrementOdd = true
                    decrementEven = true
                } else {
                    decrementOdd = true
                    incrementEven = true
                }
            } else if evenParityBad {
                return false
            }
        } else {
            return false
        }

        if incrementOdd {
            if decrementOdd {
                return false
            }

            ZXAbstractRSSReader.increment(self.oddCounts, errors: self.oddRoundingErrors)
        }

        if decrementOdd {
            ZXAbstractRSSReader.decrement(self.oddCounts, errors: self.oddRoundingErrors)
        }

        if incrementEven {
            if decrementEven {
                return false
            }

            ZXAbstractRSSReader.increment(self.evenCounts, errors: self.oddRoundingErrors)
        }

        if decrementEven {
            ZXAbstractRSSReader.decrement(self.evenCounts, errors: self.evenRoundingErrors)
        }

        return true
    }
}

// MARK: -
@objc
extension ZXRSS14Reader {
    @objc var possibleLeftPairs: NSMutableArray! {
        return self._possibleLeftPairs
    }
    @objc var possibleRightPairs: NSMutableArray! {
        return self._possibleRightPairs
    }
}