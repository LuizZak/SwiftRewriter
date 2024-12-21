// Preprocessor directives found in file:
// #import "ZXAztecCode.h"
// #import "ZXAztecEncoder.h"
// #import "ZXAztecHighLevelEncoder.h"
// #import "ZXBitArray.h"
// #import "ZXBitMatrix.h"
// #import "ZXByteArray.h"
// #import "ZXGenericGF.h"
// #import "ZXIntArray.h"
// #import "ZXReedSolomonEncoder.h"
let ZX_AZTEC_DEFAULT_EC_PERCENT: CInt = 33
let ZX_AZTEC_DEFAULT_LAYERS: CInt = 0
let ZX_AZTEC_MAX_NB_BITS: CInt = 32
let ZX_AZTEC_MAX_NB_BITS_COMPACT: CInt = 4
var ZX_AZTEC_WORD_SIZE: UnsafePointer<CInt>!

/**
 * Generates Aztec 2D barcodes.
 */
/**
 * Generates Aztec 2D barcodes.
 */
@objc
class ZXAztecEncoder: NSObject {
    /**
 * Encodes the given binary content as an Aztec symbol
 *
 * @param data input data string
 * @return Aztec symbol matrix with metadata
 */
    /**
 * Encodes the given binary content as an Aztec symbol
 *
 * @param data input data string
 * @return Aztec symbol matrix with metadata
 */
    @objc
    static func encode(_ data: ZXByteArray!) -> ZXAztecCode {
        return self.encode(data, minECCPercent: ZX_AZTEC_DEFAULT_EC_PERCENT, userSpecifiedLayers: ZX_AZTEC_DEFAULT_LAYERS)
    }
    /**
 * Encodes the given binary content as an Aztec symbol
 *
 * @param data input data string
 * @param minECCPercent minimal percentage of error check words (According to ISO/IEC 24778:2008,
 *                      a minimum of 23% + 3 words is recommended)
 * @param userSpecifiedLayers if non-zero, a user-specified value for the number of layers
 * @return Aztec symbol matrix with metadata
 */
    /**
 * Encodes the given binary content as an Aztec symbol
 *
 * @param data input data string
 * @param minECCPercent minimal percentage of error check words (According to ISO/IEC 24778:2008,
 *                      a minimum of 23% + 3 words is recommended)
 * @param userSpecifiedLayers if non-zero, a user-specified value for the number of layers
 * @return Aztec symbol matrix with metadata
 */
    @objc
    static func encode(_ data: ZXByteArray!, minECCPercent: CInt, userSpecifiedLayers: CInt) -> ZXAztecCode {
        // High-level encode
        let bits = ZXAztecHighLevelEncoder(text: data).encode()
        // stuff bits and choose symbol size
        let eccBits = bits.size * minECCPercent / 100 + 11
        let totalSizeBits = bits.size + eccBits
        var compact: Bool
        var layers: CInt
        var totalBitsInLayer: CInt
        var wordSize: CInt = ZX_AZTEC_WORD_SIZE[0]
        var stuffedBits: ZXBitArray!

        if userSpecifiedLayers != ZX_AZTEC_DEFAULT_LAYERS {
            compact = userSpecifiedLayers < 0
            layers = abs(userSpecifiedLayers)

            if layers > (compact ? ZX_AZTEC_MAX_NB_BITS_COMPACT : ZX_AZTEC_MAX_NB_BITS) {
                /*
                @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:[NSStringstringWithFormat:@"Illegal value %d for layers",userSpecifiedLayers]userInfo:nil];
                */
            }

            totalBitsInLayer = self.totalBitsInLayer(layers, compact: compact)
            wordSize = ZX_AZTEC_WORD_SIZE[layers]

            let usableBitsInLayers = totalBitsInLayer - (totalBitsInLayer % wordSize)

            stuffedBits = self.stuffBits(bits, wordSize: wordSize)

            if stuffedBits.size + eccBits > usableBitsInLayers {
                /*
                @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"Data too large for user specified layer"userInfo:nil];
                */
            }

            if compact && stuffedBits.size > wordSize * 64 {
                // Compact format only allows 64 data words, though C4 can hold more words than that
                /*
                @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"Data too large for user specified layer"userInfo:nil];
                */
            }
        } else {
            var i: CInt = 0

            while true {
                defer {
                    i += 1
                }

                if i > ZX_AZTEC_MAX_NB_BITS {
                    /*
                    @throw[NSExceptionexceptionWithName:@"IllegalArgumentException"reason:@"Data too large for an Aztec code"userInfo:nil];
                    */
                }

                compact = i <= 3
                layers = compact ? i + 1 : i
                totalBitsInLayer = self.totalBitsInLayer(layers, compact: compact)

                if totalSizeBits > totalBitsInLayer {
                    continue
                }

                // [Re]stuff the bits if this is the first opportunity, or if the
                // wordSize has changed
                if wordSize != ZX_AZTEC_WORD_SIZE[layers] {
                    wordSize = ZX_AZTEC_WORD_SIZE[layers]
                    stuffedBits = self.stuffBits(bits, wordSize: wordSize)
                }

                let usableBitsInLayers = totalBitsInLayer - (totalBitsInLayer % wordSize)

                if compact && stuffedBits.size > wordSize * 64 {
                    // Compact format only allows 64 data words, though C4 can hold more words than that
                    continue
                }

                if stuffedBits.size + eccBits <= usableBitsInLayers {
                    break
                }
            }
        }

        let messageBits = self.generateCheckWords(stuffedBits, totalBits: totalBitsInLayer, wordSize: wordSize)
        // generate check words
        let messageSizeInWords = stuffedBits.size / wordSize
        let modeMessage = self.generateModeMessageCompact(compact, layers: layers, messageSizeInWords: messageSizeInWords)
        // allocate symbol
        let baseMatrixSize = compact ? 11 + layers * 4 : 14 + layers * 4 // not including alignment lines
        var alignmentMap: UnsafeMutablePointer<CInt>!

        memset(alignmentMap, 0, Int(baseMatrixSize) * MemoryLayout<CInt>.size)

        var matrixSize: CInt

        if compact {
            // no alignment marks in compact mode, alignmentMap is a no-op
            matrixSize = baseMatrixSize

            var i: CInt = 0

            while i < baseMatrixSize {
                defer {
                    i += 1
                }

                alignmentMap[i] = i
            }
        } else {
            matrixSize = baseMatrixSize + 1 + 2 * ((baseMatrixSize / 2 - 1) / 15)

            let origCenter = baseMatrixSize / 2
            let center = matrixSize / 2
            var i: CInt = 0

            while i < origCenter {
                defer {
                    i += 1
                }

                let newOffset = i + i / 15

                alignmentMap[origCenter - i - 1] = center - newOffset - 1
                alignmentMap[origCenter + i] = center + newOffset + 1
            }
        }

        let matrix = ZXBitMatrix(dimension: matrixSize)
        var i: CInt = 0, rowOffset: CInt = 0

        while i < layers {
            defer {
                i += 1
            }

            let rowSize = compact ? (layers - i) * 4 + 9 : (layers - i) * 4 + 12
            var j: CInt = 0

            while j < rowSize {
                defer {
                    j += 1
                }

                let columnOffset = j * 2
                var k: CInt = 0

                while k < 2 {
                    defer {
                        k += 1
                    }

                    if messageBits.get(rowOffset + columnOffset + k) {
                        matrix.setX(alignmentMap[i * 2 + k], y: alignmentMap[i * 2 + j])
                    }

                    if messageBits.get(rowOffset + rowSize * 2 + columnOffset + k) {
                        matrix.setX(alignmentMap[i * 2 + j], y: alignmentMap[baseMatrixSize - 1 - i * 2 - k])
                    }

                    if messageBits.get(rowOffset + rowSize * 4 + columnOffset + k) {
                        matrix.setX(alignmentMap[baseMatrixSize - 1 - i * 2 - k], y: alignmentMap[baseMatrixSize - 1 - i * 2 - j])
                    }

                    if messageBits.get(rowOffset + rowSize * 6 + columnOffset + k) {
                        matrix.setX(alignmentMap[baseMatrixSize - 1 - i * 2 - j], y: alignmentMap[i * 2 + k])
                    }
                }
            }

            rowOffset += rowSize * 8
        }

        // draw mode message
        self.drawModeMessage(matrix, compact: compact, matrixSize: matrixSize, modeMessage: modeMessage)

        // draw alignment marks
        if compact {
            self.drawBullsEye(matrix, center: matrixSize / 2, size: 5)
        } else {
            self.drawBullsEye(matrix, center: matrixSize / 2, size: 7)

            var i: CInt = 0, j: CInt = 0

            while i < baseMatrixSize / 2 - 1 {
                defer {
                    i += 15
                    j += 16
                }

                var k = (matrixSize / 2) & 1

                while k < matrixSize {
                    defer {
                        k += 2
                    }

                    matrix.setX(matrixSize / 2 - j, y: k)
                    matrix.setX(matrixSize / 2 + j, y: k)
                    matrix.setX(k, y: matrixSize / 2 - j)
                    matrix.setX(k, y: matrixSize / 2 + j)
                }
            }
        }

        let aztec = ZXAztecCode()

        aztec.compact = compact
        aztec.size = matrixSize
        aztec.layers = layers
        aztec.codeWords = messageSizeInWords
        aztec.matrix = matrix

        return aztec
    }
    @objc
    static func drawBullsEye(_ matrix: ZXBitMatrix!, center: CInt, size: CInt) {
        var i: CInt = 0

        while i < size {
            defer {
                i += 2
            }

            var j = center - i

            while j <= center + i {
                defer {
                    j += 1
                }

                matrix.setX(j, y: center - i)
                matrix.setX(j, y: center + i)
                matrix.setX(center - i, y: j)
                matrix.setX(center + i, y: j)
            }
        }

        matrix.setX(center - size, y: center - size)
        matrix.setX(center - size + 1, y: center - size)
        matrix.setX(center - size, y: center - size + 1)
        matrix.setX(center + size, y: center - size)
        matrix.setX(center + size, y: center - size + 1)
        matrix.setX(center + size, y: center + size - 1)
    }
    @objc
    static func generateModeMessageCompact(_ compact: Bool, layers: CInt, messageSizeInWords: CInt) -> ZXBitArray {
        var modeMessage = ZXBitArray()

        if compact {
            modeMessage.appendBits(layers - 1, numBits: 2)
            modeMessage.appendBits(messageSizeInWords - 1, numBits: 6)
            modeMessage = self.generateCheckWords(modeMessage, totalBits: 28, wordSize: 4)
        } else {
            modeMessage.appendBits(layers - 1, numBits: 5)
            modeMessage.appendBits(messageSizeInWords - 1, numBits: 11)
            modeMessage = self.generateCheckWords(modeMessage, totalBits: 40, wordSize: 4)
        }

        return modeMessage
    }
    @objc
    static func drawModeMessage(_ matrix: ZXBitMatrix!, compact: Bool, matrixSize: CInt, modeMessage: ZXBitArray!) {
        let center = matrixSize / 2

        if compact {
            var i: CInt = 0

            while i < 7 {
                defer {
                    i += 1
                }

                let offset = center - 3 + i

                if modeMessage.get(i) {
                    matrix.setX(offset, y: center - 5)
                }

                if modeMessage.get(i + 7) {
                    matrix.setX(center + 5, y: offset)
                }

                if modeMessage.get(20 - i) {
                    matrix.setX(offset, y: center + 5)
                }

                if modeMessage.get(27 - i) {
                    matrix.setX(center - 5, y: offset)
                }
            }
        } else {
            var i: CInt = 0

            while i < 10 {
                defer {
                    i += 1
                }

                let offset = center - 5 + i + i / 5

                if modeMessage.get(i) {
                    matrix.setX(offset, y: center - 7)
                }

                if modeMessage.get(i + 10) {
                    matrix.setX(center + 7, y: offset)
                }

                if modeMessage.get(29 - i) {
                    matrix.setX(offset, y: center + 7)
                }

                if modeMessage.get(39 - i) {
                    matrix.setX(center - 7, y: offset)
                }
            }
        }
    }
    @objc
    static func generateCheckWords(_ bitArray: ZXBitArray!, totalBits: CInt, wordSize: CInt) -> ZXBitArray {
        // bitArray is guaranteed to be a multiple of the wordSize, so no padding needed
        let messageSizeInWords = bitArray.size / wordSize
        let rs = ZXReedSolomonEncoder(field: self.getGF(wordSize))
        let totalWords = totalBits / wordSize
        let messageWords = self.bitsToWords(bitArray, wordSize: wordSize, totalWords: totalWords)

        rs.encode(messageWords, ecBytes: totalWords - messageSizeInWords)

        let startPad = totalBits % wordSize
        let messageBits = ZXBitArray()

        messageBits.appendBits(0, numBits: startPad)

        var i: CInt = 0

        while i < totalWords {
            defer {
                i += 1
            }

            messageBits.appendBits(messageWords.array[i], numBits: wordSize)
        }

        return messageBits
    }
    @objc
    static func bitsToWords(_ stuffedBits: ZXBitArray!, wordSize: CInt, totalWords: CInt) -> ZXIntArray {
        let message = ZXIntArray(length: CUnsignedInt(totalWords))
        var i: CInt
        var n: CInt

        i = 0
        n = stuffedBits.size / wordSize

        while i < n {
            defer {
                i += 1
            }

            var value: int32_t = 0
            var j: CInt = 0

            while j < wordSize {
                defer {
                    j += 1
                }

                value |= stuffedBits.get(i * wordSize + j) ? (1 << (wordSize - j - 1)) : 0
            }

            message.array[i] = value
        }

        return message
    }
    @objc
    static func getGF(_ wordSize: CInt) -> ZXGenericGF {
        switch wordSize {
        case 4:
            return ZXGenericGF.AztecParam()
        case 6:
            return ZXGenericGF.AztecData6()
        case 8:
            return ZXGenericGF.AztecData8()
        case 10:
            return ZXGenericGF.AztecData10()
        case 12:
            return ZXGenericGF.AztecData12()
        default:
            return nil
        }
    }
    @objc
    static func stuffBits(_ bits: ZXBitArray!, wordSize: CInt) -> ZXBitArray {
        let arrayOut = ZXBitArray()
        let n = bits.size
        let mask = (1 << wordSize) - 2
        var i: CInt = 0

        while i < n {
            defer {
                i += wordSize
            }

            var word: CInt = 0
            var j: CInt = 0

            while j < wordSize {
                defer {
                    j += 1
                }

                if i + j >= n || bits.get(i + j) {
                    word |= 1 << (wordSize - 1 - j)
                }
            }

            if (word & mask) == mask {
                arrayOut.appendBits(word & mask, numBits: wordSize)
                i -= 1
            } else if (word & mask) == 0 {
                arrayOut.appendBits(word | 1, numBits: wordSize)
                i -= 1
            } else {
                arrayOut.appendBits(word, numBits: wordSize)
            }
        }

        return arrayOut
    }
    @objc
    static func totalBitsInLayer(_ layers: CInt, compact: Bool) -> CInt {
        return ((compact ? 88 : 112) + 16 * layers) * layers
    }
}