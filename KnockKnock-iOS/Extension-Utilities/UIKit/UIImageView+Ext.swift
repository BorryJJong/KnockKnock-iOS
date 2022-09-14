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
    Task{
      do {
        self.image = try await self.fetchImage(
          url: url,
          defaultImage: defaultImage
        )
      }
      catch NetworkErrorType.invalidURLString {
        print("Network error - invalidURLString")
      } catch NetworkErrorType.invalidServerResponse {
        print("Network error - invalidServerResponse")
      }
    }
  }

  func fetchImage(url: String, defaultImage: UIImage) async throws -> UIImage {
    guard let url = URL(string: url) else {
      throw NetworkErrorType.invalidURLString
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
      print(response)
      throw NetworkErrorType.invalidServerResponse

    }

    let image = UIImage(data: data)

    return image ?? defaultImage
  }
}
