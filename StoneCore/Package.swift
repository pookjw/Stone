// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StoneCore",
    platforms: [
        .macOS(.v14),
        .macCatalyst(.v17),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "StoneCore",
            targets: ["StoneCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-testing.git", branch: "main"),
        .package(url: "https://github.com/pookjw/HandyMacros.git", branch: "main")
    ],
    targets: [
        .target(
            name: "StoneCore",
            dependencies: [
                .product(name: "HandyMacros", package: "HandyMacros")
            ],
            swiftSettings: [
                // "-cxx-interoperability-mode=default"
                .unsafeFlags(["-strict-concurrency=complete", "-enable-private-imports"])
            ]
        ),
        .testTarget(
            name: "StoneCoreTests",
            dependencies: [
                .byName(name: "StoneCore"),
                .product(name: "Testing", package: "swift-testing")
            ],
            resources: [.process("Resources")],
            swiftSettings: [
                // "-cxx-interoperability-mode=default"
                .unsafeFlags(["-strict-concurrency=complete"])
            ]
        )
    ]
)
