import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #define ZX_AZTEC_SHIFT_TABLE_SIZE 6
// #import "ZXAztecHighLevelEncoder.h"
// #import "ZXAztecState.h"
// #import "ZXByteArray.h"
var ZX_AZTEC_MODE_NAMES: NSArray! = nil
let ZX_AZTEC_MODE_UPPER: CInt = 0
let ZX_AZTEC_MODE_LOWER: CInt = 1
let ZX_AZTEC_MODE_DIGIT: CInt = 2
let ZX_AZTEC_MODE_MIXED: CInt = 3
let ZX_AZTEC_MODE_PUNCT: CInt = 4
var ZX_AZTEC_LATCH_TABLE: (CInt, CInt, CInt, CInt, CInt)
let ZX_AZTEC_CHAR_MAP_HEIGHT: CInt = 5
let ZX_AZTEC_CHAR_MAP_WIDTH: CInt = 256
var ZX_AZTEC_CHAR_MAP: UnsafeMutablePointer<CInt>!
var ZX_AZTEC_SHIFT_TABLE: UnsafeMutablePointer<CInt>!
let ZX_AZTEC_SHIFT_TABLE_SIZE: Int = 6

/**
 * This produces nearly optimal encodings of text into the first-level of
 * encoding used by Aztec code.
 *
 * It uses a dynamic algorithm.  For each prefix of the string, it determines
 * a set of encodings that could lead to this prefix.  We repeatedly add a
 * character and generate a new set of optimal encodings until we have read
 * through the entire input.
 */
/**
 * This produces nearly optimal encodings of text into the first-level of
 * encoding used by Aztec code.
 *
 * It uses a dynamic algorithm.  For each prefix of the string, it determines
 * a set of encodings that could lead to this prefix.  We repeatedly add a
 * character and generate a new set of optimal encodings until we have read
 * through the entire input.
 */
@objc
class ZXAztecHighLevelEncoder: NSObject {
    private unowned(unsafe) var _text: ZXByteArray!

    @objc
    init(text: ZXByteArray!) {
        if self = super.init() {
            _text = text
        }

        return self
    }

