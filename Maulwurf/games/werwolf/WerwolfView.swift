//
//  WerwolfView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 23.06.25.
//

import Foundation
import SwiftUI

struct WerwolfView: View {
    @ObservedObject var engine: WerwolfEngine
    
    var body: some View {
        switch engine.gameState {
        case .Uninitialized: WerwolfSettingsView(engine: engine)
        case .ShowingRoles: WerwolfShowingRolesView(engine: engine)
        case .Running: WerwolfRunningViewManager(engine: engine)
        case .Finished: Text("Finished \(engine.result!)")
        }
    }
}
