// Preprocessor directives found in file:
// #import "ZXAbstractExpandedDecoder.h"
// #import "ZXAI01decoder.h"
// #import "ZXBitArray.h"
// #import "ZXRSSExpandedGeneralAppIdDecoder.h"
let ZX_AI01_GTIN_SIZE: CInt = 40

@objc
class ZXAI01decoder: ZXAbstractExpandedDecoder {
    @objc
    func encodeCompressedGtin(_ buf: NSMutableString!, currentPos: CInt) {
        buf.append("(01)")

        let initialPosition: CInt = CInt(buf.length())

        buf.append("9")
        self.encodeCompressedGtinWithoutAI(buf, currentPos: currentPos, initialBufferPosition: initialPosition)
    }
    @objc
    func encodeCompressedGtinWithoutAI(_ buf: NSMutableString!, currentPos: CInt, initialBufferPosition: CInt) {
        var i: CInt = 0

        while i < 4 {
            defer {
                i += 1
            }

            let currentBlock = self.generalDecoder.extractNumericValueFromBitArray(currentPos + 10 * i, bits: 10) ?? 0

            if currentBlock / 100 == 0 {
                buf.append("0")
            }

            if currentBlock / 10 == 0 {
                buf.append("0")
            }

            buf.appendFormat("%d", currentBlock)
        }

        self.appendCheckDigit(buf, currentPos: initialBufferPosition)
    }
    @objc
    func appendCheckDigit(_ buf: NSMutableString!, currentPos: CInt) {
        var checkDigit: CInt = 0
        var i: CInt = 0

        while i < 13 {
            defer {
                i += 1
            }

            let digit: CInt = buf.characterAtIndex(i + currentPos) - "0"

            checkDigit += ((i & 0x1) == 0) ? 3 * digit : digit
        }

        checkDigit = 10 - (checkDigit % 10)

        if checkDigit == 10 {
            checkDigit = 0
        }

        buf.appendFormat("%d", checkDigit)
    }
}