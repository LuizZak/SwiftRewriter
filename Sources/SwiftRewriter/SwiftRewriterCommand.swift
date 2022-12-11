import ArgumentParser
import Foundation
import Console
import ObjectiveCFrontend

struct SwiftRewriterCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "SwiftRewriter",
        discussion: """
        Main frontend API for SwiftRewriter. Allows selection of specific source \
        language modes.
        """,
        subcommands: [ObjectiveCCommand.self, JavaScriptCommand.self],
        defaultSubcommand: ObjectiveCCommand.self
    )
    
    func run() throws {
        
    }
}
