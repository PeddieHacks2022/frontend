//
//  HomeView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-19.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView{
            VStack{
            

                NavigationLink(destination: SelectWorkoutView()){
                    Text("Start Workout")
                
                }
            }
            
        }
        
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
