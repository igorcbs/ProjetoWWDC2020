//
//  BossScene.swift
//  Testedoteste
//
//  Created by Igor de Castro on 03/04/20.
//  Copyright © 2020 Igor de Castro. All rights reserved.
//

import Foundation
import SpriteKit

public class FinalScene: SKScene{
    
    var labelTextInitial = SKLabelNode()
    var labelTextFinal = SKLabelNode()
    
    public override func sceneDidLoad() {
    
        super.sceneDidLoad()
        self.createLabels()
    }
    
    public func createLabels(){
        
        labelTextInitial = SKLabelNode(fontNamed: "Georgia")
        labelTextFinal = SKLabelNode(fontNamed: "Georgia")
       
        labelTextInitial.position = CGPoint(x: UIScreen.main.bounds.width - 430, y: UIScreen.main.bounds.height - 200)
        labelTextInitial.fontSize = 25
        labelTextInitial.text = "Now, the ship that managed to save the earth and destroy all enemies ..."
        labelTextInitial.fontColor = .white
       
        labelTextFinal.position = CGPoint(x: UIScreen.main.bounds.width - 400, y: UIScreen.main.bounds.height - 300)
        labelTextFinal.fontSize = 25
        labelTextFinal.fontColor = .black
        labelTextFinal.text = "She will be able to return to her home."
       
        let fadeIn = SKAction.fadeIn(withDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 5.0)
        let sequence = SKAction.sequence([fadeIn,fadeOut])
        
        
        self.addChild(labelTextInitial)
        self.addChild(labelTextFinal)
        
        labelTextInitial.run(sequence, completion: {
            self.view?.alpha = 0.2
            self.labelTextFinal.run(sequence)
        })
        
    }

}
