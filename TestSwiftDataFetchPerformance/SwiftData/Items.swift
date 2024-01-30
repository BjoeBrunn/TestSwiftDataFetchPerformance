//
//  Items.swift
//  TestSwiftDataFetchPerformance
//
//  Created by Bjoern Brunnermeier on 29.01.24.
//

import Foundation
import SwiftData

@Model
class PrimaryItem {
    var name = ""
    
    // many to many relation. optional for iCloud
    @Relationship(inverse: \SecondaryItem.primaryItems)
    var secondaryItems: [SecondaryItem]?
    
    init(name: String, secondaryItems: [SecondaryItem]? = []) {
        self.name = name
        self.secondaryItems = secondaryItems
    }
}

@Model
class SecondaryItem {
    var name = ""
    
    // many to may relation. optional for iCloud
    var primaryItems: [PrimaryItem]?
    
    init(name: String, primaryItems: [PrimaryItem]? = []) {
        self.name = name
        self.primaryItems = primaryItems
    }
}

extension SecondaryItem {
    static func search(name: String, in modelContext: ModelContext) -> SecondaryItem? {
        let predicate = #Predicate<SecondaryItem>{ $0.name == name }
//        let predicate = Predicate<SecondaryItem>.true
        var fetchDescriptor = FetchDescriptor<SecondaryItem>(predicate: predicate)
        // fetchLimit may improve performance on large datasets
        fetchDescriptor.fetchLimit = 1
        return try? modelContext.fetch(fetchDescriptor).first
    }
}
