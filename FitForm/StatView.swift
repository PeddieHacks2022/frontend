//
//  StatView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-21.
//

import SwiftUI

struct StatView: View {
    @State var timeGraph: Data? = nil
    var body: some View {
        Image(uiImage: UIImage(data: timeGraph!) ?? UIImage(contentsOfFile: "chart.png")!)
            .onAppear {
                Task {
                    timeGraph = await construct.getGraph(name: "time")
                }
            }
    }
}

struct StatView_Previews: PreviewProvider {
    static var previews: some View {
        StatView()
    }
}
