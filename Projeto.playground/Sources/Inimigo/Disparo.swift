//
//  Disparo.swift
//  FirstPart
//
//  Created by Igor de Castro on 19/03/20.
//  Copyright © 2020 Igor de Castro. All rights reserved.
//

import Foundation
import SceneKit


class Disparo: SCNNode {
    override init() {
        super.init()
        let bullet = SCNSphere(radius:0.25)
        self.geometry = bullet
        let shape = SCNPhysicsShape(geometry: bullet, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        bullet.name = "bulletEnemy"
        self.physicsBody?.categoryBitMask = CollisionCategory.bulletEnemy.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.ship.rawValue
//        self.physicsBody?.collisionBitMask = 1
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: <#T##String#>)
//        self.geometry?.materials = [material]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
