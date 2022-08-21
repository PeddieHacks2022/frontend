//
//  StatisticsView.swift
//  FitForm
//
//  Created by Anish Aggarwal on 2022-08-20.
//

import Charts
import Foundation
import SwiftUI

struct StatisticsView: View {
    var test = LineChartData()
    
    var body: some View {
        ZStack{
            ARViewContainer().edgesIgnoringSafeArea(.all)
            Text(String(controller.reps))
        }
                    
        
    }
}
