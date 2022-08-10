//
//  FeedDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import UIKit

import Then
import KKDSKit

protocol FeedDetailViewProtocol {
  var interactor: FeedDetailInteractorProtocol? { get set }
  var router: FeedDetailRouterProtocol? { get set }

  func getFeedDetail(feedDetail: FeedDetail)
  func getAllComments(allComments: [Comment])
  func setVisibleComments(comments: [Comment])
  func getLike(like: [Like])
}

final class FeedDetailViewController: BaseViewController<FeedDetailView> {

  // MARK: - Properties

  var interactor: FeedDetailInteractorProtocol?
  var router: FeedDetailRouterProtocol?

  var feedDetail: FeedDetail?
  var like: [Like] = []
  var allComments: [Comment] = []
  var visibleComments: [Comment] = []

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setNavigationBar()
    self.setupConfigure()

    self.interactor?.getFeedDeatil()
    self.interactor?.getLike()
    self.interactor?.getAllComments()
    self.interactor?.setVisibleComments(comments: self.allComments)
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.postCollectionView.do {
      $0.dataSource = self
      $0.delegate = self

      $0.registHeaderView(type: PostHeaderReusableView.self)
      $0.registFooterView(type: PostFooterReusableView.self)
      $0.registCell(type: PostCell.self)

      $0.registHeaderView(type: ReactHeaderReusableView.self)
      $0.registFooterView(type: ReactFooterReusableView.self)
      $0.registCell(type: LikeCell.self)

      $0.registCell(type: PostCommentCell.self)

      $0.collectionViewLayout = self.containerView.setPostCollectionViewLayout()
    }
    self.containerView.commentTextView.do {
      $0.delegate = self
    }
    self.addKeyboardNotification()
    self.hideKeyboardWhenTappedAround()
  }

  private func setNavigationBar() {
    let navigationView = FeedDetailNavigationBarView()

    let backButton = UIBarButtonItem(
      image: KKDS.Image.ic_back_24_bk,
      style: .done,
      target: self,
      action: #selector(backButtonDidTap(_:))
    )
    let moreButton = UIBarButtonItem(
      image: KKDS.Image.ic_more_20_gr,
      style: .plain,
      target: self,
      action: #selector(moreButtonDidTap(_:))
    )

    self.navigationItem.leftBarButtonItems = [
      backButton,
      UIBarButtonItem.init(customView: navigationView)
    ]
    self.navigationItem.rightBarButtonItem = moreButton
    self.navigationController?.navigationBar.tintColor = .black
  }

  // MARK: - Button Actions

  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }

  @objc private func moreButtonDidTap(_ sender: UIButton) {
  }

  @objc private func replyMoreButtonDidTap(_ sender: UIButton) {
    self.visibleComments[sender.tag].isOpen.toggle()

    self.interactor?.setVisibleComments(comments: self.visibleComments)
    
    UIView.performWithoutAnimation {
      self.containerView.postCollectionView.reloadSections([FeedDetailSection.comment.rawValue])
    }
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
    self.containerView.likeButton.isHidden = true
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    self.setCommentsTextViewConstant(notification: notification, isAppearing: false)

    if self.containerView.commentTextView.text.isEmpty {
      self.containerView.likeButton.isHidden = false
      self.containerView.commentTextView.leadingConstraint?.constant = 0
    }
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
      self.containerView.commentTextView.leadingConstraint?.constant = -20

      UIView.animate(withDuration: animationDurationValue.doubleValue) {
        self.containerView.layoutIfNeeded()
      }
    }
  }
}

// MARK: - FeedDetailViewProtocol

extension FeedDetailViewController: FeedDetailViewProtocol {
  func getFeedDetail(feedDetail: FeedDetail) {
    self.feedDetail = feedDetail
  }

  func getAllComments(allComments: [Comment]) {
    self.allComments = allComments
  }

  func setVisibleComments(comments: [Comment]) {
    self.visibleComments = comments
  }

  func getLike(like: [Like]) {
    self.like = like
  }
}

// MARK: - CollectionView datasource, layout

extension FeedDetailViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch FeedDetailSection(rawValue: section) {
    case .content:
      return self.feedDetail?.challenge.count ?? 0

    case .like:
      return self.like.count + 1

    case .comment:
      return self.visibleComments.count
      
    default:
      assert(false)
    }
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return FeedDetailSection.allCases.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let section = FeedDetailSection(rawValue: indexPath.section)

    switch section {
    case .content:
      let cell = collectionView.dequeueCell(
        withType: PostCell.self,
        for: indexPath
      )
      if let feedDetail = self.feedDetail {
        cell.bind(text: feedDetail.challenge[indexPath.item].title)
      }
      return cell

    case .like:

      let cell = collectionView.dequeueCell(
        withType: LikeCell.self,
        for: indexPath
      )
      if indexPath.item == self.like.count {
        cell.bind(isLast: true)
      } else {
        cell.bind(isLast: false)
      }
      return cell

    case .comment:
      let cell = collectionView.dequeueCell(
        withType: PostCommentCell.self,
        for: indexPath
      )
      cell.replyMoreButton.tag = indexPath.item
      cell.replyMoreButton.addTarget(
        self,
        action: #selector(replyMoreButtonDidTap(_:)),
        for: .touchUpInside
      )

      cell.bind(comment: self.visibleComments[indexPath.item])

      return cell

    default:
      assert(false)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let section = FeedDetailSection(rawValue: indexPath.section)

    switch section {
    case .content:

      switch kind {
      case UICollectionView.elementKindSectionHeader:
        let header = collectionView.dequeueReusableSupplementaryHeaderView(
          withType: PostHeaderReusableView.self,
          for: indexPath
        )
        if let feedDetail = self.feedDetail {
          header.bind(feed: feedDetail)
        }

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

    case .like:

      switch kind {
      case UICollectionView.elementKindSectionHeader:
        let header = collectionView.dequeueReusableSupplementaryHeaderView(
          withType: ReactHeaderReusableView.self,
          for: indexPath
        )
        header.bind(count: self.like.count, section: .like)

        return header

      case UICollectionView.elementKindSectionFooter:
        let footer = collectionView.dequeueReusableSupplementaryFooterView(
          withType: ReactFooterReusableView.self,
          for: indexPath
        )
        return footer

      default:
        assert(false, "Unexpected element kind")
      }

    case .comment:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: ReactHeaderReusableView.self,
        for: indexPath
      )
      var count = self.allComments.count

      self.allComments.forEach {
        count += $0.replies.count
      }

      header.bind(count: count, section: .comment)

      return header
      
    default:
      assert(false, "Unexpected element kind")
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.section == FeedDetailSection.like.rawValue {
      if indexPath.item == self.like.count {
      self.navigationController?.pushViewController(LikeDetailViewContoller(), animated: true)
      }
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
