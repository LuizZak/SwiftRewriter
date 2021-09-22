#if os(Windows)

import Foundation
import WinSDK

class Stopwatch {
    static let frequency: LARGE_INTEGER = { 
        var ret: LARGE_INTEGER
        ret = LARGE_INTEGER()

        QueryPerformanceFrequency(&ret)
        
        return ret
    }()

    var start: LARGE_INTEGER = LARGE_INTEGER()
    
    private init() {
        QueryPerformanceCounter(&start)
    }
    
    func stop() -> TimeInterval {
        var end: LARGE_INTEGER = LARGE_INTEGER()
        QueryPerformanceCounter(&end)

        let delta_us = (end.QuadPart - start.QuadPart) / Self.frequency.QuadPart
        
        return TimeInterval(delta_us) / 1_000_000
    }
    
    static func start() -> Stopwatch {
        Stopwatch()
    }
}

#endif
