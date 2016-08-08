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
    var cam = SKCameraNode()
    var disparo: SKSpriteNode!
    var viewController: GameViewController!
  
    //STARS
    let centralStars = SKEmitterNode(fileNamed: "Stars.sks")!
    let rightStars = SKEmitterNode(fileNamed: "Stars.sks")!
    let leftStars = SKEmitterNode(fileNamed: "Stars.sks")!
    let upperStars = SKEmitterNode(fileNamed: "Stars.sks")!
    let bottomStars = SKEmitterNode(fileNamed: "Stars.sks")!

    
    
    //MARK: My functions
    
    func addControl(position: CGPoint)  {
        
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
        
        cam.addChild(controlAfuera)
        cam.addChild(controlAdentro)
        
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
        
        
        let punto1 = CGVector(point: controlAdentro.position ?? CGPoint(x: 0, y: 0))
        let punto2 = CGVector(point: controlAfuera.position ?? CGPoint(x: 0, y: 0))
        
        let p = punto2 - punto1
        let angle = atan2(p.dy, p.dx) + CGFloat(M_PI/2)
        return angle
    }
    
    
    func moveToControl() {

        let angle = CGVector(angle: hero.zRotation + CGFloat(M_PI/2))
        let vector = angle * 400
        
        hero.physicsBody?.velocity = vector
        
    }
    
    func stopMoving() {
        let angle = CGVector(angle: hero.zRotation + CGFloat(M_PI/2))
        let vector = angle * 0
        
        hero.physicsBody?.velocity = vector
    }
    
//    func moveBackground() {
//        
//        switch hero.position.x {
//        case 200 :
//            <#code#>
//        default:
//            <#code#>
//        }
//        
//        
//        if hero.position.x > CGFloat(200) {
//            
//        }
//    }
    
    //MARK: Movement functions
    
    override func didMoveToView(view: SKView) {
        
        
        self.camera = cam
        cam.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        addChild(cam)
        
        let scaleRatio = self.frame.width / 667
        
        
        //Stars X & Y
        let normalY = self.frame.height / 2 - self.frame.height / 2
        let upperY = self.frame.height / 2 + self.frame.height / 2
        let bottomY = -(self.frame.height / 2 + self.frame.height / 2)
        
        let centerX = self.frame.width / 2 - self.frame.width / 2
        let rightX = self.frame.width
        let leftX = -self.frame.width
        
        
        //STARS
        centralStars.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
        centralStars.particlePosition = CGPoint(x: centerX , y: normalY )
        addChild(centralStars)
        
        rightStars.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
        rightStars.position = CGPoint(x: rightX , y: normalY)
        addChild(rightStars)
        
        leftStars.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
        leftStars.position = CGPoint(x: leftX , y: normalY)
        addChild(leftStars)
        
        upperStars.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
        upperStars.position = CGPoint(x: centerX, y: upperY)
        addChild(upperStars)
        
        bottomStars.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
        bottomStars.position = CGPoint(x: centerX, y: bottomY)
        addChild(bottomStars)
     
        
        
        for i in 1...30 {
            meteorAnimation.append(SKTexture(imageNamed: "rocks-\(i)"))
        }
        
        hero = SKSpriteNode(imageNamed: "hero")
        hero.position = CGPoint(x: cam.frame.width / 2, y: cam.frame.height / 2)
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
    
    func fireBullet() {
        
        disparo = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 3, height: 9))
        disparo.position = hero.position
        disparo.zRotation = hero.zRotation
        addChild(disparo)
        
        disparo.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 3, height: 9))
        disparo.physicsBody?.dynamic = true
        disparo.physicsBody?.affectedByGravity = false
        
        disparo.physicsBody?.categoryBitMask    = Fisica.bullets
        disparo.physicsBody?.contactTestBitMask = Fisica.object
        disparo.physicsBody?.collisionBitMask   = Fisica.none
        
        
        let angle = CGVector(angle: hero.zRotation + CGFloat(M_PI) + CGFloat(M_PI / 2))
        let vector = angle * -1.3
        
        disparo.physicsBody!.applyImpulse(vector)
    }
    

    

    
    override func update(currentTime: NSTimeInterval) {
        cam.position = hero.position
        
        print(CGPoint(x: self.frame.width , y: self.frame.height / 2 - self.frame.height / 2))
        
        print(hero.position)
        
        if hero.position.x > 291 + 333.5 {
            print("LLEGASTE WEON")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(cam)
                        
            if location.x > cam.frame.width / 2 {
                for i in controles {
                    i.removeFromParent()
                }
                
                addControl(location)
                selectedController[touch] = controlAfuera
                selectedController[touch] = controlAdentro
            }
            
            else if location.x < cam.frame.width / 2 {
                print("Funcioan")
                fireBullet()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if selectedController[touch] != nil {
                for i in controles {
                    i.removeFromParent()
                }
                stopMoving()
            }
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(cam)
            // Update the position of the sprites
            if let node = selectedController[touch] {
                node.position = location
                //let touchedNode = nodeAtPoint(location)
                
                hero.zRotation = getAngle()
                moveToControl()
            }
            
        }
    }
}