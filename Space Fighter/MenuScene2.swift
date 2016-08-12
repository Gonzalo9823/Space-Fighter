//
//  MenuScene2.swift
//  Space Fighter
//
//  Created by Gonzalo Caballero on 8/11/16.
//  Copyright © 2016 Gonzalo Caballero. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class MenuScene2: SKScene {
    
    var viewController: GameViewController!
    
    override init(size:CGSize){
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Variables
    
    var titulo: SKSpriteNode!
    var protectTheShip: SKSpriteNode!
    var preferredLanguages : NSLocale!
    var meteorsshower: SKSpriteNode!
    var settingsJuegoUno: SKSpriteNode!
    var mundial: SKSpriteNode!
    var espanol = false
    var musicButton: SKSpriteNode!
    var playMusic = false
    let defaults = NSUserDefaults.standardUserDefaults()
    var ayuda: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        //Demas
        let scaleRatio = self.frame.width / 667
        
        let pre = NSLocale.preferredLanguages()[0]
        
        if (pre.rangeOfString("es") != nil) {
            espanol = true
        }
        
        
        playMusic = defaults.boolForKey("Musica")
        
        //Titulo
        titulo = SKSpriteNode(imageNamed: "title")
        titulo.position = CGPoint(x: self.frame.width / 2, y: (self.frame.height / 2 + (140 * scaleRatio)))
        titulo.setScale(0.3 * scaleRatio)
        addChild(titulo)
        
        //Juego Uno
        
        if espanol {
            protectTheShip = SKSpriteNode(imageNamed: "ProtegeLaNave")
            
        } else {
            protectTheShip = SKSpriteNode(imageNamed: "ProtectTheShip")
        }
        protectTheShip.position = CGPoint(x: self.frame.width / 2 - (160 * scaleRatio), y: self.frame.height / 2 )
        protectTheShip.setScale(0.5 * scaleRatio)
        protectTheShip.name = "JuegoUno"
        addChild(protectTheShip)
        
        //Settings Juego Uno
        
        settingsJuegoUno = SKSpriteNode(imageNamed: "Settings")
        settingsJuegoUno.position = CGPoint(x: self.frame.width / 2 - (195 * scaleRatio), y: self.frame.height / 2 - (115 * scaleRatio))
        settingsJuegoUno.setScale(0.1 * scaleRatio)
        settingsJuegoUno.name = "Settings Juego Uno"
        addChild(settingsJuegoUno)
        
        //Mundial Juego Uno
        mundial = SKSpriteNode(imageNamed: "World")
        mundial.name = "Mundial"
        mundial.position = CGPoint(x: self.frame.width / 2 - (135 * scaleRatio), y: self.frame.height / 2 - (115 * scaleRatio))
        
        if self.frame.width / 736 == 1 {
            mundial.setScale(0.3)
        }
        else {
            mundial.setScale(0.2 * scaleRatio)
            
        }
        addChild(mundial)
        
        //Juego Dos
        
        if espanol {
            meteorsshower = SKSpriteNode(imageNamed: "LluviaDeMeteoritos")
            
        } else {
            meteorsshower = SKSpriteNode(imageNamed: "MeteorsShower")
        }
        meteorsshower.position = CGPoint(x: self.frame.width / 2 + (160 * scaleRatio), y: self.frame.height / 2)
        meteorsshower.setScale(0.5 * scaleRatio)
        meteorsshower.name = "JuegoDos"
        addChild(meteorsshower)
        
        //Musica
        if playMusic == false {
            musicButton = SKSpriteNode(imageNamed: "music")
            musicButton.name = "Musica"
            musicButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - (130 * scaleRatio))
            musicButton.setScale(0.15 * scaleRatio)
            addChild(musicButton)
        }
        else {
            musicButton = SKSpriteNode(imageNamed: "noMusic")
            musicButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - (130 * scaleRatio))
            musicButton.name = "Musica"
            musicButton.setScale(0.15 * scaleRatio)
            addChild(musicButton)
        }
        if espanol {
            ayuda = SKSpriteNode(imageNamed: "imagenAyuda")
        } else {
            ayuda = SKSpriteNode(imageNamed: "ImagenAyudaEspanol")
        }
        ayuda.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        ayuda.size = CGSize(width: self.frame.width, height: self.frame.height)
        ayuda.zPosition = 4
        ayuda.name = "imagenAyuda"
        ayuda.alpha = 0
        addChild(ayuda)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "JuegoUno" {
                let mostrar = SKAction.fadeInWithDuration(0.4)
                ayuda.runAction(mostrar)
            }
                
            else if touchedNode.name == "imagenAyuda" {
                protectTheShip.alpha = 0.4
                
                let transition = SKTransition.fadeWithDuration(1)
                
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                
                scene?.view?.presentScene(nextScene, transition: transition)
                nextScene.viewController = viewController
            }
                
            else if touchedNode.name == "JuegoDos" {
                meteorsshower.alpha = 0.4
                
                let transition = SKTransition.fadeWithDuration(1)
                
                let nextScene = GameScene2(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                
                scene?.view?.presentScene(nextScene, transition: transition)
                nextScene.viewController = viewController
            }
                
            else if touchedNode.name == "Settings Juego Uno" {
                settingsJuegoUno.alpha = 0.4
                
                let transition = SKTransition.fadeWithDuration(1)
                
                let nextScene = Settings(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                
                scene?.view?.presentScene(nextScene, transition: transition)
                nextScene.viewController = viewController
            }
            
            else if touchedNode.name == "Mundial" {
                let vc = viewController.storyboard?.instantiateViewControllerWithIdentifier("BestScore")
                viewController.presentViewController(vc!, animated: true, completion: nil)
            }
            
            else if touchedNode.name == "Musica" {
                if playMusic == false {
                    musicButton.texture = SKTexture(imageNamed: "noMusic")
                    playMusic = true
                    defaults.setBool(true, forKey: "Musica")

                }
                else {
                    musicButton.texture = SKTexture(imageNamed: "music")
                    playMusic = false
                    defaults.setBool(false, forKey: "Musica")
                }
            }
        }
    }
}

















