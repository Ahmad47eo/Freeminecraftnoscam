import SwiftUI

@main
struct FreeMinecraftNoScamApp: App {
    @StateObject private var store = LauncherStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

final class LauncherStore: ObservableObject {
    @Published var instances: [MinecraftInstance] = [
        MinecraftInstance(name: "My Minecraft", version: "Import a version", loader: "Not configured", status: .needsImport)
    ]
    @Published var selectedTab = 0

    func addImportedInstance(name: String, version: String, loader: String) {
        instances.append(MinecraftInstance(name: name, version: version, loader: loader, status: .ready))
    }
}

struct MinecraftInstance: Identifiable {
    let id = UUID()
    let name: String
    let version: String
    let loader: String
    let status: InstanceStatus
}

enum InstanceStatus {
    case needsImport, ready, warning
    var title: String {
        switch self {
        case .needsImport: return "Needs Import"
        case .ready: return "Ready"
        case .warning: return "Needs Attention"
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var store: LauncherStore
    var body: some View {
        TabView(selection: $store.selectedTab) {
            NavigationStack { HomeView() }.tabItem { Label("Play", systemImage: "play.fill") }.tag(0)
            NavigationStack { InstancesView() }.tabItem { Label("Instances", systemImage: "square.stack.3d.up") }.tag(1)
            NavigationStack { ModsView() }.tabItem { Label("Mods", systemImage: "puzzlepiece.extension") }.tag(2)
            NavigationStack { SettingsView() }.tabItem { Label("Settings", systemImage: "gearshape") }.tag(3)
        }
    }
}

struct HomeView: View {
    @EnvironmentObject private var store: LauncherStore
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("FreeMinecraftNoScam").font(.largeTitle.bold())
                    Text("Minecraft Java launcher foundation for iPhone and iPad.").foregroundStyle(.secondary)
                    Button { store.selectedTab = 1 } label: { Label("Import Minecraft Version", systemImage: "square.and.arrow.down") }.buttonStyle(.borderedProminent)
                }.padding(.vertical, 8)
            }
            Section("Instances") { ForEach(store.instances) { instance in InstanceRow(instance: instance) } }
            Section("Systems") {
                FeatureRow(icon: "gamecontroller", title: "Touch + controller input")
                FeatureRow(icon: "speedometer", title: "Performance profiles")
                FeatureRow(icon: "checkmark.shield", title: "Compatibility checker")
                FeatureRow(icon: "doc.text.magnifyingglass", title: "Crash diagnostics")
                FeatureRow(icon: "puzzlepiece.extension", title: "Fabric / Forge / NeoForge mods")
            }
        }.navigationTitle("Launcher")
    }
}

struct InstancesView: View {
    @EnvironmentObject private var store: LauncherStore
    @State private var showingImport = false
    var body: some View {
        List {
            Section { Button { showingImport = true } label: { Label("Import Version", systemImage: "plus") } }
            Section("Your instances") { ForEach(store.instances) { instance in NavigationLink { InstanceDetailView(instance: instance) } label: { InstanceRow(instance: instance) } } }
        }.navigationTitle("Instances").sheet(isPresented: $showingImport) { ImportView() }
    }
}

struct InstanceDetailView: View {
    let instance: MinecraftInstance
    var body: some View {
        List {
            Section("Version") { LabeledContent("Minecraft", value: instance.version); LabeledContent("Loader", value: instance.loader); LabeledContent("Status", value: instance.status.title) }
            Section("Actions") { Button("Compatibility Check") {}; Button("Manage Mods") {}; Button("Performance Profile") {}; Button("View Logs") {} }
            Section("Runtime") { Text("Runtime backend integration point. It must use properly licensed upstream components.").foregroundStyle(.secondary) }
        }.navigationTitle(instance.name)
    }
}

struct ImportView: View {
    @EnvironmentObject private var store: LauncherStore
    @Environment(\.dismiss) private var dismiss
    @State private var name = "Imported Minecraft"
    @State private var version = "Unknown"
    @State private var loader = "Vanilla"
    var body: some View {
        NavigationStack {
            Form {
                Section("Imported files") {
                    Button { } label: { Label("Choose Minecraft Files", systemImage: "folder") }
                    Text("Imports files already available to you. No pirated game downloads are provided.").font(.footnote).foregroundStyle(.secondary)
                }
                Section("Profile") {
                    TextField("Instance name", text: $name)
                    TextField("Minecraft version", text: $version)
                    Picker("Loader", selection: $loader) { Text("Vanilla").tag("Vanilla"); Text("Fabric").tag("Fabric"); Text("Forge").tag("Forge"); Text("NeoForge").tag("NeoForge") }
                }
                Button("Create Instance") { store.addImportedInstance(name: name, version: version, loader: loader); dismiss() }
            }.navigationTitle("Import").toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }
}

struct ModsView: View {
    var body: some View {
        List {
            Section { Label("Import .jar mod", systemImage: "shippingbox"); Label("Detect loader and Minecraft version", systemImage: "magnifyingglass"); Label("Check dependencies", systemImage: "checklist"); Label("Enable / disable per instance", systemImage: "switch.2") }
            Section("Elevator profile") { Text("Dedicated elevator-mod support will use the real compatibility/runtime backend.").foregroundStyle(.secondary) }
        }.navigationTitle("Mods")
    }
}

struct SettingsView: View {
    var body: some View {
        Form {
            Section("Performance") { Toggle("Low-memory mode", isOn: .constant(true)); Toggle("Dynamic resolution", isOn: .constant(true)); Picker("Preset", selection: .constant("Balanced")) { Text("Battery Saver").tag("Battery Saver"); Text("Balanced").tag("Balanced"); Text("Performance").tag("Performance") } }
            Section("Controls") { Label("Touch layout editor", systemImage: "hand.draw"); Label("Controller support", systemImage: "gamecontroller"); Label("Keyboard + mouse", systemImage: "keyboard") }
            Section("Diagnostics") { Label("Crash logs", systemImage: "doc.text.magnifyingglass"); Label("Compatibility reports", systemImage: "checkmark.shield") }
        }.navigationTitle("Settings")
    }
}

struct InstanceRow: View {
    let instance: MinecraftInstance
    var body: some View {
        HStack { Image(systemName: "cube.fill").font(.title2); VStack(alignment: .leading) { Text(instance.name).font(.headline); Text("\(instance.version) • \(instance.loader)").font(.subheadline).foregroundStyle(.secondary) }; Spacer(); Text(instance.status.title).font(.caption).foregroundStyle(.secondary) }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    var body: some View { Label(title, systemImage: icon) }
}