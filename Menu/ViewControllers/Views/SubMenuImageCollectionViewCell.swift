//
//  ToppingIngredientImageCollectionViewCell.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 16/06/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol ShowFoodInARTappedDelegate: class {
    func showFoodInARWasTapped(_ food: Food)
}

class SubMenuImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var showFoodInARDelegate: ShowFoodInARTappedDelegate?
    
    private var food: Food?
    private var isShowingInfo: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionViewTopConstraint.constant = imageView.frame.height
        descriptionView.alpha = 0.0
    }
    
    func setupCell(withFood food: Food) {
        self.food = food
        imageView.image = food.image
        descriptionLabel.text = food.description
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        isShowingInfo = !isShowingInfo
        descriptionViewTopConstraint.constant = isShowingInfo ? imageView.frame.height : 0
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: [.curveEaseInOut], animations: {
            self.descriptionView.alpha = self.isShowingInfo ? 0.0 : 0.8
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func arTapped(_ sender: Any) {
        guard let food = food else { return }
        showFoodInARDelegate?.showFoodInARWasTapped(food)
    }
}
