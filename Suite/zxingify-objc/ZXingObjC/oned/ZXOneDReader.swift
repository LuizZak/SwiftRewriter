// Preprocessor directives found in file:
// #import "ZXReader.h"
// #import "ZXBinaryBitmap.h"
// #import "ZXBitArray.h"
// #import "ZXDecodeHints.h"
// #import "ZXErrors.h"
// #import "ZXIntArray.h"
// #import "ZXOneDReader.h"
// #import "ZXResult.h"
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
 * Encapsulates functionality and implementation that is common to all families
 * of one-dimensional barcodes.
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
 * Encapsulates functionality and implementation that is common to all families
 * of one-dimensional barcodes.
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
class ZXOneDReader: NSObject, ZXReader {
    @objc
    func decode(_ image: ZXBinaryBitmap!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        return self.decode(image, hints: nil, error: error)
    }
    // Note that we don't try rotation without the try harder flag, even if rotation was supported.
    @objc
    func decode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        var decodeError: Error! = nil
        let result = self.doDecode(image, hints: hints, error: &decodeError)

        if result != nil {
            return result
        } else if decodeError?.code == ZXNotFoundError {
            let tryHarder = hints != nil && hints.tryHarder

            if tryHarder && image.rotateSupported {
                let rotatedImage = image.rotateCounterClockwise()
                let result = self.doDecode(rotatedImage, hints: hints, error: error)

                if result == nil {
                    return nil
                }

                // Record that we found it rotated 90 degrees CCW / 270 degrees CW
                let metadata = result?.resultMetadata
                var orientation: CInt = 270

                if metadata != nil && metadata?[ZXResultMetadataType.kResultMetadataTypeOrientation] {
                    // But if we found it reversed in doDecode(), add in that result here:
                    orientation = (orientation + (metadata?[ZXResultMetadataType.kResultMetadataTypeOrientation] as? NSNumber).intValue()) % 360
                }

                result?.putMetadata(ZXResultMetadataType.kResultMetadataTypeOrientation, value: orientation)

                // Update result points
                let points = result?.resultPoints

                if points != nil {
                    let height = rotatedImage?.height ?? 0
                    var i: CInt = 0

                    while i < (points?.count ?? 0) {
                        defer {
                            i += 1
                        }

                        points?[Int(i)] = ZXResultPoint(x: CFloat(height) - ((points?[Int(i)] as? ZXResultPoint)?.y ?? 0.0), y: (points?[Int(i)] as? ZXResultPoint)?.x())
                    }
                }

                return result
            }
        }

        if error {
            *error = decodeError
        }

