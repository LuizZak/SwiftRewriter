// Preprocessor directives found in file:
// #import "ZXWriter.h"
// #import "ZXBitMatrix.h"
// #import "ZXBoolArray.h"
// #import "ZXEncodeHints.h"
// #import "ZXOneDimensionalCodeWriter.h"
// #import "ZXUPCAReader.h"
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
 * Encapsulates functionality and implementation that is common to one-dimensional barcodes.
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
 * Encapsulates functionality and implementation that is common to one-dimensional barcodes.
 */
@objc
class ZXOneDimensionalCodeWriter: NSObject, ZXWriter {
    @objc var longLinePositions: NSMutableArray!
    @objc var showLongLines: Bool = false

    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        return self.encode(contents, format: format, width: width, height: height, hints: nil, error: error)
    }
    /**
 * Encode the contents following specified format.
 * width and height are required size. This method may return bigger size
 * ZXBitMatrix when specified size is too small. The user can set both {width and
 * height to zero to get minimum size barcode. If negative value is set to width
 * or height, IllegalArgumentException is thrown.
 */
    @objc
    func encode(_ contents: String!, format: ZXBarcodeFormat, width: CInt, height: CInt, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXBitMatrix {
        if contents.length == 0 {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:@"Found empty contents"userInfo:nil];
            */
        }

        if width < 0 || height < 0 {
            /*
            @throw[NSExceptionexceptionWithName:NSInvalidArgumentExceptionreason:[NSStringstringWithFormat:@"Negative size is not allowed. Input: %dx%d",width,height]userInfo:nil];
            */
        }

        self.longLinePositions = NSMutableArray()
        self.showLongLines = false

        if hints.showLongLines {
            if format == ZXBarcodeFormat.kBarcodeFormatEan13 {
                self.showLongLines = true
            }

            if format == ZXBarcodeFormat.kBarcodeFormatEan8 {
                self.showLongLines = true
            }
        }

        var sidesMargin = self.defaultMargin()

        if hints && hints.margin {
            sidesMargin = hints.margin.intValue
        }

        let code = self.encode(contents)

        return self.renderResult(code, width: width, height: height, sidesMargin: sidesMargin)
    }
    /**
 * @return BOOL, YES iff input contains no other characters than digits 0-9.
 */
    @objc
    func isNumeric(_ contents: String!) -> Bool {
        let notDigits: NSCharacterSet! = NSCharacterSet.decimalDigitCharacterSet().invertedSet()

        if contents.rangeOfCharacterFromSet(notDigits).location == NSNotFound {
            return true
        } else {
            return false
        }
    }
    /**
 * @return a byte array of horizontal pixels (0 = white, 1 = black)
 */
    @objc
    func renderResult(_ code: ZXBoolArray!, width: CInt, height: CInt, sidesMargin: CInt) -> ZXBitMatrix {
        let inputWidth: CInt = CInt(code.length)
        // Add quiet zone on both sides.
        let fullWidth = inputWidth + sidesMargin
        let outputWidth = max(width, fullWidth)
        let outputHeight = max(1, height)
        let multiple = outputWidth / fullWidth
        let leftPadding = (outputWidth - (inputWidth * multiple)) / 2
        let output = ZXBitMatrix(width: outputWidth, height: outputHeight)
        var inputX: CInt = 0, outputX = leftPadding

        while inputX < inputWidth {
            defer {
                inputX += 1
                outputX += multiple
            }

            if code.array[inputX] {
                var barcodeHeight = outputHeight

                if self.showLongLines {
                    // if the position is not in the list for long lines we shorten the line by 10%
                    if !self.containsPos(inputX) {
                        barcodeHeight = CInt(CFloat(outputHeight) * 0.9)
                    }
                }

                output.setRegionAtLeft(outputX, top: 0, width: multiple, height: barcodeHeight)
            }
        }

        return output
    }
    /**
 * @param target encode black/white pattern into this array
 * @param pos position to start encoding at in target
 * @param pattern lengths of black/white runs to encode *
 * @param startColor starting color - false for white, true for black
 * @return the number of elements added to target.
 */
    @objc
    func appendPattern(_ target: ZXBoolArray!, pos: CInt, pattern: UnsafePointer<CInt>!, patternLen: CInt, startColor: Bool) -> CInt {
        var color = startColor
        var numAdded: CInt = 0
        var i: CInt = 0

        while i < patternLen {
            defer {
                i += 1
            }

            var j: CInt = 0

            while j < pattern[i] {
                defer {
                    j += 1
                }

                if self.showLongLines && self.isLongLinePattern(pattern) {
                    self.longLinePositions.add(NSNumber.numberWithInt(pos))
                }

                target.array[pos += 1] = color
            }

            numAdded += pattern[i]
            color = !color // flip color after each segment
        }

        return numAdded
    }
    @objc
    func isLongLinePattern(_ pattern: UnsafePointer<CInt>!) -> Bool {
        if pattern == ZX_UPC_EAN_MIDDLE_PATTERN {
            return true
        }

        if pattern == ZX_UPC_EAN_START_END_PATTERN {
            return true
        }

        return false
    }
    @objc
    func containsPos(_ pos: CInt) -> Bool {
        for number in self.longLinePositions {
            if number.intValue == pos {
                return true
            }
        }

        return false
    }
    @objc
    func defaultMargin() -> CInt {
        // CodaBar spec requires a side margin to be more than ten times wider than narrow space.
        // This seems like a decent idea for a default for all formats.
        return 10
    }
    /**
 * Encode the contents to boolean array expression of one-dimensional barcode.
 * Start code and end code should be included in result, and side margins should not be included.
 *
 * @param contents barcode contents to encode
 * @return a ZXBoolArray of horizontal pixels (false = white, true = black)
 */
    @objc
    func encode(_ contents: String!) -> ZXBoolArray {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
}