import Foundation

func expandTildes(path: String) -> String {
    (path as NSString).expandingTildeInPath
}
