//
//  String+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/31.
//

import UIKit

extension String {

  /// Url(String)을 이미지 데이터로 변환하여 리턴
  ///
  /// - Parameters:
  ///  - defaultImage: 이미지 변환에 실패한 경우 나타날 디폴트 이미지
  ///  - imageWidth: 이미지 뷰 길이
  func getImageFromStringUrl(
    defaultImage: UIImage,
    imageWidth: CGFloat
  ) async -> UIImage {

    guard let data = await self.getDataFromStringUrl() else { return defaultImage }

    let image = UIImage(data: data)

    return image?.resizeSquareImage(newWidth: imageWidth) ?? defaultImage

  }

  func getDataFromStringUrl() async -> Data? {
    guard let url = URL(string: self) else { return nil }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      return data

    } catch {

      return nil
    }
  }
}
