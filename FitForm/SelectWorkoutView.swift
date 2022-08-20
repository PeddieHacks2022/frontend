//
//  SelectWorkoutView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-19.
//

import SwiftUI

struct WorkoutTemplate: Codable {
    var repCount: Int32
    var type: String
    var weight: Int32? // in pounds
}

struct SelectWorkoutView: View {
    @State private var panelState : String = "Select"
    @State private var createPopup : Bool = true
    
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
        }.padding(.vertical)
    }
    
    func createWorkout() {
        print("Create Workout")
    }
}

struct SelectWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        SelectWorkoutView()
    }
}

