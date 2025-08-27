//
//  CardSettings.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 20.08.25.
//

import Foundation
import SwiftUI

struct UnoCardSettingsView: View {
    @ObservedObject var updater = Updater.getInstance()
    var manager: UnoViewManager
    var settings: UnoSettingsView
    var screen = UIScreen.main.bounds

    var body: some View {
        ZStack {
            UnoColorSettingsView(cardSettings: self)
            VStack {
                HStack {
                    Circle()
                        .frame(width: 0, height: 0)
                        .overlay {
                            Button {
                                settings.showCardSettings = false
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .scaleEffect(2)
                                    .padding(10)
                                    .accentColor(.white)
                                    .padding(.leading, 50)
                            }
                        }
                        .padding(.top, 50)
                    Spacer()
                }
                Spacer()
            }.ignoresSafeArea(.all)
        }
    }
}
