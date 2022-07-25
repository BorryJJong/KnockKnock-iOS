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

  func registHeaderView(type: UICollectionReusableView.Type, identifier: String? = nil) {
    let cellID = identifier ?? type.reusableIdentifier
    register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellID)
  }

  func registFooterView(type: UICollectionReusableView.Type, identifier: String? = nil) {
    let cellID = identifier ?? type.reusableIdentifier
    register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: cellID)
  }

  func dequeueCell<Cell: UICollectionViewCell>(withType type: Cell.Type, for indexPath: IndexPath) -> Cell {
    return dequeueReusableCell(withReuseIdentifier: type.reusableIdentifier, for: indexPath) as! Cell
  }

  func dequeueReusableSupplementaryFooterView<Footer: UICollectionReusableView>(withType type: Footer.Type, for indexPath: IndexPath) -> Footer {
    return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: type.reusableIdentifier, for: indexPath) as! Footer
  }

  func dequeueReusableSupplementaryHeaderView<Header: UICollectionReusableView>(withType type: Header.Type, for indexPath: IndexPath) -> Header {
    return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.reusableIdentifier, for: indexPath) as! Header
  }
}
