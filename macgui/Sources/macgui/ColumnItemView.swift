//
//  ColumnItemView.swift
//  macgui
//
//  Created by Alan Zeino on 2/10/26.
//

import SwiftUI
import mactools

struct ColumnItemView: View {
    let content: DirectoryContent
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 20)
            
            Text(content.filePath.lastComponent?.string ?? "Unknown")
                .lineLimit(1)
        }
        .padding(.vertical, 2)
    }
    
    private var icon: String {
        switch content {
        case .directory:
            return "folder.fill"
        case .symbolicLink:
            return "link"
        case .regularFile:
            return "doc.fill"
        }
    }
    
    private var iconColor: Color {
        switch content {
        case .directory:
            return .blue
        case .symbolicLink:
            return .purple
        case .regularFile:
            return .gray
        }
    }
}
