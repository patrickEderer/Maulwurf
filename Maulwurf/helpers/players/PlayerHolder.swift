//
//  PlayerHolder.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.06.25.
//

import Foundation

public class PlayerHolder {
    private static var INSTANCE: PlayerHolder? = PlayerHolder()
    
    private init() {}
    
    public static func getInstance() -> PlayerHolder {
        if (INSTANCE == nil) {
            INSTANCE = PlayerHolder()
        }
        return INSTANCE!
    }
}
