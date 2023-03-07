//
//  KKDSButton.swift
//  
//
//  Created by Daye on 2022/10/05.
//

import UIKit

public class KKDSButton: UIButton {

  public init() {
    super.init(frame: .zero)
    self.setupConfigure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupConfigure() {
    self.adjustsImageWhenHighlighted = false
    self.adjustsImageWhenDisabled = false
  }
}
