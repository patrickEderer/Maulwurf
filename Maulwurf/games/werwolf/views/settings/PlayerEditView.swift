//
//  PlayerEditView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.06.25.
//

import Foundation
import SwiftUI

struct PlayerEditView: View {
    @ObservedObject var updater = Updater.getInstance()
    var engine: WerwolfEngine
    var settings: WerwolfPlayerSettings
    
    var screen = UIScreen.main.bounds
    
    @State var playerIndex: Int
    
    let assetScale = 0.75
    let buttonScaleFactor = 0.5
    
    var body: some View {
        VStack {
            let player = engine.getPlayers()[playerIndex]
            
            HStack {
                Text("Name: ")
                
                TextField("Player \(playerIndex + 1)", text: Binding(get: {
                    player.getBackendName() ?? ""
                }, set: { new in
                    engine.setPlayerName(playerIndex, new)
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
            let player = engine.getPlayers()[playerIndex]
            
            HStack {
                ColorPicker("Hautfarbe", selection: Binding(get: {
                    player.imageAssets.0
                }, set: { new in
                    player.imageAssets.0 = new
                    
                    engine.savePlayers()
                }))
                .frame(width: screen.width / 2)
                
                Spacer()
                
                Button {
                    player.setRandomAssets()
                    
                    updater.update()
                    
                    engine.savePlayers()
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
                        
                        engine.savePlayers()
                    }))
                    
                    Spacer()
                        .frame(width: 20)
                }
                .frame(width: screen.width / 2)
                
                Button {
                    player.imageAssets.1 += 5
                    player.imageAssets.1 %= 6
                    
                    updater.update()
                    
                    engine.savePlayers()
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
                    player.imageAssets.1 %= 6
                    
                    updater.update()
                    
                    engine.savePlayers()
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
                    player.imageAssets.3 += 8
                    player.imageAssets.3 %= 9
                    
                    updater.update()
                    
                    engine.savePlayers()
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
                    
                    engine.savePlayers()
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
                    player.imageAssets.4 += 10
                    player.imageAssets.4 %= 11
                    
                    updater.update()
                    
                    engine.savePlayers()
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
                    
                    engine.savePlayers()
                } label: {
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaleEffect(assetScale * buttonScaleFactor)
                }
                
                Spacer()
            }
        }
    }
}
