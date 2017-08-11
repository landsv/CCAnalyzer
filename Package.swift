// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CCAnalyzer",
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject", .branch("swift4")),
        .package(url: "https://github.com/kylef/Commander", from: "0.6.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "CCAnalyzer",
            dependencies: ["CCAnalyzerCore", "Rainbow"]
        ),
        .target(
            name: "CCAnalyzerCore",
            dependencies: ["Commander", "Swinject"]
        ),
        .testTarget(
            name: "CCAnalyzerTests",
            dependencies: ["CCAnalyzerCore"]
        )
    ]
)

