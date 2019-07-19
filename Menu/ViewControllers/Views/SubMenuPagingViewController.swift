//
//  ToppingIngredientPagingViewController.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 16/06/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import Parchment

class SubMenuPagingViewController: PagingViewController<SubMenuItem> {
    override func loadView() {
        view = SubMenuPagingView(
            options: options,
            collectionView: collectionView,
            pageView: pageViewController.view
        )
    }
}
