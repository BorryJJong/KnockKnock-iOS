//
//  KKDSBannerButton.swift
//  
//
//  Created by Daye on 2023/03/15.
//

import UIKit

public final class KKDSBannerButton: KKDSButton {

  override func setupConfigure() {
    self.backgroundColor = .clear
    
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
  }
}
