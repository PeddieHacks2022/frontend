//
//  RegisterView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-20.
//

import SwiftUI

struct RegisterView: View {
    @State private var signInfo = SignInfo()
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var isRegistered = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.cyan.ignoresSafeArea()
                VStack {
                    Text("Join FitForm.")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Text("you're going to love it here")
                        .foregroundColor(.white)
                        .padding(.bottom)
                    TextField("Name", text: $signInfo.name)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    TextField("Email", text: $signInfo.email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    SecureField("Password", text: $signInfo.password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    Button(
                        action: {
                            Task {
                                await construct.register(info: signInfo)
                                isRegistered = construct.sessionID != -1
                            }
                        }) { Text("Register")
                            .padding()
                            .foregroundColor(.black)
                            .frame(width: 300, height: 50)
                            .contentShape(Rectangle())
                            .background(Color.white)
                            .cornerRadius(10)
                        }

                    NavigationLink(destination: HomeView(),
                                   isActive: $isRegistered) {
                        EmptyView()
                    }
                    Spacer()
                    NavigationLink(destination: LoginView()) {
                        Text("Already have an account?").foregroundColor(.black)
                    }.padding(.bottom, 30.0)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
