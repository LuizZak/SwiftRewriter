import ArgumentParser

enum Target: String, Codable {
    case stdout
    case filedisk
}

extension Target: ExpressibleByArgument {
    init?(argument: String) {
        if let value = Target(rawValue: argument) {
            self = value
        } else {
            return nil
        }
    }
}
