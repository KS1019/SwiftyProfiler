// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyProfiler",
        platforms: [
        .macOS(.v10_11),
    ],
    products: [
        .executable(
            name: "swprofiler",
            targets: ["SwiftyProfiler"])
    ],
    dependencies: [
        .package(name: "SwiftyXcActivityLog", url: "https://github.com/KS1019/SwiftyXcActivityLog", .upToNextMajor(from: "0.0.5")),
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.4.1")),
        .package(name: "SwiftyTextTable", url: "https://github.com/scottrhoyt/SwiftyTextTable", .upToNextMajor(from: "0.9.0"))
    ],
    targets: [
        .target(
            name: "SwiftyProfiler",
            dependencies:[
                "SwiftyXcActivityLog",
                "SwiftyTextTable",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "SwiftyProfilerTests",
            dependencies: ["SwiftyProfiler"]),
    ]
)
