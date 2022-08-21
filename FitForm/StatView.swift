//
//  StatView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-21.
//

import SwiftUI

enum GraphType {
    case reps
    case time
}

struct StatView: View {
    @State var timeGraph: Data? = nil
    @State var totalExerciseTime = 0
    @State var exerciseCount = 0
    @State var repCount = 0

    @State var graphSelected: GraphType = .time

    var body: some View {
        VStack {
            Text("Statistics")
                .font(.title)
                .fontWeight(.bold)
                .frame(alignment: .center)
            Spacer()
            Form {
                Section(header: Text("Overall Stats")) {
                    HStack {
                        Text("Total Exercise Time (in minutes):")
                        Spacer()
                        Text(String(totalExerciseTime))
                    }
                    HStack {
                        Text("Total Number of Exercises:")
                        Spacer()
                        Text(String(exerciseCount))
                    }
                    HStack {
                        Text("Total Number of Reps:")
                        Spacer()
                        Text(String(repCount))
                    }
                }
                Section(header: Text("Weekly Graphical Stats")) {
                    Picker("Workout Mode", selection: $graphSelected) {
                        Text("Exercise Time").tag(GraphType.time)
                        Text("Exercise Type").tag(GraphType.reps)
                    }.pickerStyle(.segmented)
                    HStack {
                        Spacer()
                        AsyncImage(url: URL(string: "http://192.168.2.100:8000/graph/\(graphSelected == .time ? "time" : "reps")")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.red
                        }.frame(width: 300, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        Spacer()
                    }
                }
            }
        }
    }
}

struct StatView_Previews: PreviewProvider {
    static var previews: some View {
        StatView()
    }
}
