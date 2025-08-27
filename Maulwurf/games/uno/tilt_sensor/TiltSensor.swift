//
//  TiltSensor.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 21.08.25.
//

import Foundation
import CoreMotion
import CoreGraphics
import QuartzCore

class TiltSensor: ObservableObject {
    private static var INSTANCE: TiltSensor?
    
    private init() {
        start()
    }
    
    public static func getInstance() -> TiltSensor {
        if (INSTANCE == nil) {
            INSTANCE = TiltSensor()
        }
        return INSTANCE!
    }
    
    public var maxOffset: CGFloat = 5     // clamp range in points/pixels
    public var inputGain: CGFloat = 15    // gyro rad/s -> px/s^2
    public var stiffness: CGFloat = 2      // spring pull to center (higher = stronger)
    public var damping: CGFloat = 2        // velocity damping (higher = more friction)

    // MARK: - Internals
    private let motionManager = CMMotionManager()
    private var displayLink: CADisplayLink?

    @Published private var tilt = CGPoint.zero        // current offset you will read
    private var velocity = CGPoint.zero    // internal physics velocity
    private var latestRotation = CMRotationRate(x: 0, y: 0, z: 0)
    private var lastTimestamp: CFTimeInterval?

    deinit { stop() }

    // Public API
    func getTilt() -> CGPoint { tilt }

    /// Optional: instantly recenter & clear momentum
    func recenter() {
        tilt = .zero
        velocity = .zero
    }

    // MARK: - Engine
    private func start() {
        guard displayLink == nil else { return }

        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        if motionManager.isDeviceMotionAvailable {
            // Stable reference frame; deliver updates on main to avoid races
            motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical,
                                                   to: .main) { [weak self] motion, _ in
                guard let self = self, let m = motion else { return }
                self.latestRotation = m.rotationRate
            }
        }

        let link = CADisplayLink(target: self, selector: #selector(step(_:)))
        link.add(to: .main, forMode: .default)
        displayLink = link
    }

    private func stop() {
        motionManager.stopDeviceMotionUpdates()
        displayLink?.invalidate()
        displayLink = nil
        lastTimestamp = nil
    }

    @objc private func step(_ link: CADisplayLink) {
        // dt in seconds
        let dt: CGFloat
        if let last = lastTimestamp {
            dt = CGFloat(link.timestamp - last)
        } else {
            dt = 1.0 / 60.0
        }
        lastTimestamp = link.timestamp

        // Map device rotation to parallax axes.
        // Turn phone left/right (rotationRate.y) -> move X.
        // Tilt forward/back (rotationRate.x) -> move Y (inverted to feel natural).
        let inputX = CGFloat(latestRotation.y)
        let inputY = CGFloat(-latestRotation.x)

        // 1) Add input to velocity
        velocity.x += inputGain * inputX * dt
        velocity.y += inputGain * inputY * dt

        // 2) Spring back toward origin (Hooke's law)
        velocity.x += -stiffness * tilt.x * dt
        velocity.y += -stiffness * tilt.y * dt

        // 3) Damping (friction)
        let damp = max(0, 1 - damping * dt)
        velocity.x *= damp
        velocity.y *= damp

        // 4) Integrate position
        tilt.x += velocity.x * dt
        tilt.y += velocity.y * dt

        // 5) Clamp & zero velocity at the edges
        if tilt.x > maxOffset { tilt.x = maxOffset; velocity.x = 0 }
        if tilt.x < -maxOffset { tilt.x = -maxOffset; velocity.x = 0 }
        if tilt.y > maxOffset { tilt.y = maxOffset; velocity.y = 0 }
        if tilt.y < -maxOffset { tilt.y = -maxOffset; velocity.y = 0 }
    }
}
