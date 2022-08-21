//
//  HomeView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-19.
//
// 053002
import SwiftUI

struct HomeView: View {
    @State var name: String = "Anish"
    var quotes: [String] = ["“The only person you are destined to become is the person you decide to be.” - Ralph Waldo E.", "“Once you learn to quit, it becomes a habit.” - Vince L. Jr", "The last three or four reps is what makes the muscle grow. - Arnold S.", "¨Physical fitness is the basis of creative intellectual activity.¨ – John F. Kennedy"]
    var body: some View {
        VStack {
            VStack {
                Text("Welcome, \(name)!")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                RoundedRectangle(cornerRadius: 20).fill(Color(red: 0.8, green: 0.8, blue: 0.9)).frame(width: 300, height: 100).overlay(
                    VStack {
                        Text(quotes[Int.random(in: 1 ..< quotes.count)])
                            .font(.callout)
                            .italic()
                            .fontWeight(.medium)
                            .lineLimit(4)
                            .padding(/*@START_MENU_TOKEN@*/ .all/*@END_MENU_TOKEN@*/).multilineTextAlignment(.center)
                    })
            }
            Spacer()
            ZStack {
                Rectangle().fill(.blue).frame(width: 250, height: 290).cornerRadius(25).rotationEffect(Angle(degrees: 45))
                Image("home_page").resizable().aspectRatio(contentMode: .fit
                ).frame(width: 325)
            }
            Spacer()
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
            .padding()
        }
        .padding(.top)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
