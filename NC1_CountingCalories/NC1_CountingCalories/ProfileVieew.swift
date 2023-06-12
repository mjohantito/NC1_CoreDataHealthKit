//
//  ProfileVieew.swift
//  NC1_CountingCalories
//
//  Created by Manuel Johan Tito on 16/05/23.
//

import SwiftUI

struct ProfileVieew: View {
    
    @FetchRequest(sortDescriptors: []) var bodyy: FetchedResults<Bodyy>
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var vm: HealthKitViewModel
    
    @Binding var sheet1: Bool
    
    @Binding var gender: String
    @Binding var age: Int
    @Binding var selectedHeight: String
    @Binding var selectedWeight: String
    @Binding var height: Double
    @Binding var weight: Double
    @Binding var trackedCalorie: Int
    @Binding var selectedGoals: String
    
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    HStack{
                        Text("Gender")
                        Spacer()
                        Picker("gender", selection: $gender){
                            Text("Male")
                                .tag("male")
                            Text("Female")
                                .tag("female")
                        }
                        .labelsHidden()
                    }
                    HStack{
                        Text("Age")
                        TextField("Age", value: $age, format:.number)
                            .keyboardType(.decimalPad)
                    }
                    HStack{
                        Text("Height")
                        TextField("Height", value: $height, format:.number)
                            .keyboardType(.decimalPad)
                        
                        
                        //                        var conversion : Double = 0
                        
                        
                        Picker("Unit", selection: $selectedHeight){
                            Text("cm")
                                .tag("cm")
                            Text("inch")
                                .tag("inch")
                            Text("feet")
                                .tag("feet")
                        }
                        .labelsHidden()
                        .onChange(of: selectedHeight){ newHeight in
                            if !height.isZero{
                                
                                if newHeight == "cm" {
                                    height = height * 1
                                } else if newHeight == "inch" {
                                    height = height * 2.54 // conversion inch to cm
                                } else if newHeight == "feet" {
                                    height = height * 30.84 // conversion feet to cm
                                }
                                
                            }
                            
                        }
                    }
                    HStack{
                        Text("Weight")
                        TextField("Weight", value: $weight, format:.number)
                            .keyboardType(.decimalPad)
                        Picker("UWeight", selection: $selectedWeight){
                            Text("Kg")
                                .tag("kg")
                            Text("Lbs")
                                .tag("lbs")
                        }
                        .labelsHidden()
                    }
                    HStack{
                        Text("Tracked Calories")
                        TextField("tCalories", value: $trackedCalorie, format:.number)
                            .keyboardType(.decimalPad)
                    }
                    
                    
                    
                }header: {
                    Text("Body Details")
                }
                
                Section{
                    HStack{
                        Text("Goals")
                        Spacer()
                        Picker("Goals",selection: $selectedGoals){
                            Text("Weight Loss")
                                .tag("WL")
                            Text("Maintain")
                                .tag("MT")
                            Text("Gain Mass")
                                .tag("GM")
                        }
                        .labelsHidden()
                    }
                }header:{
                    Text("Body Goals")
                }footer:{
                    Text("Body Goals suggestion from BMI")
                }
                
                
            }
            
            
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Button("Back"){
//                        self.isModalSheetShown1 = false
                        sheet1 = false
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button("Save"){
                        if bodyy.count > 0 {
                            var b = bodyy[bodyy.count - 1]
                            b.gender = gender
                            b.age = Int32(age)
                            b.height = height
                            b.weight = weight
                            b.trackedcal = Int32(trackedCalorie)
                            b.goals = selectedGoals
                            
                            try? moc.save()

                            
                        }else{
                            
                            let b = Bodyy(context: moc)
                            b.gender = gender
                            b.age = Int32(age)
                            b.height = height
                            b.weight = weight
                            b.trackedcal = Int32(trackedCalorie)
                            b.goals = selectedGoals
                            
                            try? moc.save()
                        }
                        sheet1 = false
                        
                    }
                }
            }
            .onAppear {
                if bodyy.count > 0 {
                    gender = bodyy[bodyy.count - 1].gender ?? ""
                    age = Int(bodyy[bodyy.count - 1].age)
                    height = bodyy[bodyy.count - 1].height
                    weight = bodyy[bodyy.count - 1].weight
                    
                    
                    selectedGoals = bodyy[bodyy.count - 1].goals ?? ""
                    
                }else{
                    
                }
                vm.readCalorieTakenToday()
                trackedCalorie = Int(vm.userCalCount) ?? 0
            }
        }
        .multilineTextAlignment(.trailing)
    }
}

//struct ProfileVieew_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileVieew(sheet1: <#Binding<Bool>#>, gender: <#Binding<String>#>, age: <#Binding<Int>#>, selectedHeight: <#Binding<String>#>, selectedWeight: <#Binding<String>#>, height: <#Binding<Double>#>, weight: <#Binding<Double>#>, trackedCalorie: <#Binding<Int>#>, selectedGoals: <#Binding<String>#>)
//    }
//}
