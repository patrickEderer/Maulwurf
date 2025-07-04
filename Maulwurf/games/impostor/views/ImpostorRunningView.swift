//
//  ImpostorRunningView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 02.06.25.
//

import Foundation
import SwiftUI

struct ImpostorRunningView: View {
    @ObservedObject var updater = Updater.getInstance()
    @ObservedObject var engine: ImpostorEngine
    @State var showingPlayerSelector: Bool = false
    
    var body: some View {
        ZStack {
            if showingPlayerSelector {
                PlayerSelector(engine: engine)
            } else {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            showingPlayerSelector = true
                        } label: {
                            Image(systemName: "text.book.closed")
                                .resizable()
                                .interpolation(.none)
                                .accentColor(MaulwurfApp.color)
                                .padding(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(MaulwurfApp.color)
                                        .fill(.clear)
                                        .padding(10)
                                )
                                .frame(width: 75, height: 75)
                        }
                    }
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    let startingPlayerName = engine.names[engine.startingPlayerIndex]
                    HStack {
                        Text("\(startingPlayerName == "" ? "Player \(engine.startingPlayerIndex + 1)" : startingPlayerName)")
                            .fontWeight(.heavy)
                        Text("beginnt!")
                    }
                    
                    Spacer()
                    
                    Button {
                        engine.gameState = .Done
                    } label: {
                        Text("Done")
                            .padding(10)
                            .foregroundColor(.white)
                    }.background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(MaulwurfApp.color)
                            .frame(width: 150)
                    )
                }
            }
        }
    }
}
