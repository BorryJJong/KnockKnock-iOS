//
//  FeedWriteViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/17.
//

import UIKit

import Then
import YPImagePicker

protocol FeedWriteViewProtocol: AnyObject {
  var interactor: FeedWriteInteractorProtocol? { get set }
}

final class FeedWriteViewController: BaseViewController<FeedWriteView> {

  // MARK: - Properties

  var interactor: FeedWriteInteractorProtocol?
  var pickedPhotos: [UIImage] = []

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupConfigure() {
    self.navigationItem.title = "μ κ²μκΈ"
    self.containerView.photoCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: PhotoCell.self)
    }
    self.containerView.contentTextView.do {
      $0.delegate = self
    }
    self.containerView.tagSelectButton.addTarget(
      self,
      action: #selector(tagSelectButtonDidTap(_:)),
      for: .touchUpInside)
    self.containerView.promotionSelectButton.addTarget(
      self,
      action: #selector(promotionSelectButtonDidTap(_:)),
      for: .touchUpInside)
    self.containerView.shopSearchButton.addTarget(
      self,
      action: #selector(shopSearchButtonDidTap(_:)),
      for: .touchUpInside)
    self.containerView.photoAddButton.addTarget(
      self,
      action: #selector(photoAddButtonDidTap(_:)),
      for: .touchUpInside)
  }

  @objc func tagSelectButtonDidTap(_ sender: UIButton) {
    self.navigationController?.pushViewController(PropertySelectViewController(), animated: true)
  }

  @objc func promotionSelectButtonDidTap(_ sender: UIButton) {
    self.navigationController?.pushViewController(PropertySelectViewController(), animated: true)
  }

  @objc func shopSearchButtonDidTap(_ sender: UIButton) {
    self.navigationController?.pushViewController(ShopSearchViewController(), animated: true)
  }

  @objc func photoAddButtonDidTap(_ sender: UIButton) {
    self.callImagePicker()
  }

  @objc func photoDeleteButtonDidTap(_ sender: UIButton) {
    self.pickedPhotos.remove(at: sender.tag)
    self.containerView.photoCollectionView.reloadData()
  }

  func callImagePicker() {
    let config = YPImagePickerConfiguration().with {
      $0.library.maxNumberOfItems = 5
      $0.library.mediaType = .photo
      $0.startOnScreen = .library
      $0.showsPhotoFilters = false
      $0.showsCrop = .rectangle(ratio: 1)
    }
    let picker = YPImagePicker(configuration: config)

    self.pickedPhotos = []

    picker.didFinishPicking { [unowned picker] items, cancelled in
      if cancelled {
        picker.dismiss(animated: true, completion: nil)
        return
      }
      for item in items {
        switch item {
        case let .photo(photo):
          self.pickedPhotos.append(photo.image)
          self.containerView.photoCollectionView.reloadData()
        default:
          return
        }
      }
      picker.dismiss(animated: true, completion: nil)
    }
    self.present(picker, animated: true, completion: nil)
  }
}

extension FeedWriteViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .gray40 {
      textView.text = nil
      textView.textColor = .black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "λ΄μ©μ μλ ₯ν΄μ£ΌμΈμ. (κΈμμ 1,000μ μ΄λ΄)"
      textView.textColor = .gray40
    }
  }
}

extension FeedWriteViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return pickedPhotos.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let photo = self.pickedPhotos[indexPath.row]

    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PhotoCell.reusableIdentifier,
      for: indexPath) as! PhotoCell

    cell.backgroundColor = .white
    cell.deleteButton.tag = indexPath.row
    cell.deleteButton.addTarget(
      self,
      action: #selector(photoDeleteButtonDidTap(_:)),
      for: .touchUpInside)
    cell.bind(data: photo)

    return cell
  }
}

extension FeedWriteViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: self.containerView.photoAddButton.frame.width + 10,
                  height: self.containerView.photoAddButton.frame.height + 10)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 10
  }
}

extension FeedWriteViewController: UICollectionViewDelegate {
}

extension FeedWriteViewController: FeedWriteViewProtocol {
}

extension YPImagePickerConfiguration: Then {
}
