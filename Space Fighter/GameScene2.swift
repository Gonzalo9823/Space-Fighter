//
//  GameScene2.swift
//  Space Fighter
//
//  Created by Gonzalo Caballero on 8/5/16.
//  Copyright © 2016 Gonzalo Caballero. All rights reserved.
//

import SpriteKit


class GameScene2: SKScene, SKPhysicsContactDelegate {
    
    //MARK: Variables
    
    var hero: SKSpriteNode!
    var selectedNodes = [UITouch:SKSpriteNode]()
    var selectedController = [UITouch:SKShapeNode]()
    var controlAfuera: SKShapeNode!
    var controlAdentro: SKShapeNode!
    var controles = [SKShapeNode]()
    var meteor: SKSpriteNode!
    var meteorAnimation = Array<SKTexture>()
    let stars = SKEmitterNode(fileNamed: "Stars.sks")
    var cameraOfGame = SKCameraNode()
    
    //MARK: My functions
    
    func addControl(position: CGPoint) {
        
        controlAfuera = SKShapeNode(circleOfRadius: 40)
        controlAfuera.fillColor = UIColor.whiteColor()
        controlAfuera.alpha = 0.3
        controlAfuera.name = "control"
        controlAfuera.position = position
        
        controlAdentro = SKShapeNode(circleOfRadius: 30)
        controlAdentro.fillColor = UIColor.whiteColor()
        controlAdentro.alpha = 1
        controlAdentro.name = "controlAdentro"
        controlAdentro.zPosition = 3
        controlAdentro.position = controlAfuera.position
        
        addChild(controlAfuera)
        addChild(controlAdentro)
        
        controles.append(controlAfuera)
        controles.append(controlAdentro)
        
    }
    
    func createMetor(position: CGPoint) {
        
        let meteor = SKSpriteNode(texture: meteorAnimation[0])
        let animateAction = SKAction.animateWithTextures(self.meteorAnimation, timePerFrame: 0.10);
        let repeatAction = SKAction.repeatActionForever(animateAction)
        meteor.runAction(repeatAction)
        
        meteor.zPosition = 4
        meteor.name = "meteor"
        meteor.position = position
        
        addChild(meteor)
    }
    
    
    func getAngle() -> CGFloat {
        
        let punto1 = CGVector(point: controlAdentro.position)
        let punto2 = CGVector(point: controlAfuera.position)
        let p = punto2 - punto1
        let angle = atan2(p.dy, p.dx) + CGFloat(M_PI/2)
        return angle
    }
    
    
    func moveToControl() {
        //let mover = SKAction.moveTo(position, duration: 0.5)
        //hero.runAction(mover)
        
        let angle = CGVector(angle: hero.zRotation + CGFloat(M_PI/2))
        let vector = angle * 400
        
        hero.physicsBody?.velocity = vector
        
    }
    
    func stopMoving() {
        let angle = CGVector(angle: hero.zRotation + CGFloat(M_PI/2))
        let vector = angle * 0
        
        hero.physicsBody?.velocity = vector
    }
    
    //MARK: Movement functions
    
    override func didMoveToView(view: SKView) {
        self.camera = cameraOfGame
        
        let scaleRatio = self.frame.width / 667
        
        stars!.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        addChild(stars!)
        
        
        
        for i in 1...30 {
            meteorAnimation.append(SKTexture(imageNamed: "rocks-\(i)"))
        }
        
        hero = SKSpriteNode(imageNamed: "hero")
        hero.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        hero.setScale(0.03 * scaleRatio)
        hero.zPosition = 4
        
        hero.physicsBody = SKPhysicsBody(rectangleOfSize: hero.size)
        hero.physicsBody?.dynamic = true
        hero.physicsBody?.affectedByGravity = false
        
        hero.physicsBody?.categoryBitMask    = Fisica.player
        hero.physicsBody?.contactTestBitMask = Fisica.object
        hero.physicsBody?.collisionBitMask   = Fisica.none
        
        addChild(hero)    
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        cameraOfGame.position = hero.position
        

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            for i in controles {
                i.removeFromParent()
            }
            
            addControl(location)
            
            if let node = self.nodeAtPoint(location) as? SKShapeNode {
                
                if node.name == "controlAdentro" {
                    print("Hola")
                    selectedController[touch] = node
                }
            }
            
            if let node = self.nodeAtPoint(location) as? SKSpriteNode {
                selectedNodes[touch] = node
                
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for i in controles {
            i.removeFromParent()
        }
        stopMoving()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            // Update the position of the sprites
            if let node = selectedController[touch] {
                node.position = location
                let touchedNode = nodeAtPoint(location)
                print(location)
                
                if touchedNode.name == "controlAdentro" {
                    controlAdentro.position = location
                    hero.zRotation = getAngle()
                    moveToControl()
                }
            }
            
        }
    }
}