/*
CZ, HK
12/21/23
 */

import Foundation
import SpriteKit

class MapBuilder {
    
    var scene: GameScene
    
    var level: String
    
    var roadTileArray: [SKSpriteNode] = []
    
    var winCondition: Bool
    
    var finishLine: SKSpriteNode
    
    init(scene: GameScene, level: String) {
        self.scene = scene
        self.level = level
        self.winCondition = false
        self.finishLine = SKSpriteNode(imageNamed: "Finish")
        
        // Additional setup code can go here
        setupMap()
    }
    
    public func getWinCondition() -> Bool {
        return winCondition
    }
    
    public func checkWinCondition() {
        if (level == "Tutorial") {
            if let player = scene.player, player.frame.intersects(finishLine.frame) {
                winCondition = true
            }
        }
    }
    
    public func setupMap() {
        
        if (level == "WinScreen") {
            
            
        
        } else if (level == "Tutorial") {
            
            var lastRoadPosition = CGPoint.zero
            
            // Creating road tiles
            var count = 0...2
            for i in count {
                let roadTile = SKSpriteNode(imageNamed: "Road_01_Tile_03")
                roadTileArray.append(roadTile)
                roadTile.yScale = 0.35
                roadTile.xScale = 1.5
                roadTile.zPosition = 1
                roadTile.position.x = CGFloat(Int(roadTile.size.width) * i)
                roadTile.position.y = 0
                scene.addChild(roadTile)
                lastRoadPosition = CGPoint(x: roadTile.position.x, y: roadTile.position.y)
            }
            
            // Creating grass tiles
            count = 0...15
            var numbers = 0...25
            for i in numbers {
                for j in count {
                    let grassTile = SKSpriteNode(imageNamed: "Grass_Tile")
                    grassTile.yScale = 0.5
                    grassTile.xScale = 0.5
                    grassTile.zPosition = 0
                    grassTile.position.x = CGFloat(Int(grassTile.size.width) * i) - 1280
                    grassTile.position.y = CGFloat(Int(grassTile.size.height) * j) - 2560
                    scene.addChild(grassTile)
                }
            }
            
            finishLine.position = CGPoint(x: lastRoadPosition.x + (roadTileArray[0].size.width / 2) - (finishLine.size.height / 10.5), y: lastRoadPosition.y)
            finishLine.zPosition = 2
            finishLine.zRotation = (3 * Double.pi) / 2
            finishLine.yScale = 0.2
            finishLine.size.width = roadTileArray[0].size.height
            finishLine.alpha = 1
            scene.addChild(finishLine)
            
        } else if (level == "Level1") {
            // Code for Level1
        } else if (level == "Level2") {
            // Code for Level2
        } else {
            // Code for other scenes
        }
        
    }
    
    public func changeScene(to newScene: GameScene) {
        // Perform any scene transition logic here
        scene = newScene
    }
    
}
