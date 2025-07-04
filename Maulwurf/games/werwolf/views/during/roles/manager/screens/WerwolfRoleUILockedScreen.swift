//
//  RoleUILockedScreen.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 24.06.25.
//

import Foundation
import SwiftUI

struct WerwolfRoleUILockedScreen: View {
    var manager: WerwolfRoleUIManager
    var screen = UIScreen.main.bounds
    
    var body: some View {
        VStack {
            Text("\(manager.role)")
                .font(.largeTitle)
            WerwolfLockButton(onUnlocked: {
                DispatchQueue.main.sync {
                    manager.engine.roleUIScreenState = .Showing
                }
            })
            .frame(width: screen.width * 0.5, height: screen.width * 0.5)
        }
    }
}
