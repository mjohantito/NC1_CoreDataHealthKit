//
//  ProfileView.swift
//  NC1_CountingCalories
//
//  Created by Manuel Johan Tito on 10/05/23.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var calorie: Double = 0
    @State private var bmi: Int = 0
    
    @State private var gender: String = ""
    @State private var age: Int = 0
    @State private var selectedHeight = "cm"
    @State private var selectedWeight = "kg"
    @State private var height: Double = 0
    @State private var weight: Double = 0
    @State private var trackedCalorie: Int = 0
    @State private var selectedGoals: String = "MT"
    
    var body: some View {
        NavigationStack{
            Form {
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
                        Text("Age") //ganti ke tanggal lahir
                        TextField("Age", value: $age, format:.number)
                            .keyboardType(.decimalPad)
                        
                    }
                    HStack{
                        Text("Height")
                        TextField("Height", value: $height, format:.number)
                            .keyboardType(.decimalPad)
                        
                        
                        
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
                                
                                
//                                let cmHeight = ["cm" : 111, "inch": 2.22, "feet" : 3.33]
//                                let inchHeight = ["inch" : 4.44, "cm": 5.55, "feet" : 6.66]
//                                let feetHeight = ["cm" : 7.77, "inch": 8.88, "feet" : 9.99]
//
//                                switch (selectedHeight){
//                                case "cm" :
//                                    height = height * Double((cmHeight[selectedHeightbefore] ?? Double(0.0)))
//                                case "inch" :
//                                    height = height * Double((inchHeight[selectedHeightbefore] ?? Double(Int(0.0))))
//                                case "feet" :
//                                    height = height * Double((feetHeight[selectedHeightbefore] ?? Double(0.0)))
//                                default:
//                                    print("Something went wrong!")
//                                }
                                
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
                        Text("Tracked Calories") //ambil dari healthkit
                        TextField("tCalories", value: $trackedCalorie, format:.number)
                            .keyboardType(.decimalPad)
                    }
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
                                        
                    
                }header: {
                    Text("Body Details")
                }
                .multilineTextAlignment(.trailing)
                
//                Button{
//
//                    // move to a function
//                    // change it to "see more" -> about bmi, dll
//
//                    var rmr: Double = (10 * Double(weight)) + (6.25 * height) - (5 * Double(age)) + 5
//
//                    var bmr: Double = 0
//
////                    var bmi: Double = 0
//
////                    let newHeight = selectedHeight
//                    let newWeight = selectedWeight
//
//
//
//
//
//                    if gender == "male"{
//                        rmr = rmr + 5
//                        bmr = 88.362 + (13.397 * Double(weight)) + (4.799 * height) - (5.677 * Double(age))
//                    } else if gender == "female" {
//                        rmr = rmr - 161
//                        bmr = 447.593 + (9.247 * Double(weight)) + (3.098 * height) - (4.330 * Double(age))
//                    }
//
//
//
//                    // newWeight & newHeight ganti punya Jowi
//
//                    if newWeight == "lbs" {
//                        weight = weight * 0.453592
//                    } else {
//                        weight = weight
//                    }
//
//
//                    if selectedGoals == "WL"{
//                        calorie = bmr
//                    }else if selectedGoals == "MT"{
//                        calorie = rmr + Double(trackedCalorie) + 300 // more research needed
//                    }else if selectedGoals == "GM"{
//                        calorie = rmr + Double(trackedCalorie) + 700 // more research needed
//                    }
//
//                } label:{
//                    Text("Calculate!")
//                        .frame(maxWidth: .infinity)
//                        .font(.title2)
//                }
                
                
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
