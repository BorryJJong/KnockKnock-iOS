//
//  UIImage+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/06.
//

import UIKit

extension UIImageView {

  private enum ImageError: Error {
    case loadError
  }

  func setImageFromStringUrl(
    url: String,
    defaultImage: UIImage
  ) {

    Task {
      do {
        let cacheKey = NSString(string: url)

        guard let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) else { return }

        await MainActor.run {
          self.image = cachedImage
        }
      }
    }

    Task {
      do {
        guard let url = URL(string: url) else { return }

        let photo = try await self.fetchPhoto(url: url).resize(newWidth: self.frame.width)

        await MainActor.run {
          self.image = photo
        }
      } catch {
        await MainActor.run {
          self.image = defaultImage.resize(newWidth: self.frame.width)
        }
      }
    }
  }

  func fetchPhoto(url: URL) async throws -> UIImage {
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
      throw ImageError.loadError
    }

    guard let image = UIImage(data: data) else {
      throw ImageError.loadError
    }

    return image
  }

}
