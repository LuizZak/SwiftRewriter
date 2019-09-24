import SPMUtility

enum Target: String, ArgumentKind {
    case stdout
    case filedisk
    
    init(argument: String) throws {
        if let value = Target(rawValue: argument) {
            self = value
        } else {
            throw ArgumentParserError.invalidValue(
                argument: argument,
                error: ArgumentConversionError.custom("Expected either 'stdout' or 'filedisk'")
            )
        }
    }
    
    static var completion: ShellCompletion {
        ShellCompletion.values([
            ("terminal", "Prints output of conversion to the terminal's standard output."),
            ("filedisk", """
                Saves output of conversion to the filedisk as .swift files on the same folder as the input files.
                """)
            ])
    }
}
