//
//  String+Extensions.swift
//  MacTools
//
//  Created by Alan Zeino on 2/7/26.
//

import Foundation
import System

extension String {
    init(
        contentsOfFilePath filePath: FilePath,
        encoding: String.Encoding
    ) throws {
        try self.init(
            contentsOfFile: filePath.string,
            encoding: encoding
        )
    }
}
