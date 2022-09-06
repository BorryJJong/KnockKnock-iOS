//
//  UIImage+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

import Then
import KKDSKit

extension UIImageView {
  func setImageFromStringUrl(url: String, defaultImage: UIImage?) {
    if let defaultImage = defaultImage {
      self.image = URL(string: url)
        .flatMap { try? Data(contentsOf: $0) }
        .flatMap { UIImage(data: $0) }
      ?? defaultImage
    }
  }
}
