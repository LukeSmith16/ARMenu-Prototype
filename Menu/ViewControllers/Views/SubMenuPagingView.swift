//
//  ToppingIngredientPagingView.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 16/06/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import Parchment

class SubMenuPagingView: PagingView {
    
    var menuHeightConstraint: NSLayoutConstraint?
    
    override func setupConstraints() {
        pageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        menuHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: options.menuHeight)
        menuHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            
            pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageView.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
}
