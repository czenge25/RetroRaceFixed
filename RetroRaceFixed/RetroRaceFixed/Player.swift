/*
CZ, HK
5/3/24
 */

import Foundation
import SpriteKit

class Player {
    var node: SKNode?
    var physicsBody: SKPhysicsBody?
    var maxSpeed: CGFloat = 600.0
    var grassMaxSpeed: CGFloat?
    var currentMaxSpeed: CGFloat?
    var acceleration: CGFloat = 2 // Decreased acceleration for slower movement
    var grassAcceleration: CGFloat?
    var currentAcceleration: CGFloat?
    var tractionCoefficient: CGFloat = 0.7 // Traction coefficient for grip on road surface
    var grassTractionCoefficient: CGFloat = 0.3 // Traction coefficient for grip on grass
    var decelerationRate: CGFloat = 0.999999 // Slower deceleration rate when no input is received
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
        
        // Apply friction and traction based on whether the player is on road or grass
        if isTouchingRoad {
            physicsBody.friction = tractionCoefficient
            self.currentAcceleration = acceleration
            self.currentMaxSpeed = maxSpeed
        } else {
            physicsBody.friction = grassTractionCoefficient
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
        
        // Slow down gradually when no input is received
        if !isBraking && (xPosition == 0 && yPosition == 0) {
            physicsBody.velocity.dx *= decelerationRate
            physicsBody.velocity.dy *= decelerationRate
        }
        
        // Set player's rotation angle
        playerNode.zRotation = angle
    }
}
