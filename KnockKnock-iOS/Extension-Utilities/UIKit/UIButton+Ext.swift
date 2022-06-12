//
//  UIButton+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/22.
//

import UIKit

extension UIButton {
  
  func alignTextBelow(spacing: CGFloat) {
    guard let image = self.imageView?.image,
          let titleLabel = self.titleLabel,
          let titleText = titleLabel.text else { return }

    let titleSize = titleText.size(withAttributes: [
      NSAttributedString.Key.font: titleLabel.font as Any
    ])
    titleEdgeInsets = UIEdgeInsets(
      top: spacing,
      left: -image.size.width,
      bottom: -image.size.height,
      right: 0)
    imageEdgeInsets = UIEdgeInsets(
      top: -(titleSize.height + spacing),
      left: 0,
      bottom: 0,
      right: -titleSize.width)
  }
}

