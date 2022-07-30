//
//  FeedDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import UIKit

import Then

protocol FeedDetailViewProtocol {
  var interactor: FeedDetailInteractorProtocol? { get set }
  var router: FeedDetailRouterProtocol? { get set }

  func getFeedDetail(feedDetail: FeedDetail)
}

final class FeedDetailViewController: BaseViewController<FeedDetailView> {

  // MARK: - Properties

  var interactor: FeedDetailInteractorProtocol?
  var router: FeedDetailRouterProtocol?

  var feedDetail: FeedDetail?

  let people = [
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil),
    Participant(id: 2, nickname: "", image: nil)
  ]

  var dummyComments: [Comment] = [
    Comment(userID: "user1", image: "", contents: "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다",
            replies: [
              Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
              Reply(userID: "user3", image: "", contents: "asdfwegqegweqgwerwerwsdaf", date: "0201223"),
              Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
            ], date: "123kj12"),

    Comment(userID: "user1", image: "", contents: "갖;ㅁㄷ기ㅓㅈ딥;ㅏ겆ㅂ디;ㅏ거;ㅣ나얾;ㅣㄴ아ㅓ히;ㅏ엏ㅈ;ㅣ다ㅜ;ㅣㅏ",
            replies: [
              Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
              Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
            ], date: "123kj12"),

    Comment(userID: "user1", image: "", contents: "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다",
            replies: [
            ], date: "123kj12"),

    Comment(userID: "user1", image: "", contents: "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다",
            replies: [
              Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
              Reply(userID: "user3", image: "", contents: "asdfwegqegweqgwerwerwsdaf", date: "0201223"),
              Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
            ], date: "123kj12"),
    Comment(userID: "user1", image: "", contents: "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다",
            replies: [
              Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
              Reply(userID: "user3", image: "", contents: "asdfwegqegweqgwerwerwsdaf", date: "0201223"),
              Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
            ], date: "123kj12"),
    Comment(userID: "user1", image: "", contents: "갖;ㅁㄷ기ㅓㅈ딥;ㅏ겆ㅂ디;ㅏ거;ㅣ나얾;ㅣㄴ아ㅓ히;ㅏ엏ㅈ;ㅣ다ㅜ;ㅣㅏ",
            replies: [
              Reply(userID: "user2", image: "", contents: "retewar", date: "0201223"),
              Reply(userID: "user2", image: "", contents: "retwegwelkwje;lkfjw;elfkjw;lkewar", date: "0201223")
            ], date: "123kj12")
  ]

  var testComments: [Comment] = []

  func setComment(comments: [Comment]) {
    self.testComments = []
    for comment in comments {
      if comment.replies.count != 0 && comment.isOpen {
        self.testComments.append(comment)
        for reply in comment.replies {
          self.testComments.append(
            Comment(
              userID: reply.userID,
              image: reply.image,
              contents: reply.contents,
              replies: [],
              date: reply.date,
              isReply: true
            )
          )
        }
      } else {
        if !comment.isReply {
          self.testComments.append(comment)
        }
      }
    }
  }

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
    self.interactor?.getFeedDeatil()
    self.setComment(comments: self.dummyComments)
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.postCollectionView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.collectionViewLayout = self.containerView.setPostCollectionViewLayout()

      $0.registHeaderView(type: PostHeaderReusableView.self)
      $0.registFooterView(type: PostFooterReusableView.self)
      $0.registCell(type: PostCell.self)

      $0.registHeaderView(type: ReactHeaderReusableView.self)
      $0.registFooterView(type: ReactFooterReusableView.self)
      $0.registCell(type: LikeCell.self)

      $0.registCell(type: PostCommentCell.self)
    }
    self.containerView.commentTextView.do {
      $0.delegate = self
    }
    self.addKeyboardNotification()
    self.hideKeyboardWhenTappedAround()
  }

  @objc private func replyMoreButtonDidTap(_ sender: UIButton) {
    self.testComments[sender.tag].isOpen.toggle()

    self.setComment(comments: self.testComments)

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

// MARK: - FeedDetailViewProtocol

extension FeedDetailViewController: FeedDetailViewProtocol {
  func getFeedDetail(feedDetail: FeedDetail) {
    self.feedDetail = feedDetail
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
      return self.people.count + 1

    case .comment:
      return self.testComments.count
      
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
      if indexPath.item == self.people.count {
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
      cell.bind(comment: self.testComments[indexPath.item])

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
        header.bind(count: self.people.count, section: .like)

        return header

      case UICollectionView.elementKindSectionFooter:
        let footer = collectionView.dequeueReusableSupplementaryFooterView(
          withType: ReactFooterReusableView.self,
          for: indexPath
        )
        footer.backgroundColor = .cyan
        return footer

      default:
        assert(false, "Unexpected element kind")
      }

    case .comment:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: ReactHeaderReusableView.self,
        for: indexPath
      )
      header.bind(count: 10, section: .comment)

      return header
      
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
