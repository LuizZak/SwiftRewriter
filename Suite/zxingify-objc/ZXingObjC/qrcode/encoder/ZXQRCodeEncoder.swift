// Preprocessor directives found in file:
// #import "ZXBitArray.h"
// #import "ZXByteArray.h"
// #import "ZXByteMatrix.h"
// #import "ZXCharacterSetECI.h"
// #import "ZXEncodeHints.h"
// #import "ZXErrors.h"
// #import "ZXGenericGF.h"
// #import "ZXIntArray.h"
// #import "ZXQRCode.h"
// #import "ZXQRCodeBlockPair.h"
// #import "ZXQRCodeEncoder.h"
// #import "ZXQRCodeErrorCorrectionLevel.h"
// #import "ZXQRCodeMaskUtil.h"
// #import "ZXQRCodeMatrixUtil.h"
// #import "ZXQRCodeMode.h"
// #import "ZXQRCodeVersion.h"
// #import "ZXReedSolomonEncoder.h"
var ZX_ALPHANUMERIC_TABLE: UnsafePointer<CInt>!
let ZX_DEFAULT_BYTE_MODE_ENCODING: NSStringEncoding = NSISOLatin1StringEncoding

@objc
class ZXQRCodeEncoder: NSObject {
    // The mask penalty calculation is complicated.  See Table 21 of JISX0510:2004 (p.45) for details.
    // Basically it applies four rules and summate all penalties.
    @objc
    static func calculateMaskPenalty(_ matrix: ZXByteMatrix!) -> CInt {
        return ZXQRCodeMaskUtil.applyMaskPenaltyRule1(matrix) + ZXQRCodeMaskUtil.applyMaskPenaltyRule2(matrix) + ZXQRCodeMaskUtil.applyMaskPenaltyRule3(matrix) + ZXQRCodeMaskUtil.applyMaskPenaltyRule4(matrix)
    }
    /**
 * @param content text to encode
 * @param ecLevel error correction level to use
 * @return ZXQRCode representing the encoded QR code or nil if encoding can't succeed, because of
 *  for example invalid content or configuration.
 */
    /**
 * @param content text to encode
 * @param ecLevel error correction level to use
 * @return ZXQRCode representing the encoded QR code or nil if encoding can't succeed, because of
 *  for example invalid content or configuration.
 */
    @objc
    static func encode(_ content: String!, ecLevel: ZXQRCodeErrorCorrectionLevel!, error: UnsafeMutablePointer<Error?>!) -> ZXQRCode {
        return self.encode(content, ecLevel: ecLevel, hints: nil, error: error)
    }
    @objc
    static func encode(_ content: String!, ecLevel: ZXQRCodeErrorCorrectionLevel!, hints: ZXEncodeHints!, error: UnsafeMutablePointer<Error?>!) -> ZXQRCode {
        // Determine what character encoding has been specified by the caller, if any
        var encoding: NSStringEncoding = (hints == nil) ? 0 : hints.encoding

        if encoding == 0 {
            encoding = ZX_DEFAULT_BYTE_MODE_ENCODING
        }

        // Pick an encoding mode appropriate for the content. Note that this will not attempt to use
        // multiple modes / segments even if that were more efficient. Twould be nice.
        let mode = self.chooseMode(content, encoding: encoding)
        // This will store the header information, like mode and
        // length, as well as "header" segments like an ECI segment.
        let headerBits = ZXBitArray()

        // Append ECI segment if applicable
        if (mode?.isEqual(ZXQRCodeMode.byteMode()) == true) && ZX_DEFAULT_BYTE_MODE_ENCODING != encoding {
            let eci = ZXCharacterSetECI.characterSetECIByEncoding(encoding)

            if eci != nil {
                self.appendECI(eci, bits: headerBits)
            }
        }

        // Append the FNC1 mode header for GS1 formatted data if applicable
        if hints.gs1Format {
            // GS1 formatted codes are prefixed with a FNC1 in first position mode header
            self.appendModeInfo(ZXQRCodeMode.fnc1FirstPositionMode(), bits: headerBits)
        }

        // (With ECI in place,) Write the mode marker
        self.appendModeInfo(mode, bits: headerBits)

        // Collect data within the main segment, separately, to count its size if needed. Don't add it to
        // main payload yet.
        let dataBits = ZXBitArray()

        if !self.appendBytes(content, mode: mode, bits: dataBits, encoding: encoding, error: error) {
            return nil
        }

        var version: ZXQRCodeVersion! = nil

        if hints.qrVersion != nil {
            let requestedVersion = ZXQRCodeVersion.versionForNumber(hints.qrVersion.intValue())
            let bitsNeeded = self.calculateBitsNeededForMode(mode, headerBits: headerBits, dataBits: dataBits, version: requestedVersion)

            if self.willFitIn(bitsNeeded, version: requestedVersion, ecLevel: ecLevel) {
                version = requestedVersion
            } else {
                let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Data too big"]

                if error != nil {
                    error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
                }
            }
        } else {
            version = self.recommendVersionFor(ecLevel, mode: mode, headerBits: headerBits, dataBits: dataBits, error: error)
        }

        if version == nil {
            return nil
        }

        let headerAndDataBits = ZXBitArray()

        headerAndDataBits.appendBitArray(headerBits)

        // Find "length" of main segment and write it
        let numLetters: CInt = (mode?.isEqual(ZXQRCodeMode.byteMode()) == true) ? dataBits.sizeInBytes() : CInt(content.length())

        if !self.appendLengthInfo(numLetters, version: version, mode: mode, bits: headerAndDataBits, error: error) {
            return nil
        }

        // Put data together into the overall payload
        headerAndDataBits.appendBitArray(dataBits)

        let ecBlocks = version?.ecBlocksForLevel(ecLevel)
        let numDataBytes = (version?.totalCodewords ?? 0) - (ecBlocks?.totalECCodewords ?? 0)

        // Terminate the bits properly.
        if !self.terminateBits(numDataBytes, bits: headerAndDataBits, error: error) {
            return nil
        }

        // Interleave data bits with error correction code.
        let finalBits = self.interleaveWithECBytes(headerAndDataBits, numTotalBytes: version?.totalCodewords ?? 0, numDataBytes: numDataBytes, numRSBlocks: ecBlocks?.numBlocks ?? 0, error: error)

        if !finalBits {
            return nil
        }

        let qrCode = ZXQRCode()

        qrCode.ecLevel = ecLevel
        qrCode.mode = mode
        qrCode.version = version

        // Choose the mask pattern and set to "qrCode".
        let dimension = version?.dimensionForVersion ?? 0
        let matrix = ZXByteMatrix(width: dimension, height: dimension)
        let maskPattern = self.chooseMaskPattern(finalBits, ecLevel: qrCode.ecLevel(), version: qrCode.version(), matrix: matrix, error: error)

        if maskPattern == 1 {
            return nil
        }

        qrCode.setMaskPattern(maskPattern)

        // Build the matrix and set it to "qrCode".
        if !ZXQRCodeMatrixUtil.buildMatrix(finalBits, ecLevel: ecLevel, version: version, maskPattern: maskPattern, matrix: matrix, error: error) {
            return nil
        }

        qrCode.setMatrix(matrix)

        return qrCode
    }
    @objc
    static func recommendVersionFor(_ ecLevel: ZXQRCodeErrorCorrectionLevel!, mode: ZXQRCodeMode!, headerBits: ZXBitArray!, dataBits: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> ZXQRCodeVersion? {
        // Hard part: need to know version to know how many bits length takes. But need to know how many
        // bits it takes to know version. First we take a guess at version by assuming version will be
        // the minimum, 1:
        let provisionalBitsNeeded = self.calculateBitsNeededForMode(mode, headerBits: headerBits, dataBits: dataBits, version: ZXQRCodeVersion.versionForNumber(1))
        // Use that guess to calculate the right version. I am still not sure this works in 100% of cases.
        let provisionalVersion = self.chooseVersion(provisionalBitsNeeded, ecLevel: ecLevel, error: error)
        let bitsNeeded = self.calculateBitsNeededForMode(mode, headerBits: headerBits, dataBits: dataBits, version: provisionalVersion)

        return self.chooseVersion(bitsNeeded, ecLevel: ecLevel, error: error)
    }
    @objc
    static func calculateBitsNeededForMode(_ mode: ZXQRCodeMode!, headerBits: ZXBitArray!, dataBits: ZXBitArray!, version: ZXQRCodeVersion!) -> CInt {
        let bitsNeeded = headerBits.size + mode.characterCountBits(version) + dataBits.size

        return bitsNeeded
    }
    /**
 * Return the code point of the table used in alphanumeric mode or
 * -1 if there is no corresponding code in the table.
 */
    /**
 * Return the code point of the table used in alphanumeric mode or
 * -1 if there is no corresponding code in the table.
 */
    @objc
    static func alphanumericCode(_ code: CInt) -> CInt {
        if code < MemoryLayout.size(ofValue: ZX_ALPHANUMERIC_TABLE) / MemoryLayout<CInt>.size {
            return ZX_ALPHANUMERIC_TABLE[code]
        }

        return 1
    }
    @objc
    static func chooseMode(_ content: String!) -> ZXQRCodeMode? {
        return self.chooseMode(content, encoding: 1)
    }
    /**
 * Choose the best mode by examining the content. Note that 'encoding' is used as a hint;
 * if it is Shift_JIS, and the input is only double-byte Kanji, then we return `kanjiMode`.
 */
    @objc
    static func chooseMode(_ content: String!, encoding: NSStringEncoding) -> ZXQRCodeMode? {
        if NSShiftJISStringEncoding == encoding && self.isOnlyDoubleByteKanji(content) {
            // Choose Kanji mode if all input are double-byte characters
            return ZXQRCodeMode.kanjiMode()
        }

        var hasNumeric = false
        var hasAlphanumeric = false
        var i: CInt = 0

        while i < content.length() {
            defer {
                i += 1
            }

            let c: unichar = content.characterAtIndex(i)

            if c >= '0' && c <= '9' {
                hasNumeric = true
            } else if self.alphanumericCode(c) != 1 {
                hasAlphanumeric = true
            } else {
                return ZXQRCodeMode.byteMode()
            }
        }

        if hasAlphanumeric {
            return ZXQRCodeMode.alphanumericMode()
        }

        if hasNumeric {
            return ZXQRCodeMode.numericMode()
        }

        return ZXQRCodeMode.byteMode()
    }
    @objc
    static func isOnlyDoubleByteKanji(_ content: String!) -> Bool {
        let data: NSData! = content.dataUsingEncoding(NSShiftJISStringEncoding)
        let bytes: UnsafeMutablePointer<int8_t>! = data.bytes() as? UnsafeMutablePointer<int8_t>
        let length: UInt = data.length()

        if length % 2 != 0 {
            return false
        }

        var i: CInt = 0

        while i < length {
            defer {
                i += 2
            }

            let byte1: CInt = bytes[i] & 0xff

            if (byte1 < 0x81 || byte1 > 0x9f) && (byte1 < 0xe0 || byte1 > 0xeb) {
                return false
            }
        }

        return true
    }
    @objc
    static func chooseMaskPattern(_ bits: ZXBitArray!, ecLevel: ZXQRCodeErrorCorrectionLevel!, version: ZXQRCodeVersion!, matrix: ZXByteMatrix!, error: UnsafeMutablePointer<Error?>!) -> CInt {
        var minPenalty: CInt = INT_MAX
        var bestMaskPattern: CInt = 1
        var maskPattern: CInt = 0

        while maskPattern < ZX_NUM_MASK_PATTERNS {
            defer {
                maskPattern += 1
            }

            if !ZXQRCodeMatrixUtil.buildMatrix(bits, ecLevel: ecLevel, version: version, maskPattern: maskPattern, matrix: matrix, error: error) {
                return 1
            }

            let penalty = self.calculateMaskPenalty(matrix)

            if penalty < minPenalty {
                minPenalty = penalty
                bestMaskPattern = maskPattern
            }
        }

        return bestMaskPattern
    }
    @objc
    static func chooseVersion(_ numInputBits: CInt, ecLevel: ZXQRCodeErrorCorrectionLevel!, error: UnsafeMutablePointer<Error?>!) -> ZXQRCodeVersion? {
        var versionNum: CInt = 1

        while versionNum <= 40 {
            defer {
                versionNum += 1
            }

            let version = ZXQRCodeVersion.versionForNumber(versionNum)

            if self.willFitIn(numInputBits, version: version, ecLevel: ecLevel) {
                return version
            }
        }

        let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Data too big"]

        if error != nil {
            error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
        }

        return nil
    }
    /**
 * @return true if the number of input bits will fit in a code with the specified version and
 * error correction level.
 */
    @objc
    static func willFitIn(_ numInputBits: CInt, version: ZXQRCodeVersion!, ecLevel: ZXQRCodeErrorCorrectionLevel!) -> Bool {
        // In the following comments, we use numbers of Version 7-H.
        // numBytes = 196
        let numBytes = version.totalCodewords
        // getNumECBytes = 130
        let ecBlocks = version.ecBlocksForLevel(ecLevel)
        let numEcBytes = ecBlocks?.totalECCodewords ?? 0
        // getNumDataBytes = 196 - 130 = 66
        let numDataBytes = numBytes - numEcBytes
        let totalInputBytes = (numInputBits + 7) / 8

        return numDataBytes >= totalInputBytes
    }
    @objc
    static func totalInputBytes(_ numInputBits: CInt, version: ZXQRCodeVersion!, mode: ZXQRCodeMode!) -> CInt {
        let modeInfoBits: CInt = 4
        let charCountBits = mode.characterCountBits(version)
        let headerBits = modeInfoBits + charCountBits
        let totalBits = numInputBits + headerBits

        return (totalBits + 7) / 8
    }
    /**
 * Terminate bits as described in 8.4.8 and 8.4.9 of JISX0510:2004 (p.24).
 */
    /**
 * Terminate bits as described in 8.4.8 and 8.4.9 of JISX0510:2004 (p.24).
 */
    @objc
    static func terminateBits(_ numDataBytes: CInt, bits: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        let capacity = numDataBytes * 8

        if bits.size > capacity {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: String(format: "data bits cannot fit in the QR Code %d > %d", bits.size(), capacity)]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return false
        }

        var i: CInt = 0

        while i < 4 && bits.size < capacity {
            defer {
                i += 1
            }

            bits.appendBit(false)
        }

        let numBitsInLastByte: CInt = bits.size & 0x7

        if numBitsInLastByte > 0 {
            var i = numBitsInLastByte

            while i < 8 {
                defer {
                    i += 1
                }

                bits.appendBit(false)
            }
        }

        let numPaddingBytes = numDataBytes - bits.sizeInBytes()
        var i: CInt = 0

        while i < numPaddingBytes {
            defer {
                i += 1
            }

            bits.appendBits(((i & 0x1) == 0) ? 0xec : 0x11, numBits: 8)
        }

        if bits.size != capacity {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Bits size does not equal capacity"]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return false
        }

        return true
    }
    /**
 * Get number of data bytes and number of error correction bytes for block id "blockID". Store
 * the result in "numDataBytesInBlock", and "numECBytesInBlock". See table 12 in 8.5.1 of
 * JISX0510:2004 (p.30)
 */
    /**
 * Get number of data bytes and number of error correction bytes for block id "blockID". Store
 * the result in "numDataBytesInBlock", and "numECBytesInBlock". See table 12 in 8.5.1 of
 * JISX0510:2004 (p.30)
 */
    @objc
    static func numDataBytesAndNumECBytesForBlockID(_ numTotalBytes: CInt, numDataBytes: CInt, numRSBlocks: CInt, blockID: CInt, numDataBytesInBlock: UnsafeMutablePointer<CInt>!, numECBytesInBlock: UnsafeMutablePointer<CInt>!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        if blockID >= numRSBlocks {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Block ID too large"]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return false
        }

        let numRsBlocksInGroup2 = numTotalBytes % numRSBlocks
        let numRsBlocksInGroup1 = numRSBlocks - numRsBlocksInGroup2
        let numTotalBytesInGroup1 = numTotalBytes / numRSBlocks
        let numTotalBytesInGroup2 = numTotalBytesInGroup1 + 1
        let numDataBytesInGroup1 = numDataBytes / numRSBlocks
        let numDataBytesInGroup2 = numDataBytesInGroup1 + 1
        let numEcBytesInGroup1 = numTotalBytesInGroup1 - numDataBytesInGroup1
        let numEcBytesInGroup2 = numTotalBytesInGroup2 - numDataBytesInGroup2

        if numEcBytesInGroup1 != numEcBytesInGroup2 {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "EC bytes mismatch"]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return false
        }

