// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "aoc-2020",
    products: [
        .library(
            name: "AdventOfCode2020",
            targets: ["AdventOfCode2020"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", .revision("ad6dc7a")),
    ],
    targets: [
        .target(
            name: "AdventOfCode2020",
            dependencies: [.product(name: "Algorithms", package: "swift-algorithms")]
        ),
        .testTarget(
            name: "AdventOfCode2020Tests",
            dependencies: ["AdventOfCode2020"]
        ),
    ]
)
