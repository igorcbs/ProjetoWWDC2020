//: Esse Projeto foi realizado a partir de um jogo chamado Star Fox(Nintendo)
/*
 
 
 */

import PlaygroundSupport
import SpriteKit
import SceneKit

public class GameScene: UIView {
    var scnView: NaveScene?

    public static var shared = GameScene()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        scnView = NaveScene(frame: self.frame)
        
        self.addSubview(scnView!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
print(NaveScene.self)
let view = GameScene(frame: CGRect(x: 0.0, y: 0.0, width: 800, height: 600))

PlaygroundSupport.PlaygroundPage.current.liveView = view

var string = "Hello World!"
