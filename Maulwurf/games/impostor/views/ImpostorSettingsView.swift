//
//  ImpostorSettingsView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 02.06.25.
//

import Foundation
import SwiftUI

struct ImpostorSettingsView: View {
    @ObservedObject var updater = Updater.getInstance()
    @ObservedObject var engine: ImpostorEngine
    @State var errors: [Int] = []
    
    var body: some View {
        Spacer()
        
        MainDropDown(title: "Players", value: "\(engine.names.count)", id: 0) {
            VStack {
                Text("Player count: \(engine.names.count)")
                Slider(value: Binding(get: {
                    Double(engine.names.count - 2) / 18
                }, set: { new in
                    engine.setPlayerCount(Int(new * 18) + 2)
                    
                    engine.saveAll()
                }))
                .accentColor(MaulwurfApp.color)
            }
            
            List {
                ForEach (0..<engine.names.count, id: \.self) { index in
                    TextField("Player \(index + 1)", text: Binding(get: {
                        if engine.names.count > index {
                            return engine.names[index]
                        } else {
                            return ""
                        }
                    }, set: { new in
                        if engine.names.count > index {
                            engine.names[index] = new
                        }
                        
                        engine.saveAll()
                    }))
                }
            }.frame(height: 200)
        }
        
        MainDropDown(title: "Game Modes", value: "\(engine.gameModePercentages.filter {$0.value > 0}.count)", id: 1) {
            let gameModes = ImpostorGameMode.allCases
            
            // 1 so that normal is skipped
            ForEach (1..<gameModes.count, id: \.self) { i in
                VStack {
                    HStack {
                        Text("\(gameModes[i].getName()):")
                        Spacer()
                        Text("\(Int((engine.gameModePercentages[gameModes[i]] ?? 0) * 100))%")
                    }.foregroundColor((engine.gameModePercentages[gameModes[i]] ?? 0) > 0 ? .white : .gray)
                    
                    Slider(value: Binding(get: {
                        engine.gameModePercentages[gameModes[i]] ?? 0
                    }, set: { new in
                        let steps = 5.0
                        engine.gameModePercentages[gameModes[i]] = floor(new * (100 / steps) + (steps / 100)) / (100 / steps)
                        updater.update()
                        
                        engine.saveAll()
                    }))
                    .accentColor(MaulwurfApp.color)
                }
            }
        }
        
        MainDropDown(title: "Categories", value: "\(Words.getInstance().selectedCategories.filter { b in b.value }.count)", id: 2) {
            if (errors.contains(0)) {
                Text("Select at least 1 category!")
                    .foregroundColor(.red)
            }
            CategorySelector()
        }
        
        HStack {
            Toggle(isOn: Binding(get: {
                engine.showHint
            }, set: { new in
                engine.showHint = new
                
                updater.update()
                
                engine.saveAll()
            })) {
                Text("Show Hint")
            }
            .padding(20)
        }
        
        Spacer()
        
        Button {
            if (Words.getInstance().selectedCategories.filter { b in b.value }.isEmpty) {
                errors.append(0)
                
                updater.update()
                
                DropDownOpenManager.getInstance().openDropDown(id: 2)
            } else {
                engine.startGame()
            }
        } label: {
            Text("Start game")
                .padding(10)
                .foregroundColor(.white)
        }.background(
            RoundedRectangle(cornerRadius: 10)
                .fill(MaulwurfApp.color)
                .frame(width: 150)
        )
    }
}
