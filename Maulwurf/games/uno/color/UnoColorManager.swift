//
//  UnoColorManager.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 28.07.25.
//

import Foundation

class UnoColorManager: ObservableObject {
    private static var INSTANCE: UnoColorManager?
    
    private init() {}
    
    public static func getInstance() -> UnoColorManager {
        if (INSTANCE == nil) {
            INSTANCE = UnoColorManager()
        }
        return INSTANCE!
    }
    
    @Published private var normalHexCodes: [String] = ["#FF0000", "#00FF3B", "#FFF900", "#00D9FF"]
    private var specialHexCodes: [SpecialColor: String] = [.WILD: "#5F5F5F", .PURPLE: "#872B8D", .GOLD: "#E7B700"]
    private var updater = Updater.getInstance()
    
    public func addColor() {
        normalHexCodes.append("#FFFFFF")
    }
    
    public func removeColor(_ i: Int) {
        normalHexCodes.remove(at: i)
    }
    
    public func getHexCode(colorIndex i: Int) -> String {
        if i == -3 {
            return "#00FFFF"
        }
        if i == -2 {
            return "#AAAAAA"
        }
        if i == -1 {
            return getHexCode(specialName: .WILD)
        }
        return normalHexCodes[i]
    }
    
    public func setHexCode(colorIndex i: Int, hexCode: String) {
        normalHexCodes[i] = hexCode
        updater.update()
    }
    
    public func getHexCode(specialName: SpecialColor) -> String {
        return specialHexCodes[specialName]!
    }
    
    public func getColorCount() -> Int {
        return normalHexCodes.count
    }
}