        return nil
    }
    @objc
    func reset() {
        // do nothing
    }
    /**
 * We're going to examine rows from the middle outward, searching alternately above and below the
 * middle, and farther out each time. rowStep is the number of rows between each successive
 * attempt above and below the middle. So we'd scan row middle, then middle - rowStep, then
 * middle + rowStep, then middle - (2 * rowStep), etc.
 * rowStep is bigger as the image is taller, but is always at least 1. We've somewhat arbitrarily
 * decided that moving up and down by about 1/16 of the image is pretty good; we try more of the
 * image if "trying harder".
 *
 * @param image The image to decode
 * @param hints Any hints that were requested
 * @return The contents of the decoded barcode or nil if:
 *  - no potential barcode is found
 *  - a potential barcode is found but does not pass its checksum
 *  - a potential barcode is found but format is invalid
 */
    @objc
    func doDecode(_ image: ZXBinaryBitmap!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult? {
        let width = image.width
        let height = image.height
        var row: ZXBitArray! = ZXBitArray(size: width)
        let middle = height >> 1
        let tryHarder = hints != nil && hints.tryHarder
        let rowStep: CInt = CInt(max(1, height >> (tryHarder ? 8 : 5)))
        var maxLines: CInt

        if tryHarder {
            maxLines = height
        } else {
            maxLines = 15
        }

        var x: CInt = 0

        while x < maxLines {
            defer {
                x += 1
            }

            let rowStepsAboveOrBelow = (x + 1) / 2
            let isAbove = (x & 0x1) == 0
            let rowNumber = middle + rowStep * (isAbove ? rowStepsAboveOrBelow : -rowStepsAboveOrBelow)

            if rowNumber < 0 || rowNumber >= height {
                break
            }

            var rowError: Error! = nil

            row = image.blackRow(rowNumber, row: row, error: &rowError)

            if !row && rowError?.code == ZXNotFoundError {
                continue
            } else if !row {
                if error {
                    *error = rowError
                }

                return nil
            }

            var attempt: CInt = 0

            while attempt < 2 {
                defer {
                    attempt += 1
                }

                if attempt == 1 {
                    row.reverse()

                    if hints != nil && hints.resultPointCallback {
                        hints = hints.copy()
                        hints.resultPointCallback = nil
                    }
                }

                let result = self.decodeRow(rowNumber, row: row, hints: hints, error: nil)

                if result {
                    if attempt == 1 {
                        result.putMetadata(ZXResultMetadataType.kResultMetadataTypeOrientation, value: 180)

                        let points = result.resultPoints

                        if points != nil {
                            points?[0] = ZXResultPoint(x: CFloat(width) - ((points?[0] as? ZXResultPoint)?.x ?? 0.0), y: (points?[0] as? ZXResultPoint)?.y())
                            points?[1] = ZXResultPoint(x: CFloat(width) - ((points?[1] as? ZXResultPoint)?.x ?? 0.0), y: (points?[1] as? ZXResultPoint)?.y())
                        }
                    }

                    return result
                }
            }
        }

        if error {
            *error = ZXNotFoundErrorInstance()
        }

        return nil
    }
    /**
 * Records the size of successive runs of white and black pixels in a row, starting at a given point.
 * The values are recorded in the given array, and the number of runs recorded is equal to the size
 * of the array. If the row starts on a white pixel at the given start point, then the first count
 * recorded is the run of white pixels starting from that point; likewise it is the count of a run
 * of black pixels if the row begin on a black pixels at that point.
 *
 * @param row row to count from
 * @param start offset into row to start at
 * @param counters array into which to record counts or nil if counters cannot be filled entirely
 *  from row before running out of pixels
 */
    @objc
    static func recordPattern(_ row: ZXBitArray!, start: CInt, counters: ZXIntArray!) -> Bool {
        let numCounters: CInt = CInt(counters.length)

        counters.clear()

        var array = counters.array
        let end = row.size

        if start >= end {
            return false
        }

        var isWhite = !row.get(start)
        var counterPosition: CInt = 0
        var i = start

        while i < end {
            if row.get(i) ^ isWhite {
                array?[counterPosition] += 1
            } else {
                counterPosition += 1

                if counterPosition == numCounters {
                    break
                } else {
                    array?[counterPosition] = 1
                    isWhite = !isWhite
                }
            }

            i += 1
        }

        return counterPosition == numCounters || (counterPosition == numCounters - 1 && i == end)
    }
    @objc
    static func recordPatternInReverse(_ row: ZXBitArray!, start: CInt, counters: ZXIntArray!) -> Bool {
        var numTransitionsLeft: CInt = CInt(counters.length)
        var last = row.get(start)

        while start > 0 && numTransitionsLeft >= 0 {
            if row.get(start -= 1) != last {
                numTransitionsLeft -= 1
                last = !last
            }
        }

        return !(numTransitionsLeft >= 0 || !self.recordPattern(row, start: start + 1, counters: counters))
    }
    /**
 * Determines how closely a set of observed counts of runs of black/white values matches a given
 * target pattern. This is reported as the ratio of the total variance from the expected pattern
 * proportions across all pattern elements, to the length of the pattern.
 *
 * @param counters observed counters
 * @param pattern expected pattern
 * @param maxIndividualVariance The most any counter can differ before we give up
 * @return ratio of total variance between counters and pattern compared to total pattern size
 */
    @objc
    static func patternMatchVariance(_ counters: ZXIntArray!, pattern: UnsafePointer<CInt>!, maxIndividualVariance: CFloat) -> CFloat {
        let numCounters: CInt = CInt(counters.length)
        var total: CInt = 0
        var patternLength: CInt = 0
        let array = counters.array
        var i: CInt = 0

        while i < numCounters {
            defer {
                i += 1
            }

            total += array?[i]
            patternLength += pattern[i]
        }

        if total < patternLength || patternLength == 0 {
            return FLT_MAX
        }

        let unitBarWidth: CFloat = CFloat(total) / patternLength

        maxIndividualVariance *= unitBarWidth

        var totalVariance: CFloat = 0.0
        var x: CInt = 0

        while x < numCounters {
            defer {
                x += 1
            }

            let counter: CInt = array?[x]
            let scaledPattern: CFloat = pattern[x] * unitBarWidth
            let variance: CFloat = (counter > scaledPattern) ? CFloat(counter) - scaledPattern : scaledPattern - CFloat(counter)

            if variance > maxIndividualVariance {
                return FLT_MAX
            }

            totalVariance += variance
        }

        return totalVariance / CFloat(total)
    }
    /**
 * Attempts to decode a one-dimensional barcode format given a single row of
 * an image.
 *
 * @param rowNumber row number from top of the row
 * @param row the black/white pixel data of the row
 * @param hints decode hints
 * @return ZXResult containing encoded string and start/end of barcode or nil
 *  if an error occurs or barcode cannot be found
 */
    @objc
    func decodeRow(_ rowNumber: CInt, row: ZXBitArray!, hints: ZXDecodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXResult {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
}