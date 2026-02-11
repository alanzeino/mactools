//
//  InspectorView.swift
//  macgui
//
//  Created by Alan Zeino on 2/10/26.
//

import SwiftUI
import mactools
import System

struct InspectorView: View {
    let path: FilePath
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Text("Inspector")
                .font(.headline)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // File icon
                    Image(systemName: path.isDirectory ? "folder.fill" : "doc.fill")
                        .font(.system(size: 48))
                        .foregroundColor(path.isDirectory ? .blue : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                    
                    // File name
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Name")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(path.lastComponent?.string ?? "Unknown")
                            .font(.body)
                    }
                    
                    Divider()
                    
                    // File path
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Path")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(path.string)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .textSelection(.enabled)
                    }
                    
                    Divider()
                    
                    // Type
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Type")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(path.isDirectory ? "Folder" : "File")
                            .font(.body)
                    }
                    
                    // File extension (if file)
                    if !path.isDirectory, let ext = path.extension {
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Extension")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(ext)
                                .font(.body)
                        }
                    }
                    
                    // Additional metadata
                    if let url = path.fileURL {
                        Divider()
                        
                        FileMetadataView(url: url)
                    }
                }
                .padding()
            }
        }
    }
}
