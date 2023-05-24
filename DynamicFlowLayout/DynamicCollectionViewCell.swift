//
//  DynamicCollectionViewCell.swift
//  DynamicFlowLayout
//
//  Created by Jinwoo Kim on 5/25/23.
//

import UIKit

@MainActor
final class DynamicCollectionViewCell: UICollectionViewCell {
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes: UICollectionViewLayoutAttributes = layoutAttributes
        let size: CGSize = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .fittingSizeLevel)
        
        layoutAttributes.size = (size == .zero) ? layoutAttributes.size : size
        return layoutAttributes
    }
}
