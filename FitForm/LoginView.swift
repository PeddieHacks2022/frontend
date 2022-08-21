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
            ZStack{
//                Color.blue.ignoresSafeArea()
                VStack{
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
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
                            Task{
                            await construct.login(info:signInfo)
                            isLoggedIn = construct.sessionID != -1
                            }
                        }) { Text("Sign In")
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .contentShape(Rectangle())
                            .background(Color.blue)
                            .cornerRadius(10)
                            }

                    NavigationLink( destination: HomeView(),
                                    isActive:  $isLoggedIn){
                        EmptyView()
                    }
                    Spacer()
                    NavigationLink( destination: RegisterView()){
                        Text("Register")
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
