//
//  SelectWorkoutView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-19.
//

import SwiftUI
struct WorkoutRequest : Decodable{
    var id: Int
    var name: String
    var workoutType: String
    var reps: Int
    var createdDate: String
}
class WorkoutTemplate: Codable {
    var name: String
    var repCount: Int
    var type: String
    var weight: Int // in pounds
    init(name:String, repCount:Int,type:String,weight:Int) {
        self.name = name
        self.repCount = repCount
        self.type = type
        self.weight = weight
    }
    enum CodingKeys: String, CodingKey {
        case repCount
        case type
        case weight
        case name
        }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        repCount = try values.decode(Int.self, forKey: .repCount)
        type = try values.decode(String.self, forKey: .type)
        name = try values.decode(String.self, forKey: .name)
        weight = try values.decode(Int.self, forKey: .weight)        
    }
}

struct SelectWorkoutView: View {
    @State private var panelState : String = "Select"
    @State private var createPopup : Bool = false
    
    // Create Workout States
    @State private var selectedType = "Bicep Curl"
    @State private var amountReps = ""
    @State private var weight = ""
    @State private var workoutName = ""
    
    var workoutTypes = ["Bicep Curl", "Jumping Jacks"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Select Workout")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(alignment: .center)
                Spacer()
                Button(action: { createPopup = true}) {
                    Image(systemName: "plus.circle").resizable().aspectRatio(contentMode: .fit)
                        
                }
                .padding(.trailing)
                .frame(height: 25.0).popover(isPresented: $createPopup) {
                    ZStack {
                        NavigationView {
                            Form {
                                Section() {
                                    HStack {
                                        Text("Workout Name")
                                        Spacer()
                                        TextField("", text: $workoutName).multilineTextAlignment(.trailing)

                                    }
                                    Picker("Type of Workout", selection: $selectedType) {
                                        ForEach(workoutTypes, id: \.self) { type in
                                            Text(type)
                                        }
                                    }
                                    HStack {
                                        Text("Amount of Reps")
                                        Spacer()
                                        TextField("#", text: $amountReps).keyboardType(.numberPad).multilineTextAlignment(.trailing)

                                    }
                                    if selectedType == "Bicep Curl" {
                                        HStack {
                                            Text("Amount of Weight")
                                            Spacer()
                                            TextField("lbs", text: $weight).keyboardType(.numberPad).multilineTextAlignment(.trailing)

                                        }
                                    }
                                }
                                
                                Section() {
                                    Button("Create", action: createWorkout).disabled(workoutName == "" || amountReps == "" || (weight == "" && selectedType == "Bicep Curl"))
                                }
                                
                            }.navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text("Create Workout")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .padding(.top)
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.leading)
            .frame(maxWidth: .infinity)
        Spacer()
        }.onAppear{getWorkouts()}
    }
    func getWorkouts() {
        print("Fetching workouts")
        Task {
         await construct.getWorkouts()
        }
    }
    func createWorkout() {
        Task{
            var w = 0
            if weight != ""{
                w = Int(weight)!
            }
            await construct.createWorkout(data: WorkoutTemplate.init(name: workoutName, repCount: Int(amountReps)!, type: selectedType, weight: w))
            createPopup = false
        }
    }
}

struct SelectWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        SelectWorkoutView()
    }
}

