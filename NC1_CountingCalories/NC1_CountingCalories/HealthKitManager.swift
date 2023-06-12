//
//  HealthKitManager.swift
//  NC1_CountingCalories
//
//  Created by Manuel Johan Tito on 15/05/23.
//

import HealthKit

class HealthKitManager{
    func setUpHealthRequest(healthStore: HKHealthStore, readCalorie: @escaping () -> Void){
        if HKHealthStore.isHealthDataAvailable(), let calCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned){
            healthStore.requestAuthorization(toShare: [calCount], read: [calCount]){success, error in
                if success{
                    readCalorie()
                    print("success")
                } else if error != nil {
//                    print("error\(error?.localizedDescription)")
                }
            }
        }
    }

    func readCalorieCount(forToday: Date, healthStore: HKHealthStore, completion: @escaping (Double) -> Void) {
        guard let calQuantityType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: calQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            
            completion(sum.doubleValue(for: HKUnit.largeCalorie()))
        
        }
        
        healthStore.execute(query)
        
    }
}

class HealthKitViewModel:ObservableObject{
    
    private var healthStore = HKHealthStore()
    private var healthKitManager = HealthKitManager()
    @Published var userCalCount = ""
    @Published var isAuthorized = false
    
    func healthRequest(){
        healthKitManager.setUpHealthRequest(healthStore: healthStore){
            self.changeAuthorizationStatus()
            self.readCalorieTakenToday()
        }
    }
    
    func readCalorieTakenToday() {
        healthKitManager.readCalorieCount(forToday: Date(), healthStore: healthStore) { calorie in
            if calorie != 0.0 {
                DispatchQueue.main.async {
                    self.userCalCount = String(format: "%.0f", calorie)
                }
            }
            print("calorie\(calorie)")
        }
    }
    
    func changeAuthorizationStatus() {
        guard let calQtyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {return}
        let status = self.healthStore.authorizationStatus(for: calQtyType)
        
        switch status {
        case .notDetermined:
            isAuthorized = false
        case .sharingDenied:
            isAuthorized = false
        case .sharingAuthorized:
            isAuthorized = true
        @unknown default:
            isAuthorized = false
        }
    }
}

