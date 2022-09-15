//
//  UIImage+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

extension UIImageView {
  func setImageFromStringUrl(
    url: String,
    defaultImage: UIImage
  ) {
    let cacheKey = NSString(string: url)

    if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
      self.image = cachedImage
      return
    }

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
