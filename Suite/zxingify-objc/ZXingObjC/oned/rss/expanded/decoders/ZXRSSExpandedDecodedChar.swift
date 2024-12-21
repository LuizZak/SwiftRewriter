// Preprocessor directives found in file:
// #import "ZXRSSExpandedDecodedObject.h"
// #import "ZXRSSExpandedDecodedChar.h"
let ZX_FNC1_CHAR: unichar = '$'

// It's not in Alphanumeric neither in ISO/IEC 646 charset
@objc
class ZXRSSExpandedDecodedChar: ZXRSSExpandedDecodedObject {
    private var _value: unichar
    @objc var value: unichar {
        return self._value
    }

    @objc
    init(newPosition: CInt, value: unichar) {
        if self = super.init(newPosition: newPosition) {
            _value = value
        }

        return self
    }

    @objc
    func fnc1() -> Bool {
        return self.value == ZX_FNC1_CHAR
    }
}