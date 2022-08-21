//
//  SelectWorkoutView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-19.
//

import SwiftUI

struct RoutinePostBody: Encodable {
    var name: String
    var workoutIDs: [String]
}

struct WorkoutRequest: Decodable, Hashable {
    var id: Int
    var name: String
    var workoutType: String
    var reps: Int
    var createdDate: String
}

typealias RoutineRequest = [String: [WorkoutRequest]]
class WorkoutTemplate: Codable {
    var name: String
    var repCount: Int
    var type: String
    var weight: Int // in pounds
    init(name: String, repCount: Int, type: String, weight: Int) {
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
    @State private var workoutList: [WorkoutRequest] = [WorkoutRequest(id: 30_535_572, name: "X", workoutType: "Curl", reps: 44, createdDate: "2022-08-20 17:48:54.765379")]
    @State private var redirect: Bool = false

    // Popup States
    @State private var createPopup: Bool = false
    @State private var createWorkoutPopup: Bool = false
    @State private var createRoutinePopup: Bool = false

    // Create Workout States
    @State private var workoutName = ""
    @State private var selectedType = "Bicep Curl"
    @State private var amountReps = ""
    @State private var weight = ""

    // Create Routine Stated
    @State private var routineName = ""
    @State private var selectedWorkouts: [String] = []

    var workoutTypes = ["Bicep Curl", "Left Bicep Curl", "Alternating Bicep Curl", "Right Bicep Curl", "Jumping Jacks", "Push Up", "Sit Up"]

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
                Button(action: { createPopup = true }) {
                    Image(systemName: "plus.circle").resizable().aspectRatio(contentMode: .fit)
                }
                .padding(.trailing)
                .frame(height: 25.0)
                .actionSheet(isPresented: $createPopup, content: {
                    ActionSheet(
                        title: Text("What would you like to create?"),
                        buttons: [
                            .default(Text("Workout")) { createWorkoutPopup = true },
                            .default(Text("Routine")) { createRoutinePopup = true },
                            .cancel(),
                        ]
                    )
                })
                .popover(isPresented: $createWorkoutPopup) {
                    ZStack {
                        NavigationView {
                            Form {
                                Section {
                                    HStack {
                                        Text("Workout Name")
                                        Spacer()
                                        TextField("My Workout", text: $workoutName).multilineTextAlignment(.trailing)
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

                                Section {
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
                .popover(isPresented: $createRoutinePopup) {
                    ZStack {
                        NavigationView {
                            Form {
                                Section {
                                    HStack {
                                        Text("Routine Name")
                                        Spacer()
                                        TextField("My Routine", text: $routineName).multilineTextAlignment(.trailing)
                                    }
                                }

                                ForEach(selectedWorkouts.indices, id: \.self) { index in
                                    Picker("Workout \(index + 1)", selection: $selectedWorkouts[index]) {
                                        ForEach(workoutList, id: \.self) { workout in
                                            Text(workout.name).tag(String(workout.id))
                                        }
                                    }
                                }
                                Section {
                                    Button("Add", action: addWorkoutToRoutine)
                                }
                                Section {
                                    Button("Create", action: createRoutine).disabled(routineName == "")
                                }

                            }.navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text("Create Routine")
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
            VStack {
                ForEach(workoutList, id: \.id) { workout in
                    Button(action: {
                        print(workout.id)
                        construct.workoutId = workout.id
                        construct.initialize()
                        controller.initialize()
                        redirect = true
                    }) {
                        HStack {
                            VStack {
                                Text(workout.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                Text("# of Reps: " + String(workout.reps))
                                    .fontWeight(.thin)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            Text(workout.workoutType)
                        }
                        .padding(/*@START_MENU_TOKEN@*/ .all/*@END_MENU_TOKEN@*/).border(.orange, width: 2)
                    }.buttonStyle(.plain)
                    NavigationLink(destination: WorkoutView(), isActive: $redirect) {
                        EmptyView()
                    }
                }
            }
            Spacer()
        }.onAppear {
            getWorkouts()
            redirect = false
        }
    }

    func getWorkouts() {
        Task {
            workoutList = await construct.getWorkouts()
            print(workoutList)
        }
    }

    func createWorkout() {
        Task {
            var w = 0
            if weight != "" {
                w = Int(weight)!
            }
            await construct.createWorkout(data: WorkoutTemplate(name: workoutName, repCount: Int(amountReps)!, type: selectedType, weight: w))
            getWorkouts()
            createPopup = false
            createWorkoutPopup = false
        }
    }

    func createRoutine() {
        Task {
            await construct.createRoutine(body: RoutinePostBody(name: routineName, workoutIDs: selectedWorkouts))
            createPopup = false
            createRoutinePopup = false
        }
    }

    func addWorkoutToRoutine() {
        print("adding workout to routine")
        var newSelectedWorkouts = selectedWorkouts
        newSelectedWorkouts.append("")
        selectedWorkouts = newSelectedWorkouts
    }
}

struct SelectWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        SelectWorkoutView()
    }
}
