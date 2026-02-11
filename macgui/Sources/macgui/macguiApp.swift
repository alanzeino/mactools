import SwiftUI
import mactools
import System

@main
struct macguiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 1000, height: 600)
    }
}

struct ContentView: View {
    @State private var columns: [FilePath] = [FilePath(FileManager.default.homeDirectoryForCurrentUser.path)]
    @State private var selectedItems: [FilePath?] = [nil]
    
    var body: some View {
        HStack(spacing: 0) {
            // Column view
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 0) {
                    ForEach(Array(columns.enumerated()), id: \.offset) { index, path in
                        ColumnView(
                            path: path,
                            selectedItem: binding(for: index)
                        )
                        .frame(width: 250)
                        .border(Color.gray.opacity(0.3))
                    }
                }
            }
            
            // Inspector view
            if let lastSelected = selectedItems.last, let selected = lastSelected {
                InspectorView(path: selected)
                    .frame(width: 300)
                    .border(Color.gray.opacity(0.3))
            }
        }
        .onChange(of: selectedItems) { oldValue, newValue in
            handleSelectionChange(oldValue: oldValue, newValue: newValue)
        }
    }
    
    private func binding(for index: Int) -> Binding<FilePath?> {
        Binding(
            get: {
                guard index < selectedItems.count else { return nil }
                return selectedItems[index]
            },
            set: { newValue in
                if index < selectedItems.count {
                    selectedItems[index] = newValue
                }
            }
        )
    }
    
    private func handleSelectionChange(oldValue: [FilePath?], newValue: [FilePath?]) {
        // Find which index changed
        var changedIndex: Int?
        for i in 0..<min(oldValue.count, newValue.count) {
            if oldValue[i]?.string != newValue[i]?.string {
                changedIndex = i
                break
            }
        }
        
        // If no change found in existing items, check if new items were added
        if changedIndex == nil && newValue.count > oldValue.count {
            changedIndex = oldValue.count
        }
        
        guard let index = changedIndex,
              index < newValue.count,
              let selected = newValue[index] else {
            return
        }
        
        // If the selected item is a directory, add a new column
        if selected.isDirectory {
            // Remove columns after the current one
            columns = Array(columns.prefix(index + 1))
            selectedItems = Array(selectedItems.prefix(index + 1))
            
            // Add the new directory column
            columns.append(selected)
            selectedItems.append(nil)
        } else {
            // If it's a file, remove columns after the current one
            columns = Array(columns.prefix(index + 1))
            selectedItems = Array(selectedItems.prefix(index + 1))
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 1000, height: 600)
}

