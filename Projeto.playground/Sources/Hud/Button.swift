//
//  ButtonDisparo.swift
//  FirstPart
//
//  Created by Igor de Castro on 21/03/20.
//  Copyright © 2020 Igor de Castro. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class ButtonDisparo: SKScene {
    
    var button = SKSpriteNode()
    var buttonPressed = false
    
    var base = SKSpriteNode()
    var ball = SKSpriteNode()
    
    let joystick = Joystick()
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.createButton()
    }
    
   func createButton(){
        //        button.size = CGSize(width: 10, height: 10)
        button = SKSpriteNode(imageNamed: "botaoFogo")
        button.position = CGPoint(x: UIScreen.main.bounds.size.width - 150, y: UIScreen.main.bounds.size.height - 300)
        button.zPosition = 100
        button.setScale(0.03)
        button.name = "btn"
    
        self.addChild(button)
        
        self.addChild(joystick)

    }
    
    func removeButton() {
        if button.name == "btn" {
            button.removeFromParent()
        }
    }
    
    func touchTheScreen(touches: Set<UITouch>, with event: UIEvent?)  {
        let touch = touches.first
        let location = touch?.location(in: self)
        let nodes = self.nodes(at: location!)
        print("Deu Bom, foi meu chapa!")
        if nodes.first?.name == "btn" {
            buttonPressed = true
        }
    }
}
