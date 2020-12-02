// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "aoc-2020",
    products: [
        .library(
            name: "Day1",
            targets: ["Day1"]
        ),
        .library(
            name: "Day2",
            targets: ["Day2"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", .revision("ad6dc7a")),
    ],
    targets: [
        .target(
            name: "Day1",
            dependencies: [.product(name: "Algorithms", package: "swift-algorithms")]
        ),
        .target(
            name: "Day2",
            dependencies: [.product(name: "Algorithms", package: "swift-algorithms")]
        ),
        .testTarget(
            name: "Day1Tests",
            dependencies: ["Day1"]
        ),
        .testTarget(
            name: "Day2Tests",
            dependencies: ["Day2"]
        ),
    ]
)
