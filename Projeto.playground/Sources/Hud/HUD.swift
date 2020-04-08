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

public class HUD: SKScene {
    
    var button = SKSpriteNode()
    var buttonPressed = false
    
    var base = SKSpriteNode()
    var ball = SKSpriteNode()
    
    let joystick = Joystick()
    
    public override func sceneDidLoad() {
        super.sceneDidLoad()
        self.createButton()
    }
    
   public func createButton(){
        button = SKSpriteNode(imageNamed: "assets/botaoFogo.png")
        button.position = CGPoint(x: UIScreen.main.bounds.size.width - 150, y: UIScreen.main.bounds.size.height - 800)
        button.zPosition = 100
        button.setScale(0.03)
        button.name = "btn"
    
        self.addChild(button)
        
        self.addChild(joystick)

    }
    
    public func removeButton() {
        if button.name == "btn" {
            button.removeFromParent()
        }
    }
    
    public func touchTheScreen(touches: Set<UITouch>, with event: UIEvent?)  {
        let touch = touches.first
        let location = touch?.location(in: self)
        let nodes = self.nodes(at: location!)
        if nodes.first?.name == "btn" {
            buttonPressed = true
        }
    }
}
