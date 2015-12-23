//
//  HUD.swift
//  Pierre Penguin Escapes the Antarctic
//

import SpriteKit

class HUD: SKNode {
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named:"hud.atlas")
    var score = NSTimeInterval(0)
    let scoreText = SKLabelNode(text: "00:00:00")
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()
    let posControlButton = SKSpriteNode()
    let posControlRing = SKSpriteNode()
    
    func createHudNodes() {
        let screenSize = ObjectPool.gameScene!.size
        firstUpdate = true
        scoreText.fontName = "AvenirNext-HeavyItalic"
        scoreText.position = CGPoint(x: 10, y:  screenSize.height - 23)
        scoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.addChild(scoreText)
        
        posControlRing.texture =  textureAtlas.textureNamed("ring.png")
        posControlRing.name = "HUD_posControlRing"
        posControlRing.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        posControlRing.size = CGSize(width: 150, height: 150)
        posControlRing.position = CGPoint(x: screenSize.width - posControlRing.size.width/2,
            y:posControlRing.size.height/2)
        self.addChild(posControlRing)
        
        posControlButton.texture =  textureAtlas.textureNamed("circle.png")
        posControlButton.name = "HUD_posControlButton"
        posControlButton.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        posControlButton.size = CGSize(width: 70, height: 70)
        posControlButton.position = CGPoint(x: screenSize.width - posControlRing.size.width/2,
            y:posControlRing.size.height/2)
        self.addChild(posControlButton)
        
        formatter.minimumIntegerDigits = 6
    }
    
    func gameOver() {
        let screenSize = ObjectPool.gameScene!.size
        let centerOfHud = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2-50)
        
        // Remove
        scoreText.removeFromParent()
        posControlRing.removeFromParent()
        posControlButton.removeFromParent()
        
        
        // Add buttons
        let fadeAnimation = SKAction.fadeAlphaTo(1, duration: 0.4)
        restartButton.texture = textureAtlas.textureNamed("button-restart.png")
        restartButton.name = "HUD_restartGame"
        restartButton.size = CGSize(width: 140, height: 140)
        restartButton.alpha = 0
        restartButton.removeFromParent()
        restartButton.runAction(fadeAnimation)
       
        restartButton.position =  CGPoint(x: centerOfHud.x + 40, y: centerOfHud.y+30)
        self.addChild(restartButton)
        
        menuButton.position = CGPoint(x: centerOfHud.x - 80, y: centerOfHud.y+30)
        menuButton.texture = textureAtlas.textureNamed("button-menu.png")
        menuButton.name = "HUD_returnToMenu"
        menuButton.size = CGSize(width: 70, height: 70)
        menuButton.alpha = 0
        menuButton.removeFromParent()
        menuButton.runAction(fadeAnimation)
        self.addChild(menuButton)
        
        // Add score board
        var best = NSTimeInterval(0)
        if (ObjectPool.gameScene?.appDefaults.objectForKey("bestScore") != nil){
            best = ObjectPool.gameScene?.appDefaults.objectForKey("bestScore") as! NSTimeInterval
            if (score>best) {
                best = score
            }
        } else {
            best = score
        }
        ObjectPool.gameScene?.appDefaults.setObject(best, forKey: "bestScore")
        let bestScore = SKLabelNode(text: "00:00:00")
        bestScore.text = "Best : " + timeToText(best)
        bestScore.fontName = "AvenirNext-HeavyItalic"
        bestScore.position = CGPoint(x: screenSize.width/2, y:  screenSize.height - 70)
        bestScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        bestScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.addChild(bestScore)
        
        let currentScore = SKLabelNode(text: "00:00:00")
        currentScore.text = "Time : " + timeToText(score)
        currentScore.fontName = "AvenirNext-HeavyItalic"
        currentScore.position = CGPoint(x: screenSize.width/2, y:  screenSize.height - 30)
        currentScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        currentScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.addChild(currentScore)
    }

    
    let formatter = NSNumberFormatter()

    var addPointsForTime = false
    
    var point = 0.00
    let backSpeed = CGFloat(3.0)
    
    var firstUpdate = true
    var startTime = NSTimeInterval(0)
    func update(currentTime: NSTimeInterval){
        if (firstUpdate){
            firstUpdate = false
            startTime = currentTime
        }
        
        // For time
        if ((ObjectPool.gameScene?.player.isAlive) == true) {
            score = currentTime - startTime
            scoreText.text = timeToText(score)
        }
        
        // For controller
        if (controlButtonIsMoving == false && Utilities.distance(posControlButton.position, p2: posControlRing.position) != 0) {
            posControlButton.position.x -= backSpeed * (posControlButton.position.x - posControlRing.position.x) / Utilities.distance(posControlButton.position, p2: posControlRing.position)
            posControlButton.position.y -= backSpeed * (posControlButton.position.y - posControlRing.position.y) / Utilities.distance(posControlButton.position, p2: posControlRing.position)
            if (Utilities.distance(posControlButton.position, p2: posControlRing.position) < backSpeed){
                posControlButton.position = posControlRing.position
            }
        }
        currentOffset.x = posControlButton.position.x - posControlRing.position.x
        currentOffset.y = posControlButton.position.y - posControlRing.position.y
    }

    var controlButtonIsMoving = false
    func sceneTouchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)->Bool {
        for touch in (touches) {
            let location = touch.locationInNode(self)
            let nodeTouched = nodeAtPoint(location)
            ObjectPool.gameScene?.lastTouchedNode = nodeTouched
            if let gameSprite = nodeTouched as? GameSprite {
                gameSprite.onTap()
            }
            
            // Check for HUD buttons:
            if nodeTouched.name == "HUD_restartGame" {
                let skView =  ObjectPool.gameViewController?.view as! SKView
                skView.ignoresSiblingOrder = true
                ObjectPool.transitionScene.size = (ObjectPool.gameViewController?.view.bounds.size)!
                skView.presentScene(ObjectPool.transitionScene, transition: .crossFadeWithDuration(0.6))
                return true
            }
            else if (nodeTouched.name == "HUD_returnToMenu") {
                // Transition to the menu scene:
                ObjectPool.gameScene!.view?.presentScene(
                    MenuScene(size: ObjectPool.gameScene!.size),
                    transition: .crossFadeWithDuration(0.6))
                return true
            } else if (nodeTouched.name == "HUD_posControlButton") {
                controlButtonIsMoving = true
                return true
            }
        }
        return false
    }
    
    var currentOffset = CGPoint(x:0, y:0)
    func sceneTouchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)->Bool {
        if (ObjectPool.gameScene?.lastTouchedNode == posControlButton) {
            for touch in touches {
                let location = touch.locationInNode(self)
                if (Utilities.distance(location, p2: posControlRing.position)<20) {
                    posControlButton.position = location
                } else {
                    let k = (posControlRing.position.y - location.y)/(posControlRing.position.x - location.x)
                    let r = CGFloat(20)
                    var x = r/sqrt(k*k+1)
                    if (location.x - posControlRing.position.x < 0) {
                        x = -x
                    }
                    x += posControlRing.position.x
                    var y = k * r/sqrt(k*k+1)
                    if (location.x - posControlRing.position.x < 0) {
                        y = -y
                    }
                    y += posControlRing.position.y
                    posControlButton.position = CGPoint(x: x,y: y)
                }
            }
            return true
        }
        return false
    }
    
    func timeToText (var elapsedTime : NSTimeInterval) -> String{
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        let fraction = UInt8(elapsedTime * 100)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d",fraction)
        
        return "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    func sceneTouchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) -> Bool {
        for touch in (touches) {
            let location = touch.locationInNode(self)
            let nodeTouched = nodeAtPoint(location)
            if (nodeTouched.name == "HUD_posControlButton") {
                controlButtonIsMoving = false
                return true
            }
        }
        return false
    }
    
    func sceneTouchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) -> Bool {
       for touch in (touches)! {
            let location = touch.locationInNode(self)
            let nodeTouched = nodeAtPoint(location)
            if (nodeTouched.name == "HUD_posControlButton") {
                return true
            }
        }
        return false
    }
    
}