        if numRSBlocks != numRsBlocksInGroup1 + numRsBlocksInGroup2 {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "RS blocks mismatch"]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return false
        }

        if numTotalBytes != ((numDataBytesInGroup1 + numEcBytesInGroup1) * numRsBlocksInGroup1) + ((numDataBytesInGroup2 + numEcBytesInGroup2) * numRsBlocksInGroup2) {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Total bytes mismatch"]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return false
        }

        if blockID < numRsBlocksInGroup1 {
            numDataBytesInBlock[0] = numDataBytesInGroup1
            numECBytesInBlock[0] = numEcBytesInGroup1
        } else {
            numDataBytesInBlock[0] = numDataBytesInGroup2
            numECBytesInBlock[0] = numEcBytesInGroup2
        }

        return true
    }
    /**
 * Interleave "bits" with corresponding error correction bytes. On success, store the result in
 * "result". The interleave rule is complicated. See 8.6 of JISX0510:2004 (p.37) for details.
 */
    /**
 * Interleave "bits" with corresponding error correction bytes. On success, store the result in
 * "result". The interleave rule is complicated. See 8.6 of JISX0510:2004 (p.37) for details.
 */
    @objc
    static func interleaveWithECBytes(_ bits: ZXBitArray!, numTotalBytes: CInt, numDataBytes: CInt, numRSBlocks: CInt, error: UnsafeMutablePointer<Error?>!) -> ZXBitArray {
        // "bits" must have "getNumDataBytes" bytes of data.
        if bits.sizeInBytes() != numDataBytes {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Number of bits and data bytes does not match"]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return nil
        }

        // Step 1.  Divide data bytes into blocks and generate error correction bytes for them. We'll
        // store the divided data bytes blocks and error correction bytes blocks into "blocks".
        var dataBytesOffset: CInt = 0
        var maxNumDataBytes: CInt = 0
        var maxNumEcBytes: CInt = 0
        // Since, we know the number of reedsolmon blocks, we can initialize the vector with the number.
        let blocks: NSMutableArray! = NSMutableArray.arrayWithCapacity(numRSBlocks)
        var i: CInt = 0

        while i < numRSBlocks {
            defer {
                i += 1
            }

            let numDataBytesInBlock: UnsafeMutablePointer<CInt>!
            let numEcBytesInBlock: UnsafeMutablePointer<CInt>!

            if !self.numDataBytesAndNumECBytesForBlockID(numTotalBytes, numDataBytes: numDataBytes, numRSBlocks: numRSBlocks, blockID: i, numDataBytesInBlock: numDataBytesInBlock, numECBytesInBlock: numEcBytesInBlock, error: error) {
                return nil
            }

            let size: CInt = numDataBytesInBlock[0]
            let dataBytes = ZXByteArray(length: CUnsignedInt(size))

            bits.toBytes(8 * dataBytesOffset, array: dataBytes, offset: 0, numBytes: size)

            let ecBytes = self.generateECBytes(dataBytes, numEcBytesInBlock: numEcBytesInBlock[0])

            blocks.add(ZXQRCodeBlockPair(data: dataBytes, errorCorrection: ecBytes))

            maxNumDataBytes = max(maxNumDataBytes, size)

            maxNumEcBytes = max(maxNumEcBytes, numEcBytesInBlock[0])

            dataBytesOffset += numDataBytesInBlock[0]
        }

        if numDataBytes != dataBytesOffset {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Data bytes does not match offset"]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return nil
        }

        let result = ZXBitArray()
        var i: CInt = 0

        while i < maxNumDataBytes {
            defer {
                i += 1
            }

            for block in blocks {
                let dataBytes: ZXByteArray! = block.dataBytes
                let length: UInt = UInt(dataBytes.length)

                if i < length {
                    result.appendBits(dataBytes.array[i], numBits: 8)
                }
            }
        }

        var i: CInt = 0

        while i < maxNumEcBytes {
            defer {
                i += 1
            }

            for block in blocks {
                let ecBytes: ZXByteArray! = block.errorCorrectionBytes
                let length: CInt = CInt(ecBytes.length)

                if i < length {
                    result.appendBits(ecBytes.array[i], numBits: 8)
                }
            }
        }

        if numTotalBytes != result.sizeInBytes() {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: String(format: "Interleaving error: %d and %d differ.", numTotalBytes, result.sizeInBytes())]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return nil
        }

        return result
    }
    @objc
    static func generateECBytes(_ dataBytes: ZXByteArray!, numEcBytesInBlock: CInt) -> ZXByteArray {
        let numDataBytes: CInt = CInt(dataBytes.length)
        let toEncode = ZXIntArray(length: CUnsignedInt(numDataBytes + numEcBytesInBlock))
        var i: CInt = 0

        while i < numDataBytes {
            defer {
                i += 1
            }

            toEncode.array[i] = dataBytes.array[i] & 0xff
        }

        ZXReedSolomonEncoder(field: ZXGenericGF.QrCodeField256()).encode(toEncode, ecBytes: numEcBytesInBlock)

        let ecBytes = ZXByteArray(length: CUnsignedInt(numEcBytesInBlock))
        var i: CInt = 0

        while i < numEcBytesInBlock {
            defer {
                i += 1
            }

            ecBytes.array[i] = toEncode.array[numDataBytes + i] as? int8_t
        }

        return ecBytes
    }
    /**
 * Append mode info. On success, store the result in "bits".
 */
    /**
 * Append mode info. On success, store the result in "bits".
 */
    @objc
    static func appendModeInfo(_ mode: ZXQRCodeMode!, bits: ZXBitArray!) {
        bits.appendBits(mode.bits(), numBits: 4)
    }
    /**
 * Append length info. On success, store the result in "bits".
 */
    /**
 * Append length info. On success, store the result in "bits".
 */
    /**
 * Append length info. On success, store the result in "bits".
 */
    @objc
    static func appendLengthInfo(_ numLetters: CInt, version: ZXQRCodeVersion!, mode: ZXQRCodeMode!, bits: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        let numBits = mode.characterCountBits(version)

        if numLetters >= (1 << numBits) {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: String(format: "%d is bigger than %d", numLetters, (1 << numBits) - 1)]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return false
        }

        bits.appendBits(numLetters, numBits: numBits)

        return true
    }
    /**
 * Append "bytes" in "mode" mode (encoding) into "bits". On success, store the result in "bits".
 */
    /**
 * Append "bytes" in "mode" mode (encoding) into "bits". On success, store the result in "bits".
 */
    @objc
    static func appendBytes(_ content: String!, mode: ZXQRCodeMode!, bits: ZXBitArray!, encoding: NSStringEncoding, error: UnsafeMutablePointer<Error?>!) -> Bool {
        if mode.isEqual(ZXQRCodeMode.numericMode()) {
            self.appendNumericBytes(content, bits: bits)
        } else if mode.isEqual(ZXQRCodeMode.alphanumericMode()) {
            if !self.appendAlphanumericBytes(content, bits: bits, error: error) {
                return false
            }
        } else if mode.isEqual(ZXQRCodeMode.byteMode()) {
            self.append8BitBytes(content, bits: bits, encoding: encoding)
        } else if mode.isEqual(ZXQRCodeMode.kanjiMode()) {
            if !self.appendKanjiBytes(content, bits: bits, error: error) {
                return false
            }
        } else {
            let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: String(format: "Invalid mode: %@", mode)]

            if error != nil {
                error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
            }

            return false
        }

        return true
    }
    @objc
    static func appendNumericBytes(_ content: String!, bits: ZXBitArray!) {
        let length: UInt = content.length()
        var i: CInt = 0

        while i < length {
            let num1: CInt = content.characterAtIndex(i) - '0'

            if i + 2 < length {
                let num2: CInt = content.characterAtIndex(i + 1) - '0'
                let num3: CInt = content.characterAtIndex(i + 2) - '0'

                bits.appendBits(num1 * 100 + num2 * 10 + num3, numBits: 10)
                i += 3
            } else if i + 1 < length {
                let num2: CInt = content.characterAtIndex(i + 1) - '0'

                bits.appendBits(num1 * 10 + num2, numBits: 7)
                i += 2
            } else {
                bits.appendBits(num1, numBits: 4)
                i += 1
            }
        }
    }
    @objc
    static func appendAlphanumericBytes(_ content: String!, bits: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        let length: UInt = content.length()
        var i: CInt = 0

        while i < length {
            let code1 = self.alphanumericCode(content.characterAtIndex(i))

            if code1 == 1 {
                if error != nil {
                    error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: nil)
                }

                return false
            }

            if i + 1 < length {
                let code2 = self.alphanumericCode(content.characterAtIndex(i + 1))

                if code2 == 1 {
                    if error != nil {
                        error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: nil)
                    }

                    return false
                }

                bits.appendBits(code1 * 45 + code2, numBits: 11)
                i += 2
            } else {
                bits.appendBits(code1, numBits: 6)
                i += 1
            }
        }

        return true
    }
    @objc
    static func append8BitBytes(_ content: String!, bits: ZXBitArray!, encoding: NSStringEncoding) {
        let data: NSData! = content.dataUsingEncoding(encoding)
        let bytes: UnsafeMutablePointer<int8_t>! = data.bytes() as? UnsafeMutablePointer<int8_t>
        var i: CInt = 0

        while i < data.length() {
            defer {
                i += 1
            }

            bits.appendBits(bytes[i], numBits: 8)
        }
    }
    @objc
    static func appendKanjiBytes(_ content: String!, bits: ZXBitArray!, error: UnsafeMutablePointer<Error?>!) -> Bool {
        let data: NSData! = content.dataUsingEncoding(NSShiftJISStringEncoding)
        let bytes: UnsafeMutablePointer<int8_t>! = data.bytes() as? UnsafeMutablePointer<int8_t>
        var i: CInt = 0

        while i < data.length() {
            defer {
                i += 2
            }

            let byte1: CInt = bytes[i] & 0xff
            let byte2: CInt = bytes[i + 1] & 0xff
            let code = (byte1 << 8) | byte2
            var subtracted: CInt = 1

            if code >= 0x8140 && code <= 0x9ffc {
                subtracted = code - 0x8140
            } else if code >= 0xe040 && code <= 0xebbf {
                subtracted = code - 0xc140
            }

            if subtracted == 1 {
                let userInfo: NSDictionary! = [NSLocalizedDescriptionKey: "Invalid byte sequence"]

                if error != nil {
                    error.pointee = Error(domain: ZXErrorDomain, code: ZXWriterError, userInfo: userInfo)
                }

                return false
            }

            let encoded = ((subtracted >> 8) * 0xc0) + (subtracted & 0xff)

            bits.appendBits(encoded, numBits: 13)
        }

        return true
    }
    @objc
    static func appendECI(_ eci: ZXCharacterSetECI!, bits: ZXBitArray!) {
        bits.appendBits(ZXQRCodeMode.eciMode().bits(), numBits: 4)
        bits.appendBits(eci.value(), numBits: 8)
    }
}