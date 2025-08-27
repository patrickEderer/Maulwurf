//
//  UnoViewManager.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 10.08.25.
//

import Foundation
import SwiftUI

struct UnoViewManager: View {
    @ObservedObject var engine: UnoEngine
    @State var serverView = false
    var screen = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            if serverView {
                UnoServerView(manager: self)
                    .transition(.slide)
            } else if !engine.isRunning {
                UnoSettingsView(manager: self)
                    .ignoresSafeArea(.all)
                    .transition(.slide)
            } else {
                UnoView(engine: engine)
                    .transition(.slide)
            }
        }
    }
}
