//
//  Joystick.swift
//  Testedoteste
//
//  Created by Igor de Castro on 25/03/20.
//  Copyright © 2020 Igor de Castro. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class Joystick: SKNode {
    
    let ball = SKSpriteNode(imageNamed: "seta.png")
    let base = SKSpriteNode(imageNamed: "bola.png")

    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    
    let maxSpeed: CGFloat = 2
    let maxSlide: CGFloat = UIScreen.main.bounds.size.width
    var hDir: CGFloat = 0
    var vDir: CGFloat = 0
    var move = CGPoint()
    
    
    override init() {
        super.init()
        base.position = CGPoint(x: UIScreen.main.bounds.size.width - 750, y: UIScreen.main.bounds.height - 300)
        base.zPosition = 100
        base.setScale(0.03)
        base.name = "base"
        self.addChild(base)
        
        ball.position = CGPoint(x: UIScreen.main.bounds.size.width - 750, y: UIScreen.main.bounds.height - 300)
        ball.zPosition = 101
        ball.setScale(0.03)
        ball.name = "ball"
        self.addChild(ball)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func movementJoystick(location: CGPoint) {
        let angle = atan2(location.y - self.base.position.y, location.x - self.base.position.x)
        let distanceForCenter = CGFloat(self.base.frame.size.height/2)

        let distanceX = CGFloat(sin(angle - CGFloat(Double.pi/2))*distanceForCenter)
        let distanceY = CGFloat(cos(angle - CGFloat(Double.pi/2))*distanceForCenter)

        if(self.base.frame.contains(location)){
            self.ball.position = location
        }else{
            self.ball.position = CGPoint(x: self.base.position.x - distanceX, y: self.base.position.y + distanceY)
        }
////MARK:       mudar depois pois vai rodar em um ipad
////        self.velocityX = (self.ball.position.x - self.base.position.x) / 20
////        self.velocityY = (self.ball.position.y - self.base.position.y) / 20
//

        self.velocityX = (self.ball.position.x - self.base.position.x) / 20
        self.velocityY = (self.ball.position.y - self.base.position.y) / 20
        
        
    }
    
    func keepMoving() {
        self.ball.position = CGPoint(x: self.base.position.x, y: self.base.position.y)
    }
    
    func movementOver() {
        let moveBack = SKAction.move(to: CGPoint(x: self.base.position.x, y: self.base.position.y), duration: TimeInterval(floatLiteral: 0.1))
        
        moveBack.timingMode = .linear
        
        self.ball.run(moveBack)
        self.velocityX = 0.0
        self.velocityY = 0.0

        self.removeAction(forKey: "FadeAction")
        self.alpha = 1.0
    }
    
    func updateMovement(ship: SCNNode, canMove: Bool, distance: CGPoint) {

        velocityX = (maxSpeed * (distance.x)) / maxSlide
        velocityY = (maxSpeed * (-distance.y)) / maxSlide
        
        
        if velocityX > maxSpeed {
            move.x = maxSpeed
        }else if velocityX < maxSpeed{
            move.x = maxSpeed
        }
        if velocityY > maxSpeed {
            move.y = maxSpeed
        }else if velocityY < maxSpeed{
            move.y = maxSpeed
        }

        if canMove {
            var shipPos = ship.presentation.position
            shipPos.x += Float(velocityX)
            shipPos.y += Float(velocityY)
            //            ship.position.y += Float(yAdd)
            ship.position = shipPos
        }
        
    }
    
    
}
