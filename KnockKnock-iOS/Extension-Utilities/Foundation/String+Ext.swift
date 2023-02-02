//
//  String+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/31.
//

import UIKit

extension String {
  func stringUrlToImage(defaultImage: UIImage) -> UIImage {
    guard let url = URL(string: self) else {
      return defaultImage
    }

    do {
      let data = try Data(contentsOf: url)
      
      return UIImage(data: data) ?? defaultImage

    } catch {

      return defaultImage
    }
  }
}
