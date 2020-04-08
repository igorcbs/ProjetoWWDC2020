/*
    Aqui temos o grande espetaculo, a classe onde será gerada todo do jogo




*/
import Foundation
import SceneKit
import QuartzCore
import PlaygroundSupport

public class NaveScene: SCNView, SCNPhysicsContactDelegate, SCNSceneRendererDelegate{

    //Hud Layer
    var button = HUD(size: UIScreen.main.bounds.size)
    var cameraNode = SCNNode()
    
    //Player
    var ship = SCNNode()
    var bullet = SCNNode()
    
    //Movimentação do Player
    var initialTouch = CGPoint()
    var canMove = false
    var heightDiretion: CGFloat = 0
    var verticalDiretion: CGFloat = 0
    var updateNavePosition = SCNVector3()
    var distance = CGPoint(){
        willSet{
            heightDiretion = newValue.x > 0 ? -1 : 1
            verticalDiretion = newValue.y > 0 ? 1 : -1
        }
    }
    
    //Inimigo e Boss
    var enemy = Enemy()
    var targetHit = false
    var hitEnemy = 0
    var boss = SCNNode()
    var hitBoss = 0
    var bossApear = true
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame, options: [SCNView.Option.preferredRenderingAPI.rawValue: SCNRenderingAPI.metal.rawValue])
        print(cameraNode)
        print(button)
        print(ship)
        //Definindo a scene
        self.scene = SCNScene(named: "Navescene/nave.scn")!
        
        //Configurando a camera na scene
        cameraNode.camera = SCNCamera()
        self.scene?.rootNode.addChildNode(cameraNode)
        self.allowsCameraControl = false
        self.autoenablesDefaultLighting = false
        
        // Definindo o nave do player
        ship = (self.scene?.rootNode.childNode(withName: "ship", recursively: true))!
        
        //Definindo a bala que será disparada pelo Player
        bullet = (self.scene?.rootNode.childNode(withName: "bullet", recursively: true))!
        
        //Adicionando o ship como filho da cameraNode
        cameraNode.addChildNode(ship)
        
        //Adicionando delegate na scena
        self.delegate = self
        
        self.scene?.physicsWorld.contactDelegate = self
        
        self.backgroundColor = UIColor.black
        
        //Renderizando objetos SpriteKit em Sceneki
        self.overlaySKScene = button
        self.overlaySKScene?.isUserInteractionEnabled = false
        
        self.pointOfView?.camera = cameraNode.camera
        
        self.isPlaying = true
        
        self.scene?.physicsWorld.gravity = SCNVector3(0.0, 0.0, 0.0)
        
        addInimigo(scnView: self)
        navePhysics()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Funções Touches
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        button.touchTheScreen(touches: touches, with: event)
        guard let touchJs = touches.first else {return}
        let jsTouchLocation = touchJs.location(in: self.button.joystick)
        initialTouch = jsTouchLocation
        
        if button.buttonPressed{
            self.button.joystick.movementOver()
            
            guard let bullet2 = bullet.copy() as? SCNNode else { return }
            updatePosition(of: bullet2, with: cameraNode.position, relative: ship)

            let directionBullet = SCNVector3(CGFloat(ship.transform.m31), CGFloat(ship.transform.m32),CGFloat(ship.transform.m33))
            bullet2.removeFromParentNode()
            bullet2.position = ship.position
            bullet2.physicsBody?.applyForce(directionBullet, asImpulse: true)
            bullet2.physicsBody?.velocity.z = 10
            self.scene?.rootNode.addChildNode(bullet2)
            bullet2.isHidden = false
            button.buttonPressed = false

        }else{
            self.button.joystick.base.position = jsTouchLocation
            self.button.joystick.ball.position = jsTouchLocation
            canMove = true
        }

    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       if let touch = touches.first?.location(in: self.button.joystick) {
            distance = CGPoint(x: initialTouch.x - touch.x, y: initialTouch.y - touch.y)
            self.button.joystick.movementJoystick(location: touch)
            canMove = true
        }
    }

    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.button.joystick.movementOver()
        canMove = false
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.button.joystick.movementOver()
        canMove = false
        distance = .zero
        initialTouch = .zero
    }
    
    
    //MARK: - RENDERER
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.button.joystick.updateMovement(ship: ship, canMove: canMove, distance: distance)
        updateNavePosition = ship.position
    }
    
    
    //MARK: - PHYSICS WORLD
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.enemy.rawValue || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.enemy.rawValue ) && contact.nodeA.name != "ship"{
            print("HitShip")
            
            if hitEnemy < 5{
                print(hitEnemy)
                self.targetHit = true
                removeNodeWithAnimation(contact.nodeB, explosion: false, sceneView: self)
                self.enemy.removeInScene(self.enemy.bulletEnemy)
                self.removeNodeWithAnimation(contact.nodeA, explosion: true, sceneView: self)
                self.targetHit = false
                self.addInimigo(scnView: self)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                    self.enemy.removeInScene(self.enemy.bulletEnemy)
//                    self.removeNodeWithAnimation(contact.nodeA, explosion: true, sceneView: self.scnView)
//                    self.targetHit = false
//                    self.addNewInimigo(scnView: self.scnView)
//
//                })
                
            }else {
                
                if hitEnemy == 5 && hitBoss == 0{
                    self.removeNodeWithAnimation(contact.nodeA, explosion: true, sceneView: self)
                }
                
                if bossApear {
                    enemy.createBoss(in: self)
                    bossApear = false
                }

                if hitBoss < 5 {
//                    guard let bulletEnemy = enemy.bulletEnemy.copy() as? SCNNode else {return}
//                    bulletEnemy.isHidden = true
//                    bulletEnemy.position = SCNVector3(boss.position.x, boss.position.y, boss.position.z + 5)
//                    for _ in 1...3{
//                       shoot(in: ship, of: bulletEnemy, with: scnView)
//                    }
                    removeNodeWithAnimation(contact.nodeB, explosion: false, sceneView: self)
                    hitBoss += 1;
                }else {
                    removeNodeWithAnimation(contact.nodeB, explosion: false, sceneView: self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//                        self.enemy.removeInScene(self.enemy.bulletEnemy)
                        self.removeNodeWithAnimation(contact.nodeA, explosion: true, sceneView: self)

                    })
                    self.button.joystick.isHidden = true
                    self.button.isHidden = true
                    let waitAction = SCNAction.wait(duration: 1.0)
                    let moveAction = SCNAction.move(to: SCNVector3(ship.position.x, ship.position.y, ship.position.z + 200), duration: 5.0)
                    let sequence = SCNAction.sequence([waitAction,moveAction])
                    ship.runAction(sequence)
                    self.overlaySKScene = FinalScene(size: UIScreen.main.bounds.size)
                }
                
            }
                
        }else if (contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.ship.rawValue && contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.bulletEnemy.rawValue) {
            let positionNodeA = contact.nodeA.position
            let positionNodeB = contact.nodeB.position
            
           if contact.nodeA.physicsBody?.contactTestBitMask == contact.nodeB.physicsBody?.categoryBitMask && positionNodeA.x == positionNodeB.x {
                actionNave(with: ship)
                removeNodeWithAnimation(contact.nodeB, explosion: false, sceneView: self)
            }
            
        }
                
    }
    
    //Adicionando Inimigo
    public func addInimigo(scnView: SCNView){
        
        //Copia da bala da classe Enemy
        guard let bulletEnemy = enemy.bulletEnemy.copy() as? SCNNode else {return}

        //Variaveis que através da função floatBetween trás valores aleatórios entre dois números
        let posX = floatBetween(10, and: -20)
        let posY = floatBetween(45, and: 20)
        let posZ = floatBetween(10, and: 25)
        
        //Defino a posição do inimigo através das variáveis acima e adiciono na scene
        enemy.position = SCNVector3(posX, posY,posZ)
        self.scene?.rootNode.addChildNode(enemy)

        //Configuração da bala do inimigo
        bulletEnemy.isHidden = true
        bulletEnemy.position = SCNVector3(enemy.position.x, enemy.position.y - 0.2, enemy.position.z)
        //Definindo a movimentação da bala do inimigo
        if !targetHit{

            enemy.shoot(inPosition: updateNavePosition, of: bulletEnemy, with: self)
            
        }
        self.hitEnemy += 1
    }
    
    /*Essa função recebe dois valores do tipo Float um maior e um menor e através do arc4random e uma conta, retorna
     *um valor para aleatório entre eles
     */
    public func floatBetween(_ first: Float,  and second: Float) -> Float { // random float between upper and lower bound (inclusive)
        return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
    }
    
    /*
     * Essa funçãp remove o node que sofreu dano ou um node bala, podendo ou não ter alguma animação de explosão
     */
    public func removeNodeWithAnimation(_ node: SCNNode, explosion: Bool, sceneView: SCNView) {

        // Play collision sound for all collisions (bullet-bullet, etc.)

//        self.playSoundEffect(ofType: .collision)

        if explosion {

            // Play explosion sound for bullet-ship collisions

//            self.playSoundEffect(ofType: .explosion)
//
            let particleSystem = SCNParticleSystem(named: "Particle/explode.scnp", inDirectory: nil)!
            let systemNode = SCNNode()
            systemNode.addParticleSystem(particleSystem)
            particleSystem.particleSize = CGFloat(integerLiteral: 2)
            systemNode.position = node.position
            sceneView.scene?.rootNode.addChildNode(systemNode)
        }

        // remove node
        node.removeFromParentNode()
        
    }
    
    
    public func actionNave(with nave: SCNNode) {
        let fadeIn = SCNAction.fadeIn(duration: 2.0)
        let fadeOut = SCNAction.fadeOut(duration: 3.0)
        let sequence = SCNAction.sequence([fadeOut,fadeIn])
        
        nave.runAction(sequence)
    }
    
    /*
        Essa função faz update da posicao da camera em relacao a movimentação da nave em tempo real. Pegando a matrix 4x4 da nave e fazendo calculos do proprio Xcode para
            incrementar na bala da nave.
     */
    public func updatePosition(of bullet: SCNNode,with position: SCNVector3,relative nave: SCNNode) {
        //Getting the matrix 4x4 to the camera.transform
        let nodeTranform = matrix_float4x4(nave.transform)
        
        //Setup the translation matirx in position
        var translation = matrix_identity_float4x4
        translation.columns.3.x = position.x
        translation.columns.3.y = position.y
        translation.columns.3.z = position.z
        
        let updateTranformNode = matrix_multiply(nodeTranform, translation)
        
        bullet.transform = SCNMatrix4(updateTranformNode)
        
    }
    
    public func navePhysics() {
        ship.physicsBody?.contactTestBitMask = CollisionCategory.bulletEnemy.rawValue
    }
    
    
}

