//
//  ImpostorFactory.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 01.06.25.
//

import Foundation

public class ImpostorFactory {
    private static var INSTANCE: ImpostorEngine?
    
    private init() {}
    
    public static func getInstance() -> ImpostorEngine {
        if (INSTANCE == nil) {
            INSTANCE = ImpostorEngine()
        }
        return INSTANCE!
    }
}
