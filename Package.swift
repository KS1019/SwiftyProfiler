// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyProfiler",
        platforms: [
        .macOS(.v10_11),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "SwiftyProfiler",
            targets: ["SwiftyProfiler"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),

        .package(name: "SwiftyXcActivityLog", url: "https://github.com/KS1019/SwiftyXcActivityLog", .upToNextMajor(from: "0.0.5")),
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.4.1")),
        .package(name: "SwiftyTextTable", url: "https://github.com/scottrhoyt/SwiftyTextTable", .upToNextMajor(from: "0.9.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
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
