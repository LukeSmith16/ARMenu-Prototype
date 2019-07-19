//
//  ToppingsIngredientViewController.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 15/06/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import Parchment

protocol ImagesViewControllerDelegate: class {
    func imagesViewControllerDidScroll(_: SubMenuViewController)
    func foodWasSelected(_ food: Food)
}

class SubMenuViewController: UIViewController {
    
    weak var delegate: ImagesViewControllerDelegate?
    
    fileprivate let foods: [Food]
    
    fileprivate lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        layout.minimumLineSpacing = 15
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(foods: [Food], options: PagingOptions) {
        self.foods = foods
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(collectionView)
        view.constrainToEdges(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SubMenuImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SubMenuImageCollectionViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionViewLayout.invalidateLayout()
    }
}

extension SubMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width - 36,
            height: 220)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.imagesViewControllerDidScroll(self)
    }
}

extension SubMenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubMenuImageCollectionViewCell", for: indexPath) as! SubMenuImageCollectionViewCell
        let food = foods[indexPath.item]
        
        cell.showFoodInARDelegate = self
        cell.setupCell(withFood: food)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
}

extension SubMenuViewController: ShowFoodInARTappedDelegate {
    func showFoodInARWasTapped(_ food: Food) {
        delegate?.foodWasSelected(food)
    }
}
