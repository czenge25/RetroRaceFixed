//
//  WinScene.swift
//  RetroRaceFixed
//
//  Created by Cameron Zenge on 4/29/24.
//

import Foundation
import SpriteKit

class WinScene: SKScene {
    
    override func didMove(to view: SKView) {

        let congratulationLabel = SKLabelNode(fontNamed: "Arial")
        congratulationLabel.text = "Congratulations! You win!"
        congratulationLabel.fontSize = 100
        congratulationLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(congratulationLabel)

        let buttonSize = CGSize(width: 400, height: 120)
        let playAgainButton = SKShapeNode(rectOf: buttonSize, cornerRadius: buttonSize.height / 2)
        playAgainButton.fillColor = .blue
        playAgainButton.strokeColor = .clear
        playAgainButton.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        playAgainButton.name = "playAgainButton"
        addChild(playAgainButton)

        let capsuleWidth = buttonSize.width
        let capsuleHeight = buttonSize.height

        let buttonText = SKLabelNode(fontNamed: "Arial")
        buttonText.text = "Play Again"
        buttonText.fontSize = 80
        buttonText.fontColor = .white
        buttonText.position = CGPoint(x: 0, y: -capsuleHeight * 0.2)
        playAgainButton.addChild(buttonText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "playAgainButton" {
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
                }
            }
        }
    }
}
