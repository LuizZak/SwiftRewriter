// Preprocessor directives found in file:
// #import "ZXByteMatrix.h"
// #import "ZXQRCode.h"
// #import "ZXQRCodeErrorCorrectionLevel.h"
// #import "ZXQRCodeMode.h"
let ZX_NUM_MASK_PATTERNS: CInt = 8

@objc
class ZXQRCode: NSObject {
    private var _mode: ZXQRCodeMode!
    private var _ecLevel: ZXQRCodeErrorCorrectionLevel!
    private var _version: ZXQRCodeVersion!
    private var _maskPattern: CInt = 0
    private var _matrix: ZXByteMatrix!
    @objc var mode: ZXQRCodeMode! {
        get {
            return self._mode
        }
        set {
            self._mode = newValue
        }
    }
    @objc var ecLevel: ZXQRCodeErrorCorrectionLevel! {
        get {
            return self._ecLevel
        }
        set {
            self._ecLevel = newValue
        }
    }
    @objc var version: ZXQRCodeVersion! {
        get {
            return self._version
        }
        set {
            self._version = newValue
        }
    }
    @objc var maskPattern: CInt {
        get {
            return self._maskPattern
        }
        set {
            self._maskPattern = newValue
        }
    }
    @objc var matrix: ZXByteMatrix! {
        get {
            return self._matrix
        }
        set {
            self._matrix = newValue
        }
    }

    @objc
    override init() {
        if self = super.init() {
            _mode = nil

            _ecLevel = nil

            _version = nil

            _maskPattern = 1

            _matrix = nil
        }

        return self
    }

    @objc
    func description() -> String? {
        let result = NSMutableString(capacity: 200)

        result.appendFormat("<<\\n mode: %@", self.mode)
        result.appendFormat("\\n ecLevel: %@", self.ecLevel)
        result.appendFormat("\\n version: %@", self.version)
        result.appendFormat("\\n maskPattern: %d", self.maskPattern)

        if self.matrix == nil {
            result.append("\\n matrix: (null)\\n")
        } else {
            result.appendFormat("\\n matrix:\\n%@", self.matrix.description())
        }

        result.append(">>\\n")

        return String.stringWithString(result)
    }
    // Check if "mask_pattern" is valid.
    @objc
    static func isValidMaskPattern(_ maskPattern: CInt) -> Bool {
        return maskPattern >= 0 && maskPattern < ZX_NUM_MASK_PATTERNS
    }
}