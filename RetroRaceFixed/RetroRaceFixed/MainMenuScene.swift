//
//  MainMenuScene.swift
//  RetroRaceFixed
//
//  Created by John Karmozyn on 4/4/24.
//

import Foundation
import SpriteKit
class MainMenuScene: SKScene {
    var gameScene: GameScene?
    override func didMove(to view: SKView) {
        // Set up your menu scene
        backgroundColor = SKColor.lightGray
        let titleLabel = SKLabelNode(fontNamed: "Courier New")
        titleLabel.text = "RetroRace"
        titleLabel.fontSize = 40
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(titleLabel)
        let startButton = SKSpriteNode(imageNamed: "startbutton")
        startButton.name = "startButton" // Set the name for identification
        startButton.zPosition = 1
        let width = startButton.size.width
        let height = startButton.size.height
        startButton.scale(to: CGSize(width: width * 0.2, height: height * 0.2))
        startButton.position = CGPoint(x: frame.midX, y: frame.midY - startButton.size.height) // Adjusted for visibility
        addChild(startButton)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesArray = self.nodes(at: location)
        gameScene = GameScene(size: self.size)
        if nodesArray.first?.name == "startButton" {
            let transition = SKTransition.fade(withDuration: 1.0) // Create a transition effect
            let gameScene = GameScene(size: self.size) // Assuming your game scene is called GameScene
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
}

