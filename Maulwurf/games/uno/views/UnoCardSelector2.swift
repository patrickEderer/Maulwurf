//
//  UnoCardSelector.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 14.07.25.
//

import Foundation
import SwiftUI

struct UnoCardSelector2: View {
    var onPlaceCard: () -> Void = { }
    
    var screen = UIScreen.main.bounds
    var sensoryFeedback = SensoryFeedback.getInstance()
    
    var body: some View {
        Text("Test")
    }
}

#Preview {
    UnoCardSelector2()
}
