//
//  ContentView.swift
//  SociallyDemo
//
//  Created by Phoe Lapyae on 16/06/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI
import Socially

struct ContentView: View {
    @ObservedObject var signInManager: SignInManager = .sharedInstance
    var body: some View {
        Group {
            if self.signInManager.user == nil {
                LoginButtonView()
            } else {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hi,")
                                .font(.largeTitle)
                                .bold()
                            Text(self.signInManager.user!.name)
                                .font(.largeTitle)
                                .bold()
                        }
                        .padding()
                        Spacer()
                    }.padding()
                    Spacer()
                    Button(action: {
                        SociallyAuth.signOut()
                    }) {
                        Text("Sign Out")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    }.buttonStyle(PlainButtonStyle())
                    .padding()
                    Spacer()
                }
            }
        }.onAppear {
            SociallyAuth.restore()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LoginButtonView: View {
    @ObservedObject var signInManager: SignInManager = .sharedInstance
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Socially")
                .font(.largeTitle)
                .bold()
            Spacer()
            VStack(alignment: .leading) {
                Text("Sign in")
                    .font(.title)
                    .bold()
                Button(action: {
                    SociallyAuth.signIn(with: .google)
                }) {
                    HStack(spacing: 15) {
                        Image("google")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.leading, 5)
                        Text("Sign In with Google")
                        Spacer()
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                }.buttonStyle(PlainButtonStyle())
                Button(action: {
                    SociallyAuth.signIn(with: .facebook)
                }) {
                    HStack(spacing: 15) {
                        Image("facebook")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.leading, 5)
                        Text("Sign In with Facebook")
                        Spacer()
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                }.buttonStyle(PlainButtonStyle())
            }.padding()
            Spacer()
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
    }
}
