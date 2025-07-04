//
//  WerwolfArmorRoleUI.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 05.07.25.
//

import Foundation
import SwiftUI

struct WerwolfArmorRoleUI: View {
    var engine: WerwolfEngine
    var screen = UIScreen.main.bounds
    
    @State var selectedPlayers: [Int] = []
    
    var body: some View {
        VStack {
            Text("Wen möchtest\ndu Verlieben?")
                .foregroundColor(Color(hex: "#FF1C57"))
                .font(.system(size: 75))
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .ignoresSafeArea(.all)
                .padding(.top, 10)
                .minimumScaleFactor(0.5)
            
            PlayerGrid(players: engine.getPlayers(), awakePlayersRole: .None)
                .setSelectionStyle(.Pair)
                .setColors(colors: (Color(hex: "#B81440").opacity(1 / 3), Color(hex: "#B81440"), Color(hex: "#FF407F")))
                .setBounds(bounds: CGRect(x: 0, y: 0, width: screen.width * 0.9, height: screen.height * 0.6))
                .onClick { selected in
                    withAnimation(.easeOut(duration: 0.5)) {
                        selectedPlayers = selected
                    }
                }
            
            let fillPercentage = getButtonFillPercentage()
            Button {
                engine.roleActions!.armorAction()
            } label: {
                Text(getButtonText())
                    .font(.system(size: 20).bold())
                    .foregroundColor(Color(hex: "#FFB7E4"))
                    .frame(width: 200, height: 60)
            }.background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#5E5E5E"))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: fillPercentage == 1 ? "#FF1C57" : "#961134"))
                        .mask(
//                        LinearGradient(stops: [.init(color: Color(hex: fillPercentage == 1 ? "#FF1C57" : "#961134"), location: fillPercentage - 0.01), .init(color: Color(hex: "#5E5E5E"), location: fillPercentage)], startPoint: .leading, endPoint: .trailing)
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 200)
                                    .offset(x: (fillPercentage - 1) * 200)
                            }
                        )
                }
            ).disabled(fillPercentage != 1)
        }
    }
    
    private func getButtonFillPercentage() -> CGFloat {
        return CGFloat(selectedPlayers.count) / 2.0
    }
    
    private func getButtonText() -> String {
        return selectedPlayers.count == 2 ? "Verlieben 🏹" : "\(selectedPlayers.count)/2🏹"
    }
}
