//
//  Inimigo.swift
//  FirstPart
//
//  Created by Igor de Castro on 19/03/20.
//  Copyright © 2020 Igor de Castro. All rights reserved.
//

import Foundation
import SceneKit

public class Enemy: SCNNode {
    
    var bulletEnemy = Disparo()
    var boss = SCNNode()
    var enemy = SCNNode()
    var enemyScene = SCNScene(named: "NaveScene/naveInimigacopy.scn")!
    var bossScene = SCNScene(named: "NaveScene/naveBosscopy.scn")!
        
    public override init() {
        super.init()
        enemy = enemyScene.rootNode.childNode(withName: "Cube-009", recursively: true)!
        enemy.boundingBox = (min:SCNVector3(80, 80, 80) , max: SCNVector3(100, 100, 100))
        self.geometry = enemy.geometry
        let shape2 = SCNPhysicsShape(geometry: (enemy.geometry)!, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape2)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = CollisionCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
        
        let scale = SCNAction.scale(by: 2, duration: 1.0)
        let fadeInEnemy = SCNAction.fadeIn(duration: 3.0)
        let waitActionEnemy = SCNAction.wait(duration: 2.0)
        let sequence = SCNAction.sequence([scale,waitActionEnemy,fadeInEnemy])
        self.runAction(sequence)

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createBoss(in scnView: SCNView){
        
        boss = bossScene.rootNode.childNode(withName: "Cube-005", recursively: true)!
        self.geometry = boss.geometry
        let shape = SCNPhysicsShape(geometry: boss.geometry!, options: nil)
        
        let bossNode = SCNNode()
        bossNode.geometry = boss.geometry
        bossNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        bossNode.position = SCNVector3(0, 35, 25)
        bossNode.physicsBody?.categoryBitMask = CollisionCategory.enemy.rawValue
        bossNode.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
        bossNode.physicsBody?.isAffectedByGravity = false
        scnView.scene?.rootNode.addChildNode(bossNode)
        
        let scale = CGFloat(5)
        let scaleAction = SCNAction.scale(by: scale, duration: 1.0)
        let fadeAction = SCNAction.fadeIn(duration: 2.0)
        let moveUp = SCNAction.moveBy(x: 0.0, y: 5, z: 0.0, duration: 1.0)
        let moveDown = SCNAction.moveBy(x: 0.0, y: -5, z: 0.0, duration: 1.0)
        let moveLeft = SCNAction.moveBy(x: 10, y: 0, z: 0.0, duration: 1.0)
        let moveRight = SCNAction.moveBy(x: -10, y: 0, z: 0.0, duration: 1.0)
        let actionSequence = SCNAction.sequence([fadeAction,moveDown,moveLeft,moveUp,moveRight])
        let repeteAction = SCNAction.repeatForever(actionSequence)
        let sequence = SCNAction.sequence([scaleAction,repeteAction])
        bossNode.runAction(sequence)
    }
    
    public func shoot(inPosition ship: SCNVector3,of bullet: SCNNode,with scnView: SCNView) {
        let moveActionBullet =  SCNAction.move(to: SCNVector3(ship.x, ship.y, ship.z - 50), duration: 5.0)
        let waitAction = SCNAction.wait(duration: 3.0)
        let desapearBullet = SCNAction.run({ _ in
            self.removeInScene(bullet)
        })
        let actions = SCNAction.sequence([moveActionBullet,desapearBullet,waitAction])
        bullet.runAction(SCNAction.repeat(actions, count: 2))
        bullet.isHidden = false
        scnView.scene?.rootNode.addChildNode(bullet)
    }
    
    public func removeInScene(_ node: SCNNode){
        node.removeFromParentNode()
    }
}
