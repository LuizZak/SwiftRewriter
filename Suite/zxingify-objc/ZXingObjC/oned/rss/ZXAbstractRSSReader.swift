// Preprocessor directives found in file:
// #import "ZXOneDReader.h"
// #import "ZXAbstractRSSReader.h"
// #import "ZXIntArray.h"
// #define ZX_RSS14_FINDER_PATTERNS_LEN 9
// #define ZX_RSS14_FINDER_PATTERNS_SUB_LEN 4
// #define ZX_RSS_EXPANDED_FINDER_PATTERNS_LEN 6
// #define ZX_RSS_EXPANDED_FINDER_PATTERNS_SUB_LEN 4
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
enum ZX_RSS_PATTERNS: CInt {
    case ZX_RSS_PATTERNS_RSS14_PATTERNS = 0
    case ZX_RSS_PATTERNS_RSS_EXPANDED_PATTERNS
}

var ZX_RSS_MAX_AVG_VARIANCE: CFloat = 0.2
var ZX_RSS_MAX_INDIVIDUAL_VARIANCE: CFloat = 0.45
let ZX_RSS_MIN_FINDER_PATTERN_RATIO: CFloat = 9.5 / 12.0
let ZX_RSS_MAX_FINDER_PATTERN_RATIO: CFloat = 12.5 / 14.0
var ZX_RSS14_FINDER_PATTERNS: UnsafePointer<CInt>!
var ZX_RSS_EXPANDED_FINDER_PATTERNS: UnsafePointer<CInt>!
private let ZX_RSS14_FINDER_PATTERNS_LEN: Int = 9
private let ZX_RSS14_FINDER_PATTERNS_SUB_LEN: Int = 4
private let ZX_RSS_EXPANDED_FINDER_PATTERNS_LEN: Int = 6
private let ZX_RSS_EXPANDED_FINDER_PATTERNS_SUB_LEN: Int = 4

// A
// B
// C
// D
// E
// F
@objc
class ZXAbstractRSSReader: ZXOneDReader {
    private var _decodeFinderCounters: ZXIntArray!
    private var _dataCharacterCounters: ZXIntArray!
    private unowned(unsafe) var _oddRoundingErrors: UnsafeMutablePointer<CFloat>!
    private var _oddRoundingErrorsLen: CUnsignedInt = 0
    private unowned(unsafe) var _evenRoundingErrors: UnsafeMutablePointer<CFloat>!
    private var _evenRoundingErrorsLen: CUnsignedInt = 0
    private var _oddCounts: ZXIntArray!
    private var _evenCounts: ZXIntArray!
    @objc var decodeFinderCounters: ZXIntArray! {
        return self._decodeFinderCounters
    }
    @objc var dataCharacterCounters: ZXIntArray! {
        return self._dataCharacterCounters
    }
    @objc unowned(unsafe) var oddRoundingErrors: UnsafeMutablePointer<CFloat>! {
        return self._oddRoundingErrors
    }
    @objc var oddRoundingErrorsLen: CUnsignedInt {
        return self._oddRoundingErrorsLen
    }
    @objc unowned(unsafe) var evenRoundingErrors: UnsafeMutablePointer<CFloat>! {
        return self._evenRoundingErrors
    }
    @objc var evenRoundingErrorsLen: CUnsignedInt {
        return self._evenRoundingErrorsLen
    }
    @objc var oddCounts: ZXIntArray! {
        return self._oddCounts
    }
    @objc var evenCounts: ZXIntArray! {
        return self._evenCounts
    }

