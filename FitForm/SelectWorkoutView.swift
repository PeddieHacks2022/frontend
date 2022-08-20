//
//  SelectWorkoutView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-19.
//

import SwiftUI

class WorkoutTemplate: APIData {
    var repCount: Int
    var type: String
    var weight: Int // in pounds
    init(repCount:Int,type:String,weight:Int) {
        
        self.repCount = repCount
        self.type = type
        self.weight = weight
        super.init()
        
    }
    enum CodingKeys: String, CodingKey {
        case repCount
        case type
        case weight
        }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        repCount = try values.decode(Int.self, forKey: .repCount)
        type = try values.decode(String.self, forKey: .type)
        weight = try values.decode(Int.self, forKey: .weight)
        super.init()
        
    }
}

struct SelectWorkoutView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SelectWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        SelectWorkoutView()
    }
}
