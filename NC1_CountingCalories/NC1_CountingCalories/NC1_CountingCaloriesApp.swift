//
//  NC1_CountingCaloriesApp.swift
//  NC1_CountingCalories
//
//  Created by Manuel Johan Tito on 05/05/23.
//

import SwiftUI

@main
struct NC1_CountingCaloriesApp: App {
    
    @StateObject var healthKitViewModel: HealthKitViewModel = HealthKitViewModel()
    @StateObject var myData:DataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitViewModel)
                .environment(\.managedObjectContext, myData.container.viewContext)
        }
    }
}
