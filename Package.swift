// swift-tools-version: 5.9
import PackageDescription
import AppleProductTypes

let package = Package(
    name: "ARKitPoseStreamer",
    platforms: [.iOS("16.0")],
    products: [
        .iOSApplication(
            name: "ARKitPoseStreamer",
            targets: ["AppModule"],
            bundleIdentifier: "com.mmaarrwa.ARKitPoseStreamer",
            teamIdentifier: nil,
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .default),   // ✅ fixed
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [.phone],
            supportedInterfaceOrientations: [   // ✅ added this
                .portrait,
                .landscapeLeft,
                .landscapeRight
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources"
        )
    ]
)
