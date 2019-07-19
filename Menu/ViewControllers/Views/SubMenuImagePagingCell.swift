//
//  ToppingIngredientImagePagingCell.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 16/06/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import Parchment

class SubMenuImagePagingCell: PagingCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(white: 0, alpha: 0.6)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var paragraphStyle: NSParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1
        paragraphStyle.alignment = .center
        return paragraphStyle
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.constrainToEdges(imageView)
        contentView.constrainToEdges(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        let item = pagingItem as! SubMenuItem
        imageView.image = item.headerImage
        titleLabel.attributedText = NSAttributedString(
            string: item.title,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        if selected {
            imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        } else {
            imageView.transform = CGAffineTransform.identity
        }
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? PagingCellLayoutAttributes {
            let imageScale = 1 + attributes.progress
            imageView.transform = CGAffineTransform(scaleX: imageScale, y: imageScale)
        }
    }
}
