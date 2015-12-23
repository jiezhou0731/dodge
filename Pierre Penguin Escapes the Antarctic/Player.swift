import SpriteKit

class Player : SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named:"player.atlas")
    var flyAnimation = SKAction()
    var deadAnimation = SKAction()
    let playerSpeed = CGFloat(10.0)
    
    func spawn(parentNode:SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 32)) {
        isAlive = true
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        
        let physicsTexture = textureAtlas.textureNamed("player.png")
        self.physicsBody = SKPhysicsBody(
            texture: physicsTexture,
            size: size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 0.9
        self.physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.stone.rawValue |
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.powerup.rawValue |
            PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = ~(PhysicsCategory.bullet.rawValue)
      
        
        self.physicsBody?.affectedByGravity = false
        
        self.runAction(flyAnimation, withKey: "flyAnimation")

    }
    
    func createAnimations() {
        // Create the flying animation:
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("player.png")
        ]
        let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.03)
        flyAnimation = SKAction.group([
            SKAction.repeatActionForever(flyAction)
        ])
        
        let deadFrames:[SKTexture] = [
            textureAtlas.textureNamed("dead.png")
        ]
        let deadAction = SKAction.animateWithTextures(deadFrames, timePerFrame: 0.03)
        deadAnimation = SKAction.group([
            SKAction.repeatActionForever(deadAction)
        ])
    }
    
    var isAlive = true
    func update() {
        if ( isAlive ) {
            self.zRotation = -(ObjectPool.gameScene?.hud.currentOffset.x)!/30
            self.physicsBody?.velocity.dx = (ObjectPool.gameScene?.hud.currentOffset.x)! * playerSpeed
            self.physicsBody?.velocity.dy = (ObjectPool.gameScene?.hud.currentOffset.y)! * playerSpeed
        } else {
            self.physicsBody?.velocity.dx = 0
            self.physicsBody?.velocity.dy = 0
        }
    }
    
    
    func die() {
        isAlive = false
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        self.size = CGSize(width: 64, height: 64)
        self.removeActionForKey("flyAnimation")
        self.runAction(deadAnimation, withKey: "deadAnimation")
        // Alert the GameScene:
        if let gameScene = self.parent?.parent as? GameScene {
            gameScene.gameOver()
        }
    }
    
    func onTap() {}
}