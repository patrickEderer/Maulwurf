//
//  PlayerEditView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.06.25.
//

import Foundation
import SwiftUI

struct UnoPlayerEditView: View {
    @ObservedObject var updater = Updater.getInstance()
    var manager: UnoViewManager
    var settings: UnoSettingsView
    
    var screen = UIScreen.main.bounds
    
    @State var playerIndex: Int
    
    let assetScale = 0.75
    let buttonScaleFactor = 0.5
    
    var body: some View {
        VStack {
            let player = manager.engine.players[playerIndex]
            
            HStack {
                Text("Name: ")
                
                TextField("Player \(playerIndex + 1)", text: Binding(get: {
                    player.name
                }, set: { new in
                    manager.engine.players[playerIndex].name = new
                    
                    manager.engine.savePlayers()
                    
                    updater.update()
                }))
                .padding(10)
                .background(Color(hex: "#0096FF").cornerRadius(10))
            }
            
            characterDesignView
            
            Spacer()
        }
    }
    
    private var characterDesignView: some View {
        VStack {
            let player = manager.engine.players[playerIndex]
            
            HStack {
                ColorPicker("Hautfarbe", selection: Binding(get: {
                    player.imageAssets.0
                }, set: { new in
                    player.imageAssets.0 = new
                    
                    manager.engine.savePlayers()
                    
                    updater.update()
                }))
                .frame(width: screen.width / 2)
                
                Spacer()
                
                Button {
                    player.setRandomAssets()
                    
                    updater.update()
                    
                    manager.engine.savePlayers()
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle")
                }
            }
            
            HStack {
                HStack {
                    ColorPicker("Haare", selection: Binding(get: {
                        player.imageAssets.2
                    }, set: { new in
                        player.imageAssets.2 = new
                        
                        updater.update()
                        
                        manager.engine.savePlayers()
                    }))
                    
                    Spacer()
                        .frame(width: 20)
                }
                .frame(width: screen.width / 2)
                
                Button {
                    player.imageAssets.1 += 6
                    player.imageAssets.1 %= 7
                    
                    updater.update()
                    
                    manager.engine.savePlayers()
                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaleEffect(assetScale * buttonScaleFactor)
                }
                
                Image("hair.\(player.imageAssets.1)")
                    .interpolation(.none)
                    .resizable()
                    .scaleEffect(assetScale)
                    .colorMultiply(player.imageAssets.2)
                    .aspectRatio(0.75, contentMode: .fit)
                
                Button {
                    player.imageAssets.1 += 1
                    player.imageAssets.1 %= 7
                    
                    updater.update()
                    
                    manager.engine.savePlayers()
                } label: {
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaleEffect(assetScale * buttonScaleFactor)
                }
                
                Spacer()
            }
            
            HStack {
                HStack {
                    Text("Augen")
                    
                    Spacer()
                }
                .frame(width: screen.width / 2)
                
                Button {
                    player.imageAssets.3 += 8
                    player.imageAssets.3 %= 9
                    
                    updater.update()
                    
                    manager.engine.savePlayers()
                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaleEffect(assetScale * buttonScaleFactor)
                }
                
                Image("eyes.\(player.imageAssets.3)")
                    .interpolation(.none)
                    .resizable()
                    .scaleEffect(assetScale)
                    .aspectRatio(1, contentMode: .fit)
                
                Button {
                    player.imageAssets.3 += 1
                    player.imageAssets.3 %= 9
                    
                    updater.update()
                    
                    manager.engine.savePlayers()
                } label: {
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaleEffect(assetScale * buttonScaleFactor)
                }
                
                Spacer()
            }
            
            HStack {
                HStack {
                    Text("Mund")
                    
                    Spacer()
                }
                .frame(width: screen.width / 2)
                
                Button {
                    player.imageAssets.4 += 10
                    player.imageAssets.4 %= 11
                    
                    updater.update()
                    
                    manager.engine.savePlayers()
                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaleEffect(assetScale * buttonScaleFactor)
                }
                
                Image("mouth.\(player.imageAssets.4)")
                    .interpolation(.none)
                    .resizable()
                    .scaleEffect(assetScale)
                    .aspectRatio(1, contentMode: .fit)
                
                Button {
                    player.imageAssets.4 += 1
                    player.imageAssets.4 %= 11
                    
                    updater.update()
                    
                    manager.engine.savePlayers()
                } label: {
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaleEffect(assetScale * buttonScaleFactor)
                }
                
                Spacer()
            }
            VStack {
                PlayerIcon(player: player, size: screen.width / 3)
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(hex: "#0096FF").opacity(0.5))
                    .stroke(Color(hex: "#0096FF"))
            )
        }
    }
}
