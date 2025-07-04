//
//  RoleUIManager.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 24.06.25.
//

import Foundation
import SwiftUI

struct WerwolfRoleUIManager: View {
    var engine: WerwolfEngine
    var role: WerwolfRole
    var onDone: () -> Void
    
    init(engine: WerwolfEngine, role: WerwolfRole, onDone: @escaping () -> Void) {
        self.engine = engine
        self.role = role
        self.onDone = onDone
    }
    
    var body: some View {
        switch engine.roleUIScreenState {
        case .Locked: WerwolfRoleUILockedScreen(manager: self)
        case .Showing: viewForRole
        case .Sleeping: WerwolfRoleUISleepingView(onDone: onDone)
        }
    }
    
    var viewForRole: some View {
        switch role {
        case .Werwolf: AnyView(WerwolfWerwolfRoleUI(engine: engine))
        case .Hexe: AnyView(WerwolfWitchRoleUI(engine: engine))
        case .Seherin: AnyView(WerwolfSeherinRoleUI(engine: engine))
        default: AnyView(WerwolfWerwolfRoleUI(engine: engine))
        }
    }
}
