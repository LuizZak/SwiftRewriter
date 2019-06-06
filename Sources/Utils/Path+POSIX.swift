import Foundation

func expandTildes(path: String) -> String {
    return URL(fileURLWithPath: path).standardizedFileURL.absoluteString
}
