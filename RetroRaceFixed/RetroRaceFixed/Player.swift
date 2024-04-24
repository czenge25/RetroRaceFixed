//
//  Player.swift
//  RetroRaceFixed
//
//  Created by Cameron Zenge on 4/4/24.
//

import Foundation
import SpriteKit

class Player {
    var node: SKNode?
    var physicsBody: SKPhysicsBody?
    var maxSpeed: CGFloat = 600.0
    var grassMaxSpeed: CGFloat?
    var currentMaxSpeed: CGFloat?
    var acceleration: CGFloat = 4
    var grassAcceleration: CGFloat?
    var currentAcceleration: CGFloat?
    var isBraking = false
    var isTouchingRoad = true
    
    init(node: SKNode?, physicsBody: SKPhysicsBody?) {
        self.node = node
        self.physicsBody = physicsBody
    }
    
    func move(withJoystickKnob joystickKnob: SKNode?, isBraking: Bool, isTouchingRoad: Bool, currentMaxSpeed: CGFloat?, currentAcceleration: CGFloat?) {
        guard let playerNode = node, let physicsBody = physicsBody, let joystickKnob = joystickKnob else { return }
        
        // Update player properties
        self.isBraking = isBraking
        self.isTouchingRoad = isTouchingRoad
        self.currentMaxSpeed = currentMaxSpeed
        self.currentAcceleration = currentAcceleration
        
        // Player Movement
        guard let currentMaxSpeed = currentMaxSpeed, let currentAcceleration = currentAcceleration else { return }
        
        let xPosition = Double(joystickKnob.position.x)
        let yPosition = Double(joystickKnob.position.y)
        
        // Apply friction based on whether the player is on road or grass
        if isTouchingRoad {
            physicsBody.friction = 0.7
            self.currentAcceleration = acceleration
            self.currentMaxSpeed = maxSpeed
        } else {
            physicsBody.friction = 0.3
            self.currentMaxSpeed = grassMaxSpeed
            self.currentAcceleration = grassAcceleration
        }
        
        if isBraking {
            // Apply braking force
            let brakeFriction: CGFloat = 0.98
            
            physicsBody.velocity.dx *= brakeFriction
            physicsBody.velocity.dy *= brakeFriction
            
            if (abs(physicsBody.velocity.dx) < 5.0 && abs(physicsBody.velocity.dy) < 5.0) {
                physicsBody.velocity = CGVector(dx: 0, dy: 0)
                self.isBraking = false
            }
        }
        
        let deltaTime = 1.0 / 60.0 // Assuming 60 FPS
        
        let xForce = CGFloat(xPosition) * currentAcceleration * deltaTime
        let yForce = CGFloat(yPosition) * currentAcceleration * deltaTime
        
        let angle = atan2(yForce, xForce)
        
        let impulse = CGVector(dx: xForce, dy: yForce)
        physicsBody.applyImpulse(impulse)
        
        // Limit the player's speed
        let speed = sqrt(pow(physicsBody.velocity.dx, 2) + pow(physicsBody.velocity.dy, 2))
        if speed > currentMaxSpeed {
            physicsBody.velocity.dx *= currentMaxSpeed / speed
            physicsBody.velocity.dy *= currentMaxSpeed / speed
        }
        
        // Set player's rotation angle
        playerNode.zRotation = angle
    }
}
