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
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                
                ButtonView(iconSystemName: IconButtons.icons.refresh,
                           text: "Refresh") {
                    homeViewModel.refresh()
                }
                
                ButtonView(iconSystemName: IconButtons.icons.signout,
                           text: "Log out") {
                    sessionViewModel.logout()
                    path.removeAll()
                }
                
            }.padding(.top, 40)
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(homeViewModel.playlists) { playlist in
                        VStack(alignment: .leading) {
                            Text("\(playlist.name) (\(playlist.totalTracks))")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(playlist.ownerName)
                                .font(.footnote)
                        }
                        .padding(.bottom, 8)
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            Spacer()
            
        }
        .onAppear(perform: {
            homeViewModel.fetch()
        })
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView(path: .constant([]))
}
