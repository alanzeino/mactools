//
//  URL+FilePath.swift
//  MacTools
//
//  Created by Alan Zeino on 2/7/26.
//

import System
import Foundation

public extension URL {
    var filePath: FilePath? {
        guard isFileURL else {
            return nil
        }
        return FilePath(absoluteString)
    }
}

public extension FilePath {
    var fileURL: URL? {
        URL(filePath: self)
    }
}
