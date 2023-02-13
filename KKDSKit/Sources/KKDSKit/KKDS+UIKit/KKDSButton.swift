//
//  File.swift
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

extension UIButton {
  func setBackgroundColor(
    _ color: UIColor,
    for state: UIControl.State
  ) {

    UIGraphicsBeginImageContext(
      CGSize(
        width: 1.0,
        height: 1.0
      )
    )

    guard let context = UIGraphicsGetCurrentContext() else { return }

    context.setFillColor(color.cgColor)
    context.fill(
      CGRect(
        x: 0.0,
        y: 0.0,
        width: 1.0,
        height: 1.0
      )
    )

    let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    self.setBackgroundImage(
      backgroundImage,
      for: state
    )
  }
}
