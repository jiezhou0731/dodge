//
//  Bat.swift
//  Pierre Penguin Escapes the Antarctic
//

import SpriteKit

class Stone: SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named:"stone.atlas")
    var flyAnimation = SKAction()
    
    var slope = CGFloat(0.0)
    var right = CGFloat(1.0)
    
    var initialPostion = CGPoint(x: 0.0, y:0.0)
    let stoneSpeed = CGFloat(1.5)
    
    func spawn(parentNode:SKNode, position: CGPoint, size: CGSize = CGSize(width: 44, height: 24)) {
        self.initialPostion = position
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.runAction(flyAnimation)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.stone.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        slope = Utilities.randomCGFloat(0, secondNum: 3.14)
        if (Utilities.randomCGFloat(-1.0, secondNum: 1.0)<0){
            right = -1
        }
    }
    
    func createAnimations() {
        // The Bat has 4 frames of animation:
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("stone.png")
        ]
        let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.06)
        flyAnimation = SKAction.repeatActionForever(flyAction)
    }
    
    func onTap() {}
    
    func update(){
        position.x += sin(slope) * stoneSpeed * right
        position.y += cos(slope) * stoneSpeed
        if (sin(slope)==0 && cos(slope)==0) {
            print(slope)
        }
    }
}