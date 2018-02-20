// This code is based off Vapor's Console library
//
// http://github.com/vapor/console
//

public enum Terminal {

}

public extension Terminal {
    /**
        Available terminal commands.
    */
    enum Command {
        case moveHome
        case eraseScreen
        case eraseLine
        case cursorUp
    }
}

public extension Terminal.Command {
    /**
        Converts the command to its ansi code.
    */
    public var ansi: String {
        switch self {
        case .moveHome:
            return "H".ansi
        case .cursorUp:
            return "1A".ansi
        case .eraseScreen:
            return "2J".ansi
        case .eraseLine:
            return "2K".ansi
        }
    }
}