//
//  ViewController.swift
//  MainITAssignment
//
//  Created by zezenzo on 15/10/17.
//  Copyright © 2017 null. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    // Few Cheeky Declarations
    
    @IBOutlet var menu: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var score: UILabel!
    @IBOutlet var time: UILabel!
    
    @IBOutlet var pressToStart: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet var crosshair: UIImageView!
    
    var audioPlayer: AVAudioPlayer!
    var timer = Timer()
    var counter = 30
    var scoreCounter = 0
    // Timer
    
   // var timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.userScore), userInfo: nil, repeats: true)
    
    
    // Setting up Scene
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create an Empty Scene
        let scene = SCNScene()
        
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.scene.physicsWorld.contactDelegate = self

        self.placeMonster()
        
    }
    
    // End
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func worldPositionFromScreenPosition(_ position: CGPoint,
                                         objectPos: SCNVector3?,
                                         infinitePlane: Bool = false) -> (position: SCNVector3?, planeAnchor: ARPlaneAnchor?, hitAPlane: Bool) {
        
        return (nil, nil, false)
    }

    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    // Timer Function
    @objc func timerAction(_ sender: Timer) {
        counter -= 1
        time.text = "\(counter)"
        
            if (counter <= 0) {
                
                sender.invalidate()
                
                let gameOver = UIAlertController(title: "Game Over", message: "Your score is \(scoreCounter)", preferredStyle: .actionSheet)
                
                
                
                let dismissAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    self.counter = 30
                    self.scoreCounter = 0
                    self.score.text = "0"
                    self.time.text = "30"
                })
                gameOver.addAction(dismissAlertAction)
                
                self.present(gameOver, animated: true, completion: nil)
                
            }
        
    }
    
    // End
    
    // Getting Users Position ----------------------------------------------------------------------------------------/
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    // Getting Users Position End ------------------------------------------------------------------------------------/
    
    
    // Start
    @IBAction func startGame(sender: UIButton) {
        
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.timerAction(_:)), userInfo: nil, repeats: true)
        
        sender.isHidden = true
        
        
    }
    
    
    
    
    
    // Float Function Begin ------------------------------------------------------------------------------------------/
    
    
    func floatBetween(_ first: Float,  and second: Float) -> Float { // random float between upper and lower bound (inclusive)
        return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
    }
    
    // Float Function End --------------------------------------------------------------------------------------------/
    
    
    
    
    
    
    
    
    // Placing the Monster -------------------------------------------------------------------------------------------/
    
    let path = Bundle.main.path(forResource: "Table", ofType: "scn", inDirectory: "Resources.scnassets/Models")
    
    func placeMonster() {
        
    //    let monsterNode = SCNNode()
        
        let path = Bundle.main.path(forResource: "Monster", ofType: "scn", inDirectory: "art.scnassets")
        let referenceURL = URL(fileURLWithPath: path!)
        let referenceNode = SCNReferenceNode(url: referenceURL)!
        referenceNode.load()
        let monsterNode = referenceNode.childNodes.first!
        
        //sceneView.scene.rootNode.addChildNode(monsterNode)
        
        /*
        guard let virtualObjectScene = SCNScene(named: "Monster.scn", inDirectory: "art.scnassets" ) else {
            return
        }
        
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.diffuse.contents = UIColor.black
            wrapperNode.addChildNode(child)
        }
        */
        let posX = floatBetween(-0.5, and: 0.5)
        let posY = floatBetween(-0.5, and: 0.5 )
        
        monsterNode.physicsBody?.categoryBitMask = CollisionCategory.ship.rawValue
        monsterNode.physicsBody?.contactTestBitMask = CollisionCategory.bullet.rawValue
     //   monsterNode.pivot = SCNMatrix4MakeRotation(Float(CGFloat(Double.pi/2)), 1, 0, 0)
        monsterNode.position = SCNVector3(posX, posY, -1)

     
        print("Placing Monster")

        sceneView.scene.rootNode.addChildNode(monsterNode)
        

    }
 
    // Placing Monster End -------------------------------------------------------------------------------------------/
 
    
    
    
    
    
    
    
    // Remove Node ----------------------------------------------------------------------------------------------------/
    
    func removeNode(_ node: SCNNode, explosion: Bool) {
        
                print("removing Node")
                node.removeFromParentNode()
    }
    
    // Remove Node End ------------------------------------------------------------------------------------------------/
    
    
    
    
    
    
    
    
    
    // Bullet Class Begins --------------------------------------------------------------------------------------------/
    
    class Bullet: SCNNode {
        override init () {
            super.init()
            let sphere = SCNSphere(radius: 0.025)
            self.geometry = sphere
            let shape = SCNPhysicsShape(geometry: sphere, options: nil)
            self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
            self.physicsBody?.isAffectedByGravity = false
            self.physicsBody?.categoryBitMask = CollisionCategory.bullet.rawValue
            self.physicsBody?.collisionBitMask = CollisionCategory.ship.rawValue
            
            
            
            // add texture
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "bullet_texture.jpg")
            self.geometry?.materials  = [material]
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // Bullet Class Ends ---------------------------------------------------------------------------------------------/
    
    
    
    
    
    
    
    
    
    // Collision Detection Function -----------------------------------------------------------------------------------/
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("did begin contact", contact.nodeA.physicsBody!.categoryBitMask, contact.nodeB.physicsBody!.categoryBitMask)
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.ship.rawValue || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.bullet.rawValue { // this conditional is not required--we've used the bit masks to ensure only one type of collision takes place--will be necessary as soon as more collisions are created/enabled
            
            print("Hit ship!")
            self.removeNode(contact.nodeB, explosion: false) // remove the bullet
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { // remove/replace ship after half a second to visualize collision
                self.soundEffect(ofType: .explosion)
                self.removeNode(contact.nodeA, explosion: false)
                self.placeMonster()
                self.scoreCounter += 1
                self.score.text = "\(self.scoreCounter)"
            })
            
        }
    }
    
    // Collision Ends Fudge YES!!!! ----------------------------------------------------------------------------------/
    
    
    
    
    
    
    
    // Tapping Screen Action Using gesture Begins --------------------------------------------------------------------/
    
    @IBAction func didTapScreen(_ sender: UITapGestureRecognizer) { // fire bullet in direction camera is facing
        
        print("getting tapped")
        
        let bulletsNode = Bullet()
        
        let (direction, position) = self.getUserVector()
        bulletsNode.position = position // SceneKit/AR coordinates are in meters
        
        let bulletDirection = direction
        bulletsNode.physicsBody?.applyForce(bulletDirection, asImpulse: true)
        sceneView.scene.rootNode.addChildNode(bulletsNode)
        self.soundEffect(ofType: .bullet)
        
        
    }
    
    // Tapping Screen Action Ends ------------------------------------------------------------------------------------/
    
    
    
    
    
    
    
    // User Score Functions ------------------------------------------------------------------------------------------/
   
    
    func userScore() {
        
        

        
    }
    
    // User Score Functions End --------------------------------------------------------------------------------------/
    
    
    

    
    
    
    // Collision Category Begin --------------------------------------------------------------------------------------/
    
    struct CollisionCategory: OptionSet {
        let rawValue: Int
        
        static let bullet  = CollisionCategory(rawValue: 1 << 0) // 00...01
        static let ship = CollisionCategory(rawValue: 1 << 1) // 00..10
    }
    
    
    // Collision Category Ends ----------------------------------------------------------------------------------------/
    
    
    enum sounds: String {
        case explosion = "explosion"
        case bullet = "bullet"
    }
    
    func soundEffect(ofType effect: sounds) {
        
        // Async to avoid substantial cost to graphics processing (may result in sound effect delay however)
        DispatchQueue.main.async {
            do
            {
                if let effectURL = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3") {
                    
                    self.audioPlayer = try AVAudioPlayer(contentsOf: effectURL)
                    self.audioPlayer.play()
                    
                }
            }
            catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    
    
    
}
