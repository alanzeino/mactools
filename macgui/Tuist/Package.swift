// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "mactools": .framework
    ]
)
#endif

let package = Package(
    name: "macgui",
    dependencies: [
        .package(path: "../../mactools")
    ]
)
