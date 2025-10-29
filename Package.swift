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
            bundleIdentifier: "com.mmaarrwa.ARKitPoseStreamer", // change YOURNAME
            teamIdentifier: nil,
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder,
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [.phone]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources"
        )
    ]
)
