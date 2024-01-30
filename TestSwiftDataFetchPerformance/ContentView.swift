//
//  ContentView.swift
//  TestSwiftDataFetchPerformance
//
//  Created by Bjoern Brunnermeier on 29.01.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PrimaryItem.name) private var primaryItems: [PrimaryItem]
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    Button("Generate Sample Items", action: generateSampleItems)
                    Button("Delete all PrimaryItems (\(primaryItems.count))", role: .destructive, action: deleteAllItems)
                }
                .buttonStyle(.borderedProminent)
                
                ForEach(primaryItems) { primaryItem in
                    NavigationLink(value: primaryItem) {
                        Text(primaryItem.name)
                    }
                }
            }
            .navigationTitle("Test Fetch Performance")
            .navigationDestination(for: PrimaryItem.self, destination: PrimaryDetailView.init)
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

struct PrimaryDetailView: View {
    let primaryItem: PrimaryItem
    var body: some View {
        List {
            Text("PrimaryItem: \(primaryItem.name)")
            
            Text("SecondaryItems (\(primaryItem.secondaryItems?.count ?? 0)):").foregroundStyle(Color.accentColor)
            
            if let secondaryItems = primaryItem.secondaryItems?.sorted(by: { $0.name < $1.name }) {
                ForEach(secondaryItems) { secondaryItem in
                    NavigationLink(value: secondaryItem) {
                        Text("Secondary: \(secondaryItem.name)")
                    }
                }
            }
        }
        .navigationTitle(primaryItem.name)
        .navigationDestination(for: SecondaryItem.self, destination: SecondaryDetailView.init)
    }
}

struct SecondaryDetailView: View {
    let secondaryItem: SecondaryItem
    var body: some View {
        List {
            Text("SecondaryItem: \(secondaryItem.name)")
            
            Text("PrimaryItems (\(secondaryItem.primaryItems?.count ?? 0)):").foregroundStyle(Color.accentColor)
            
            if let primaryItems = secondaryItem.primaryItems?.sorted(by: { $0.name < $1.name }) {
                ForEach(primaryItems) { primaryItem in
                    Text("Primary: \(primaryItem.name)")
                }
            }
        }
        .navigationTitle(secondaryItem.name)
    }
}


#Preview {
    ContentView()
        .modelContainer(for: PrimaryItem.self, inMemory: true)
}
