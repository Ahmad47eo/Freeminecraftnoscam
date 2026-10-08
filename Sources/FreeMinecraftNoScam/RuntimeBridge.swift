import Foundation

protocol MinecraftRuntime {
    func launch(instance: MinecraftInstance) async throws
}

struct UnconfiguredRuntime: MinecraftRuntime {
    func launch(instance: MinecraftInstance) async throws {
        throw RuntimeError.notInstalled
    }
    enum RuntimeError: LocalizedError {
        case notInstalled
        var errorDescription: String? {
            "No compatible Java/Minecraft runtime backend is installed yet. Importing and scanning are available, but gameplay runtime integration is still required."
        }
    }
}
