// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoveoOneLibrary",
    platforms: [
            .iOS(.v15) // Add this to restrict the package to iOS only (minimum iOS version 14)
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MoveoOneLibrary",
            targets: ["MoveoOneLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/1024jp/GzipSwift", from: "5.2.0"),
        .package(url: "https://github.com/Kuniwak/MultipartFormDataKit.git", from: "1.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MoveoOneLibrary",
            dependencies: [
                .product(name: "Gzip", package: "GzipSwift"),
                .product(name: "MultipartFormDataKit", package: "MultipartFormDataKit")
            ]),
        
    ]
)
