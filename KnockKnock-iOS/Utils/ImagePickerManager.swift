//
//  ImagePicker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/19.
//

import UIKit

import YPImagePicker
import Then
import KKDSKit

final class ImagePickerManager {

  static let shared = ImagePickerManager()

  private init() {}

  func setImagePicker() -> YPImagePicker {
    let config = YPImagePickerConfiguration().with {
      $0.library.maxNumberOfItems = 5
      $0.library.mediaType = .photo
      $0.library.isSquareByDefault = true

      $0.onlySquareImagesFromCamera = true
      $0.startOnScreen = .library
      $0.showsPhotoFilters = false
      $0.showsCrop = .rectangle(ratio: 1)
      $0.shouldSaveNewPicturesToAlbum = false
      $0.colors.tintColor = KKDS.Color.green50
      $0.wordings.libraryTitle = "갤러리"
      $0.wordings.cameraTitle = "카메라"
      $0.wordings.cancel = "취소"
      $0.wordings.next = "완료"
      $0.wordings.save = "완료"
      $0.wordings.warningMaxItemsLimit = "최대 5장까지 선택 가능합니다."
    }
    
    return YPImagePicker(configuration: config)
  }

}

extension YPImagePickerConfiguration: Then {
}
