//
//  FeedWriteViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/17.
//

import UIKit

import Then

import KKDSKit

protocol FeedWriteViewProtocol: AnyObject {
  var interactor: FeedWriteInteractorProtocol? { get set }

  func fetchTag(tag: String)
  func fetchPromotion(promotion: String)
  func fetchAddress(address: AddressResult.Documents)

  func showAlertView(isDone: Bool)
}

final class FeedWriteViewController: BaseViewController<FeedWriteView> {

  // MARK: - Enum

  enum WriteStatus {
    case allFilled
    case hasBlank
  }

  // MARK: - Properties
  
  var interactor: FeedWriteInteractorProtocol?

  var pickedPhotos: [UIImage] = []
  var contentTextViewFilled = false
  var writeStatus: WriteStatus = .hasBlank

  // MARK: - UIs

  private lazy var dismissBarButtonItem = UIBarButtonItem(
    image: KKDS.Image.ic_close_24_bk,
    style: .plain,
    target: self,
    action: #selector(self.dismissBarButtonDidTap(_:))
  ).then {
    $0.tintColor = .black
  }

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.hideKeyboardWhenTappedAround()

    self.navigationItem.do {
      $0.title = "새 게시글"
      $0.leftBarButtonItem = self.dismissBarButtonItem
    }
    self.navigationController?.navigationBar.setDefaultAppearance()

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
      action: #selector(self.tagSelectButtonDidTap(_:)),
      for: .touchUpInside
    )

    self.containerView.promotionSelectButton.addTarget(
      self,
      action: #selector(self.promotionSelectButtonDidTap(_:)),
      for: .touchUpInside
    )

    self.containerView.shopSearchButton.addTarget(
      self,
      action: #selector(self.shopSearchButtonDidTap(_:)),
      for: .touchUpInside
    )

    self.containerView.photoAddButton.addTarget(
      self,
      action: #selector(self.photoAddButtonDidTap(_:)),
      for: .touchUpInside
    )

    self.containerView.doneButton.addTarget(
      self,
      action: #selector(self.doneButtonDidTap(_:)),
      for: .touchUpInside
    )

    self.containerView.alertView.cancelButton.addTarget(
      self,
      action: #selector(self.alertCancelButtonDidTap(_:)),
      for: .touchUpInside
    )

    self.containerView.alertView.confirmButton.addTarget(
      self,
      action: #selector(self.alertConfirmButtonDidTap(_:)),
      for: .touchUpInside
    )
  }

  // MARK: - Button Actions

  @objc func tagSelectButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToProperty(
      source: self,
      propertyType: .tag
    )
  }

  @objc func promotionSelectButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToProperty(
      source: self,
      propertyType: .promotion
    )
  }

  @objc func dismissBarButtonDidTap(_ sender: UIBarButtonItem) {
    self.interactor?.dismissFeedWriteView(source: self)
  }

  @objc func shopSearchButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToShopSearch(source: self)
  }

  @objc func photoAddButtonDidTap(_ sender: UIButton) {
    self.callImagePicker()
  }

  @objc func photoDeleteButtonDidTap(_ sender: UIButton) {
    self.pickedPhotos.remove(at: sender.tag)
    self.containerView.bindPhotoCount(count: self.pickedPhotos.count)
    self.containerView.photoCollectionView.reloadData()
  }

  @objc func doneButtonDidTap(_ sender: UIButton) {
    let photoAndContentFilled = self.pickedPhotos.count != 0 && self.contentTextViewFilled

    self.interactor?.checkEssentialField(photoAndContentFilled: photoAndContentFilled)
  }

  @objc private func alertCancelButtonDidTap(_ sender: UIButton) {
    self.containerView.alertView.isHidden = true
  }

  @objc private func alertConfirmButtonDidTap(_ sender: UIButton) {
    self.containerView.alertView.isHidden = true

    if self.writeStatus == .allFilled {
      self.interactor?.requestUploadFeed(
        source: self,
        userId: 19, // api 수정 필요(헤더에 토큰 첨부하는 방식으로 변경 될듯?)
        content: self.containerView.contentTextView.text,
        images: self.pickedPhotos
      )
    }
  }

  // MARK: - ImagePicker

  func callImagePicker() {
    self.pickedPhotos = []

    let picker = ImagePickerManager.shared.setImagePicker()

    picker.didFinishPicking { [unowned picker] items, _ in
      for item in items {
        switch item {
        case let .photo(photo):
          self.pickedPhotos.append(photo.image)
          self.containerView.photoCollectionView.reloadData()
        default:
          print("error")
        }
      }
      self.containerView.bindPhotoCount(count: self.pickedPhotos.count)
      picker.dismiss(animated: true, completion: nil)
    }
    self.present(picker, animated: true, completion: nil)
  }
}

// MARK: - Feed Write View Protocol

extension FeedWriteViewController: FeedWriteViewProtocol {

  func fetchTag(tag: String) {
    self.containerView.setTag(tag: tag)
  }

  func fetchPromotion(promotion: String) {
    self.containerView.setPromotion(promotion: promotion)
  }

  func fetchAddress(address: AddressResult.Documents) {
    self.containerView.setAddress(
      name: address.placeName,
      address: address.addressName
    )
  }

  func showAlertView(isDone: Bool) {
    self.containerView.showAlertView(isDone: isDone)
    self.writeStatus = isDone ? .allFilled : .hasBlank
  }
}

// MARK: - TextView Delegate

extension FeedWriteViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .gray40 {
      textView.text = nil
      textView.textColor = .black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "내용을 입력해주세요. (글자수 1,000자 이내)"
      textView.textColor = .gray40
      self.contentTextViewFilled = false
    } else {
      self.contentTextViewFilled = true
    }
  }
}

// MARK: - CollectionView DataSource

extension FeedWriteViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.pickedPhotos.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let photo = self.pickedPhotos[indexPath.row]

    let cell = collectionView.dequeueCell(
      withType: PhotoCell.self,
      for: indexPath
    )

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

// MARK: - CollectionView Delegate

extension FeedWriteViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: self.containerView.photoAddButton.frame.width + 10,
      height: self.containerView.photoAddButton.frame.height + 10
    )
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
