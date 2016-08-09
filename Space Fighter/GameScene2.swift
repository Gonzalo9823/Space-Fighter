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
    var numberOfBullets = 2
    var bulletsLabel: SKLabelNode!
    var preferredLanguages : NSLocale!
    var espanol = false
    var meteors = [SKSpriteNode]()
    
    var numberOfLifes = 3
    
    //STARS
    let centralStars = SKEmitterNode(fileNamed: "Stars.sks")!
    let rightStars = SKEmitterNode(fileNamed: "Stars.sks")!
    let upperRightStars = SKEmitterNode(fileNamed: "Stars.sks")!
    let upperStars = SKEmitterNode(fileNamed: "Stars.sks")!
    
    var estrellas = [SKEmitterNode]()
    
    
    
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
    func playerCollides() {
        switch numberOfLifes {
        case 3:
            hero.texture = SKTexture(imageNamed: "hero")
        case 2:
            hero.texture = SKTexture(imageNamed: "heroOneHit")
        case 1:
            hero.texture = SKTexture(imageNamed: "heroTwoHits")
        case 0:
            hero.texture = SKTexture(imageNamed: "heroThreeHits")
        case -1:
            hero.texture = SKTexture(imageNamed: "heroDead")
        default:
            print("Ya perdiste")
        }
    }
    
    func createMetor(position: CGPoint) {
        
        let meteor = SKSpriteNode(texture: meteorAnimation[0])
        let animateAction = SKAction.animateWithTextures(self.meteorAnimation, timePerFrame: 0.10);
        let repeatAction = SKAction.repeatActionForever(animateAction)
        meteor.runAction(repeatAction)
        
        meteor.setScale(0.8)
        meteor.zPosition = 4
        meteor.name = "meteor"
        meteor.position = position
        
        meteor.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: meteor.size.width, height: meteor.size.height))
        meteor.physicsBody?.dynamic = true
        meteor.physicsBody?.affectedByGravity = false
        
        meteor.physicsBody?.categoryBitMask    = Fisica.object
        meteor.physicsBody?.contactTestBitMask = Fisica.player
        meteor.physicsBody?.collisionBitMask   = Fisica.object
        
        meteors.append(meteor)
        addChild(meteor)
        
        // Calculate vector components x and y
        var dx = hero.position.x - meteor.position.x
        var dy = hero.position.y - meteor.position.y
        
        // Normalize the components
        let magnitude = sqrt(dx*dx+dy*dy)
        dx /= magnitude
        dy /= magnitude
        
        // Create a vector in the direction of the bird
        let vector = CGVectorMake(100*dx, 100*dy)
        
        // Apply impulse
        meteor.physicsBody?.applyImpulse(vector)
        
    }
    
    func moverHaciaHero() {
        
        let numberOfMeteor = meteors.count - 1
        
        let mover = SKAction.moveTo(hero.position, duration: 0.2)
        
        meteors[numberOfMeteor].runAction(mover)
        
    }
    
    
    func getAngle() -> CGFloat {
        
        
        let punto1 = CGVector(point: controlAdentro.position)
        let punto2 = CGVector(point: controlAfuera.position)
        
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
    
    func moveBackground() {
        for background in estrellas {
            let x = background.position.x - cam.position.x
            let y = background.position.y - cam.position.y
            
            if x < -size.width {
                background.position.x += size.width * 2
            } else if x > size.width {
                background.position.x -= size.width * 2
            }
            
            if y < -size.height {
                background.position.y += size.height * 2
            } else if y > size.height {
                background.position.y -= size.height * 2
            }
        }
        
    }
    
    //MARK: Movement functions
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        self.camera = cam
        cam.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        addChild(cam)
        
        let scaleRatio = self.frame.width / 667
        
        let pre = NSLocale.preferredLanguages()[0]
        if (pre.rangeOfString("es") != nil) {
            espanol = true
        }
        
        
        //Stars X & Y
        let normalY = self.frame.height / 2 - self.frame.height / 2
        let upperY = self.frame.height / 2 + self.frame.height / 2
        
        let centerX = self.frame.width / 2 - self.frame.width / 2
        let rightX = self.frame.width
        
        
        //STARS
        centralStars.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
        centralStars.particlePosition = CGPoint(x: centerX , y: normalY )
        addChild(centralStars)
        estrellas.append(centralStars)
        
        rightStars.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
        rightStars.position = CGPoint(x: rightX , y: normalY)
        addChild(rightStars)
        estrellas.append(rightStars)
        
        upperRightStars.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
        upperRightStars.position = CGPoint(x: rightX , y: upperY)
        addChild(upperRightStars)
        estrellas.append(upperRightStars)
        
        upperStars.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
        upperStars.position = CGPoint(x: centerX, y: upperY)
        addChild(upperStars)
        estrellas.append(upperStars)
        
        
        
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
        
        bulletsLabel = SKLabelNode(fontNamed: "VCR OSD Mono")
        
        if espanol {
            bulletsLabel.text = "Disparos restantes: \(numberOfBullets)"
            
        }
        else {
            bulletsLabel.text = "Bullets left: \(numberOfBullets)"
        }
        
        bulletsLabel.horizontalAlignmentMode = .Left
        bulletsLabel.position = CGPoint(x: (cam.frame.width / 2 - 320) * scaleRatio  , y: (cam.frame.height / 2 + 140) * scaleRatio)
        bulletsLabel.fontSize = 30 * scaleRatio
        cam.addChild(bulletsLabel)
        
        var randomDoubleForX : CGFloat!
        var randomDoubleForY : CGFloat!
        
        
        let crear = SKAction.runBlock {
            
            randomDoubleForX = CGFloat.random(-736, 736)
            randomDoubleForY = CGFloat.random(-414.0, 414.0)
            
            self.createMetor(CGPoint(x: self.hero.position.x + randomDoubleForX , y: self.hero.position.y + randomDoubleForY))
        }
        
        let wait = SKAction.waitForDuration(1)
        
        let seq = SKAction.sequence([wait,crear])
        
        let repeat5Ever = SKAction.repeatActionForever(seq)
        runAction(repeat5Ever)
    }
    
    func fireBullet() {
        
        if numberOfBullets > 0 {
            
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
            numberOfBullets -= 1
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        cam.position = hero.position
        
        moveBackground()
        
        if espanol {
            bulletsLabel.text = "Disparos restantes: \(numberOfBullets)"
            
        }
        else {
            bulletsLabel.text = "Bullets left: \(numberOfBullets)"
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
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == Fisica.player | Fisica.object {
            if contact.bodyA.node!.name == "meteor" {
                numberOfLifes -= 1
                
                let particles = SKEmitterNode(fileNamed: "Smoke")!
                particles.position = contact.bodyA.node!.position
                particles.numParticlesToEmit = 20
                addChild(particles)
                
                contact.bodyA.node!.removeFromParent()
                playerCollides()
                
            }
            else {
                numberOfLifes -= 1
                
                let particles = SKEmitterNode(fileNamed: "Smoke")!
                particles.position = contact.bodyB.node!.position
                particles.numParticlesToEmit = 20
                addChild(particles)
                
                contact.bodyB.node!.removeFromParent()
                playerCollides()
            }
        }
    }
}























