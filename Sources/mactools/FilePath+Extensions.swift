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
