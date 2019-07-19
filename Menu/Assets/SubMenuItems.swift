//
//  SubMenuItems.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 07/07/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

let subMenuItems = [
    SubMenuItem(
        index: 0,
        title: "Starters",
        headerImage: UIImage(named: "starters")!,
        foods: [
            Food(image: UIImage(named: "starter1")!,
                 title: "TestStarter",
                 description: "TestDescription"),
            Food(image: UIImage(named: "starter2")!,
                 title: "TestStarter",
                 description: "TestDescription")
        ]),
    SubMenuItem(
        index: 1,
        title: "Mains",
        headerImage: UIImage(named: "mains")!,
        foods: [
            Food(image: UIImage(named: "mains1")!,
                 title: "TestMains",
                 description: "Bleh")
        ]),
    SubMenuItem(
        index: 2,
        title: "Desserts",
        headerImage: UIImage(named: "deserts")!,
        foods: [
            Food(image: UIImage(named: "pie")!,
                 title: "Salted Caramel Apple Pie",
                 description: "A delicious salted caramel apple pie!")
        ]),
    SubMenuItem(
        index: 3,
        title: "Drinks",
        headerImage: UIImage(named: "drinks")!,
        foods: [
            Food(image: UIImage(named: "deserts")!,
                 title: "Sandwich",
                 description: "Bleh")
        ])
]
