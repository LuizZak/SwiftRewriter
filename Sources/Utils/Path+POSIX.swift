import Foundation

func expandTildes(path: String) -> String {
    return (path as NSString).expandingTildeInPath
}
