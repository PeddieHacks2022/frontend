//
//  LoginView.swift
//  FitForm
//
//  Created by Nithin Muthukumar on 2022-08-19.
//

import SwiftUI

struct LoginView: View {
    @State private var loginInfo = LoginInfo()
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
                    TextField("Username", text: $loginInfo.username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                    SecureField("Password", text: $loginInfo.password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                    Button("Sign In") {
                        Task{
                            await login()
                        }
                        
                        isLoggedIn = true
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
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
    /// Authenticate with API and login
    func login() async {
        
        guard let encoded = try? JSONEncoder().encode(loginInfo) else {
            
            print("Failed to encode login info")
            return
        }
        let url = URL(string: "localhost:5000/signup")!
        var request = URLRequest(url:url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            print(data)
            
        }
        catch {
            print("Login Failed")
        }
        
    }
    
}






struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
