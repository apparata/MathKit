// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "MathKit",
    platforms: [
        // Relevant platforms.
        .iOS(.v13), .macOS(.v11), .tvOS(.v13)
    ],
    products: [
        .library(name: "MathKit", targets: ["MathKit"])
    ],
    dependencies: [
        // It's a good thing to keep things relatively
        // independent, but add any dependencies here.
    ],
    targets: [
        .target(
            name: "MathKit",
            dependencies: [],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("SWIFT_PACKAGE")
            ]),
        .testTarget(name: "MathKitTests", dependencies: ["MathKit"]),
    ]
)
