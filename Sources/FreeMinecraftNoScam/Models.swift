import Foundation

struct MinecraftInstance: Identifiable, Codable {
    let id: UUID
    var name: String
    var version: String
    var loader: String
    var gameURL: URL?
    var mods: [ModInfo]
    var status: InstanceStatus

    init(id: UUID = UUID(), name: String, version: String, loader: String, gameURL: URL? = nil, mods: [ModInfo] = [], status: InstanceStatus = .needsImport) {
        self.id = id; self.name = name; self.version = version; self.loader = loader
        self.gameURL = gameURL; self.mods = mods; self.status = status
    }
}

enum InstanceStatus: String, Codable {
    case needsImport, ready, warning
    var title: String {
        switch self { case .needsImport: return "Needs Import"; case .ready: return "Ready"; case .warning: return "Needs Attention" }
    }
}

struct ModInfo: Identifiable, Codable {
    let id: UUID
    var modID: String
    var name: String
    var version: String
    var loader: String
    var minecraftVersions: [String]
    var dependencies: [String]
    var fileName: String
    var enabled: Bool

    init(id: UUID = UUID(), modID: String, name: String, version: String, loader: String, minecraftVersions: [String] = [], dependencies: [String] = [], fileName: String, enabled: Bool = true) {
        self.id = id; self.modID = modID; self.name = name; self.version = version; self.loader = loader
        self.minecraftVersions = minecraftVersions; self.dependencies = dependencies; self.fileName = fileName; self.enabled = enabled
    }
}

struct CompatibilityReport: Codable {
    var errors: [String] = []
    var warnings: [String] = []
    var passed: [String] = []
    var isLaunchable: Bool { errors.isEmpty }
}
