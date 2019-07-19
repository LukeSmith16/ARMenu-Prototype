//
//  SCNFoodModel.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 07/07/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import ARKit

struct SCNFoodModel {
    private enum FoodName: String {
        case Pie = "pie" 
    }
    
    private static let foodScene = SCNScene(named: "art.scnassets/food.scn")!
    
    static let pie: SCNNode = foodScene.rootNode.childNode(withName: FoodName.Pie.rawValue, recursively: false)!
}
