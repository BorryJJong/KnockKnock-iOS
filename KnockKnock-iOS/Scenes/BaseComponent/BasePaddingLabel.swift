//
//  UILabel+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/19.
//

import UIKit

class BasePaddingLabel: UILabel {
  private let padding: UIEdgeInsets

  init(padding: UIEdgeInsets) {
    self.padding = padding
    super.init(frame: .zero)
  }
   
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
