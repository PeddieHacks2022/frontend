//
//  SelectWorkoutView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-19.
//

import SwiftUI

enum WorkoutMode {
    case workout
    case routine
}

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

struct RoutineRequest: Decodable {
    var id: Int
    var name: String
    var workouts: [WorkoutRequest]
}

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
    @State private var workoutList: [WorkoutRequest] = []
    @State private var routineList: [RoutineRequest] = []
    @State private var redirect: Bool = false
    @State private var workoutMode: WorkoutMode = .routine

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

    var workoutTypes = ["Bicep Curl", "Left Bicep Curl", "Right Bicep Curl", "Overhead Press", "Left Overhead Press", "Right Overhead Press"]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Select \(workoutMode == WorkoutMode.workout ? "Workout" : "Routine")")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(alignment: .center)
                Spacer()
                Button(action: { if workoutMode == WorkoutMode.workout { createWorkoutPopup = true } else { createRoutinePopup = true } }) {
                    Image(systemName: "plus.circle").resizable().aspectRatio(contentMode: .fit)
                }
                .padding(.trailing)
                .frame(height: 25.0)
                /* .actionSheet(isPresented: $createPopup, content: { */
                /*     ActionSheet( */
                /*         title: Text("What would you like to create?"), */
                /*         buttons: [ */
                /*             .default(Text("Workout")) { createWorkoutPopup = true }, */
                /*             .default(Text("Routine")) { createRoutinePopup = true }, */
                /*             .cancel(), */
                /*         ] */
                /*     ) */
                /* }) */
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
            Picker("Workout Mode", selection: $workoutMode) {
                Text("Workout").tag(WorkoutMode.workout)
                Text("Routine").tag(WorkoutMode.routine)
            }.pickerStyle(.segmented)

            if workoutMode == WorkoutMode.workout {
                VStack {
                    List {
                        ForEach(workoutList, id: \.id) { workout in
                            Button(action: {
                                print("here")
                                print(workout.id)
                                construct.workoutId = workout.id
                                construct.isRoutine = 0

                                redirect = true
                                construct.initialize()
                                controller.initialize()
                            }) {
                                Text(workout.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                /*
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
                                     Text("Insert Image")
                                 .padding(/*@START_MENU_TOKEN@*/ .all/*@END_MENU_TOKEN@*/)
                                 */
                            }.buttonStyle(.plain)
                        }
                    }
                }
            } else {
                VStack {
                    List {
                        ForEach(routineList, id: \.id) { routine in
                            Button(action: {
                                print("routine.id" + String(routine.id))
                                construct.workoutId = routine.id
                                construct.isRoutine = 1

                                redirect = true
                                construct.initialize()
                                controller.initialize()
                            }) {
                                Text(routine.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                            }.buttonStyle(.plain)
                        }
                    }
                }
            }

            Spacer()
        }.onAppear {
            getWorkouts()
            getRoutines()
            redirect = false
        }
        NavigationLink(destination: WorkoutView(), isActive: $redirect) {
            EmptyView()
        }
    }

    func getWorkouts() {
        Task {
            workoutList = await construct.getWorkouts()
            print(workoutList)
        }
    }

    func getRoutines() {
        Task {
            routineList = await construct.getRoutines()
            print(routineList)
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
            getRoutines()
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
