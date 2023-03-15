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
  func fetchAddress(address: AddressResponse.Documents)
  
  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class FeedWriteViewController: BaseViewController<FeedWriteView> {
  
  // MARK: - Properties
  
  var interactor: FeedWriteInteractorProtocol?
  
  var selectedImages: [UIImage] = [] {
    didSet {
      self.containerView.photoCollectionView.reloadData()
    }
  }
  
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
    self.changeStatusBarBgColor(bgColor: .clear)
    
    self.navigationItem.do {
      $0.title = "새 게시글"
      $0.leftBarButtonItem = self.dismissBarButtonItem
    }
    self.navigationController?.navigationBar.do {
      $0.backgroundColor = .white
    }
    
    self.addKeyboardNotification()
    
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
  }
  
  // MARK: - Keyboard Show & Hide
  
  private func addKeyboardNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    self.containerView.setContainerViewConstant(notification: notification, isAppearing: true)
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    self.containerView.setContainerViewConstant(notification: notification, isAppearing: false)
  }
  
  // MARK: - Button Actions
  
  @objc func tagSelectButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToProperty(propertyType: .tag)
  }
  
  @objc func promotionSelectButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToProperty(propertyType: .promotion)
  }
  
  @objc func dismissBarButtonDidTap(_ sender: UIBarButtonItem) {
    self.interactor?.dismissFeedWriteView()
  }
  
  @objc func shopSearchButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToShopSearch()
  }
  
  @objc private func photoAddButtonDidTap(_ sender: UIButton) {
    self.callImagePicker()
  }
  
  @objc private func photoDeleteButtonDidTap(_ sender: UIButton) {
    self.selectedImages.remove(at: sender.tag)
    self.containerView.bindPhotoCount(count: self.selectedImages.count)
    self.containerView.photoCollectionView.reloadData()
  }
  
  @objc func doneButtonDidTap(_ sender: UIButton) {
    self.interactor?.checkEssentialField(image: self.selectedImages.map { $0.pngData() })
  }
  
  // MARK: - ImagePicker
  
  func callImagePicker() {
    var images: [UIImage] = []
    
    let picker = ImagePickerManager.shared.setImagePicker()
    
    picker.didFinishPicking { [unowned picker] items, _ in
      Task {
        for item in items {
          switch item {
            
          case let .photo(photo):
            let resizeImage = photo.image.resizeSquareImage(newWidth: self.containerView.frame.width)
            
            images.append(resizeImage)
            
            self.selectedImages = images
            
          default:
            print("error")
          }
        }
        self.containerView.bindPhotoCount(count: self.selectedImages.count)
        picker.dismiss(animated: true, completion: nil)
      }
    }
    self.present(picker, animated: true, completion: nil)
  }
}

// MARK: - Feed Write View Protocol

extension FeedWriteViewController: FeedWriteViewProtocol, AlertProtocol {
  
  func fetchTag(tag: String) {
    self.containerView.setTag(tag: tag)
  }
  
  func fetchPromotion(promotion: String) {
    self.containerView.setPromotion(promotion: promotion)
  }
  
  func fetchAddress(address: AddressResponse.Documents) {
    self.containerView.setAddress(
      name: address.placeName,
      address: address.addressName
    )
  }
  
  /// Alert 팝업 창
  func showAlertView(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    DispatchQueue.main.async {
      self.showAlert(
        message: message,
        isCancelActive: isCancelActive,
        confirmAction: confirmAction
      )
    }
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
      self.interactor?.setCurrentText(text: "")
    } else {
      self.interactor?.setCurrentText(text: textView.text)
    }
  }
}

// MARK: - CollectionView DataSource

extension FeedWriteViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.selectedImages.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    let photo = self.selectedImages[indexPath.row]
    
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
