// Preprocessor directives found in file:
// #import "ZXRSSExpandedDecodedObject.h"
// #import "ZXRSSExpandedDecodedNumeric.h"
let ZX_FNC1_INT: CInt = 10

@objc
class ZXRSSExpandedDecodedNumeric: ZXRSSExpandedDecodedObject {
    private var _firstDigit: CInt = 0
    private var _secondDigit: CInt = 0
    @objc var firstDigit: CInt {
        return self._firstDigit
    }
    @objc var secondDigit: CInt {
        return self._secondDigit
    }
    @objc var value: CInt {
        return self.firstDigit * 10 + self.secondDigit
    }

    @objc
    init?(newPosition: CInt, firstDigit: CInt, secondDigit: CInt) {
        if firstDigit < 0 || firstDigit > 10 || secondDigit < 0 || secondDigit > 10 {
            return nil
        }

        if self = super.init(newPosition: newPosition) {
            _firstDigit = firstDigit
            _secondDigit = secondDigit
        }

        return self
    }

    @objc
    func firstDigitFNC1() -> Bool {
        return self.firstDigit == ZX_FNC1_INT
    }
    @objc
    func secondDigitFNC1() -> Bool {
        return self.secondDigit == ZX_FNC1_INT
    }
    @objc
    func anyFNC1() -> Bool {
        return self.firstDigit == ZX_FNC1_INT || self.secondDigit == ZX_FNC1_INT
    }
}