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
    @State private var workoutList: [WorkoutRequest] = [
        WorkoutRequest(id: 0, name: "my workout 1", workoutType: "Curl", reps: 44, createdDate: ""),
        WorkoutRequest(id: 1, name: "my workout 2", workoutType: "Curl", reps: 44, createdDate: ""),
        WorkoutRequest(id: 2, name: "my workout 3", workoutType: "Curl", reps: 44, createdDate: ""),
        WorkoutRequest(id: 3, name: "my workout 4", workoutType: "Curl", reps: 44, createdDate: ""),
    ]
    @State private var routineList: [RoutineRequest] = [
        RoutineRequest(id: 0, name: "My Routine 1", workouts: []),
        RoutineRequest(id: 1, name: "My Routine 2", workouts: []),
        RoutineRequest(id: 2, name: "My Routine 3", workouts: []),
        RoutineRequest(id: 3, name: "My Routine 4", workouts: []),
    ]
    @State private var redirect: Bool = false
    @State private var workoutMode: WorkoutMode = .workout

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
                Text("\(workoutMode == WorkoutMode.workout ? "🏋️Select Workout" : "⚡Select Routine")")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                /* .frame(alignment: .center) */
                Spacer()
                Button(action: { if workoutMode == WorkoutMode.workout { createWorkoutPopup = true } else { createRoutinePopup = true } }) {
                    Image(systemName: "plus").resizable().aspectRatio(contentMode: .fit)
                }
                .frame(height: 20.0)
                .padding(.trailing)
                .popover(isPresented: $createWorkoutPopup) {
                    ZStack {
                        NavigationView {
                            Form {
                                Section(header: Text("Workout Information")) {
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

                                Section(footer: Text("A workout is a single type of exercise that you perform. You can build an entire workout routines by composing individual workouts.")) {
                                    Button("Create Workout", action: createWorkout).disabled(workoutName == "" || amountReps == "" || (weight == "" && selectedType == "Bicep Curl"))
                                    Button("Cancel", action: { createRoutinePopup = false }).foregroundColor(.red)
                                }

                            }.navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text("Create Workout")
                                            .font(.title)
                                            .fontWeight(.bold)
                                    }
                                }
                        }
                    }
                }
                .popover(isPresented: $createRoutinePopup) {
                    ZStack {
                        NavigationView {
                            Form {
                                Section(header: Text("Routine information")) {
                                    HStack {
                                        Text("Routine Name")
                                        Spacer()
                                        TextField("My Routine", text: $routineName).multilineTextAlignment(.trailing)
                                    }
                                }

                                Section(header: Text("Workouts")) {
                                    ForEach(selectedWorkouts.indices, id: \.self) { index in
                                        Picker("Workout \(index + 1)", selection: $selectedWorkouts[index]) {
                                            ForEach(workoutList, id: \.self) { workout in
                                                Text(workout.name).tag(String(workout.id))
                                            }
                                        }
                                    }
                                    Button("Add Workout", action: addWorkoutToRoutine)
                                }

                                Section(footer: Text("Routines are 'playlists' of workouts. You can add workouts that you have previously created into this workout routine.")) {
                                    Button("Create Routine", action: createRoutine).disabled(routineName == "")
                                    Button("Cancel", action: { createRoutinePopup = false }).foregroundColor(.red)
                                }

                            }.navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text("Create Routine")
                                            .font(.title)
                                            .fontWeight(.bold)
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.leading)
            .frame(maxWidth: .infinity)

            HStack {
                Picker("Workout Mode", selection: $workoutMode) {
                    Text("Workout").tag(WorkoutMode.workout)
                    Text("Routine").tag(WorkoutMode.routine)
                }.pickerStyle(.segmented).padding(.trailing).padding(.leading)
            }

            VStack {
                Form {
                    if workoutMode == WorkoutMode.workout {
                        Section(footer: Text("\(workoutList.count) total workouts")) {
                            ForEach(workoutList, id: \.id) { workout in
                                Button(action: {
                                    print("here")
                                    print(workout.id)
                                    construct.workoutId = workout.id
                                    construct.isRoutine = 0

                                    redirect = true
                                }) {
                                    HStack {
                                        Text(workout.name)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(workout.workoutType)
                                            .padding(.trailing, 10)
                                        Image(systemName: "chevron.right").resizable().aspectRatio(contentMode: .fit)
                                            .frame(height: 20.0)
                                    }
                                }.foregroundColor(.gray)
                            }
                        }
                    } else {
                        Section(footer: Text("\(routineList.count) total routines")) {
                            ForEach(routineList, id: \.id) { routine in
                                Button(action: {
                                    print("routine.id" + String(routine.id))
                                    construct.workoutId = routine.id
                                    construct.isRoutine = 1

                                    redirect = true
                                }) {
                                    HStack {
                                        Text(routine.name)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("\(routine.workouts.count) workouts")
                                            .padding(.trailing, 10)
                                        Image(systemName: "chevron.right").resizable().aspectRatio(contentMode: .fit)
                                            .frame(height: 20.0)
                                    }
                                }.foregroundColor(.gray)
                            }
                        }
                    }
                }
            }

            Spacer()
        }.onAppear {
            /* getWorkouts() */
            /* getRoutines() */
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
