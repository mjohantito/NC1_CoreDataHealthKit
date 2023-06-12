//
//  AddIntake.swift
//  NC1_CountingCalories
//
//  Created by Manuel Johan Tito on 16/05/23.
//

import SwiftUI

struct AddIntake: View {
    
    @FetchRequest(sortDescriptors: []) var intake: FetchedResults<Intake>
    @Environment(\.managedObjectContext) var moc
    
    @Binding var sheet2: Bool
    
    @State private var foodname: String = ""
    @State private var foodcalorie: Int = Int()
    @State private var foodDate: Date = Date()
    
    
    var body: some View {
        
        NavigationStack{
            Form{
                Section{
                    HStack{
                        DatePicker(
                            "Date",
                            selection: $foodDate,
                            displayedComponents: [.date,.hourAndMinute]
                        )
                    }
                    HStack{
                        Text("Name")
                        TextField(text: $foodname) {
                            Text("Food Name")
                        }
                        .keyboardType(.default)
                    }
                    HStack{
                        Text("Food Calorie")
                        TextField("Calorie", value: $foodcalorie, format:.number)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Button("Cancel"){
                        sheet2 = false
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button("Add"){
                        
                        let masuk = Intake(context: moc)
                        masuk.date = foodDate
                        masuk.foodName = foodname
                        masuk.foodCalories = Int32(foodcalorie)
                        
                        
                        try? moc.save()
                        
                        // isi ke core data
                        sheet2 = false
                    }
                }
            }
        }
        .multilineTextAlignment(.trailing)
    }
}

struct AddIntake_Previews: PreviewProvider {
    static var previews: some View {
        AddIntake(sheet2: .constant(false))
    }
}
