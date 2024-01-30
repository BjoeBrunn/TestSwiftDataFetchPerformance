//
//  GenerateDataView.swift
//  TestSwiftDataFetchPerformance
//
//  Created by Bjoern Brunnermeier on 29.01.24.
//

import SwiftUI

struct GenerateDataView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            Group {
                Button("Generate Sample Items", action: generateSampleItems)
                Button("Delete all PrimaryItems", role: .destructive, action: deleteAllItems)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    func generateSampleItems() {
        let container = modelContext.container
        Task {
            let manager = ItemManager(modelContainer: container)
            await manager.generateSampleItems(primaryItemsCount: 1000, secondaryItemsCount: 10)
        }
    }
    
    func deleteAllItems() {
        try? modelContext.delete(model: PrimaryItem.self)
    }
}

#Preview {
    GenerateDataView()
        .modelContainer(for: PrimaryItem.self, inMemory: true)
}
