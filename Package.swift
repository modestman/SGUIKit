// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SGUIKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SGUIKit",
            targets: ["SGUIKit"]
        )
    ],
    dependencies: [
        .package(name: "RxSwift", url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0"),
        .package(name: "InputMask", url: "https://github.com/RedMadRobot/input-mask-ios", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "SGUIKit",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "InputMask", package: "InputMask")
            ], 
            path: "", 
            sources: ["SGUIKit"]
        )
    ]
)
