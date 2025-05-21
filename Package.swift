// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorAutofillSavePassword",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CapgoCapacitorAutofillSavePassword",
            targets: ["SavePasswordPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "SavePasswordPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/SavePasswordPlugin"),
        .testTarget(
            name: "SavePasswordPluginTests",
            dependencies: ["SavePasswordPlugin"],
            path: "ios/Tests/SavePasswordPluginTests")
    ]
)
