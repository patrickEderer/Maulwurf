//
//  ImpostorSettingsView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 02.06.25.
//

import Foundation
import SwiftUI

struct WerwolfSettingsView: View {
    @ObservedObject var updater = Updater.getInstance()
    @ObservedObject var engine: WerwolfEngine
    @State var errors: [Int] = []
    
    @State var settingsScreen: WerwolfSettingsScreen = .Home
    
    var body: some View {
        switch settingsScreen {
        case .Home:
            homeSettingsView
        case .Players:
            WerwolfPlayerSettings(engine: engine, settings: self)
        }
    }
    
    private var homeSettingsView: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(MaulwurfApp.color)
            
            Spacer()
            
            if engine.errors.contains(.RoleCountInvalid) {
                Text("Role count must be equal to player count!")
                    .foregroundColor(.red)
            }
            dropDowns
            
            Spacer()
            
            Button {
                engine.start()
            } label: {
                Text("Start Game")
                    .padding(10)
                    .foregroundColor(.white)
            }.background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(MaulwurfApp.color)
                    .frame(width: 150)
            )
        }
    }
    
    private var dropDowns: some View {
        VStack {
            Button {
                settingsScreen = .Players
            } label: {
                Text("Players")
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(MaulwurfApp.color.darker(by: -0.5))
            )
            
            let roleCount = engine.getRoles().map { $0.value }.reduce(0, +)
            MainDropDown(title: "Roles", value: "\(roleCount)", id: 1) {
                List {
                    ForEach (0..<roleOrder.count, id: \.self) { index in
                        VStack {
                            let role: WerwolfRole = roleOrder[index]
                            let max = Double(maxRoleCount[role]!)
                            
                            Text("\(role): \(engine.getRoles()[role] ?? 0)")
                            
                            Slider(value: Binding(get: {
                                Double(engine.getRoles()[role] ?? 0) / max
                            }, set: { new in
                                let newCount = Int((new + (0.5 / max)) * max)
                                
                                engine.setRole(role, count: newCount)
                            }))
                        }
                    }
                }
                .frame(height: 400)
            }
        }
    }
    
    let roleOrder: [WerwolfRole] = [
        .Werwolf,
        .Dorfbewohner,
        .Hexe,
        .Seherin,
        .Armor,
//        .Jäger
    ]
    let maxRoleCount: [WerwolfRole: Int] = [
        .Werwolf: 10,
        .Dorfbewohner: 10,
        .Hexe: 1,
        .Seherin: 1,
        .Armor: 1,
//        .Jäger: 1
    ]
}
