//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import SceneKit

public class GameScene: UIView {
    var scnView: NaveScene?
    
    public static var shared = GameScene()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        scnView = NaveScene(frame: self.frame)
        
        self.addSubview(scnView!)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

let view = GameScene(frame: CGRect(x: 0, y: 0, width: 768, height: 600))


PlaygroundSupport.PlaygroundPage.current.liveView = view
