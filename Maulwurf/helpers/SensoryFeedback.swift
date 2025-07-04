//
//  Vibration.swift
//  Gyzz
//
//  Created by Ederer Patrick on 09.05.25.
//

import Foundation
import UIKit
import AudioToolbox

class SensoryFeedback {
    private static var INSTANCE: SensoryFeedback? = SensoryFeedback()
    private var lastImpact: Date = Date()
    
    private var impactGenerators:
        [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] =
            [:]
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    private init() {
        prepareGenerators()
    }
    
    public static func getInstance() -> SensoryFeedback {
        if (INSTANCE == nil) {
            
            INSTANCE = SensoryFeedback()
        }
        return INSTANCE!
    }

    func prepareGenerators() {
        let feedbackStyles: [UIImpactFeedbackGenerator.FeedbackStyle] = [
            .light, .medium, .heavy, .soft, .rigid,
        ]
        for style in feedbackStyles {
            impactGenerators[style] = UIImpactFeedbackGenerator(style: style)
            
            impactGenerators[style]!.prepare()
        }
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }
    
    func playVibrationSound() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        if !canImpactAgain() { return }
        impactGenerators[style]!.impactOccurred()
    }

    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        if !canImpactAgain() { return }
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(type)
    }

    func selectionChanged() {
        if !canImpactAgain() { return }
        selectionGenerator.prepare()
        selectionGenerator.selectionChanged()
    }

    private func canImpactAgain() -> Bool {
        let canImpact = abs(lastImpact.distance(to: Date())) > (1.0 / 10.0)
        if canImpact {
            lastImpact = Date()
        } else {
            print("RATE LIMITED: \(1 / abs(lastImpact.distance(to: Date())))hz")
        }
        return canImpact
    }
}
