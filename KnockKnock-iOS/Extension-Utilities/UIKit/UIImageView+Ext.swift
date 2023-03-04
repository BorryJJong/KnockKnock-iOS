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
  ///  - defaultImage: 이미지 변환에 실패한 경우 나타날 디폴트 이미지
  ///  - imageWidth: 이미지 뷰 길이
  func setImageFromStringUrl(
    stringUrl: String?,
    defaultImage: UIImage,
    imageWidth: CGFloat? = nil
  ) {
    guard let url = stringUrl else { return }
    self.kf.setImage(with: URL(string: url))
//    Task {
//      do {
//
//        let image = try await self.loadImage(stringUrl: stringUrl)
//
//        await MainActor.run {
//          self.image = image
//        }
//
//      } catch {
//
//        let image = defaultImage.resizeSquareImage(newWidth: imageWidth ?? self.frame.width)
//
//        await MainActor.run {
//          self.image = image
//        }
//      }
//    }
  }
  
  /// String -> URL로 변환
  private func convertStringToUrl(stringUrl: String?) async throws -> URL {
    
    guard let stringUrl = stringUrl,
          let url = URL(string: stringUrl) else {
      throw ImageError.loadError
    }
    
    return url
  }
  
  /// URL -> Data로 변환
  private func fetchData(url: URL) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
      throw ImageError.loadError
    }
    
    return data
  }
  
  /// 이미지 로드 및 이미지 리사이징
  private func loadImage(
    stringUrl: String?,
    imageWidth: CGFloat? = nil
  ) async throws -> UIImage {
    
    guard let chacedImage = await self.setCachedImage(stringUrl: stringUrl) else {
      
      let url = try await self.convertStringToUrl(stringUrl: stringUrl)
      let data = try await self.fetchData(url: url)
      
      guard let image = UIImage(data: data) else {
        throw ImageError.loadError
      }
      
      let resizeImage = image.resizeSquareImage(newWidth: imageWidth ?? self.frame.width)
      
      return resizeImage
    }
    
    return chacedImage
  }
  
  /// 캐시 이미지 처리
  private func setCachedImage(stringUrl: String?) async -> UIImage? {
    
    guard let stringUrl = stringUrl else { return nil }
    
    let cacheKey = NSString(string: stringUrl)
    let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey)
    
    return cachedImage
  }
}