    @objc
    static func load() {
        ZX_AZTEC_MODE_NAMES = ["UPPER", "LOWER", "DIGIT", "MIXED", "PUNCT"]
        memset(ZX_AZTEC_CHAR_MAP, 0, Int(ZX_AZTEC_CHAR_MAP_HEIGHT * ZX_AZTEC_CHAR_MAP_WIDTH) * MemoryLayout<CInt>.size)
        ZX_AZTEC_CHAR_MAP[ZX_AZTEC_MODE_UPPER][' '] = 1

        var c: CInt = 'A'

        while c <= 'Z' {
            defer {
                c += 1
            }

            ZX_AZTEC_CHAR_MAP[ZX_AZTEC_MODE_UPPER][c] = c - 'A' + 2
        }

        ZX_AZTEC_CHAR_MAP[ZX_AZTEC_MODE_LOWER][' '] = 1

        var c: CInt = 'a'

        while c <= 'z' {
            defer {
                c += 1
            }

            ZX_AZTEC_CHAR_MAP[ZX_AZTEC_MODE_LOWER][c] = c - 'a' + 2
        }

        ZX_AZTEC_CHAR_MAP[ZX_AZTEC_MODE_DIGIT][' '] = 1

        var c: CInt = '0'

        while c <= '9' {
            defer {
                c += 1
            }

            ZX_AZTEC_CHAR_MAP[ZX_AZTEC_MODE_DIGIT][c] = c - '0' + 2
        }

        ZX_AZTEC_CHAR_MAP[ZX_AZTEC_MODE_DIGIT][','] = 12
        ZX_AZTEC_CHAR_MAP[ZX_AZTEC_MODE_DIGIT]['.'] = 13

        let mixedTable: UnsafePointer<CInt>!
        var i: CInt = 0

        while i < MemoryLayout.size(ofValue: mixedTable) / MemoryLayout<CInt>.size {
            defer {
                i += 1
            }

            ZX_AZTEC_CHAR_MAP[ZX_AZTEC_MODE_MIXED][mixedTable[i]] = i
        }

        let punctTable: UnsafePointer<CInt>!
        var i: CInt = 0

        while i < MemoryLayout.size(ofValue: punctTable) / MemoryLayout<CInt>.size {
            defer {
                i += 1
            }

            if punctTable[i] > 0 {
                ZX_AZTEC_CHAR_MAP[ZX_AZTEC_MODE_PUNCT][punctTable[i]] = i
            }
        }

        memset(ZX_AZTEC_SHIFT_TABLE, 1, ZX_AZTEC_SHIFT_TABLE_SIZE * ZX_AZTEC_SHIFT_TABLE_SIZE * MemoryLayout<CInt>.size)

        ZX_AZTEC_SHIFT_TABLE[ZX_AZTEC_MODE_UPPER][ZX_AZTEC_MODE_PUNCT] = 0
        ZX_AZTEC_SHIFT_TABLE[ZX_AZTEC_MODE_LOWER][ZX_AZTEC_MODE_PUNCT] = 0
        ZX_AZTEC_SHIFT_TABLE[ZX_AZTEC_MODE_LOWER][ZX_AZTEC_MODE_UPPER] = 28
        ZX_AZTEC_SHIFT_TABLE[ZX_AZTEC_MODE_MIXED][ZX_AZTEC_MODE_PUNCT] = 0
        ZX_AZTEC_SHIFT_TABLE[ZX_AZTEC_MODE_DIGIT][ZX_AZTEC_MODE_PUNCT] = 0
        ZX_AZTEC_SHIFT_TABLE[ZX_AZTEC_MODE_DIGIT][ZX_AZTEC_MODE_UPPER] = 15
    }
    /**
 * @return text represented by this encoder encoded as a ZXBitArray
 */
    /**
 * @return text represented by this encoder encoded as a ZXBitArray
 */
    @objc
    func encode() -> ZXBitArray {
        var states: NSArray = [ZXAztecState.initialState()]
        var index: CInt = 0

        while index < (self.text.length ?? 0) {
            defer {
                index += 1
            }

            var pairCode: CInt
            let nextChar: CInt = (index + 1 < (self.text.length ?? 0)) ? self.text.array[index + 1] : 0

            switch self.text.array[index] {
            case '\r':
                pairCode = (nextChar == '\n') ? 2 : 0
            case '.':
                pairCode = (nextChar == ' ') ? 3 : 0
            case ',':
                pairCode = (nextChar == ' ') ? 4 : 0
            case ':':
                pairCode = (nextChar == ' ') ? 5 : 0
            default:
                pairCode = 0
            }

            if pairCode > 0 {
                // We have one of the four special PUNCT pairs.  Treat them specially.
                // Get a new set of states for the two new characters.
                states = self.updateStateListForPair(states, index: index, pairCode: pairCode)
                index += 1
            } else {
                // Get a new set of states for the new character.
                states = self.updateStateListForChar(states, index: index)
            }
        }

        // We are left with a set of states.  Find the shortest one.
        let minState: ZXAztecState! = states.sortedArrayUsingComparator { (a: ZXAztecState!, b: ZXAztecState!) -> ComparisonResult in
            return a.bitCount - b.bitCount
        }.firstObject()

        // Convert it to a bit array, and return.
        return minState.toBitArray(self.text)
    }
    // We update a set of states for a new character by updating each state
    // for the new character, merging the results, and then removing the
    // non-optimal states.
    @objc
    func updateStateListForChar(_ states: NSArray!, index: CInt) -> NSArray {
        let result = NSMutableArray()

        for state in states {
            self.updateStateForChar(state, index: index, result: result)
        }

        return self.simplifyStates(result)
    }
    // Return a set of states that represent the possible ways of updating this
    // state for the next character.  The resulting set of states are added to
    // the "result" list.
    @objc
    func updateStateForChar(_ state: ZXAztecState!, index: CInt, result: NSMutableArray!) {
        let ch: unichar = (self.text.array[index] & 0xff) as? unichar
        let charInCurrentTable = ZX_AZTEC_CHAR_MAP[state.mode][ch] > 0
        var stateNoBinary: ZXAztecState! = nil
        var mode: CInt = 0

        while mode <= ZX_AZTEC_MODE_PUNCT {
            defer {
                mode += 1
            }

            let charInMode: CInt = ZX_AZTEC_CHAR_MAP[mode][ch]

            if charInMode > 0 {
                if stateNoBinary == nil {
                    // Only create stateNoBinary the first time it's required.
                    stateNoBinary = state.endBinaryShift(index)
                }

                // Try generating the character by latching to its mode
                if !charInCurrentTable || mode == state.mode || mode == ZX_AZTEC_MODE_DIGIT {
                    // If the character is in the current table, we don't want to latch to
                    // any other mode except possibly digit (which uses only 4 bits).  Any
                    // other latch would be equally successful *after* this character, and
                    // so wouldn't save any bits.
                    let latch_state = stateNoBinary?.latchAndAppend(mode, value: charInMode)

                    if let latch_state = latch_state {
                        result.add(latch_state)
                    }
                }

                // Try generating the character by switching to its mode.
                if !charInCurrentTable && ZX_AZTEC_SHIFT_TABLE[state.mode][mode] >= 0 {
                    // It never makes sense to temporarily shift to another mode if the
                    // character exists in the current mode.  That can never save bits.
                    let shift_state = stateNoBinary?.shiftAndAppend(mode, value: charInMode)

                    if let shift_state = shift_state {
                        result.add(shift_state)
                    }
                }
            }
        }

        if state.binaryShiftByteCount > 0 || ZX_AZTEC_CHAR_MAP[state.mode][ch] == 0 {
            // It's never worthwhile to go into binary shift mode if you're not already
            // in binary shift mode, and the character exists in your current mode.
            // That can never save bits over just outputting the char in the current mode.
            let binaryState = state.addBinaryShiftChar(index)

            result.add(binaryState)
        }
    }
    @objc
    func updateStateListForPair(_ states: NSArray!, index: CInt, pairCode: CInt) -> NSArray {
        let result = NSMutableArray()

        for state in states {
            self.updateStateForPair(state, index: index, pairCode: pairCode, result: result)
        }

        return self.simplifyStates(result)
    }
    @objc
    func updateStateForPair(_ state: ZXAztecState!, index: CInt, pairCode: CInt, result: NSMutableArray!) {
        let stateNoBinary = state.endBinaryShift(index)

        // Possibility 1.  Latch to ZX_AZTEC_MODE_PUNCT, and then append this code
        result.add(stateNoBinary?.latchAndAppend(ZX_AZTEC_MODE_PUNCT, value: pairCode))

        if state.mode != ZX_AZTEC_MODE_PUNCT {
            // Possibility 2.  Shift to ZX_AZTEC_MODE_PUNCT, and then append this code.
            // Every state except ZX_AZTEC_MODE_PUNCT (handled above) can shift
            result.add(stateNoBinary?.shiftAndAppend(ZX_AZTEC_MODE_PUNCT, value: pairCode))
        }

        if pairCode == 3 || pairCode == 4 {
            // both characters are in DIGITS.  Sometimes better to just add two digits
            let digit_state = stateNoBinary?.latchAndAppend(ZX_AZTEC_MODE_DIGIT, value: 16 - pairCode).latchAndAppend(ZX_AZTEC_MODE_DIGIT, value: 1) // space in DIGIT

            if let digit_state = digit_state {
                result.add(digit_state)
            }
        }

        if state.binaryShiftByteCount > 0 {
            // It only makes sense to do the characters as binary if we're already
            // in binary mode.
            let binaryState = state.addBinaryShiftChar(index).addBinaryShiftChar(index + 1)

            result.add(binaryState)
        }
    }
    @objc
    func simplifyStates(_ states: NSArray!) -> NSArray {
        let result = NSMutableArray()

        for newState in states {
            var add = true
            let resultCopy: NSArray! = NSArray.arrayWithArray(result)

            for oldState in resultCopy {
                if oldState.isBetterThanOrEqualTo(newState) {
                    add = false

                    break
                }

                if newState.isBetterThanOrEqualTo(oldState) {
                    result.remove(oldState)
                }
            }

            if add {
                result.add(newState)
            }
        }

        return result
    }
}

// MARK: -
@objc
extension ZXAztecHighLevelEncoder {
    @objc unowned(unsafe) var text: ZXByteArray! {
        return self._text
    }
}