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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var menu: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var score: UILabel!
    @IBOutlet var time: UILabel!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var crosshair: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create an Empty Scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        self.addNewShip()
        
    }
    
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

    
    // Getting Users Position
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    func floatBetween(_ first: Float,  and second: Float) -> Float { // random float between upper and lower bound (inclusive)
        return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
    }
    
    
    // Placing the Monster
    
    func placeMonster() {
        
        
    //    let monsterNode = SCNNode()
        
        guard let virtualObjectScene = SCNScene(named: "Monster.scn", inDirectory: "art.scnassets" ) else {
            return
        }
        
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.diffuse.contents = UIColor.black
            wrapperNode.addChildNode(child)
        }
        
        let posX = floatBetween(-0.5, and: 0.5)
        let posY = floatBetween(-0.5, and: 0.5 )
        wrapperNode.pivot = SCNMatrix4MakeRotation(Float(CGFloat(Double.pi/2)), 1, 0, 0)

        wrapperNode.position = SCNVector3(posX, posY, -1)
     
        print("Placing Monster")

        sceneView.scene.rootNode.addChildNode(wrapperNode)
        
        
    }

    
    func removeNode(){
        
        
        
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        //print("did begin contact", contact.nodeA.physicsBody!.categoryBitMask, contact.nodeB.physicsBody!.categoryBitMask)
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.ship.rawValue || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.ship.rawValue { // this conditional is not required--we've used the bit masks to ensure only one type of collision takes place--will be necessary as soon as more collisions are created/enabled
            
            print("Hit ship!")
            self.removeNode(contact.nodeB, explosion: false) // remove the bullet
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { // remove/replace ship after half a second to visualize collision
                self.removeNode(contact.nodeA, explosion: true)
                self.addNewShip()
            })
            
        }
    }
    
    @IBAction func didTapScreen(_ sender: UITapGestureRecognizer) { // fire bullet in direction camera is facing
        
        print("getting tapped")
        
        let bulletsNode = Bullet()
        
        let (direction, position) = self.getUserVector()
        bulletsNode.position = position // SceneKit/AR coordinates are in meters
        
        let bulletDirection = direction
        bulletsNode.physicsBody?.applyForce(bulletDirection, asImpulse: true)
        sceneView.scene.rootNode.addChildNode(bulletsNode)
        
        
        placeMonster()
        
        
    }
    
    
    
    
    
    
    func userScore() {
        
        
        
    }
    
    
    func addNewShip() {
        
        
        
        
    }
    
    
    
    
    struct CollisionCategory: OptionSet {
        let rawValue: Int
        
        static let 2  = CollisionCategory(rawValue: 1 << 0) // 00...01
        static let ship = CollisionCategory(rawValue: 1 << 1) // 00..10
    }
    
    
    
    
    
    
    
    
    
}
