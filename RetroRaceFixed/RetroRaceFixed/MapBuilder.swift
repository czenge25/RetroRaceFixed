/*
CZ, HK
5/3/24
 */

import Foundation
import SpriteKit

class MapBuilder {
    
    var scene: GameScene
    
    var level: String
    
    var roadTileArray: [SKSpriteNode] = []
    
    var winCondition: Bool
    
    var finishLine: SKSpriteNode
    
    var boundary: CGRect
    
    init(scene: GameScene, level: String) {
        self.scene = scene
        self.level = level
        self.winCondition = false
        self.finishLine = SKSpriteNode(imageNamed: "Finish")
        self.boundary = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        // Additional setup code can go here
        setupMap()
    }
    
    public func checkWinCondition() {
        if (level == "Tutorial") {
            if let player = scene.player, player.frame.intersects(finishLine.frame) {
                winCondition = true
                if winCondition {
                scene.isHidden = true

                let winScene = WinScene(size: scene.size)
                winScene.scaleMode = .aspectFill
                scene.view?.presentScene(winScene, transition: SKTransition.fade(withDuration: 0.5))
                }
            }
        }
    }
    
    public func setupMap() {

        if (level == "Tutorial") {
            
            boundary = CGRect(x: -1280, y: -2560, width: 2560, height: 5120)
            
            var lastRoadPosition = CGPoint.zero
            
            // Creating road tiles
            var count = 0...5
            for i in count {
                let roadTile = SKSpriteNode(imageNamed: "Road_01_Tile_03")
                roadTileArray.append(roadTile)
                roadTile.yScale = 0.35
                roadTile.xScale = 1.5
                roadTile.zPosition = 1
                roadTile.position.x = CGFloat(Int(roadTile.size.width) * i) - roadTile.size.width
                roadTile.position.y = 0
                scene.addChild(roadTile)
                lastRoadPosition = CGPoint(x: roadTile.position.x, y: roadTile.position.y)
            }
            
            // Creating grass tiles
            count = 0...15
            var numbers = 0...25
            
            var minX = CGFloat.infinity
            var minY = CGFloat.infinity
            var maxX: CGFloat = 0
            var maxY: CGFloat = 0
            
            for i in numbers {
                for j in count {
                    let grassTile = SKSpriteNode(imageNamed: "Grass_Tile")
                    grassTile.yScale = 0.5
                    grassTile.xScale = 0.5
                    grassTile.zPosition = 0
                    let grassTileX = CGFloat(Int(grassTile.size.width) * i) - 1280
                    let grassTileY = CGFloat(Int(grassTile.size.height) * j) - 2560
                    grassTile.position = CGPoint(x: grassTileX, y: grassTileY)
                    scene.addChild(grassTile)
                    
                    minX = min(minX, grassTileX - (grassTile.size.width / 2))
                    minY = min(minY, grassTileY - (grassTile.size.height / 2))
                    maxX = max(maxX, grassTileX + (grassTile.size.width / 2))
                    maxY = max(maxY, grassTileY + (grassTile.size.height / 2))
                }
            }
            
            boundary = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
            
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
