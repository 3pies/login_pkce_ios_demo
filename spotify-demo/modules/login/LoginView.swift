//
//  LoginView.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 28/11/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @State var path: [Navigation] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ButtonView(iconSystemName: IconButtons.icons.lock,
                           text: "Login",
                           action: {
                    viewModel.login()
                })
            }
            .onReceive(viewModel.$isLogged, perform: { value in
                if value == true {
                    path.append(Navigation(view: "HomeView"))
                } else {
                    viewModel.checkIsLogged()
                }
            })
            .navigationDestination(for: Navigation.self) { nav in
                HomeView(path: $path)
            }
            .padding()
        }
        .onOpenURL { incomingURL in
            viewModel.handleUrl(url: incomingURL)
        }
    }
}

#Preview {
    LoginView()
}
