// Preprocessor directives found in file:
// #import "ZXAbstractRSSReader.h"
// #import "ZXAbstractExpandedDecoder.h"
// #import "ZXBitArray.h"
// #import "ZXBitArrayBuilder.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXResult.h"
// #import "ZXRSSDataCharacter.h"
// #import "ZXRSSExpandedPair.h"
// #import "ZXRSSExpandedReader.h"
// #import "ZXRSSExpandedRow.h"
// #import "ZXRSSFinderPattern.h"
// #import "ZXRSSUtils.h"
// #define ZX_FINDER_PATTERN_SEQUENCES_LEN 10
// #define ZX_FINDER_PATTERN_SEQUENCES_SUBLEN 11
var ZX_SYMBOL_WIDEST: UnsafePointer<CInt>!
var ZX_EVEN_TOTAL_SUBSET: UnsafePointer<CInt>!
var ZX_GSUM: UnsafePointer<CInt>!
var ZX_WEIGHTS: (CInt, CInt, CInt, CInt, CInt, CInt, CInt, CInt)
let ZX_FINDER_PAT_A: CInt = 0
let ZX_FINDER_PAT_B: CInt = 1
let ZX_FINDER_PAT_C: CInt = 2
let ZX_FINDER_PAT_D: CInt = 3
let ZX_FINDER_PAT_E: CInt = 4
let ZX_FINDER_PAT_F: CInt = 5
var ZX_FINDER_PATTERN_SEQUENCES: UnsafePointer<CInt>!
private let ZX_FINDER_PATTERN_SEQUENCES_LEN: Int = 10
private let ZX_FINDER_PATTERN_SEQUENCES_SUBLEN: Int = 11

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
class ZXRSSExpandedReader: ZXAbstractRSSReader {
    private var _startEnd: ZXIntArray!
    private var _pairs: NSMutableArray!
    private var _rows: NSMutableArray!
    private var _startFromEven: Bool = false
    @objc var rows: NSMutableArray! {
        return self._rows
    }

    @objc
    override init() {
        if self = super.init() {
            _pairs = NSMutableArray()

            _rows = NSMutableArray()

            _startFromEven = false

            _startEnd = ZXIntArray(length: 2)
        }

        return self
    }

    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        // Rows can start with even pattern in case in prev rows there where odd number of patters.
        // So lets try twice
        self.pairs.removeAllObjects()
        self.startFromEven = false

        var pairs = self.decodeRow2pairs(rowNumber, row: row, error: error)

        if pairs != nil {
            let result = self.constructResult(pairs, error: error)

            if result != nil {
                return result
            }
        }

        self.pairs.removeAllObjects()
        self.startFromEven = true
        pairs = self.decodeRow2pairs(rowNumber, row: row, error: error)

        if pairs == nil {
            if error {
                *error = ZXNotFoundErrorInstance()
            }

            return nil
        }

