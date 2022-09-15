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
  func setImageFromStringUrl(
    url: String,
    defaultImage: UIImage
  ) {
    DispatchQueue.global(qos: .background).async {
      if let url = URL(string: url) {
        URLSession.shared.dataTask(with: url) { (data, _, err) in
          if err != nil {
            DispatchQueue.main.async {
              self.image = defaultImage
            }
            return
          }
          DispatchQueue.main.async {
            if let data = data, let image = UIImage(data: data) {
              self.image = image
            }
          }
        }.resume()
      }
    }
  }
}
