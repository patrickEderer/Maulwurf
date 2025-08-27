//
//  UnoSettingsView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 10.08.25.
//

import Foundation
import SwiftUI

struct UnoSettingsView: View {
    var manager: UnoViewManager
    @ObservedObject var unoCardService = UnoCardService.getInstance()
    @State var showPlayerSettings = false
    @State var showCardSettings = false
    @State var showLoadGameSaveConfirmation: Bool = false

    var body: some View {
        VStack {
            if showPlayerSettings {
                UnoPlayerSettings(manager: manager, settings: self)
//                    .ignoresSafeArea(.all)
            } else if showCardSettings {
                UnoCardSettingsView(manager: manager, settings: self)
            } else {
                homeSettingsView
            }
        }.background(Color(hex: "#005588"))
    }

    var homeSettingsView: some View {
        VStack {
            HStack {
                Spacer()
                
                Image(systemName: "square.and.arrow.down")
                    .onTapGesture {
                        showLoadGameSaveConfirmation = true
                    }.padding(20)
                    .alert("Load Game Save?", isPresented: $showLoadGameSaveConfirmation) {
                        Button("Cancel", role: .cancel) {}
                        Button("Load", role: .destructive) {
                            manager.engine.start()
                            manager.engine.readOldGameSave()
                        }
                    }
                

                QRCodeView(urlString: "http://\(getIPv4Address()):8080")
                    .scaleEffect(0.25)
                    .onTapGesture {
                        manager.serverView = true
                    }
            }

            Spacer()
            
            UNODropDown(title: "Starting Card Count", value: "\(manager.engine.startingCardsCount)", id: 1) {
                let min = 1
                let max = 50.0 - Double(min)
                Slider(value: Binding(get: {
                    Double(manager.engine.startingCardsCount - min) / max
                }, set: { new in
                    let newCount = Int((new + (0.5 / max)) * max)
                    
                    manager.engine.startingCardsCount = newCount + min
                }))
            }
            
            UNODropDown(title: "Special Cards", value: "\(unoCardService.getIncludedSpecialCards().count)", id: 2) {
                HStack {
                    let lookupTable: [(SpecialUnoCardTypes, any UnoCard)] = [
                        (.DRAW_2, Draw2(colorIndex: 0)),
                        (.REVERSE, Reverse(colorIndex: 0)),
                        (.SKIP, Skip(colorIndex: 0)),
                        (.WILD, Wild()),
                        (.DRAW_4, Draw4())
                    ]
                    
                    ForEach (Array(lookupTable), id: \.0) { key, value in
                        UnoCardView(card: value, glowing: unoCardService.getIncludedSpecialCards().contains(key))
                            .onTapGesture {
                                unoCardService.toggleSpecialCard(key)
                            }
                    }
                }.mask {
                    RoundedRectangle(cornerRadius: 10)
                        .blur(radius: 2)
                }
            }

            Button {
                showPlayerSettings = true
            } label: {
                Text("Players")
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(MaulwurfApp.color.darker(by: -0.5))
            )
            
            Button {
                showCardSettings = true
            } label: {
                Text("Cards")
                    .padding(10)
                    .foregroundColor(.white)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(MaulwurfApp.color.darker(by: -0.5))
            )

            Spacer()

            Button {
                manager.engine.start()
            } label: {
                Text("Start")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.green)
                            .stroke(.green.darker(by: 0.5), lineWidth: 1)
                    )
            }
            .padding(.bottom, 50)
        }
    }
}
