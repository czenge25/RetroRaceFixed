/*
CZ, HK
12/21/23
 */

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Player and joystick vars
    var player : SKNode?
    var joystick : SKNode?
    var joystickKnob : SKNode?
    var xArrow : SKNode?
    var yArrow : SKNode?
    
    // Brake vars
    var brakeButton: SKSpriteNode?
    var isBraking = false
    var isTouchingRoad = true
    
    var maxSpeed: CGFloat = 600.0
    var grassMaxSpeed: CGFloat?
    var currentMaxSpeed: CGFloat?
    
    var acceleration: CGFloat = 4
    var grassAcceleration: CGFloat?
    var currentAcceleration: CGFloat?
    
    var friction: CGFloat = 0.995
    
    // MapBuilder vars
    var mp : MapBuilder?
    var roadTileArray : [SKSpriteNode] = []

    // Camera var
    var sceneCamera : SKCameraNode = SKCameraNode()
    
    // Joystick variables
    var joystickAction = false
    var xKnobRadius: CGFloat = 50.0
    var yKnobRadius: CGFloat = 50.0
    
    // Sprite Engine
    var previousTimeInterval : TimeInterval = 0
    var playerIsFacingRight = true
    var playerSpeedX: CGFloat = 1.0
    var playerSpeedY: CGFloat = 1.0
    
    // Win message
    var hasPrintedWinMessage = false
    var winLabel: SKLabelNode?
    
    // Pi constant
    let pi = CGFloat.pi

    // didMove
    override func didMove(to view: SKView) {
        
        grassMaxSpeed = maxSpeed * (3/5)
        grassAcceleration = acceleration * (0.3/0.7)
        
        player = childNode(withName: "Car1")
        
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        xArrow = joystick?.childNode(withName: "xArrow")
        yArrow = joystick?.childNode(withName: "yArrow")
        
        joystickKnob?.position = CGPoint(x: 0, y: 0)
        joystickKnob?.zPosition = 5
        xArrow?.position = CGPoint(x: 0, y: 0)
        yArrow?.position = CGPoint(x: 0, y: 0)
        joystick?.zPosition = 4
        
        player?.position = CGPoint(x: 0,y: 0)
        player?.zPosition = 3
        
        
        // Create brake button as SKSpriteNode
        let brakeButtonTexture = SKTexture(imageNamed: "BrakeButton")
        brakeButton = SKSpriteNode(texture: brakeButtonTexture)
        brakeButton?.scale(to: CGSize(width: 200, height: 600))
        brakeButton?.name = "brakeButton"
        brakeButton?.zPosition = 4
        
        addChild(brakeButton!)

        camera = sceneCamera
        
        // Set up physics for the player
        player?.physicsBody = SKPhysicsBody(rectangleOf: player!.frame.size)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        player?.position = CGPoint(x: 0, y: 0)
        
// MARK: Map Selection
        mp = MapBuilder(scene: self, level: "Tutorial")
        
        roadTileArray = mp!.roadTileArray
    }
}

// MARK: Touches
extension GameScene {
    // Touch Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystickAction = true
        for touch in touches {
            // Check if the touch is on the brakeButton
            if let brakeButton = brakeButton {
                let location = touch.location(in: self)
                isBraking = brakeButton.frame.contains(location)
            }
            // Check if the touch is on the joystickKnob
            if let joystickKnob = joystickKnob {
                let location = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(location)
            }
        }
    }
    
    // Touch Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        
        if !joystickAction { return }
        
        // Move the joystick knob based on touch distance
        for touch in touches {
            let position = touch.location(in: joystick)
            let xLength = position.x
            let yLength = position.y

            let length = sqrt(pow(xLength, 2) + pow(yLength, 2))

            if length < xKnobRadius {
                joystickKnob.position = position
            } else {
                let angle = atan2(yLength, xLength)
                let xMovement = cos(angle) * xKnobRadius
                let yMovement = sin(angle) * yKnobRadius
                joystickKnob.position = CGPoint(x: xMovement, y: yMovement)
            }
        }
    }
    
    // Touch End
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            resetKnobPosition()
        }
    }
}

extension GameScene {
    // Reset joystick knob position
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
}

// MARK: Game Loop
extension GameScene {
    
    // Show the win message for the player
    func showWinMessage() {
        winLabel = SKLabelNode(text: "You win!")
        winLabel?.fontName = "Arial"
        winLabel?.fontSize = 50
        winLabel?.fontColor = .white
        winLabel?.zPosition = 5
        winLabel?.alpha = 1
        addChild(winLabel!)
    }
    