    @objc
    override init() {
        if self = super.init() {
            _decodeFinderCounters = ZXIntArray(length: 4)

            _dataCharacterCounters = ZXIntArray(length: 8)

            _oddRoundingErrorsLen = 4

            _oddRoundingErrors = malloc(Int(_oddRoundingErrorsLen) * MemoryLayout<CFloat>.size) as? UnsafeMutablePointer<CFloat>

            memset(_oddRoundingErrors, 0, Int(_oddRoundingErrorsLen) * MemoryLayout<CFloat>.size)

            _evenRoundingErrorsLen = 4

            _evenRoundingErrors = malloc(Int(_evenRoundingErrorsLen) * MemoryLayout<CFloat>.size) as? UnsafeMutablePointer<CFloat>

            memset(_evenRoundingErrors, 0, Int(_evenRoundingErrorsLen) * MemoryLayout<CFloat>.size)

            _oddCounts = ZXIntArray(length: _dataCharacterCounters.length / 2)

            _evenCounts = ZXIntArray(length: _dataCharacterCounters.length / 2)
        }

        return self
    }

    deinit {
        if _oddRoundingErrors != nil {
            free(_oddRoundingErrors)
            _oddRoundingErrors = nil
        }

        if _evenRoundingErrors != nil {
            free(_evenRoundingErrors)
            _evenRoundingErrors = nil
        }
    }

    @objc
    static func parseFinderValue(_ counters: ZXIntArray!, finderPatternType: ZX_RSS_PATTERNS) -> CInt {
        switch finderPatternType {
        case ZX_RSS_PATTERNS.ZX_RSS_PATTERNS_RSS14_PATTERNS:
            var value: CInt = 0

            while value < ZX_RSS14_FINDER_PATTERNS_LEN {
                defer {
                    value += 1
                }

                if self.patternMatchVariance(counters, pattern: ZX_RSS14_FINDER_PATTERNS[value], maxIndividualVariance: ZX_RSS_MAX_INDIVIDUAL_VARIANCE) < ZX_RSS_MAX_AVG_VARIANCE {
                    return value
                }
            }
        case ZX_RSS_PATTERNS.ZX_RSS_PATTERNS_RSS_EXPANDED_PATTERNS:
            var value: CInt = 0

            while value < ZX_RSS_EXPANDED_FINDER_PATTERNS_LEN {
                defer {
                    value += 1
                }

                if self.patternMatchVariance(counters, pattern: ZX_RSS_EXPANDED_FINDER_PATTERNS[value], maxIndividualVariance: ZX_RSS_MAX_INDIVIDUAL_VARIANCE) < ZX_RSS_MAX_AVG_VARIANCE {
                    return value
                }
            }
        default:
            break
        }

        return 1
    }
    @objc
    static func count(_ array: ZXIntArray!) -> CInt {
        return array.sum()
    }
    @objc
    static func increment(_ array: ZXIntArray!, errors: UnsafeMutablePointer<CFloat>!) {
        var index: CInt = 0
        var biggestError: CFloat = errors[0]
        var i: CInt = 1

        while i < array.length {
            defer {
                i += 1
            }

            if errors[i] > biggestError {
                biggestError = errors[i]
                index = i
            }
        }

        array.array[index] += 1
    }
    @objc
    static func decrement(_ array: ZXIntArray!, errors: UnsafeMutablePointer<CFloat>!) {
        var index: CInt = 0
        var biggestError: CFloat = errors[0]
        var i: CInt = 1

        while i < array.length {
            defer {
                i += 1
            }

            if errors[i] < biggestError {
                biggestError = errors[i]
                index = i
            }
        }

        array.array[index] -= 1
    }
    @objc
    static func isFinderPattern(_ counters: ZXIntArray!) -> Bool {
        let array = counters.array
        let firstTwoSum: CInt = array?[0] + array?[1]
        let sum: CInt = firstTwoSum + array?[2] + array?[3]
        let ratio: CFloat = CFloat(firstTwoSum) / CFloat(sum)

        if ratio >= ZX_RSS_MIN_FINDER_PATTERN_RATIO && ratio <= ZX_RSS_MAX_FINDER_PATTERN_RATIO {
            var minCounter: CInt = INT_MAX
            var maxCounter: CInt = INT_MIN
            var i: CInt = 0

            while i < counters.length {
                defer {
                    i += 1
                }

                let counter: CInt = array?[i]

                if counter > maxCounter {
                    maxCounter = counter
                }

                if counter < minCounter {
                    minCounter = counter
                }
            }

            return maxCounter < 10 * minCounter
        }

        return false
    }
}