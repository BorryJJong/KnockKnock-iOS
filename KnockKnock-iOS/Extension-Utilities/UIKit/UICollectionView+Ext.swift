//
//  UICollectionView+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/12.
//

import UIKit

extension UICollectionView {

  func registCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
    let cellID = identifier ?? type.reusableIdentifier
    register(type, forCellWithReuseIdentifier: cellID)
  }

  func registFooterView(type: UICollectionReusableView.Type, identifier: String? = nil) {
    let cellID = identifier ?? type.reusableIdentifier
    register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: cellID)
  }

  func dequeueCell<Cell: UICollectionViewCell>(withType type: Cell.Type, for indexPath: IndexPath) -> Cell {
    return dequeueReusableCell(withReuseIdentifier: type.reusableIdentifier, for: indexPath) as! Cell
  }

  func dequeueReusableSupplementaryFooterView(for indexPath: IndexPath) -> UICollectionReusableView {
    return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.reusableIdentifier, for: indexPath) as! FooterCollectionReusableView
  }
}
