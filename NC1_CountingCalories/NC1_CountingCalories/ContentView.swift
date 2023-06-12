//
//  ContentView.swift
//  NC1_CountingCalories
//
//  Created by Manuel Johan Tito on 05/05/23.
//

import SwiftUI
import Charts



struct ContentView: View {
    
    @FetchRequest(sortDescriptors: []) var intake: FetchedResults<Intake>
    @FetchRequest(sortDescriptors: []) var bodyy: FetchedResults<Bodyy>
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var vm: HealthKitViewModel
    
    @State private var calorie: Double = Double()
    @State private var bmi: Int = Int()
    
    @State private var gender: String = ""
    @State private var age: Int = Int() // ganti birthdate
    @State private var selectedHeight = "cm"
    @State private var selectedWeight = "kg"
    @State private var height: Double = Double()
    @State private var weight: Double = Double()
    @State private var trackedCalorie: Int = Int()
    @State private var selectedGoals: String = "MT"
    
    @State private var foodname: String = ""
    @State private var foodcalorie: Double = Double()
    @State private var foodDate: Date = Date()
    
    @State var isModalSheetShown1: Bool = false
    @State var isModalSheetShown2: Bool = false
    
    
    @State private var totalCalorie: Double = Double()
    
    
    
    func calculateAll(){
        // move to a function
        // change it to "see more" -> about bmi, dll
        
        var rmr: Double = (10 * Double(weight)) + (6.25 * height) - (5 * Double(age)) + 5
        
        var bmr: Double = 0
        
        //                    var bmi: Double = 0
        
        //                    let newHeight = selectedHeight
        let newWeight = selectedWeight
        
        
        
        
        
        if gender == "male"{
            rmr = rmr + 5
            bmr = 88.362 + (13.397 * Double(weight)) + (4.799 * height) - (5.677 * Double(age))
        } else if gender == "female" {
            rmr = rmr - 161
            bmr = 447.593 + (9.247 * Double(weight)) + (3.098 * height) - (4.330 * Double(age))
        }
        
        
        
        // newWeight & newHeight ganti punya Jowi
        
        if newWeight == "lbs" {
            weight = weight * 0.453592
        } else {
            weight = weight
        }
        
        
        var sumcaloriein: Double = 0.0
        
        //sum calorie
        for i in 0..<intake.count {
//            print(i)
            let sapiman =  Double(intake[i].foodCalories)
            sumcaloriein = sumcaloriein + sapiman
        }
        
        
        
        if selectedGoals == "WL"{
            calorie = bmr - sumcaloriein// - tracked calorie
        }else if selectedGoals == "MT"{
            calorie = rmr + Double(trackedCalorie) + 300 - sumcaloriein// more research needed
        }else if selectedGoals == "GM"{
            calorie = rmr + Double(trackedCalorie) + 700 - sumcaloriein// more research needed
        }
    }
    
    
    //    init() {
    //        changeAuthorizationStatus()
    //    }
    

    
    var body: some View {
        NavigationStack{
            
            Form {
                Section{
                    HStack{
                        // add image
                        Text("\(calorie, specifier: "%.2f") KCal to go")
                            .frame(maxWidth:.infinity, alignment: .center)
                            .font(.title)
                            .onAppear(){
                                
//                                var total = intake.foodCalories
//                                var calorieAwal = calorie
//
//                                for i in 0..<intake.count {
//
//                                    total = total + total
//
//                                    totalCalorie = $intake.foodcalorie[i]
//                                }
//                                calorie = calorieAwal - total
                                
//                                var minusFood = foodcalorie
//                                    minusFood = minusFood + minusFood
//
//                                calorie = calorie - minusFood
                                
                            }
                        // add KCal
                        // KCal to go (sisa calorie yang harus di masukan)
                    }
                    //                    HStack{
                    //                        Text("Tracked Calories")
                    //                        TextField("tCalories", value: $trackedCalorie, format:.number)
                    //                            .keyboardType(.decimalPad)
                    //                    }
                }header:{
                    HStack{
                        Text("Calorie needed")
                        //                            .font(.title2)
                        
                    }
                }
                
                
                Section{
                    List(intake){intake in
                        HStack{
                            Text(intake.foodName ?? "u")
                            Spacer()
                            Text("\(intake.foodCalories)")
                        }
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                    }
                    
                    
                    
                }header:{
                    HStack{
                        Text("today's intake")
                            .font(.headline)
                        
                    }
                }
                //                Button{
                //
                //                } label: {
                //                    Text("See More!")
                //                        .frame(maxWidth: .infinity)
                //                        .font(.title2)
                //                }
                
                
                //                Section{
                //                    VStack{
                //                        Text("Result Here")
                //                        // calories have to take, BMI, suggestion (if underweight / overweight)
                //                    }
                //                }header: {
                //                    Text("Result")
                //                }
                
                // add saved intake di hari2 sebelumnya, tanggal2, dll
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Let's Count")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button("+"){
                        self.isModalSheetShown2 = true
                        // add calorie intake
                    }
                    .sheet(isPresented: $isModalSheetShown2,onDismiss:{
                        
                    }){
                        AddIntake(sheet2: $isModalSheetShown2)
                        
                    }
                    
                    
                    
                    
                    Button("Profile"){
                        self.isModalSheetShown1 = true
                    }
                    .sheet(isPresented: $isModalSheetShown1, onDismiss:{
                        
                    }){
                        ProfileVieew(sheet1: $isModalSheetShown1, gender: $gender, age: $age, selectedHeight: $selectedHeight, selectedWeight: $selectedWeight, height: $height, weight: $weight, trackedCalorie: $trackedCalorie, selectedGoals: $selectedGoals)
                    }
                }
            }
        }
        .onChange(of: isModalSheetShown1 || isModalSheetShown2, perform: { newValue in
            calculateAll()
        })
        .onAppear {
            if bodyy.count > 0 {
                gender = bodyy[bodyy.count - 1].gender ?? ""
                age = Int(bodyy[bodyy.count - 1].age)
                height = bodyy[bodyy.count - 1].height
                weight = bodyy[bodyy.count - 1].weight
                
                
                
                selectedGoals = bodyy[bodyy.count - 1].goals ?? ""
                
                
                
                
                
                
                calculateAll()
                
            }else{
                
            }
            
            vm.healthRequest()
            trackedCalorie = Int(vm.userCalCount) ?? 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
