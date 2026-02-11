//
//  ColumnView.swift
//  macgui
//
//  Created by Alan Zeino on 2/10/26.
//

import SwiftUI
import mactools
import System

struct ColumnView: View {
    let path: FilePath
    @Binding var selectedItem: FilePath?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text(path.lastComponent?.string ?? "/")
                .font(.headline)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
            
            // Content list
            if let contents = path.contents, !contents.isEmpty {
                List(selection: $selectedItem) {
                    ForEach(sortedContents(contents), id: \.filePath) { content in
                        ColumnItemView(content: content)
                            .tag(content.filePath)
                    }
                }
                .listStyle(.plain)
            } else if path.contents?.isEmpty == true {
                Text("Empty directory")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text("Unable to read directory")
                        .foregroundColor(.secondary)
                    Text("You may not have permission to access this location")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
    }
    
    private func sortedContents(_ contents: [DirectoryContent]) -> [DirectoryContent] {
        contents.sorted { first, second in
            // Directories first, then files
            let firstIsDir = if case .directory = first { true } else { false }
            let secondIsDir = if case .directory = second { true } else { false }
            
            if firstIsDir != secondIsDir {
                return firstIsDir
            }
            
            // Then sort alphabetically
            let firstName = first.filePath.lastComponent?.string ?? ""
            let secondName = second.filePath.lastComponent?.string ?? ""
            return firstName.localizedCaseInsensitiveCompare(secondName) == .orderedAscending
        }
    }
}
