import Foundation

/// Unix-compatible stopwatch system
public class Stopwatch {
    var start: timespec = timespec()
    
    private init() {
        if #available(OSX 10.12, *) {
            clock_gettime(CLOCK_MONOTONIC_RAW, &start)
        } else {
            fatalError()
        }
    }
    
    public func stop() -> TimeInterval {
        var end: timespec = timespec()
        if #available(OSX 10.12, *) {
            clock_gettime(CLOCK_MONOTONIC_RAW, &end)
        } else {
            fatalError()
        }
        
        let delta_us = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_nsec - start.tv_nsec) / 1000
        
        return TimeInterval(delta_us) / 1_000_000
    }
    
    public static func start() -> Stopwatch {
        Stopwatch()
    }
}
