
import Foundation

func createDirectoryIfNotExists(at url: URL) throws {
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: url.path) {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
}
