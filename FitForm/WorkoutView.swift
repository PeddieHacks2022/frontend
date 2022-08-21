//
//  WorkoutView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-20.
//

import AVKit
import SwiftUI
struct WorkoutView: View {
    var body: some View {
        ZStack {
            ARViewContainer().edgesIgnoringSafeArea(.all)
            Text(String(controller.reps))
        }

        NavigationLink(destination: HomeView()) {
            Text("Finish")
                .padding()
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .contentShape(Rectangle())
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
