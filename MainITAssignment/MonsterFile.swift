//
//  Monster.swift
//  MainITAssignment
//
//  Created by zezenzo on 15/10/17.
//  Copyright © 2017 null. All rights reserved.
//

import Foundation
import SceneKit

class Candle: VirtualObject {
    
    override init() {
        super.init(modelName: "Monster", fileExtension: "scn", thumbImageFilename: "Monster", title: "Monster")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
