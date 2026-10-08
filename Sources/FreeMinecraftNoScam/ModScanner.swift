import Foundation

struct ModScanner {
    func scan(url: URL) throws -> ModInfo {
        let name = url.deletingPathExtension().lastPathComponent
        let data = try Data(contentsOf: url)
        guard data.count >= 4, data[0] == 0x50, data[1] == 0x4B else { throw ScannerError.notZip }
        let lower = name.lowercased()
        let loader = lower.contains("neoforge") ? "NeoForge" : lower.contains("forge") ? "Forge" : lower.contains("fabric") ? "Fabric" : "Unknown"
        return ModInfo(modID: name, name: name, version: "Unknown", loader: loader, fileName: url.lastPathComponent)
    }
    enum ScannerError: LocalizedError {
        case notZip
        var errorDescription: String? { "The selected file is not a readable JAR/ZIP archive." }
    }
}
