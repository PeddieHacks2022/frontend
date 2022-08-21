//
//  SplashView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-21.
//

import SwiftUI
// Splash Screen that displays logo
struct SplashView: View {
    @State var isActive: Bool = false

    var body: some View {
        VStack {
            if self.isActive {
                LoginView()
            } else {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
