import Foundation

struct CompatibilityEngine {
    func check(instance: MinecraftInstance) -> CompatibilityReport {
        var r = CompatibilityReport()
        if instance.version == "Unknown" || instance.version == "Import a version" { r.errors.append("Minecraft version has not been imported.") }
        else { r.passed.append("Minecraft version is configured.") }
        if instance.loader == "Not configured" { r.errors.append("Mod loader is not configured.") }
        else { r.passed.append("Loader is configured.") }
        for mod in instance.mods where mod.enabled {
            if mod.loader != "Unknown" && mod.loader != instance.loader && instance.loader != "Vanilla" {
                r.warnings.append("\(mod.name): loader metadata may not match the instance.")
            }
            if !mod.dependencies.isEmpty { r.warnings.append("\(mod.name): dependency validation requires dependency metadata.") }
        }
        return r
    }
}
