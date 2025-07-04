//
//  WerwolfWerwolfRoleUI.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI

struct WerwolfSeherinRoleUI: View {
    var engine: WerwolfEngine
    var screen = UIScreen.main.bounds
    
    @State var selectedPlayer: Int? = nil
    
    @State var viewIndex: Int = 0
    
    var body: some View {
        switch viewIndex {
        case 0: selectionView
        default: showView
        }
    }
    
    var selectionView: some View {
        VStack {
            Text("Wen möchtest\ndu Sehen?")
                .foregroundColor(Color(hex: "#951DF6"))
                .font(.system(size: 50))
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .ignoresSafeArea(.all)
                .padding(.top, 10)
            
            PlayerGrid(players: engine.getPlayers())
                .setColors(colors: (Color(hex: "#951DF6").opacity(1 / 3), Color(hex: "#951DF6"), Color(hex: "#C93FFF")))
                .setBounds(bounds: CGRect(x: 0, y: 0, width: screen.width * 0.9, height: screen.height * 0.6))
                .onClick { selected in
                    if selected.count == 0 {
                        selectedPlayer = nil
                    } else {
                        selectedPlayer = selected[0]
                    }
                }
            
            Button {
                viewIndex = 1
            } label: {
                Text("Anschauen")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 20, leading: 100, bottom: 20, trailing: 100))
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(selectedPlayer == nil ? .gray : Color(hex: "#951DF6"))
            )
            .disabled(selectedPlayer == nil)
        }
    }
    
    var showView: some View {
        VStack {
            Spacer()
            
            Text("\(engine.getPlayers()[selectedPlayer!].role)")
                .font(.system(size: 50))
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                engine.roleUIScreenState = .Sleeping
            } label: {
                Text("Weiter")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 20, leading: 100, bottom: 20, trailing: 100))
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(selectedPlayer == nil ? .gray : Color(hex: "#951DF6"))
            )
            .disabled(selectedPlayer == nil)
        }
    }
}
