//
//  FileMetadataView.swift
//  macgui
//
//  Created by Alan Zeino on 2/10/26.
//

import SwiftUI
import Foundation

struct FileMetadataView: View {
    let url: URL
    @State private var fileSize: Int64?
    @State private var creationDate: Date?
    @State private var modificationDate: Date?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let size = fileSize {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Size")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(ByteCountFormatter.string(fromByteCount: size, countStyle: .file))
                        .font(.body)
                }
            }
            
            if let creation = creationDate {
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Created")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(creation, style: .date)
                        .font(.body)
                    Text(creation, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if let modification = modificationDate {
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Modified")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(modification, style: .date)
                        .font(.body)
                    Text(modification, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .task {
            loadMetadata()
        }
    }
    
    private func loadMetadata() {
        do {
            let values = try url.resourceValues(forKeys: [
                .fileSizeKey,
                .creationDateKey,
                .contentModificationDateKey
            ])
            
            if let size = values.fileSize {
                fileSize = Int64(size)
            }
            creationDate = values.creationDate
            modificationDate = values.contentModificationDate
        } catch {
            print("Error loading metadata: \(error.localizedDescription)")
        }
    }
}
