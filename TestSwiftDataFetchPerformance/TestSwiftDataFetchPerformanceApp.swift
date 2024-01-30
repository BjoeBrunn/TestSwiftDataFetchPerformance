//
//  TestSwiftDataFetchPerformanceApp.swift
//  TestSwiftDataFetchPerformance
//
//  Created by Bjoern Brunnermeier on 29.01.24.
//

import SwiftUI

@main
struct TestSwiftDataFetchPerformanceApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            GenerateDataView()
        }
        .modelContainer(for: PrimaryItem.self)
    }
}
