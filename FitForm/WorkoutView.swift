//
//  WorkoutView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-20.
//

import SwiftUI
import AVKit
struct WorkoutView: View {
    
    var body: some View {
        ZStack{
            ARViewContainer().edgesIgnoringSafeArea(.all)
            Text(String(controller.reps))
        }
                    
        
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
