//
//  PlayerWithIcon.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 10.08.25.
//

import Foundation
import SwiftUI

protocol PlayerWithIcon {
    // Skin color, hair, hair color, eyes, mouth
    func getImageAssets() -> (Color, Int, Color, Int, Int)
}
