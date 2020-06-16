//
//  ContentView.swift
//  SociallyDemo
//
//  Created by Phoe Lapyae on 16/06/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var signInManager = SignInManager()
    var body: some View {
        Group {
            if self.signInManager.user == nil {
                VStack {
                    Button(action: {
                        self.signInManager.signIn()
                    }) {
                        HStack {
                            Image("google")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign In with Google")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.4))
                    }
                }
            } else {
                VStack {
                    Text("I'm \(self.signInManager.user!.name)")
                    Button(action: {
                        self.signInManager.signOut()
                    }) {
                        HStack {
                            Image("google")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign Out")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.4))
                    
                    }
                }
            }
        }
        .onAppear {
            if self.signInManager.googleManager.hasPreviousSignIn {
                self.signInManager.restore()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
