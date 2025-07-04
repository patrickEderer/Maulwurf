//
//  DropDownOpenManager.swift
//  Gyzz
//
//  Created by Ederer Patrick on 21.05.25.
//

import Foundation
import SwiftUI

public class DropDownOpenManager: ObservableObject {
    private static var INSTANCE: DropDownOpenManager? = DropDownOpenManager()
    
    @Published private var openDropDownId: Int? = nil
    
    private init() {}
    
    public static func getInstance() -> DropDownOpenManager {
        if (INSTANCE == nil) {
            INSTANCE = DropDownOpenManager()
        }
        return INSTANCE!
    }
    
    public func openDropDown(id: Int) {
        withAnimation(.easeInOut(duration: 0.5)) {
            openDropDownId = id
        }
    }
    
    public func getOpenDropDownId() -> Int? {
        return openDropDownId
    }
    
    public func closeAll() {
        withAnimation(.easeInOut(duration: 0.5)) {
            openDropDownId = nil
        }
    }
}
