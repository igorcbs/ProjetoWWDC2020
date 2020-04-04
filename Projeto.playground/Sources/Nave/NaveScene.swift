/*
    Aqui temos o grande espetaculo, a classe onde será gerada todo do jogo




*/
import Foundation
import SceneKit
import QuartzCore

public class NaveScene: SCNView, SCNPhysicsContactDelegate, SCNSceneRendererDelegate{
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame, options: [SCNView.Option.preferredRenderingAPI.rawValue: SCNRenderingAPI.metal.rawValue])
        self.scene = SCNScene(named: "Navescene/nave.scn")!
        
        self.allowCameraControl = false
        self.autoEnableDefaultLighting = false

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

