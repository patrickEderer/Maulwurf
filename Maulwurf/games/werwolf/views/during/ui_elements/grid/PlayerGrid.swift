//
//  PlayerGrid.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI

struct PlayerGrid: View {
    var players: [WerwolfPlayer]
    var bounds: CGRect
    var onClick: ([Int]) -> Void
    var selectionStyle: SelectionStyle = .Single
    var awakePlayersRole: WerwolfRole
    var disabledPlayers: [Int]
    var deathMarkedPlayers: [Int]
    
    //Fill (selected), Stroke, Stroke (selected)
    var colors: (Color, Color, Color)
    
    @State private var selected: [Int] = []
    
    init(
        players: [WerwolfPlayer],
        bounds: CGRect = UIScreen.main.bounds,
        onClick: @escaping ([Int]) -> Void = { _ in },
        colors: (Color, Color, Color) = (Color(hex: "#EA4D3D").opacity(1 / 3), Color(hex: "#EA4D3D"), Color(hex: "#FF0000")),
        selectionStyle: SelectionStyle = .Single,
        awakePlayersRole: WerwolfRole,
        disabledPlayers: [Int] = [],
        deathMarkedPlayers: [Int] = []
    ) {
        self.players = players
        self.bounds = bounds
        self.onClick = onClick
        self.colors = colors
        self.selectionStyle = selectionStyle
        self.awakePlayersRole = awakePlayersRole
        self.disabledPlayers = disabledPlayers
        self.deathMarkedPlayers = deathMarkedPlayers
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: (0..<(fullscreen() ? 1 : 2)).map { _ in GridItem(.fixed(bounds.width * 0.45)) }) {
                ForEach (0..<players.count, id: \.self) { i in
                    if fullscreen() == (selected.contains(i) && selectionStyle == .Single) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(getFillColor(i))
                                .stroke(getStrokeColor(i), lineWidth: 2)
                                .contentShape(Rectangle())
                                .frame(width: bounds.width * (fullscreen() ? 0.9 : 0.45), height: fullscreen() ? (bounds.height * 0.9) : (bounds.width * 0.45))
                                .onTapGesture {
                                    if isPlayerDisabled(players[i]) {
                                        return
                                    }
                                    withAnimation(.bouncy(duration: 0.25, extraBounce: 0.05)) {
                                        clickedOn(i)
                                    }
                                    
                                    onClick(selected)
                                }
                                .overlay {
                                    ZStack {
                                        let player = players[i]
                                        ZStack {
                                            
                                            PlayerIcon(player: player, size: bounds.width * (fullscreen() ? 0.6 : 0.3), showDead: isPlayerDead(player))
                                                .colorMultiply(Color(hex: (isPlayerDisabled(player)) ? "#AAAAAA" : "#FFFFFF"))
                                            
                                            VStack {
                                                Text("\(players[i].getName())")
                                                    .fontWeight(.bold)
                                                    .minimumScaleFactor(0.3)
                                                    .padding(.top, 5)
                                                Spacer()
                                            }
                                        }
                                        VStack {
                                            if player.isAlive && awakePlayersRole == player.role {
                                                Image(systemName: "eye.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .scaleEffect(0.5)
                                                    .shadow(color: .black, radius: 3, x: 1, y: 1)
                                            }
                                        }
                                    }.allowsHitTesting(false)
                                }
                        }
                    }   
                }
            }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))
        }
        .frame(width: bounds.width, height: bounds.height)
    }
    
    private func fullscreen() -> Bool {
        return !selected.isEmpty && selectionStyle == .Single
    }
    
    private func isPlayerDisabled(_ player: WerwolfPlayer) -> Bool {
        return isPlayerDead(player) || player.role == awakePlayersRole || disabledPlayers.contains(player.index)
    }
    
    private func isPlayerDead(_ player: WerwolfPlayer) -> Bool {
        return deathMarkedPlayers.contains(player.index) || !player.isAlive
    }
    
    private func getFillColor(_ i: Int) -> Color {
        if isPlayerDead(players[i]) {
            return .gray.opacity(0.1)
        }
        
        if players[i].role == awakePlayersRole {
            return .clear
        }
        
        return selected.contains(i) ? colors.0 : .clear
    }
    
    private func getStrokeColor(_ i: Int) -> Color {
        if isPlayerDisabled(players[i]) {
            return colors.1.darker(by: 0.5)
        }
        
        return selected.contains(i) ? colors.2 : colors.1
    }
    
    private func clickedOn(_ i: Int) {
        SensoryFeedback.getInstance().impact(.light)
        
        if selectionStyle == .Single {
            if selected.contains(i) {
                selected.removeAll { $0 == i }
            } else {
                selected = [i]
            }
        } else if selectionStyle == .Pair {
            if selected.contains(i) {
                selected.removeAll { $0 == i }
            } else {
                if selected.count >= 1 {
                    selected.removeFirst(selected.count - 1)
                }
                selected.append(i)
            }
        } else {
            if selected.contains(i) {
                selected.removeAll { $0 == i }
            } else {
                selected.append(i)
            }
        }
    }
    
    private func copy() -> PlayerGrid {
        return PlayerGrid(players: players, bounds: bounds, onClick: onClick, colors: colors, selectionStyle: selectionStyle, awakePlayersRole: awakePlayersRole, disabledPlayers: disabledPlayers, deathMarkedPlayers: deathMarkedPlayers)
    }
    
    public func setBounds(bounds: CGRect) -> PlayerGrid {
        var copy = copy()
        copy.bounds = bounds
        return copy
    }
    
    public func onClick(onClick: @escaping ([Int]) -> Void) -> PlayerGrid {
        var copy = copy()
        copy.onClick = onClick
        return copy
    }
    
    public func setColors(colors: (Color, Color, Color)) -> PlayerGrid {
        var copy = copy()
        copy.colors = colors
        return copy
    }
    
    public func setSelectionStyle(_ style: SelectionStyle) -> PlayerGrid {
        var copy = copy()
        copy.selectionStyle = style
        return copy
    }
}
