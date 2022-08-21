//
//  WorkoutView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-20.
//

import AVKit
import SwiftUI
struct WorkoutView: View {
    @State var redirect = false

    var body: some View {
        ZStack {
            ARViewContainer().edgesIgnoringSafeArea(.all)
            Text(String(controller.reps))
        }

        Button(action: {
            redirect = true
            controller.complete = true
        }) {
            Text("Finish")
                .font(.headline)
                .fontWeight(.bold)
        }.buttonStyle(.plain)
        NavigationLink(destination: HomeView(), isActive: $redirect) {
            EmptyView()
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