        return self.constructResult(pairs, error: error)
    }
    @objc
    func reset() {
        self.pairs.removeAllObjects()
        self.rows.removeAllObjects()
    }
    @objc
    func decodeRow2pairs(_ rowNumber: CInt, row: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> NSMutableArray? {
        while true {
            let nextPair = self.retrieveNextPair(row, previousPairs: self.pairs, rowNumber: rowNumber)

            if nextPair == nil {
                if self.pairs.count == 0 {
                    return nil
                }

                break
            }

            if let nextPair = nextPair {
                self.pairs.add(nextPair)
            }
        }

        // TODO: verify sequence of finder patterns as in checkPairSequence()
        if self.checkChecksum() {
            return self.pairs
        }

        let tryStackedDecode = (self.rows.count ?? 0) > 0
        let wasReversed = false // TODO: deal with reversed rows

        self.storeRow(rowNumber, wasReversed: wasReversed)

        if tryStackedDecode {
            // When the image is 180-rotated, then rows are sorted in wrong dirrection.
            // Try twice with both the directions.
            var ps = self.checkRows(false)

            if ps != nil {
                return ps
            }

            ps = self.checkRows(true)

            if ps != nil {
                return ps
            }
        }

        return nil
    }
    @objc
    func checkRows(_ reverse: Bool) -> NSMutableArray? {
        // Limit number of rows we are checking
        // We use recursive algorithm with pure complexity and don't want it to take forever
        // Stacked barcode can have up to 11 rows, so 25 seems resonable enough
        if (self.rows.count ?? 0) > 25 {
            self.rows.removeAllObjects()

            return nil
        }

        self.pairs.removeAllObjects()

        if reverse {
            self.rows = self.rows.reverseObjectEnumerator().allObjects().mutableCopy()
        }

        let ps = self.checkRows(NSMutableArray(), current: 0)

        if reverse {
            self.rows = self.rows.reverseObjectEnumerator().allObjects().mutableCopy()
        }

        return ps
    }
    // Try to construct a valid rows sequence
    // Recursion is used to implement backtracking
    @objc
    func checkRows(_ collectedRows: NSMutableArray!, current currentRow: CInt) -> NSMutableArray? {
        var i = currentRow

        while i < (self.rows.count ?? 0) {
            defer {
                i += 1
            }

            let row: ZXRSSExpandedRow! = self.rows[Int(i)]

            self.pairs.removeAllObjects()

            let size: UInt = UInt(collectedRows.count)
            var j: CInt = 0

            while j < size {
                defer {
                    j += 1
                }

                self.pairs.addObjects(from: collectedRows[Int(j)].pairs())
            }

            if let pairs = row?.pairs {
                self.pairs.addObjects(from: pairs)
            }

            if !self.isValidSequence(self.pairs) {
                continue
            }

            if self.checkChecksum() {
                return self.pairs
            }

            let rs = NSMutableArray()

            rs.addObjects(from: collectedRows)

            if let row = row {
                rs.add(row)
            }

            let ps = self.checkRows(rs, current: i + 1)

            if ps != nil {
                return ps
            }
        }

        return nil
    }
    // Whether the pairs form a valid find pattern seqience,
    // either complete or a prefix
    @objc
    func isValidSequence(_ pairs: NSArray!) -> Bool {
        let count: CInt = CInt(pairs.count)
        var i: CInt = 0, sz: CInt = 2

        while i < ZX_FINDER_PATTERN_SEQUENCES_LEN {
            defer {
                i += 1
                sz += 1
            }

            if count > sz {
                continue
            }

            var stop = true
            var j: CInt = 0

            while j < count {
                defer {
                    j += 1
                }

                if pairs[Int(j)].finderPattern().value() != ZX_FINDER_PATTERN_SEQUENCES[i][j] {
                    stop = false

                    break
                }
            }

            if stop {
                return true
            }
        }

        return false
    }
    @objc
    func storeRow(_ rowNumber: CInt, wasReversed: Bool) {
        // Discard if duplicate above or below; otherwise insert in order by row number.
        var insertPos: CInt = 0
        var prevIsSame = false
        var nextIsSame = false

        while insertPos < (self.rows.count ?? 0) {
            let erow: ZXRSSExpandedRow! = self.rows[Int(insertPos)]

            if (erow?.rowNumber ?? 0) > rowNumber {
                nextIsSame = erow?.isEquivalent(self.pairs) == true

                break
            }

            prevIsSame = erow?.isEquivalent(self.pairs) == true
            insertPos += 1
        }

        if nextIsSame || prevIsSame {
            return
        }

        // When the row was partially decoded (e.g. 2 pairs found instead of 3),
        // it will prevent us from detecting the barcode.
        // Try to merge partial rows
        // Check whether the row is part of an allready detected row
        if self.isPartialRow(self.pairs, of: self.rows) {
            return
        }

        self.rows.insertObject(ZXRSSExpandedRow(pairs: self.pairs, rowNumber: rowNumber, wasReversed: wasReversed), atIndex: insertPos)
        self.removePartialRows(self.pairs, from: self.rows)
    }
    // Remove all the rows that contains only specified pairs
    @objc
    func removePartialRows(_ pairs: NSArray!, from rows: NSMutableArray!) {
        let toRemove = NSMutableArray()

        for r in rows {
            if r.pairs.count() == pairs.count {
                continue
            }

            var allFound = true

            for p in r.pairs {
                var found = false

                for pp in pairs {
                    if p.isEqual(pp) {
                        found = true

                        break
                    }
                }

                if !found {
                    allFound = false

                    break
                }
            }

            if allFound {
                toRemove.add(r)
            }
        }

        for r in toRemove {
            rows.remove(r)
        }
    }
    @objc
    func isPartialRow(_ pairs: NSArray!, of rows: NSArray!) -> Bool {
        for r in rows {
            var allFound = true

            for p in pairs {
                var found = false

                for pp in r.pairs {
                    if p.isEqual(pp) {
                        found = true

                        break
                    }
                }

                if !found {
                    allFound = false

                    break
                }
            }

            if allFound {
                // the row 'r' contain all the pairs from 'pairs'
                return true
            }
        }

        return false
    }
    @objc
    func constructResult(_ pairs: NSMutableArray!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let binary = ZXBitArrayBuilder.buildBitArray(pairs)
        let decoder = ZXAbstractExpandedDecoder.createDecoder(binary)
        let resultingString = decoder.parseInformationWithError(error)

        if !resultingString {
            return nil
        }

        let firstPoints = (_pairs[0] as? ZXRSSExpandedPair)?.finderPattern.resultPoints
        let lastPoints: NSArray! = (_pairs.lastObject as? ZXRSSExpandedPair)?.finderPattern().resultPoints()

        return ZXResult.resultWithText(resultingString, rawBytes: nil, resultPoints: [firstPoints?[0], firstPoints?[1], lastPoints[0], lastPoints[1]], format: ZXBarcodeFormat.kBarcodeFormatRSSExpanded)
    }
    @objc
    func checkChecksum() -> Bool {
        let firstPair: ZXRSSExpandedPair! = self.pairs[0]
        let checkCharacter = firstPair?.leftChar
        let firstCharacter = firstPair?.rightChar

        if firstCharacter == nil {
            return false
        }

        var checksum = firstCharacter?.checksumPortion ?? 0
        var s: CInt = 2
        var i: CInt = 1

        while i < (self.pairs.count ?? 0) {
            defer {
                i += 1
            }

            let currentPair: ZXRSSExpandedPair! = self.pairs[Int(i)]

            checksum += (currentPair?.leftChar.checksumPortion ?? 0)
            s += 1

            let currentRightChar = currentPair?.rightChar

            if currentRightChar != nil {
                checksum += (currentRightChar?.checksumPortion ?? 0)
                s += 1
            }
        }

        checksum %= 211

        let checkCharacterValue = 211 * (s - 4) + checksum

        return checkCharacterValue == checkCharacter?.value
    }
    @objc
    func nextSecondBar(_ row: ZXBitArray!, initialPos: CInt) -> CInt {
        var currentPos: CInt

        if row.get(initialPos) {
            currentPos = row.nextUnset(initialPos)
            currentPos = row.nextSet(currentPos)
        } else {
            currentPos = row.nextSet(initialPos)
            currentPos = row.nextUnset(currentPos)
        }

        return currentPos
    }
    @objc
    func retrieveNextPair(_ row: ZXBitArray!, previousPairs: NSMutableArray!, rowNumber: CInt) -> ZXRSSExpandedPair? {
        var isOddPattern = previousPairs.count % 2 == 0

        if self.startFromEven {
            isOddPattern = !isOddPattern
        }

        var pattern: ZXRSSFinderPattern!
        var keepFinding = true
        var forcedOffset: CInt = 1

        repeat {
            if !self.findNextPair(row, previousPairs: previousPairs, forcedOffset: forcedOffset) {
                return nil
            }

            pattern = self.parseFoundFinderPattern(row, rowNumber: rowNumber, oddPattern: isOddPattern)

            if pattern == nil {
                forcedOffset = self.nextSecondBar(row, initialPos: self.startEnd.array[0])
            } else {
                keepFinding = false
            }
        } while keepFinding

        // When stacked symbol is split over multiple rows, there's no way to guess if this pair can be last or not.
        // boolean mayBeLast = checkPairSequence(previousPairs, pattern);
        let leftChar = self.decodeDataCharacter(row, pattern: pattern, isOddPattern: isOddPattern, leftChar: true)

        if leftChar == nil {
            return nil
        }

        if previousPairs.count > 0 && previousPairs.lastObject?.mustBeLast() {
            return nil
        }

        let rightChar = self.decodeDataCharacter(row, pattern: pattern, isOddPattern: isOddPattern, leftChar: false)
        let mayBeLast = true

        return ZXRSSExpandedPair(leftChar: leftChar, rightChar: rightChar, finderPattern: pattern, mayBeLast: mayBeLast)
    }
    @objc
    func findNextPair(_ row: ZXBitArray!, previousPairs: NSMutableArray!, forcedOffset: CInt) -> Bool {
        let counters = self.decodeFinderCounters

        counters?.clear()

        let width = row.size
        var rowOffset: CInt

        if forcedOffset >= 0 {
            rowOffset = forcedOffset
        } else if previousPairs.count == 0 {
            rowOffset = 0
        } else {
            let lastPair: ZXRSSExpandedPair! = previousPairs.lastObject

            rowOffset = lastPair?.finderPattern.startEnd.array[1]
        }

        var searchingEvenPair = previousPairs.count % 2 != 0

        if self.startFromEven {
            searchingEvenPair = !searchingEvenPair
        }

        var isWhite = false

        while rowOffset < width {
            isWhite = !row.get(rowOffset)

            if !isWhite {
                break
            }

            rowOffset += 1
        }

        var counterPosition: CInt = 0
        var patternStart = rowOffset
        var array = counters?.array
        var x = rowOffset

        while x < width {
            defer {
                x += 1
            }

            if row.get(x) ^ isWhite {
                array?[counterPosition] += 1
            } else {
                if counterPosition == 3 {
                    if searchingEvenPair {
                        self.reverseCounters(counters)
                    }

                    if ZXAbstractRSSReader.isFinderPattern(counters) {
                        self.startEnd.array[0] = patternStart
                        self.startEnd.array[1] = x

                        return true
                    }

                    if searchingEvenPair {
                        self.reverseCounters(counters)
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

        return false
    }
    @objc
    func reverseCounters(_ counters: ZXIntArray!) {
        let length: CInt = CInt(counters.length)
        var array = counters.array
        var i: CInt = 0

        while i < length / 2 {
            defer {
                i += 1
            }

            let tmp: CInt = array?[i]

            array?[i] = array?[length - i - 1]
            array?[length - i - 1] = tmp
        }
    }
    @objc
    func parseFoundFinderPattern(_ row: ZXBitArray!, rowNumber: CInt, oddPattern: Bool) -> ZXRSSFinderPattern? {
        // Actually we found elements 2-5.
        var firstCounter: CInt
        var start: CInt
        var end: CInt

        if oddPattern {
            // If pattern number is odd, we need to locate element 1 *before *the current block.
            var firstElementStart: CInt = self.startEnd.array[0] - 1

            // Locate element 1
            while firstElementStart >= 0 && !row.get(firstElementStart) {
                firstElementStart -= 1
            }

            firstElementStart += 1

            firstCounter = self.startEnd.array[0] - firstElementStart

            start = firstElementStart

            end = self.startEnd.array[1]
        } else {
            // If pattern number is even, the pattern is reversed, so we need to locate element 1 *after *the current block.
            start = self.startEnd.array[0]
            end = row.nextUnset(self.startEnd.array[1] + 1)
            firstCounter = end - self.startEnd.array[1]
        }

        // Make 'counters' hold 1-4
        let counters = ZXIntArray(length: self.decodeFinderCounters.length ?? 0)
        var i: CInt = 1

        while i < counters.length {
            defer {
                i += 1
            }

            counters.array[i] = self.decodeFinderCounters.array[i - 1]
        }

        counters.array[0] = firstCounter
        memcpy(self.decodeFinderCounters.array, counters.array, Int(counters.length) * MemoryLayout.size(ofValue: int32_t))

        let value = ZXAbstractRSSReader.parseFinderValue(counters, finderPatternType: ZX_RSS_PATTERNS.ZX_RSS_PATTERNS_RSS_EXPANDED_PATTERNS)

        if value == 1 {
            return nil
        }

        return ZXRSSFinderPattern(value: value, startEnd: ZXIntArray(ints: start, end, 1), start: start, end: end, rowNumber: rowNumber)
    }
    @objc
    func decodeDataCharacter(_ row: ZXBitArray!, pattern: ZXRSSFinderPattern!, isOddPattern: Bool, leftChar: Bool) -> ZXRSSDataCharacter? {
        let counters = self.dataCharacterCounters

        counters?.clear()

        if leftChar {
            if !ZXOneDReader.recordPatternInReverse(row, start: pattern.startEnd().array[0], counters: counters) {
                return nil
            }
        } else {
            if !ZXOneDReader.recordPattern(row, start: pattern.startEnd().array[1], counters: counters) {
                return nil
            }

            // reverse it
            var array = counters?.array
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
        } //counters[] has the pixels of the module

        let numModules: CInt = 17 //left and right data characters have all the same length
        let elementWidth: CFloat = CFloat(ZXAbstractRSSReader.count(counters)) / CFloat(numModules)
        // Sanity check: element width for pattern and the character should match
        let expectedElementWidth: CFloat = (pattern.startEnd.array[1] - pattern.startEnd.array[0]) / 15.0

        if fabsf(elementWidth - expectedElementWidth) / expectedElementWidth > 0.3 {
            return nil
        }

        var array = counters?.array
        var i: CInt = 0

        while i < (counters?.length ?? 0) {
            defer {
                i += 1
            }

            let value: CFloat = 1.0 * array?[i] / elementWidth
            var count: CInt = CInt(value + 0.5)

            if count < 1 {
                if value < 0.3 {
                    return nil
                }

                count = 1
            } else if count > 8 {
                if value > 8.7 {
                    return nil
                }

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

        if !self.adjustOddEvenCounts(numModules) {
            return nil
        }

        let weightRowNumber = 4 * pattern.value + (isOddPattern ? 0 : 2) + (leftChar ? 0 : 1) - 1
        var oddSum: CInt = 0
        var oddChecksumPortion: CInt = 0
        var i: CInt = CInt((self.oddCounts.length ?? 0) - 1)

        while i >= 0 {
            defer {
                i -= 1
            }

            if self.isNotA1left(pattern, isOddPattern: isOddPattern, leftChar: leftChar) {
                let weight: CInt = ZX_WEIGHTS[weightRowNumber][2 * i]

                oddChecksumPortion += self.oddCounts.array[i] * weight
            }

            oddSum += self.oddCounts.array[i]
        }

        var evenChecksumPortion: CInt = 0
        var i: CInt = CInt((self.evenCounts.length ?? 0) - 1)

        while i >= 0 {
            defer {
                i -= 1
            }

            if self.isNotA1left(pattern, isOddPattern: isOddPattern, leftChar: leftChar) {
                let weight: CInt = ZX_WEIGHTS[weightRowNumber][2 * i + 1]

                evenChecksumPortion += self.evenCounts.array[i] * weight
            }
        }

        //evenSum += self.evenCounts[i];
        let checksumPortion = oddChecksumPortion + evenChecksumPortion

        if (oddSum & 0x1) != 0 || oddSum > 13 || oddSum < 4 {
            return nil
        }

        let group = (13 - oddSum) / 2
        let oddWidest: CInt = ZX_SYMBOL_WIDEST[group]
        let evenWidest = 9 - oddWidest
        let vOdd = ZXRSSUtils.rssValue(self.oddCounts, maxWidth: oddWidest, noNarrow: true)
        let vEven = ZXRSSUtils.rssValue(self.evenCounts, maxWidth: evenWidest, noNarrow: false)
        let tEven: CInt = ZX_EVEN_TOTAL_SUBSET[group]
        let gSum: CInt = ZX_GSUM[group]
        let value = vOdd * tEven + vEven + gSum

        return ZXRSSDataCharacter(value: value, checksumPortion: checksumPortion)
    }
    @objc
    func isNotA1left(_ pattern: ZXRSSFinderPattern!, isOddPattern: Bool, leftChar: Bool) -> Bool {
        return !(pattern.value == 0 && isOddPattern && leftChar)
    }
    @objc
    func adjustOddEvenCounts(_ numModules: CInt) -> Bool {
        let oddSum = ZXAbstractRSSReader.count(self.oddCounts)
        let evenSum = ZXAbstractRSSReader.count(self.evenCounts)
        let mismatch = oddSum + evenSum - numModules
        let oddParityBad = (oddSum & 0x1) == 1
        let evenParityBad = (evenSum & 0x1) == 0
        var incrementOdd = false
        var decrementOdd = false

        if oddSum > 13 {
            decrementOdd = true
        } else if oddSum < 4 {
            incrementOdd = true
        }

        var incrementEven = false
        var decrementEven = false

        if evenSum > 13 {
            decrementEven = true
        } else if evenSum < 4 {
            incrementEven = true
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
extension ZXRSSExpandedReader {
    @objc var startEnd: ZXIntArray! {
        return self._startEnd
    }
    @objc var pairs: NSMutableArray! {
        return self._pairs
    }
    @objc var rows: NSMutableArray! {
        get {
            return self._rows
        }
        set {
            self._rows = newValue
        }
    }
    @objc var startFromEven: Bool {
        get {
            return self._startFromEven
        }
        set {
            self._startFromEven = newValue
        }
    }
}