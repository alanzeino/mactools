//
//  URLFilePathTests.swift
//  MacTools
//
//  Created by Alan Zeino on 2/7/26.
//

import Foundation
import System
import Testing

@testable import mactools

@Suite("URL and FilePath Conversion Tests")
struct URLFilePathTests {

    @Test("Convert URL to FilePath with absolute path")
    func testURLToFilePathAbsolute() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let testFilePath = tempDir.appendingPathComponent("test_url_conversion.txt")

        /// Create file
        try Data("URL test".utf8).write(to: testFilePath)

        /// Convert URL to FilePath
        guard let filePath = testFilePath.filePath else {
            Issue.record("Failed to convert URL to FilePath")
            return
        }

        /// Verify file exists using FilePath
        #expect(fileManager.fileExists(atFilePath: filePath))

        /// Cleanup
        try? fileManager.removeItem(at: testFilePath)
    }

    @Test("Convert URL with directoryHint to FilePath")
    func testURLWithDirectoryHintToFilePath() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory

        /// Create a test directory
        let testDirPath = tempDir.appendingPathComponent("test_directory_hint")
        try fileManager.createDirectory(at: testDirPath, withIntermediateDirectories: true)

        /// Create URL with directory hint
        let directoryURL = URL(
            filePath: testDirPath.path,
            directoryHint: .isDirectory
        )

        /// Convert to FilePath
        guard let filePath = directoryURL.filePath else {
            Issue.record("Failed to convert directory URL to FilePath")
            return
        }

        /// Verify directory exists using FilePath
        #expect(fileManager.directoryExists(atFilePath: filePath))

        /// Cleanup
        try? fileManager.removeItem(at: testDirPath)
    }

    @Test("Convert URL with relativeTo to FilePath")
    func testURLWithRelativeToFilePath() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory

        /// Create base directory
        let baseDir = tempDir.appendingPathComponent("base_directory")
        try fileManager.createDirectory(at: baseDir, withIntermediateDirectories: true)

        /// Create a file in the base directory
        let fileName = "relative_file.txt"
        let fullFilePath = baseDir.appendingPathComponent(fileName)
        try Data("Relative test".utf8).write(to: fullFilePath)

        /// Create URL with relativeTo - need to use file URL for base
        let baseDirURL = URL(fileURLWithPath: baseDir.path, isDirectory: true)
        let relativeURL = URL(
            filePath: fileName,
            directoryHint: .notDirectory,
            relativeTo: baseDirURL
        )

        /// Get absolute URL
        let absoluteURL = relativeURL.absoluteURL

        /// Convert to FilePath
        guard let filePath = absoluteURL.filePath else {
            Issue.record("Failed to convert relative URL to FilePath")
            return
        }

        /// Verify file exists using FilePath
        #expect(fileManager.fileExists(atFilePath: filePath))

        /// Cleanup
        try? fileManager.removeItem(at: baseDir)
    }

    @Test("Round trip: FilePath to URL to FilePath")
    func testFilePathToURLRoundTrip() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("roundtrip_test.txt")

        /// Create file
        try Data("Round trip test".utf8).write(to: testFile)

        /// Start with FilePath
        let originalFilePath = FilePath(testFile.path)

        /// Convert to URL
        guard let url = originalFilePath.fileURL else {
            Issue.record("Failed to convert FilePath to URL")
            return
        }

        /// Convert back to FilePath
        guard let convertedFilePath = url.filePath else {
            Issue.record("Failed to convert URL back to FilePath")
            return
        }

        /// Verify file exists using converted FilePath
        #expect(fileManager.fileExists(atFilePath: convertedFilePath))

        /// Verify the paths match
        #expect(originalFilePath.string == convertedFilePath.string)

        /// Cleanup
        try? fileManager.removeItem(at: testFile)
    }

    @Test("URL with file:/// scheme converts to FilePath")
    func testFileSchemeURLToFilePath() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("file_scheme_test.txt")

        /// Create file
        try Data("File scheme test".utf8).write(to: testFile)

        /// Create URL with file:/// scheme
        let fileURL = URL(fileURLWithPath: testFile.path)

        /// Convert to FilePath
        guard let filePath = fileURL.filePath else {
            Issue.record("Failed to convert file:/// URL to FilePath")
            return
        }

        /// Verify file exists
        #expect(fileManager.fileExists(atFilePath: filePath))

        /// Verify we can read contents
        let data = fileManager.contents(atFilePath: filePath)
        #expect(data != nil)

        /// Cleanup
        try? fileManager.removeItem(at: testFile)
    }

    @Test("Non-file URL returns nil for FilePath")
    func testNonFileURLReturnsNil() async throws {
        let httpURL = URL(string: "https://www.example.com")!

        /// Should return nil for non-file URL
        let filePath = httpURL.filePath
        #expect(filePath == nil)
    }

    @Test("FilePath from URL works with nested directories")
    func testNestedDirectoryURLToFilePath() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory

        /// Create nested directory structure
        let nestedPath = tempDir
            .appendingPathComponent("level1")
            .appendingPathComponent("level2")
            .appendingPathComponent("level3")

        try fileManager.createDirectory(at: nestedPath, withIntermediateDirectories: true)

        /// Create file in nested directory
        let testFile = nestedPath.appendingPathComponent("nested_file.txt")
        try Data("Nested test".utf8).write(to: testFile)

        /// Create URL
        let url = URL(filePath: testFile.path)

        /// Convert to FilePath
        guard let filePath = url.filePath else {
            Issue.record("Failed to convert nested URL to FilePath")
            return
        }

        /// Verify file exists
        #expect(fileManager.fileExists(atFilePath: filePath))

        /// Verify we can read the file
        let contents = fileManager.contents(atFilePath: filePath)
        #expect(contents != nil)

        if let contents = contents,
           let text = String(data: contents, encoding: .utf8) {
            #expect(text == "Nested test")
        }

        /// Cleanup
        let rootPath = tempDir.appendingPathComponent("level1")
        try? fileManager.removeItem(at: rootPath)
    }

    @Test("FilePath with special characters converts properly")
    func testSpecialCharactersInPath() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory

        /// Create file with special characters in name
        let specialFileName = "test file with spaces & special-chars.txt"
        let testFile = tempDir.appendingPathComponent(specialFileName)
        try Data("Special chars test".utf8).write(to: testFile)

        /// Create URL
        let url = URL(filePath: testFile.path)

        /// Convert to FilePath
        guard let filePath = url.filePath else {
            Issue.record("Failed to convert URL with special chars to FilePath")
            return
        }

        /// Verify file exists
        #expect(fileManager.fileExists(atFilePath: filePath))

        /// Cleanup
        try? fileManager.removeItem(at: testFile)
    }

    @Test("FilePath to URL preserves directory hint")
    func testDirectoryHintPreservation() async throws {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory

        /// Create directory
        let testDir = tempDir.appendingPathComponent("hint_directory")
        try fileManager.createDirectory(at: testDir, withIntermediateDirectories: true)

        /// Create FilePath for directory
        let dirFilePath = FilePath(testDir.path)

        /// Convert to URL
        guard let url = dirFilePath.fileURL else {
            Issue.record("Failed to convert directory FilePath to URL")
            return
        }

        /// Convert back to FilePath
        guard let convertedFilePath = url.filePath else {
            Issue.record("Failed to convert URL back to FilePath")
            return
        }

        /// Verify it's still recognized as a directory
        #expect(fileManager.directoryExists(atFilePath: convertedFilePath))

        /// Cleanup
        try? fileManager.removeItem(at: testDir)
    }
}
