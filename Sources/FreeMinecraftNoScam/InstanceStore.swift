import Foundation
import Combine

@MainActor
final class InstanceStore: ObservableObject {
    @Published private(set) var instances: [MinecraftInstance] = []
    private let fileManager = FileManager.default

    init() { load() }

    private var storeURL: URL {
        let base = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? fileManager.createDirectory(at: base, withIntermediateDirectories: true)
        return base.appendingPathComponent("instances.json")
    }

    func add(_ instance: MinecraftInstance) { instances.append(instance); save() }
    func update(_ instance: MinecraftInstance) {
        if let i = instances.firstIndex(where: { $0.id == instance.id }) { instances[i] = instance; save() }
    }
    private func load() {
        guard let data = try? Data(contentsOf: storeURL),
              let value = try? JSONDecoder().decode([MinecraftInstance].self, from: data) else { return }
        instances = value
    }
    private func save() {
        if let data = try? JSONEncoder().encode(instances) { try? data.write(to: storeURL, options: .atomic) }
    }
}
