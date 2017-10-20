//
//  VirtualObject.swift
//  MainITAssignment
//
//  Created by zezenzo on 15/10/17.
//  Copyright © 2017 null. All rights reserved.
//


import Foundation
import SceneKit
import ARKit

class VirtualObject  : SCNNode {
    
    var modelName: String = ""
    var fileExtension: String = ""
    var thumbImage: UIImage!
    var title: String = ""
    var modelLoaded: Bool = false
    
    var viewController: ViewController?
    
    override init() {
        super.init()
        self.name = "Virtual object root node"
    }
    
    init(modelName: String, fileExtension: String, thumbImageFilename: String, title: String) {
        super.init()
        self.name = "Virtual object root node"
        self.modelName = modelName
        self.fileExtension = fileExtension
        self.thumbImage = UIImage(named: thumbImageFilename)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadModel() {
        guard let virtualObjectScene = SCNScene(named: "\(modelName).\(fileExtension)", inDirectory: "Models.scnassets/\(modelName)") else {
            return
        }
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            child.movabilityHint = .movable
            wrapperNode.addChildNode(child)
        }
        self.addChildNode(wrapperNode)
        
        modelLoaded = true
    }
    
    func unloadModel() {
        for child in self.childNodes {
            child.removeFromParentNode()
        }
        
        modelLoaded = false
    }

}

class monster: VirtualObject {
    
    override init() {
        super.init(modelName: "Monster", fileExtension: "scn", thumbImageFilename: "Monster", title: "Monster")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VirtualObject {
    
    static func isNodePartOfVirtualObject(_ node: SCNNode) -> Bool {
        if node.name == "Virtual object root node" {
            return true
        }
        
        if node.parent != nil {
            return isNodePartOfVirtualObject(node.parent!)
        }
        
        return false
    }
    
    static let availableObjects: [VirtualObject] = [
        monster()
    ]
}

// MARK: - Protocols for Virtual Objects

protocol ReactsToScale {
    func reactToScale()
}

extension SCNNode {
    
    func reactsToScale() -> ReactsToScale? {
        if let canReact = self as? ReactsToScale {
            return canReact
        }
        
        if parent != nil {
            return parent!.reactsToScale()
        }
        
        return nil
    }
}

