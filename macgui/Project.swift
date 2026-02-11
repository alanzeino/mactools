import ProjectDescription

let project = Project(
    name: "macgui",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0",
            "SWIFT_APPROACHABLE_CONCURRENCY": "true",
            "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        .target(
            name: "macgui",
            destinations: .macOS,
            product: .app,
            bundleId: "com.example.macgui",
            deploymentTargets: .macOS("26.0"),
            sources: ["Sources/macgui/**"],
            dependencies: [
                .external(name: "mactools")
            ]
        )
    ]
)
