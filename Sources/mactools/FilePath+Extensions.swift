//
//  FilePath+Extensions.swift
//  MacTools
//
//  Created by Alan Zeino on 2/7/26.
//

import Foundation
import System

public extension FilePath {
    var isDirectory: Bool {
        guard let fileURL else {
            print("fileURL is nil")
            return false
        }
        do {
            guard let isDirectory = try fileURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory else {
                return false
            }
            return isDirectory
        } catch {
            print("resource values error: \(error.localizedDescription)")
            return false
        }
    }
    
    var contents: [DirectoryContent]? {
        guard isDirectory, let fileURL else {
            return nil
        }
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: [.isDirectoryKey, .isRegularFileKey, .isSymbolicLinkKey])
            return contents.compactMap { url in
                guard let values = try? url.resourceValues(forKeys: [.isDirectoryKey, .isRegularFileKey, .isSymbolicLinkKey]) else {
                    return nil
                }
                guard let filePath = FilePath(url) else { return nil }
                return DirectoryContent(path: filePath, resourceValues: values)
            }
        } catch {
            print("contents error: \(error.localizedDescription)")
            return nil
        }
    }
    
    var contentsOfDirectory: [FilePath]? {
        guard isDirectory, let fileURL else {
            return nil
        }
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: nil)
            return contents.compactMap { FilePath($0) }
        } catch {
            print("contentsOfDirectory error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static nonisolated var currentWorkingDirectory: FilePath {
        FilePath(FileManager.default.currentDirectoryPath)
    }
}

public enum DirectoryContent {
    case regularFile(FilePath)
    case symbolicLink(FilePath)
    case directory(FilePath)

    init?(path: FilePath, resourceValues: URLResourceValues) {
        if resourceValues.isSymbolicLink == true {
            self = .symbolicLink(path)
        } else if resourceValues.isDirectory == true {
            self = .directory(path)
        } else if resourceValues.isRegularFile == true {
            self = .regularFile(path)
        } else {
            return nil
        }
    }
    
    var filePath: FilePath {
        switch self {
        case .regularFile(let filePath): filePath
        case .symbolicLink(let filePath): filePath
        case .directory(let filePath): filePath
        }
    }
}

public extension Array where Element == DirectoryContent {
    var allDirectories: [FilePath] {
        compactMap { content in
            if case .directory(let path) = content {
                return path
            }
            return nil
        }
    }

    var allFiles: [FilePath] {
        compactMap { content in
            switch content {
            case .regularFile(let path), .symbolicLink(let path):
                return path
            case .directory:
                return nil
            }
        }
    }
}

