//
//  WerwolfRunningViewManager.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 24.06.25.
//

import Foundation
import SwiftUI

struct WerwolfRunningViewManager: View {
    @ObservedObject var engine: WerwolfEngine
    var screen = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            //Background because of night img not being full screen
            Rectangle()
                .fill(Color(hex: "#0D0D0D"))
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: 50)
                
                //Background
                VStack {
                    VStack {
                        Image("werwolf.background.night")
                            .resizable()
                            .frame(width: screen.width, height: screen.width * (1644 / 882))
                    }
                    .frame(width: screen.width, height: screen.height)
                    
                    LinearGradient(colors: [Color(hex: "#0D0D0D"), Color(hex: "#00FECD")], startPoint: .top, endPoint: .init(x: 0.5, y: 0.9))
                        .frame(height: screen.height / 2)
                    
                    ZStack {
                        Color(hex: "#00FECD")
                            .frame(width: screen.height * (890 / 1630), height: screen.height)
                        
                        Image("werwolf.background.day")
                            .resizable()
                            .frame(width: screen.height * (890 / 1630), height: screen.height)
                            .ignoresSafeArea(.all)
                            .padding(.top, -10)
                    }
                }.offset(x: 0, y: screen.height * (engine.getDayNight() == .Day ? -0.7 : 0.7))
                
                Spacer()
            }.ignoresSafeArea(.all)
                .frame(width: screen.width, height: screen.height * 0.75)
            
            if engine.getDayNight() == .Day {
                WerwolfDayManager(engine: engine)
            }
            
            if (engine.showingRoleUI != nil) {
                WerwolfRoleUIManager(engine: engine, role: engine.showingRoleUI!) {
                    engine.showingRoleUI = nil
                }
            }
        }
    }
}
