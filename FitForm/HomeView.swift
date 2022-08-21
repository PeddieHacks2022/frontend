//
//  HomeView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-19.
//
// 053002
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: SelectWorkoutView()) {
                Text("Start Workout")
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .contentShape(Rectangle())
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            NavigationLink(destination: StatView()) {
                Text("Stats")
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .contentShape(Rectangle())
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
