//
//  Inimigo.swift
//  FirstPart
//
//  Created by Igor de Castro on 19/03/20.
//  Copyright © 2020 Igor de Castro. All rights reserved.
//

import Foundation
import SceneKit

class Enemy: SCNNode {
    
    var bulletEnemy = Disparo()
    var boss = SCNBox()
        
    override init() {
        super.init()
        let inimigo = SCNBox(width: 3, height:3.0, length: 3, chamferRadius: 0)
        self.geometry = inimigo
        let shape = SCNPhysicsShape(geometry: inimigo, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = CollisionCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
        
        let fadeInEnemy = SCNAction.fadeIn(duration: 3.0)
        let waitActionEnemy = SCNAction.wait(duration: 4.0)
        let sequence = SCNAction.sequence([waitActionEnemy,fadeInEnemy])
        self.runAction(sequence)
        
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: <#T##String#>)
//        self.geometry?.materials = [material,material,material]
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createBoss(in scnView: SCNView){
        
        boss = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        self.geometry = boss
        let shape = SCNPhysicsShape(geometry: boss, options: nil)

        let bossNode = SCNNode()
        bossNode.geometry = boss
        bossNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        bossNode.position = SCNVector3(0, 35, 25)
        bossNode.physicsBody?.categoryBitMask = CollisionCategory.enemy.rawValue
        bossNode.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
        bossNode.physicsBody?.isAffectedByGravity = false
        scnView.scene?.rootNode.addChildNode(bossNode)
        
        let fadeAction = SCNAction.fadeIn(duration: 2.0)
        let moveUp = SCNAction.moveBy(x: 0.0, y: 5, z: 0.0, duration: 1.0)
        let moveDown = SCNAction.moveBy(x: 0.0, y: -5, z: 0.0, duration: 1.0)
        let moveLeft = SCNAction.moveBy(x: 10, y: 0, z: 0.0, duration: 1.0)
        let moveRight = SCNAction.moveBy(x: -10, y: 0, z: 0.0, duration: 1.0)
        let actionSequence = SCNAction.sequence([fadeAction,moveDown,moveLeft,moveUp,moveRight])
        let repeteAction = SCNAction.repeatForever(actionSequence)
        bossNode.runAction(repeteAction)
    }
    
    func shoot(inPosition ship: SCNVector3,of bullet: SCNNode,with scnView: SCNView) {
        let moveActionBullet =  SCNAction.move(to: SCNVector3(ship.x, ship.y, ship.z - 50), duration: 5.0)
        let waitAction = SCNAction.wait(duration: 3.0)
        let resetPositionAction = SCNAction.run { (node) in
            bullet.position = self.position
        }
        let actions = SCNAction.sequence([waitAction,moveActionBullet])
        bullet.runAction(SCNAction.repeat(actions, count: 2))
        bullet.isHidden = false
        scnView.scene?.rootNode.addChildNode(bullet)
    }
    
    func removeInScene(_ node: SCNNode){
        node.removeFromParentNode()
    }
}
