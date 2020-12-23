// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "aoc-2020",
    platforms: [.macOS(.v10_12)],
    products: [
        .library(
            name: "AdventOfCode2020",
            targets: ["AdventOfCode2020"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", .revision("ad6dc7a")),
        .package(url: "https://github.com/ChimeHQ/Flexer.git", .revision("fa4a3988")),
    ],
    targets: [
        .target(
            name: "AdventOfCode2020",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Flexer", package: "Flexer"),
            ]
        ),
        .testTarget(
            name: "AdventOfCode2020Tests",
            dependencies: ["AdventOfCode2020"]
        ),
    ]
)
