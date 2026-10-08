import XCTest
@testable import FreeMinecraftNoScam

final class LauncherTests: XCTestCase {
    func testDefaultInstanceNeedsImport() {
        let store = LauncherStore()
        XCTAssertEqual(store.instances.count, 1)
        XCTAssertEqual(store.instances[0].status.title, "Needs Import")
        XCTAssertEqual(store.instances[0].version, "Import a version")
    }

    func testImportedInstanceIsAddedAsReady() {
        let store = LauncherStore()
        store.addImportedInstance(
            name: "Test 1.21.8",
            version: "1.21.8",
            loader: "Fabric"
        )

        XCTAssertEqual(store.instances.count, 2)
        XCTAssertEqual(store.instances[1].name, "Test 1.21.8")
        XCTAssertEqual(store.instances[1].version, "1.21.8")
        XCTAssertEqual(store.instances[1].loader, "Fabric")
        XCTAssertEqual(store.instances[1].status.title, "Ready")
    }
}