    // Game loop for player movement and actions
    override func update(_ currentTime: TimeInterval) {
        // Update camera position based on player position
        camera?.position.x = player?.position.x ?? 0
        camera?.position.y = player?.position.y ?? 0
        
        // Update joystick position based on camera position
        joystick?.position.x = (camera?.position.x ?? 0) - 600
        joystick?.position.y = (camera?.position.y ?? 0) - 200
        
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
        // Player Movement
        guard let joystickKnob = joystickKnob else { return }
        let xPosition = Double(joystickKnob.position.x)
        let yPosition = Double(joystickKnob.position.y)
        
        brakeButton?.position.x = (player?.position.x ?? 0) + 575
        brakeButton?.position.y = (player?.position.y ?? 0) - 350
        
        for roadTileArray in self.roadTileArray {
            if player?.frame.intersects(roadTileArray.frame) ?? false {
                // Change the variable based on the collision
                isTouchingRoad = true
                break;
            } else {
                isTouchingRoad = false
            }
        }
                
        if isTouchingRoad {
                friction = 0.7
                currentAcceleration = acceleration
                currentMaxSpeed = maxSpeed
            } else {
                friction = 0.3
                currentMaxSpeed = grassMaxSpeed
                currentAcceleration = grassAcceleration
            }
        
        if isBraking {
            // Apply braking force
            let brakeFriction: CGFloat = 0.98
            
            player?.physicsBody?.velocity.dx *= brakeFriction
            player?.physicsBody?.velocity.dy *= brakeFriction
            
            if (abs(player?.physicsBody?.velocity.dx ?? 0) < 5.0 && abs(player?.physicsBody?.velocity.dy ?? 0) < 5.0) {
                player?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                isBraking = false
            }
        }
        
        if (joystickAction) {
            // Calculate force components and apply force to the player's physics body
            let xForce = CGFloat(xPosition) * playerSpeedX * deltaTime
            let yForce = CGFloat(yPosition) * playerSpeedY * deltaTime
            
            /*
            
            player?.physicsBody?.applyForce(CGVector(dx: xForce, dy: yForce))
            
            player?.physicsBody?.velocity.dx = max(min((player?.physicsBody?.velocity.dx ?? 0) + xForce * acceleration, maxSpeed), -maxSpeed)
            player?.physicsBody?.velocity.dy = max(min((player?.physicsBody?.velocity.dy ?? 0) + yForce * acceleration, maxSpeed), -maxSpeed)
             
             */
            
            let angle = atan2(yForce, xForce)
            
            // Kill orthogonal velocity
            let playerVelocityX = player?.physicsBody?.velocity.dx ?? 0
            let playerVelocityY = player?.physicsBody?.velocity.dy ?? 0

            // Calculate the x and y components of the velocity parallel to the joystick direction
            let parallelVelocityX = playerVelocityX * cos(angle)
            let parallelVelocityY = playerVelocityY * sin(angle)

            // Calculate the total parallel velocity by summing the x and y components
            let parallelVelocity = parallelVelocityX + parallelVelocityY
            
            player?.physicsBody?.velocity.dx = parallelVelocity * cos(angle)
            player?.physicsBody?.velocity.dy = parallelVelocity * sin(angle)
            
            // Apply the force in the direction of the joystick
            let impulse = CGVector(dx: xForce, dy: yForce)
            player?.physicsBody?.applyImpulse(impulse)
            
            // Limit the player's speed
            let speed = sqrt(pow(player?.physicsBody?.velocity.dx ?? 0, 2) + pow(player?.physicsBody?.velocity.dy ?? 0, 2))
            if speed > currentMaxSpeed ?? 0 {
                player?.physicsBody?.velocity.dx *= (currentMaxSpeed ?? 0) / speed
                player?.physicsBody?.velocity.dy *= (currentMaxSpeed ?? 0) / speed
            }
            
            player?.zRotation = angle
        } else {
            // Apply friction to gradually reduce velocity when there's no input
            player?.physicsBody?.velocity.dx *= friction
            player?.physicsBody?.velocity.dy *= friction
            
            let velocity = physicsBody?.velocity

            player?.physicsBody?.velocity.dx = 0.0
            player?.physicsBody?.velocity.dy = 0.0
        }
        
        if let playerPhysicsBody = player?.physicsBody {
            let speed = abs(hypot(playerPhysicsBody.velocity.dx, playerPhysicsBody.velocity.dy))
            if speed > currentMaxSpeed ?? 0 {
                playerPhysicsBody.velocity.dx *= ((currentMaxSpeed ?? 0)/speed)
                playerPhysicsBody.velocity.dy *= ((currentMaxSpeed ?? 0)/speed)
            }
        }
        
        mp?.checkWinCondition()
            
        // Display win message if win condition is met
        if mp?.getWinCondition() ?? false {
            if let winLabel = winLabel {
                winLabel.position = CGPoint(x: player?.position.x ?? 0, y: player?.position.y ?? 0)
            }
            winLabel?.position = CGPoint(x: player?.position.x ?? 0, y: player?.position.y ?? 0)
            if !hasPrintedWinMessage {
                showWinMessage()
                hasPrintedWinMessage = true
            }
        }
        
        print("Joystick Position: \(joystick?.position ?? .zero)")
        print("Player Is Hidden: \(player?.isHidden ?? true)")
        print("Joystick Action: \(joystickAction)")
    }
}

// MARK: Collisions

// *Not currently properly functional*

/*
extension GameScene: SKPhysicsContactDelegate{
    
    struct Collision{
        enum Masks: Int{
            case killing, player, reward, ground
            var bitmask: UInt32{ return 1<<self.rawValue}
        }
        let masks: (first: UInt32, second:UInt32)
        func matches (first: Masks, second: Masks) -> Bool{
            return (first.bitmask==masks.first && second.bitmask == masks.second) ||
            (first.bitmask==masks.second && second.bitmask == masks.first)
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
        
        if collision.matches(first: .player, second: .killing) {
            let die = SKAction.move(to: CGPoint(x: -300, y: -100), duration: 0.0)
            player?.run(die)
        }
    }
    
}
*/

