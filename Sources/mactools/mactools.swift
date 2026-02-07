// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import System

@main
struct MacTools: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        subcommands: [PrintContentsCommand.self],
        defaultSubcommand: PrintContentsCommand.self
    )
}

struct PrintContentsCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(commandName: "print")
    
    @Argument(help: "The path to recursively list. Defaults to current working directory.", transform: { FilePath($0) })
    var path: FilePath = FilePath.currentWorkingDirectory

    mutating func run() async throws {
        try await printContentsRecursively(at: path)
    }

    @MainActor
    private func printContentsRecursively(
        at path: FilePath,
        indent: Int = 0
    ) async throws {
        print(
            "\(path.lastComponent, default: "invalid path")",
            terminator: "\n\(String(repeating: "\t", count: indent))"
        )

        guard path.isDirectory else { return }

        guard let contents = path.contentsOfDirectory else {
            return
        }

        for itemURL in contents {
            try await printContentsRecursively(at: itemURL, indent: indent + 1)
        }
    }
}
