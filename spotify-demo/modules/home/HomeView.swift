//
//  HomeView.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 28/11/23.
//

import SwiftUI

struct HomeView: View {
    @Binding var path: [Navigation]
    @StateObject var sessionViewModel = SessionViewModel()
    
    var body: some View {
        VStack {
            ButtonView(iconSystemName: IconButtons.icons.signout,
                    text: "Log out") {
                sessionViewModel.logout()
                path.removeAll()
            }
            Text("Hello")
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView(path: .constant([]))
}
