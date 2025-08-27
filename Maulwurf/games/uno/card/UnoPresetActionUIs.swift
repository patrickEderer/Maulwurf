//
//  UnoPresetActionUIs.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 08.08.25.
//

import Foundation
import SwiftUI

public class UnoPresetActionUIs {
    var screen = UIScreen.main.bounds
    
    private static var INSTANCE: UnoPresetActionUIs?
    
    private init() {}
    
    public static func getInstance() -> UnoPresetActionUIs {
        if (INSTANCE == nil) {
            INSTANCE = UnoPresetActionUIs()
        }
        return INSTANCE!
    }
    
    func getPickColorUI(engine: UnoEngine, _ onSelect: @escaping (Int) -> Void) -> any View {
        let colorCount = UnoColorManager.getInstance().getColorCount()
        
        return ZStack {
            ForEach (0..<2) { blur in
                ZStack {
                    ForEach (0..<colorCount, id: \.self) { i in
                        Segment(startAngle: .degrees(Double(i) / Double(colorCount) * 360), endAngle: .degrees(Double(i + 1) / Double(colorCount) * 360))
                            .fill(Color(hex: UnoColorManager.getInstance().getHexCode(colorIndex: i)))
                            .contentShape(
                                Segment(startAngle: .degrees(Double(i) / Double(colorCount) * 360), endAngle: .degrees(Double(i + 1) / Double(colorCount) * 360))
                            )
                            .scaleEffect(CGSize(width: 1, height: 1.55))
                            .zIndex(1)
                            .onTapGesture {
                                onSelect(i)
                            }
                    }
                }
                .blur(radius: blur == 0 ? 10 : 0)
            }
            Text("Pick A Color")
                .foregroundColor(Color.white)
                .font(.system(size: 50, weight: .bold))
                .shadow(color: .black, radius: 5)
                .zIndex(2)
        }
        .padding(20)
        .background(
            Circle()
                .fill(Color.black)
                .scaleEffect(CGSize(width: 1, height: 1.5))
        )
        .padding(20)
    }
}

struct Segment: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: center)
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle - .degrees(90),
                    endAngle: endAngle - .degrees(90),
                    clockwise: false)
        path.closeSubpath()

        return path
    }
}

#Preview {let engine = UnoEngine.getInstance()
    let _ = engine.start()
    UnoView(engine: engine)
//    let _ = engine.isLocked = false
    let _ = engine.activeCardUI = UnoPresetActionUIs.getInstance().getDrawCardUI(cardChar: "+2", onPlace: { _ in
        
    }, onDraw: {
        
    }, currentCountFunc: {"2"})
}
