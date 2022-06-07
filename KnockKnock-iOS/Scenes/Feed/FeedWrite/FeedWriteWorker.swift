//
//  FeedWriteWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import Foundation
import YPImagePicker

protocol FeedWriteWorkerProtocol: AnyObject {
  func callImagePicker(callback: @escaping (YPImagePicker) -> Void) -> [UIImage]
}

final class FeedWriteWorker: FeedWriteWorkerProtocol {
  func callImagePicker(callback: @escaping (YPImagePicker) -> Void) -> [UIImage] {
    var config = YPImagePickerConfiguration()
    config.library.maxNumberOfItems = 5
    config.library.mediaType = .photo

    let picker = YPImagePicker(configuration: config)
    var pickedPhotos: [UIImage] = []

    picker.didFinishPicking { [unowned picker] items, cancelled in
      if cancelled {
        picker.dismiss(animated: true, completion: nil)
        return
      }
      for item in items {
        switch item {
        case .photo(let photo):
          pickedPhotos.append(photo.image)
        default:
          return
        }
      }
        picker.dismiss(animated: true, completion: nil)
    }
    callback(picker)
    return pickedPhotos
  }
}
