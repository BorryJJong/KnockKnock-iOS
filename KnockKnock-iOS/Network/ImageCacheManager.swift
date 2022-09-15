//
//  ImageCacheManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/15.
//

import UIKit

final class ImageCacheManager {

  static let shared = NSCache<NSString, UIImage>()

  private init() {
    
  }
}
