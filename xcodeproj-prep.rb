require 'xcodeproj'

swift_async_flags = ["-Xfrontend", "-enable-experimental-concurrency", "-Xfrontend", "-disable-availability-checking"]
release_mode_targets = ["Antlr4", "ObjcParserAntlr", "SwiftSyntax"]

project_path = 'SwiftRewriter.xcodeproj'
# @type [Xcodeproj::Project]
project = Xcodeproj::Project.open(project_path)

configurations = project.build_configurations

puts "Checking if concurrency is enabled..."

configurations.each do |config|
    # @type [String]
    other_flags = project.build_settings(config.name)["OTHER_SWIFT_FLAGS"]

    if !other_flags.include?(swift_async_flags)
        puts "Concurrency is disabled for config #{config.name}, enabling..."
        
        other_flags.concat(swift_async_flags)
        project.build_settings(config.name)["OTHER_SWIFT_FLAGS"] = other_flags
    end
end

puts "Done!"

puts "Marking targets #{release_mode_targets} to compile in optimized mode ..."

configurations.each do |config|
    project.targets.each do |target|
        if release_mode_targets.include?(target.name)
            target.build_settings(config.name)["SWIFT_OPTIMIZATION_LEVEL"] = "-O"
        end
    end
end

puts "Done!"

project.save
