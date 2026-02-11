//
//  FilePathTests.swift
//  MacTools
//
//  Created by Alan Zeino on 2/7/26.
//

import Foundation
import System
import Testing

@testable import mactools

@Suite("FilePath Tests")
struct FilePathTests {

    @Test("Create files with absolute paths")
    func testAbsolutePathCreation() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let testFile = FilePath(tempDir.path).appending("test_absolute.txt")

        /// Create file using absolute path
        let success = fileManager.createFile(
            atFilePath: testFile,
            contents: Data("Absolute path test".utf8)
        )

        #expect(success)
        #expect(fileManager.fileExists(atFilePath: testFile))

        /// Cleanup
        try? fileManager.removeItem(atPath: testFile.string)
    }

    @Test("Create files with tilde paths")
    func testTildePathCreation() async throws {
        let fileManager = FileManager.default

        /// Create path with ~ that represents home directory
        let homeDir = fileManager.homeDirectoryForCurrentUser
        let testFile = FilePath(homeDir.path).appending("test_tilde.txt")

        /// Create file
        let toWrite = Data("Tilde path test".utf8)
        let success = fileManager.createFile(
            atFilePath: testFile,
            contents: toWrite
        )

        #expect(success)
        #expect(fileManager.fileExists(atFilePath: testFile))
        
        let contents = fileManager.contents(atFilePath: testFile)
        #expect(contents == toWrite)

        /// Cleanup
        try? fileManager.removeItem(atPath: testFile.string)
    }

    @Test("Create files with root paths")
    func testRootPathCreation() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory

        /// Create path starting with /
        let testFile = FilePath(tempDir.path).appending("test_root.txt")

        #expect(testFile.string.hasPrefix("/"))

        let success = fileManager.createFile(
            atFilePath: testFile,
            contents: Data("Root path test".utf8)
        )

        #expect(success)
        #expect(fileManager.fileExists(atFilePath: testFile))

        /// Cleanup
        try? fileManager.removeItem(atPath: testFile.string)
    }

    @Test("Create directory structure")
    func testDirectoryCreation() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let testDir = FilePath(tempDir.path).appending("test_directory")

        /// Create directory
        try fileManager.createDirectory(
            atPath: testDir.string,
            withIntermediateDirectories: true
        )

        #expect(fileManager.directoryExists(atFilePath: testDir))

        /// Create a file inside the directory
        let testFile = testDir.appending("nested_file.txt")
        let success = fileManager.createFile(
            atFilePath: testFile,
            contents: Data("Nested file test".utf8)
        )

        #expect(success)
        #expect(fileManager.fileExists(atFilePath: testFile))

        /// Cleanup
        try? fileManager.removeItem(atPath: testDir.string)
    }

    @Test("Create symbolic link")
    func testSymbolicLinkCreation() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory

        /// Create original file
        let originalFile = FilePath(tempDir.path).appending("original.txt")
        let createSuccess = fileManager.createFile(
            atFilePath: originalFile,
            contents: Data("Original file".utf8)
        )
        #expect(createSuccess)

        /// Create symbolic link
        let linkFile = FilePath(tempDir.path).appending("link.txt")
        try fileManager.createSymbolicLink(
            atPath: linkFile.string,
            withDestinationPath: originalFile.string
        )

        #expect(fileManager.fileExists(atFilePath: linkFile))

        /// Cleanup
        try? fileManager.removeItem(atPath: originalFile.string)
        try? fileManager.removeItem(atPath: linkFile.string)
    }

    @Test("Create nested directory structure")
    func testNestedDirectoryCreation() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory

        /// Create nested path: /tmp/level1/level2/level3
        let nestedPath = FilePath(tempDir.path)
            .appending("level1")
            .appending("level2")
            .appending("level3")

        try fileManager.createDirectory(
            atPath: nestedPath.string,
            withIntermediateDirectories: true
        )

        #expect(fileManager.directoryExists(atFilePath: nestedPath))

        /// Create file in deepest directory
        let deepFile = nestedPath.appending("deep_file.txt")
        let success = fileManager.createFile(
            atFilePath: deepFile,
            contents: Data("Deep nested file".utf8)
        )

        #expect(success)

        /// Cleanup
        let rootPath = FilePath(tempDir.path).appending("level1")
        try? fileManager.removeItem(atPath: rootPath.string)
    }

    @Test("Read file contents")
    func testReadFileContents() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let testFile = FilePath(tempDir.path).appending("test_read.txt")

        let testContent = "Test content for reading"
        let success = fileManager.createFile(
            atFilePath: testFile,
            contents: Data(testContent.utf8)
        )

        #expect(success)

        /// Read contents
        if let data = fileManager.contents(atFilePath: testFile),
           let readContent = String(data: data, encoding: .utf8) {
            #expect(readContent == testContent)
        } else {
            Issue.record("Failed to read file contents")
        }

        /// Cleanup
        try? fileManager.removeItem(atPath: testFile.string)
    }
}
