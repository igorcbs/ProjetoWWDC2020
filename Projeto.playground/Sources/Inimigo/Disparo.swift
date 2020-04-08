//
//  Disparo.swift
//  FirstPart
//
//  Created by Igor de Castro on 19/03/20.
//  Copyright © 2020 Igor de Castro. All rights reserved.
//

import Foundation
import SceneKit


public class Disparo: SCNNode {
    public override init() {
        super.init()
        let bullet = SCNSphere(radius:0.25)
        self.geometry = bullet
        let shape = SCNPhysicsShape(geometry: bullet, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        bullet.name = "bulletEnemy"
        self.physicsBody?.categoryBitMask = CollisionCategory.bulletEnemy.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.ship.rawValue

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
