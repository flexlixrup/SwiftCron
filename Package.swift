// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwiftCron",
	defaultLocalization: "en",
	platforms: [
		.macOS(.v12),
		.iOS(.v15),
		.watchOS(.v8),
		.visionOS(.v1)
	],
    products: [
        .library(name: "SwiftCron", targets: ["SwiftCron"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SwiftCron", dependencies: [], path: "Sources/"),
    ],
    swiftLanguageVersions: [.v5]
)
