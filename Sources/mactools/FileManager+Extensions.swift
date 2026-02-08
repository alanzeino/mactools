//
//  FileManager+Extensions.swift
//  MacTools
//
//  Created by Alan Zeino on 2/7/26.
//

import Foundation
import System

public extension FileManager {
    var currentDirectoryFilePath: FilePath {
        FilePath(currentDirectoryPath)
    }
    
    func changeCurrentDirectoryFilePath(_ filePath: FilePath) {
        changeCurrentDirectoryPath(filePath.string)
    }
    
    func fileExists(atFilePath filePath: FilePath) -> Bool {
        fileExists(atPath: filePath.string)
    }
    
    func directoryExists(atFilePath filePath: FilePath) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: filePath.string, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    func contents(atFilePath filePath: FilePath) -> Data? {
        contents(atPath: filePath.string)
    }
    
    func createFile(
        atFilePath filePath: FilePath,
        contents data: Data?,
        attributes: [FileAttributeKey: Any]? = nil
    ) -> Bool {
        createFile(
            atPath: filePath.string,
            contents: data,
            attributes: attributes
        )
    }
}
