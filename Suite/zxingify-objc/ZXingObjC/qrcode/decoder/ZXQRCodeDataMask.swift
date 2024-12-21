// Preprocessor directives found in file:
// #import "ZXBitMatrix.h"
// #import "ZXQRCodeDataMask.h"
var DATA_MASKS: NSArray! = nil

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
// See ISO 18004:2006 6.8.1
/**
 * 000: mask bits for which (x + y) mod 2 == 0
 */
@objc
class ZXDataMask000: ZXQRCodeDataMask {
    @objc
    func isMasked(_ i: CInt, j: CInt) -> Bool {
        return ((i + j) & 0x1) == 0
    }
}
/**
 * 001: mask bits for which x mod 2 == 0
 */
@objc
class ZXDataMask001: ZXQRCodeDataMask {
    @objc
    func isMasked(_ i: CInt, j: CInt) -> Bool {
        return (i & 0x1) == 0
    }
}
/**
 * 010: mask bits for which y mod 3 == 0
 */
@objc
class ZXDataMask010: ZXQRCodeDataMask {
    @objc
    func isMasked(_ i: CInt, j: CInt) -> Bool {
        return j % 3 == 0
    }
}
/**
 * 011: mask bits for which (x + y) mod 3 == 0
 */
@objc
class ZXDataMask011: ZXQRCodeDataMask {
    @objc
    func isMasked(_ i: CInt, j: CInt) -> Bool {
        return (i + j) % 3 == 0
    }
}
/**
 * 100: mask bits for which (x/2 + y/3) mod 2 == 0
 */
@objc
class ZXDataMask100: ZXQRCodeDataMask {
    @objc
    func isMasked(_ i: CInt, j: CInt) -> Bool {
        return (((i / 2) + (j / 3)) & 0x1) == 0
    }
}
/**
 * 101: mask bits for which xy mod 2 + xy mod 3 == 0
 * equivalently, such that xy mod 6 == 0
 */
@objc
class ZXDataMask101: ZXQRCodeDataMask {
    @objc
    func isMasked(_ i: CInt, j: CInt) -> Bool {
        return (i * j) % 6 == 0
    }
}
/**
 * 110: mask bits for which (xy mod 2 + xy mod 3) mod 2 == 0
 * equivalently, such that xy mod 6 < 3
 */
@objc
class ZXDataMask110: ZXQRCodeDataMask {
    @objc
    func isMasked(_ i: CInt, j: CInt) -> Bool {
        return ((i * j) % 6) < 3
    }
}
/**
 * 111: mask bits for which ((x+y)mod 2 + xy mod 3) mod 2 == 0
 * equivalently, such that (x + y + xy mod 3) mod 2 == 0
 */
@objc
class ZXDataMask111: ZXQRCodeDataMask {
    @objc
    func isMasked(_ i: CInt, j: CInt) -> Bool {
        return ((i + j + ((i * j) % 3)) & 0x1) == 0
    }
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
 * Encapsulates data masks for the data bits in a QR code, per ISO 18004:2006 6.8. Implementations
 * of this class can un-mask a raw BitMatrix. For simplicity, they will unmask the entire BitMatrix,
 * including areas used for finder patterns, timing patterns, etc. These areas should be unused
 * after the point they are unmasked anyway.
 *
 * Note that the diagram in section 6.8.1 is misleading since it indicates that i is column position
 * and j is row position. In fact, as the text says, i is row position and j is column position.
 */
@objc
class ZXQRCodeDataMask: NSObject {
    /**
 * Implementations of this method reverse the data masking process applied to a QR Code and
 * make its bits ready to read.
 *
 * @param bits representation of QR Code bits
 * @param dimension dimension of QR Code, represented by bits, being unmasked
 */
    /**
 * See ISO 18004:2006 6.8.1
 */
    /**
 * Implementations of this method reverse the data masking process applied to a QR Code and
 * make its bits ready to read.
 */
    @objc
    func unmaskBitMatrix(_ bits: ZXBitMatrix!, dimension: CInt) {
        var i: CInt = 0

        while i < dimension {
            defer {
                i += 1
            }

            var j: CInt = 0

            while j < dimension {
                defer {
                    j += 1
                }

                if self.isMasked(i, j: j) {
                    bits.flipX(j, y: i)
                }
            }
        }
    }
    @objc
    func isMasked(_ i: CInt, j: CInt) -> Bool {
        /*
        @throw[NSExceptionexceptionWithName:NSInternalInconsistencyExceptionreason:[NSStringstringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)]userInfo:nil];
        */
    }
    /**
 * @param reference a value between 0 and 7 indicating one of the eight possible
 * data mask patterns a QR Code may use
 * @return DataMask encapsulating the data mask pattern
 */
    @objc
    static func forReference(_ reference: CInt) -> ZXQRCodeDataMask? {
        if !DATA_MASKS {
            DATA_MASKS = [ZXDataMask000(), ZXDataMask001(), ZXDataMask010(), ZXDataMask011(), ZXDataMask100(), ZXDataMask101(), ZXDataMask110(), ZXDataMask111()]
        }

        if reference < 0 || reference > 7 {
            NSException.raise(NSInvalidArgumentException, format: "Invalid reference value")
        }

        return DATA_MASKS[Int(reference)]
    }
}