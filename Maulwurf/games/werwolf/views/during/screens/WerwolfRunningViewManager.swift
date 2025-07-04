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
                switch engine.dayNight {
                case .Day:
                    Image("werwolf.background.day")
                        .resizable()
                        .frame(width: screen.height * (890 / 1630), height: screen.height)
                        .ignoresSafeArea(.all)
                case .Night:
                    Image("werwolf.background.night")
                        .resizable()
                        .frame(width: screen.width, height: screen.width * (1644 / 882))
                }
                
                Spacer()
            }.ignoresSafeArea(.all)
            
            if engine.dayNight == .Day {
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
