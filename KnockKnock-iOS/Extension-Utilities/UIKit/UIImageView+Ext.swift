//
//  UIImage+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

import Kingfisher

extension UIImageView {

  /// Url(String)을 이미지로 변환하여 UIImageView.image 설정(정방형 비율 리사이징 포함)
  ///
  /// - Parameters:
  ///  - stringUrl: 이미지 url(String type)
  ///  - defaultImage: 이미지 or URL 변환에 실패한 경우 나타날 디폴트 이미지
  func setImageFromStringUrl(
    stringUrl: String?,
    defaultImage: UIImage
  ) {
    guard let stringUrl = stringUrl else { return }

    ImageCache.default.retrieveImage(
      forKey: stringUrl,
      options: nil
    ) { result in
      
      switch result {
      case .success(let value):
        
        guard let image = value.image else {
          
          // 캐시 이미지 없는 경우
          guard let url = URL(string: stringUrl) else {
            // String -> URL 변환 실패시 기본 이미지 세팅
            self.image = defaultImage
            return
          }
          
          self.kf.setImage(
            with: ImageResource(
              downloadURL: url,
              cacheKey: stringUrl
            )
          ) { result in
            
            switch result {
              
            case .failure:
              self.image = defaultImage
              
            case .success:
              return
            }
          }
          return
        }
        
        // 캐시 이미지가 있는 경우
        self.image = image
        
      case .failure(let error):
        print(error)
      }
    }
  }
}
