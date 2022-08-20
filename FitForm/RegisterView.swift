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
            ZStack{
//                Color.blue.ignoresSafeArea()
                VStack{
                    Text("Register")
                        .font(.largeTitle)
                        .bold()
                        .padding()
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
                    Button("Sign Up") {
                        Task{
                            await APIConstruct.register(info:signInfo)
                        }
                        
                        isRegistered = true
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    NavigationLink( destination: LoginView(),
                                    isActive:  $isRegistered){
                        EmptyView()
                    }
                    Spacer()
                    NavigationLink( destination: LoginView()){
                        Text("Login")
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
