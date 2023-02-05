//
//  UIImage+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/07.
//

import UIKit

extension UIImage {
  
  /// 이미지 리사이징(정방형)
  func resizeSquareImage(newWidth: CGFloat) -> UIImage {
    let newHeight = newWidth

    let size = CGSize(width: newWidth, height: newHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { _ in
      self.draw(in: CGRect(origin: .zero, size: size))
    }

    return renderImage
  }

  /// 2개의 이미지가 동일 이미지인지 판별
  func isEqualToImage(image: UIImage?) -> Bool {
    guard let image = image else { return false }

    guard let data1 = self.pngData() as? NSData,
          let data2 = image.pngData() as? NSData else { return false }

    return data1.isEqual(data2)
  }
}
