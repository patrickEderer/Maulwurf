//
//  ImpostorDoneView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 04.06.25.
//

import Foundation
import SwiftUI

struct ImpostorDoneView: View {
    @ObservedObject var engine: ImpostorEngine
    var screen = UIScreen.main.bounds
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Game Mode:")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(engine.gameMode.getName())")
                        .font(.headline)
                }.padding(10)
                
                HStack {
                    Text("Hidden Word\(engine.gameMode == .MultipleWords ? "s" : ""):")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(engine.words.joined(separator: ", "))")
                        .font(.headline)
                }.padding(10)
                
                if engine.gameMode != .NoImpostors && engine.gameMode != .MultipleWords {
                    HStack {
                        Text("Impostor\(engine.gameMode == .MultipleImpostors ? "s" : ""):")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(Array(engine.players.filter { p in p.isImpostor }.map(\.name)).joined(separator: ", "))")
                            .font(.headline)
                    }.padding(10)
                }
            }.frame(width: screen.width * 0.75)
            
            Divider()
            
            Button {
                engine.gameState = .Settings
            } label: {
                HStack {
                    Image(systemName: "gear")
                        .padding(.leading, 10)
                        .foregroundColor(.white)
                    Text("Settings")
                        .padding(10)
                        .foregroundColor(.white)
                }
            }.background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(MaulwurfApp.color)
                    .frame(width: 150)
            ).padding(10)
            
            Button {
                engine.startGame()
            } label: {
                HStack {
                    Image(systemName: "arrow.trianglehead.counterclockwise")
                        .padding(.leading, 10)
                        .foregroundColor(.white)
                    Text("Restart")
                        .padding(10)
                        .foregroundColor(.white)
                }
            }.background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(MaulwurfApp.color)
                    .frame(width: 150)
            )
        }
    }
}
