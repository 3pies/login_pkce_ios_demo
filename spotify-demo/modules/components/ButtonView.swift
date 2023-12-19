//
//  ButtonView.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 28/11/23.
//

import SwiftUI

struct ButtonView: View {
    
    var iconSystemName: String
    var text: String
    var action: () -> Void
    
    
    
    private var iconSize: CGFloat {
        return 20.0
    }
    
    
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: iconSystemName)
                    .foregroundColor(Color.white)
                    .frame(width: iconSize, height: iconSize)
                    
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 6)
                )
        }
        .frame(alignment: Alignment.center)
        .background(Color.black)
        .buttonStyle(ButtonDefault())
    }
}

struct ButtonDefault: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.7), value: configuration.isPressed)
    }
    
    
}

struct IconButtons {
    static let icons = IconNames()
    
    struct IconNames {
        let lock = "lock"
        let signout = "figure.run"
        let refresh = "arrow.clockwise"
    }
}


#Preview {
    ButtonView(iconSystemName: IconButtons.icons.lock,
               text: "Login",
               action: {})
}
