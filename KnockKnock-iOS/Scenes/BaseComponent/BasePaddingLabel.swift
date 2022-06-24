//
//  UILabel+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/19.
//

import UIKit

class BasePaddingLabel: UILabel {
  private var padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

  convenience init(padding: UIEdgeInsets) {
    self.init()
    self.padding = padding
  }

  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: padding))
  }

  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.height += padding.top + padding.bottom
    contentSize.width += padding.left + padding.right
    
    return contentSize
  }
}
