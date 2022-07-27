//
//  FeedDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import UIKit

import Then

class FeedDetailViewController: BaseViewController<FeedDetailView> {

  // MARK: - Properties

  let feed =  Feed(userId: 5, content: "aa", images: ["feed_sample_3", "feed_sample_2", "feed_sample_2"], scale: "1:1")
  let tags = ["#용기내챌린지", "#프로모션", "#제로웨이스트", "#지구지키기프로젝트", "#용기내챌린지", "#용기내챌린지"]

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.postCollectionView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.collectionViewLayout = self.containerView.setPostCollectionViewLayout()
      $0.registCell(type: PostImageCell.self)
      $0.registHeaderView(type: PostHeaderReusableView.self)
      $0.registFooterView(type: PostFooterReusableView.self)
    }
    self.containerView.commentTextView.do {
      $0.delegate = self
    }
    self.addKeyboardNotification()
    self.hideKeyboardWhenTappedAround()
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
    self.setCommentsTextViewConstant(notification: notification, isAppearing: true)
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    self.setCommentsTextViewConstant(notification: notification, isAppearing: false)
  }

  private func setCommentsTextViewConstant(notification: Notification, isAppearing: Bool) {
    let userInfo = notification.userInfo

    if let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardSize = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardSize.height

      guard let animationDurationValue = userInfo?[
        UIResponder
          .keyboardAnimationDurationUserInfoKey
      ] as? NSNumber else { return }

      let heightConstant = isAppearing ? (-keyboardHeight + 15) : -19

      self.containerView.commentTextView.bottomConstraint?.constant = heightConstant

      UIView.animate(withDuration: animationDurationValue.doubleValue) {
        self.containerView.layoutIfNeeded()
      }
    }
  }
}

// MARK: - CollectionView datasource, layout

extension FeedDetailViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    
    return self.tags.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: PostImageCell.self,
      for: indexPath)
    cell.bind(text: self.tags[indexPath.item])
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: PostHeaderReusableView.self,
        for: indexPath
      )
      header.bind(feed: self.feed)

      return header

    case UICollectionView.elementKindSectionFooter:
      let footer = collectionView.dequeueReusableSupplementaryFooterView(
        withType: PostFooterReusableView.self,
        for: indexPath
      )

      return footer

    default:
          assert(false, "Unexpected element kind")
    }

  }
}

extension FeedDetailViewController: UICollectionViewDelegateFlowLayout {

}

// MARK: - TextField delegate

extension FeedDetailViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    self.containerView.setPlaceholder()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    self.containerView.setPlaceholder()
  }

  func textViewDidChange(_ textView: UITextView) {
    let size = CGSize(
      width: view.frame.width,
      height: .infinity
    )
    let estimatedSize = textView.sizeThatFits(size)

    textView.constraints.forEach { (constraint) in
      if estimatedSize.height <= 60 && constraint.firstAttribute == .height {
        constraint.constant = estimatedSize.height
      }
    }
  }
}
