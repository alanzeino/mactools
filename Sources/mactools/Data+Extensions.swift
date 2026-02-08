//
//  Data+Extensions.swift
//  MacTools
//
//  Created by Alan Zeino on 2/7/26.
//

import Foundation
import System

enum FilePathError: Error {
    case cannotConvertToURL
}

extension Data {
    init(filePath: FilePath) throws {
        guard let fileURL = filePath.fileURL else {
            throw FilePathError.cannotConvertToURL
        }
        try self.init(contentsOf: fileURL)
    }
}
