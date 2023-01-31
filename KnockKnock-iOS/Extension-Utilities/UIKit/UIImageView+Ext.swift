//
//  UIImage+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

extension UIImageView {

  enum ImageError: Error {
    case loadError
  }

  func setImageFromStringUrl(
    stringUrl: String?,
    defaultImage: UIImage,
    imageWidth: CGFloat? = nil
  ) {
    Task {
      do {
        let image = try await self.loadImage(stringUrl: stringUrl)

        await MainActor.run {
          self.image = image
        }

      } catch {

        let image = await defaultImage.resize(newWidth: imageWidth ?? self.frame.width)

        await MainActor.run {
          self.image = image
        }
      }
    }
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

  /// 이미지 로드
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

      let resizeImage = await image.resize(newWidth: imageWidth ?? self.frame.width)

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
