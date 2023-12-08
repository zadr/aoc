// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v13)],
	dependencies: [
		.package(url: "https://github.com/apple/swift-algorithms", .upToNextMajor(from: "1.2.0")),
	    .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.0")),
		.package(url: "https://github.com/apple/swift-atomics", .upToNextMajor(from: "1.2.0")),
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "aoc",
			dependencies: [
				.product(name: "Algorithms", package: "swift-algorithms"),
			    .product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "Atomics", package: "swift-atomics"),
			],
            swiftSettings: [.enableUpcomingFeature("BareSlashRegexLiterals")]
		),
    ]
)
