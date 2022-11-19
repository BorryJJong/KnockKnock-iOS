//
//  FeedWriteViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/17.
//

import UIKit

import Then
//import YPImagePicker
import KKDSKit

protocol FeedWriteViewProtocol: AnyObject {
  var interactor: FeedWriteInteractorProtocol? { get set }
  var router: FeedWriteRouterProtocol? { get set }

  func fetchProperty(propertyType: PropertyType, content: String)

  func fetchSelectedPromotions(promotionList: [Promotion])
  func fetchSelectedTags(tagList: [ChallengeTitle])
}

final class FeedWriteViewController: BaseViewController<FeedWriteView> {

  // MARK: - Properties
  
  var interactor: FeedWriteInteractorProtocol?
  var router: FeedWriteRouterProtocol?

  private var selectedPromotion: [Promotion] = []
  private var selectedTag: [ChallengeTitle] = []

  var pickedPhotos: [UIImage] = []

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.hideKeyboardWhenTappedAround()
    self.navigationItem.title = "새 게시글"
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

  // MARK: - Button Actions

  @objc func tagSelectButtonDidTap(_ sender: UIButton) {
    self.router?.navigateToProperty(
      source: self,
      propertyType: .tag,
      promotionList: nil,
      tagList: self.selectedTag
    )
  }

  @objc func promotionSelectButtonDidTap(_ sender: UIButton) {
    self.router?.navigateToProperty(
      source: self,
      propertyType: .promotion,
      promotionList: self.selectedPromotion,
      tagList: nil
    )
  }

  @objc func shopSearchButtonDidTap(_ sender: UIButton) {
    self.router?.navigateToShopSearch(source: self)
  }

  @objc func photoAddButtonDidTap(_ sender: UIButton) {
    self.callImagePicker()
  }

  @objc func photoDeleteButtonDidTap(_ sender: UIButton) {
    self.pickedPhotos.remove(at: sender.tag)
    self.containerView.photoCollectionView.reloadData()
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
      picker.dismiss(animated: true, completion: nil)
    }
    self.present(picker, animated: true, completion: nil)
  }
}

// MARK: - Feed Write View Protocol

extension FeedWriteViewController: FeedWriteViewProtocol {
  func fetchProperty(propertyType: PropertyType, content: String) {
    self.containerView.bind(
      propertyType: propertyType,
      content: content
    )
  }
  func fetchSelectedPromotions(promotionList: [Promotion]){
    self.selectedPromotion = promotionList
  }

  func fetchSelectedTags(tagList: [ChallengeTitle]){
    self.selectedTag = tagList
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
    }
  }
}

  // MARK: - CollectionView DataSource

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

  // MARK: - CollectionView Delegate

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
