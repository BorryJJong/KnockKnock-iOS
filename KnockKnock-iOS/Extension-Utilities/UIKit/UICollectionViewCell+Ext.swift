//
//  UICollectionViewCell+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/12.
//

import UIKit

extension UICollectionReusableView {

  static var reusableIdentifier: String {
    return String(describing: Self.self)
  }
}
