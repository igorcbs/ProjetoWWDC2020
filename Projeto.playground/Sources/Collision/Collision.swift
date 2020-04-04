//
//  Collision.swift
//  FirstPart
//
//  Created by Igor de Castro on 19/03/20.
//  Copyright © 2020 Igor de Castro. All rights reserved.
//

import Foundation

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let bullet = CollisionCategory(rawValue: 4)
    static let enemy = CollisionCategory(rawValue: 8)
//    static let floor = CollisionCategory(rawValue: 1 << 1)
    static let ship = CollisionCategory(rawValue: 1 )
    static let bulletEnemy = CollisionCategory(rawValue: 2)
}
