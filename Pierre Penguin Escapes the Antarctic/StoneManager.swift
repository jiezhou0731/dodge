import SpriteKit

class StoneManager {
    static var maxNumberOfStone = 30
    static let distance = 1000
    static var stones:[Stone] = []
    static var player : Player?
    static var isFirstUpdate = true
    
    static func initialize(){
        isFirstUpdate = true
        // Remove existing stones
        for stone in stones{
            if let index = stones.indexOf(stone) {
                stones.removeAtIndex(index)
            }
        }
        
        player = (ObjectPool.gameScene?.player)!
        while (stones.count<maxNumberOfStone){
            let i = Utilities.randomInt (-distance , secondNum: distance*2)
            let j = Utilities.randomInt (-distance , secondNum: distance*2)
            let floatI = CGFloat(i)
            let floatJ = CGFloat(j)
            if ( player!.position.x - (ObjectPool.gameScene?.size.width)!/3.0 < floatI ){
                if ( floatI < player!.position.x + 2.0/3.0 * (ObjectPool.gameScene?.size.width)!) {
                    if (player!.position.y - (ObjectPool.gameScene?.size.height)!/2.0 < floatJ) {
                         if (floatJ < player!.position.y + (ObjectPool.gameScene?.size.height)!/2.0) {
                            continue
                        }
                    }
                }
            }
            let newStone = Stone()
            let position = CGPoint(x:i,y:j)
            newStone.spawn(ObjectPool.gameScene!.world, position: position)
            stones.append(newStone)
        }
    }
    
    static func addStones() {
        for stone in stones{
            if (Utilities.distance(stone.position, p2: (ObjectPool.gameScene?.player.position)!)>CGFloat(distance+200)) {
                stone.removeFromParent()
                if let index = stones.indexOf(stone) {
                    stones.removeAtIndex(index)
                }
            }
        }
        
        // Add new stones
        while (stones.count<maxNumberOfStone){
            let i = Utilities.randomInt (Int((player?.position.x)!) - distance , secondNum: Int((player?.position.x)!) + distance*2)
            let j = Utilities.randomInt (Int((player?.position.y)!) - distance , secondNum: Int((player?.position.y)!) + distance*2)
            let floatI = CGFloat(i)
            let floatJ = CGFloat(j)
            if ( player!.position.x - (ObjectPool.gameScene?.size.width)!/3.0 < floatI ){
                if ( floatI < player!.position.x + 2.0/3.0 * (ObjectPool.gameScene?.size.width)!) {
                    if (player!.position.y - (ObjectPool.gameScene?.size.height)!/2.0 < floatJ) {
                        if (floatJ < player!.position.y + (ObjectPool.gameScene?.size.height)!/2.0) {
                            continue
                        }
                    }
                }
            }
            let newStone = Stone()
            let position = CGPoint(x:i,y:j)
            newStone.spawn(ObjectPool.gameScene!.world, position: position)
            stones.append(newStone)
        }
    }
    
    
    static var startTime = NSTimeInterval(0)
    static func update(currentTime: NSTimeInterval){
        if (isFirstUpdate){
            startTime = currentTime
            isFirstUpdate = false
        }
        maxNumberOfStone =  30+Int((abs(sin((currentTime - startTime)/7))*230))
        addStones()
        
        for stone in stones{
            stone.update()
        }
    }
}
