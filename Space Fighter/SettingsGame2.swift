//
//  SettingsGame2.swift
//  
//
//  Created by Gonzalo Caballero on 8/12/16.
//
//

import Foundation
import SpriteKit
import UIKit

class SettingsGame2: SKScene {
    
    var viewController: GameViewController!
    
    override init(size:CGSize){
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Variables
    
    var backButton: SKSpriteNode!
    var preferredLanguages : NSLocale!
    var espanol = false
    
    override func didMoveToView(view: SKView) {
    
        let scaleRatio = self.frame.width / 667
        
        let pre = NSLocale.preferredLanguages()[0]
        
        if (pre.rangeOfString("es") != nil) {
            espanol = true
        }
        
        if espanol {
            backButton = SKSpriteNode(imageNamed: "Atras")
            backButton.name = "Back"
            backButton.position = CGPoint(x: self.frame.width / 2 - (280 * scaleRatio), y: self.frame.height / 2 + (160 * scaleRatio))
            backButton.setScale(0.15 * scaleRatio)
            addChild(backButton)
        }
        else {
            backButton = SKSpriteNode(imageNamed: "Back")
            backButton.name = "Back"
            backButton.position = CGPoint(x: self.frame.width / 2 - (280 * scaleRatio), y: self.frame.height / 2 + (160 * scaleRatio))
            backButton.setScale(0.15 * scaleRatio)
            addChild(backButton)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "Back" {
                backButton.alpha = 0.4
                let transition = SKTransition.fadeWithDuration(0.5)
                let nextScene = MenuScene2(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                scene?.view?.presentScene(nextScene, transition: transition)
                nextScene.viewController = viewController
            }
        }
    }
}