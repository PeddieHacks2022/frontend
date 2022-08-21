//
//  LoginView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-19.
//

import SwiftUI

struct LoginView: View {
    @State private var signInfo = SignInfo()
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var isLoggedIn = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.orange.ignoresSafeArea()
                VStack {
                    Text("Welcome back.")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Text("it's great to see you again")
                        .foregroundColor(.white)
                        .padding(.bottom)
                    TextField("Email", text: $signInfo.email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                    SecureField("Password", text: $signInfo.password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                    Button(
                        action: {
                            Task {
                                await construct.login(info: signInfo)
                                isLoggedIn = construct.sessionID != -1
                            }
                        }) { Text("Login")
                            .padding()
                            .foregroundColor(.black)
                            .frame(width: 300, height: 50)
                            .contentShape(Rectangle())
                            .background(Color.white)
                            .cornerRadius(10)
                        }

                    NavigationLink(destination: HomeView(),
                                   isActive: $isLoggedIn) {
                        EmptyView()
                    }
                    Spacer()
                    NavigationLink(destination: RegisterView()) {
                        Text("Don't have an account?").foregroundColor(.black)
                    }.padding(.bottom, 30.0)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
