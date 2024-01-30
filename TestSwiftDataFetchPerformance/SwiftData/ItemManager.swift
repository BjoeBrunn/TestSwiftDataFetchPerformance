//
//  ItemManager.swift
//  TestSwiftDataFetchPerformance
//
//  Created by Bjoern Brunnermeier on 29.01.24.
//

import Foundation
import SwiftData

@ModelActor actor ItemManager {}

extension ItemManager {
    func generateSampleItems(primaryItemsCount: Int, secondaryItemsCount: Int) {
        let totalStart = Date.now
        for i in 1 ... secondaryItemsCount {
            print("generate SecondaryItem #\(i)")
            let newSecondaryItem = SecondaryItem(name: "Secondary \(i)")
            modelContext.insert(newSecondaryItem)
        }
        
        try? modelContext.save()
        
        for i in 1 ... primaryItemsCount {
            print("generate PrimaryItem #\(i)")
            let newPrimaryItem = PrimaryItem(name: "Primary \(i)")
            
//            let secondaryIndexes = (1 ... secondaryItemsCount).shuffled()
//            let numberOfSecondaries = (1 ... secondaryItemsCount).randomElement()!
//            print("attach to \(numberOfSecondaries) Secondary Items")
//            for k in 0 ..< numberOfSecondaries {
            for k in 1 ... secondaryItemsCount {
//                print("\(k + 1)/\(numberOfSecondaries)")
                print("\(k)/\(secondaryItemsCount)")
//                let nameToSearch = "Secondary \(secondaryIndexes[k])"
                let nameToSearch = "Secondary \(k)"
                let start = Date.now
                if let secondaryItem =  SecondaryItem.search(name: nameToSearch, in: modelContext) {
                    print("search time:  \(Date.now.timeIntervalSince(start))s")
                    newPrimaryItem.secondaryItems?.append(secondaryItem) // Total time to generate: 24.157724976539612s
//                    secondaryItem.primaryItems?.append(newPrimaryItem) // Total time to generate: 34.86188197135925s
                    
//                    let saveStart = Date.now
//                    try? modelContext.save()
//                    print("time to save: \(Date.now.timeIntervalSince(saveStart))s")
                } else {
                    fatalError("logic error: SecondaryItem with name: \(nameToSearch) not found")
                }
            }
        }
        
        print("Total time to generate: \(Date.now.timeIntervalSince(totalStart))s")
        try? modelContext.save()
    }
}
