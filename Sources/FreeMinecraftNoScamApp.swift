import SwiftUI
import UniformTypeIdentifiers

@main
struct FreeMinecraftNoScamApp: App {
    @StateObject private var store = LauncherStore()
    var body: some Scene {
        WindowGroup { ContentView().environmentObject(store) }
    }
}

@MainActor
final class LauncherStore: ObservableObject {
    @Published var instances: [MinecraftInstance] = [
        MinecraftInstance(name: "My Minecraft", version: "Import a version", loader: "Not configured")
    ]
    @Published var selectedTab = 0

    func addImportedInstance(name: String, version: String, loader: String, url: URL? = nil) {
        instances.append(MinecraftInstance(name: name, version: version, loader: loader, gameURL: url, status: .ready))
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
                    Text("Minecraft Java launcher for locally imported game files.").foregroundStyle(.secondary)
                    Button { store.selectedTab = 1 } label: {
                        Label("Import Minecraft Version", systemImage: "square.and.arrow.down")
                    }.buttonStyle(.borderedProminent)
                }.padding(.vertical, 8)
            }
            Section("Instances") { ForEach(store.instances) { InstanceRow(instance: $0) } }
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
            Section("Your instances") {
                ForEach(store.instances) { instance in
                    NavigationLink { InstanceDetailView(instance: instance) } label: { InstanceRow(instance: instance) }
                }
            }
        }.navigationTitle("Instances").sheet(isPresented: $showingImport) { ImportView() }
    }
}

struct InstanceDetailView: View {
    let instance: MinecraftInstance
    @State private var report: CompatibilityReport?
    @State private var runtimeError: String?
    var body: some View {
        List {
            Section("Version") {
                LabeledContent("Minecraft", value: instance.version)
                LabeledContent("Loader", value: instance.loader)
                LabeledContent("Status", value: instance.status.title)
            }
            Section("Actions") {
                Button("Compatibility Check") { report = CompatibilityEngine().check(instance: instance) }
                Button("Launch") {
                    Task {
                        do { try await UnconfiguredRuntime().launch(instance: instance) }
                        catch { runtimeError = error.localizedDescription }
                    }
                }
            }
            if let report {
                Section("Compatibility") {
                    if report.errors.isEmpty { Label("No blocking errors", systemImage: "checkmark.circle") }
                    ForEach(report.errors, id: \.self) { Text("ERROR: \($0)").foregroundStyle(.red) }
                    ForEach(report.warnings, id: \.self) { Text("Warning: \($0)") }
                    ForEach(report.passed, id: \.self) { Text("Passed: \($0)") }
                }
            }
            if let runtimeError { Section("Runtime") { Text(runtimeError).foregroundStyle(.secondary) } }
            Section("Runtime") {
                Text("The runtime bridge is intentionally blocked until a properly licensed Java/Minecraft backend is integrated.")
                    .foregroundStyle(.secondary)
            }
        }.navigationTitle(instance.name)
    }
}

struct ImportView: View {
    @EnvironmentObject private var store: LauncherStore
    @Environment(\.dismiss) private var dismiss
    @State private var showingImporter = false
    @State private var importedURL: URL?
    @State private var name = "Imported Minecraft"
    @State private var version = "Unknown"
    @State private var loader = "Vanilla"
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Minecraft files") {
                    Button { showingImporter = true } label: {
                        Label(importedURL == nil ? "Choose Minecraft Files" : "File Selected", systemImage: "folder")
                    }
                    if let importedURL {
                        Text(importedURL.lastPathComponent).font(.footnote)
                    }
                    Text("This imports files already available to you. It does not download or distribute game copies.")
                        .font(.footnote).foregroundStyle(.secondary)
                    if let errorMessage { Text(errorMessage).foregroundStyle(.red) }
                }
                Section("Profile") {
                    TextField("Instance name", text: $name)
                    TextField("Minecraft version", text: $version)
                    Picker("Loader", selection: $loader) {
                        Text("Vanilla").tag("Vanilla")
                        Text("Fabric").tag("Fabric")
                        Text("Forge").tag("Forge")
                        Text("NeoForge").tag("NeoForge")
                    }
                }
                Button("Create Instance") {
                    store.addImportedInstance(name: name, version: version, loader: loader, url: importedURL)
                    dismiss()
                }.disabled(importedURL == nil)
            }
            .navigationTitle("Import")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
            .fileImporter(
                isPresented: $showingImporter,
                allowedContentTypes: [.data, .archive],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls): importedURL = urls.first
                case .failure(let error): errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct ModsView: View {
    @State private var showingImporter = false
    @State private var result = "No mod scanned yet."
    var body: some View {
        List {
            Section {
                Button { showingImporter = true } label: { Label("Import and scan .jar", systemImage: "shippingbox") }
                Text(result).font(.footnote).foregroundStyle(.secondary)
            }
            Section("Checks") {
                Label("JAR/ZIP signature check", systemImage: "checkmark")
                Label("Loader detection", systemImage: "magnifyingglass")
                Label("Dependency reporting", systemImage: "checklist")
                Label("Per-instance enable / disable", systemImage: "switch.2")
            }
            Section("Elevator profile") {
                Text("Elevator-mod end-to-end gameplay testing still requires the real Java runtime backend.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Mods")
        .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.data, .archive], allowsMultipleSelection: false) { response in
            if case .success(let urls) = response, let url = urls.first {
                do {
                    let mod = try ModScanner().scan(url: url)
                    result = "\(mod.name) • \(mod.loader) • \(mod.version)"
                } catch { result = "Scan failed: \(error.localizedDescription)" }
            }
        }
    }
}

struct SettingsView: View {
    @State private var lowMemory = true
    @State private var dynamicResolution = true
    @State private var preset = "Balanced"
    var body: some View {
        Form {
            Section("Performance") {
                Toggle("Low-memory mode", isOn: $lowMemory)
                Toggle("Dynamic resolution", isOn: $dynamicResolution)
                Picker("Preset", selection: $preset) {
                    Text("Battery Saver").tag("Battery Saver")
                    Text("Balanced").tag("Balanced")
                    Text("Performance").tag("Performance")
                }
            }
            Section("Controls") {
                Label("Touch layout editor", systemImage: "hand.draw")
                Label("Controller support", systemImage: "gamecontroller")
                Label("Keyboard + mouse", systemImage: "keyboard")
            }
            Section("Diagnostics") {
                Label("Crash logs", systemImage: "doc.text.magnifyingglass")
                Label("Compatibility reports", systemImage: "checkmark.shield")
            }
        }.navigationTitle("Settings")
    }
}

struct InstanceRow: View {
    let instance: MinecraftInstance
    var body: some View {
        HStack {
            Image(systemName: "cube.fill").font(.title2)
            VStack(alignment: .leading) {
                Text(instance.name).font(.headline)
                Text("\(instance.version) • \(instance.loader)").font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Text(instance.status.title).font(.caption).foregroundStyle(.secondary)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    var body: some View { Label(title, systemImage: icon) }
}
