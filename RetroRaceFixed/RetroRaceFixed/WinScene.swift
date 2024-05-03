//  WinScene.swift
//  RetroRaceFixed
//
//  Created by Cameron Zenge on 4/29/24.
//

import Foundation
import SpriteKit

class WinScene: SKScene {
    
    var elapsedTime: TimeInterval = 0
    var bestTimeKey = "BestTime" // Key for storing the best time in UserDefaults
    
    override func didMove(to view: SKView) {
        let timeLabel = SKLabelNode(fontNamed: "Courier New")
        timeLabel.fontSize = 30
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        addChild(timeLabel)
        
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
        
        // Retrieve and display the best time from UserDefaults
        if let bestTime = UserDefaults.standard.value(forKey: bestTimeKey) as? TimeInterval {
            timeLabel.text = "Best Time: \(formatTime(bestTime))"
        } else {
            timeLabel.text = "Best Time: N/A"
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "startButton" {
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
                }
            }
        }
    }
}
