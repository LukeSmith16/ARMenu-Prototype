//
//  ToppingIngredientMenuItem.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 16/06/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import Parchment

struct SubMenuItem: PagingItem, Hashable, Comparable {
    let index: Int
    let title: String
    let headerImage: UIImage
    let foods: [Food]
    
    var hashValue: Int {
        return index.hashValue &+ title.hashValue
    }
    
    static func ==(lhs: SubMenuItem, rhs: SubMenuItem) -> Bool {
        return lhs.index == rhs.index && lhs.title == rhs.title
    }
    
    static func <(lhs: SubMenuItem, rhs: SubMenuItem) -> Bool {
        return lhs.index < rhs.index
    }
}
