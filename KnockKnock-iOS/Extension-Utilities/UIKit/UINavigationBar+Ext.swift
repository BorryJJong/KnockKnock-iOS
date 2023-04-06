//
//  UINavigationBar.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/29.
//

import UIKit

extension UINavigationBar {
  func setDefaultAppearance(){
    let appearance = UINavigationBarAppearance().then {
      $0.configureWithTransparentBackground()
    }

    self.tintColor = .black
    self.standardAppearance = appearance
  }
}
