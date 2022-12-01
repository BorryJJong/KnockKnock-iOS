//
//  FeedDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import UIKit

import Then
import KKDSKit

protocol FeedDetailViewProtocol: AnyObject {
  var interactor: FeedDetailInteractorProtocol? { get set }
  var router: FeedDetailRouterProtocol? { get set }

  func getFeedDetail(feedDetail: FeedDetail)
  func getAllComments(allComments: [Comment])
  func fetchVisibleComments(comments: [Comment])
  func getLike(like: [LikeInfo])
}

final class FeedDetailViewController: BaseViewController<FeedDetailView> {

  // MARK: - Properties

  var interactor: FeedDetailInteractorProtocol?
  var router: FeedDetailRouterProtocol?

  var feedDetail: FeedDetail? {
    didSet {
      self.containerView.postCollectionView.reloadData()
      if let feed = feedDetail?.data.feed {
        self.containerView.navigationView.bind(feed: feed)
      }
    }
  }
  var feedId: Int = 6
  var userId: Int = 1
  var commentId: Int?
  var like: [LikeInfo] = []

  var allComments: [Comment] = []
  var visibleComments: [Comment] = [] {
    didSet {
      UIView.performWithoutAnimation {
        self.containerView.postCollectionView.reloadSections(
          IndexSet(integer: FeedDetailSection.comment.rawValue)
        )
      }
    }
  }

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    LoadingIndicator.showLoading()

    self.setNavigationBar()
    self.setupConfigure()
    self.fetchData()
  }

  // MARK: - Configure

  private func fetchData() {
    self.interactor?.getFeedDeatil(feedId: feedId)
    self.interactor?.getLike(feedId: feedId)
    self.interactor?.fetchAllComments(feedId: feedId)
  }

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
      $0.registCell(type: DefaultCollectionViewCell.self)

      $0.collectionViewLayout = self.containerView.setPostCollectionViewLayout()
      $0.scrollsToTop = true
    }
    self.containerView.commentTextView.do {
      $0.delegate = self
    }
    self.containerView.registButton.do {
      $0.addTarget(self, action: #selector(self.registButtonDidTap(_:)), for: .touchUpInside)
    }
    self.addKeyboardNotification()
    self.hideKeyboardWhenTappedAround()
  }

  private func setNavigationBar() {

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
      UIBarButtonItem.init(customView: self.containerView.navigationView)
    ]
    self.navigationItem.rightBarButtonItem = moreButton
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.changeStatusBarBgColor(bgColor: .white)
  }

  func changeStatusBarBgColor(bgColor: UIColor?) {
    if #available(iOS 13.0, *) {
      let window = UIApplication.shared.windows.first
      let statusBarManager = window?.windowScene?.statusBarManager

      let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
      statusBarView.backgroundColor = bgColor

      window?.addSubview(statusBarView)
    } else {
      let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
      statusBarView?.backgroundColor = bgColor
    }
  }

  // MARK: - Button Actions

  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }

  @objc private func moreButtonDidTap(_ sender: UIButton) {
  }

  @objc private func replyMoreButtonDidTap(_ sender: UIButton) {
    self.visibleComments[sender.tag].isOpen.toggle()

    self.interactor?.fetchVisibleComments(comments: self.visibleComments)
    
    UIView.performWithoutAnimation {
      self.containerView.postCollectionView.reloadSections([FeedDetailSection.comment.rawValue])
    }
  }

  @objc private func registButtonDidTap(_ sender: UIButton) {
    if let content = self.containerView.commentTextView.text {
      self.interactor?.requestAddComment(
        comment: AddCommentRequest(
          feedId: self.feedId,
          userId: self.userId,
          content: content,
          commentId: self.commentId
        )
      )
    }
    self.containerView.commentTextView.text = ""
    self.containerView.setPlaceholder()
    self.commentId = nil
  }

  @objc private func replyWriteButtonDidTap(_ sender: UIButton) {
    self.commentId = sender.tag
    self.containerView.commentTextView.becomeFirstResponder()
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
    self.setCommentsTextViewConstant(isAppearing: true)
    self.setContainerViewConstant(notification: notification, isAppearing: true)
    self.containerView.likeButton.isHidden = true
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    self.setCommentsTextViewConstant(isAppearing: false)
    self.setContainerViewConstant(notification: notification, isAppearing: false)
    
    if self.containerView.commentTextView.text.isEmpty {
      self.containerView.likeButton.isHidden = false
      self.containerView.commentTextView.leadingConstraint?.constant = 0
    }
  }

  private func setCommentsTextViewConstant(isAppearing: Bool) {
    let textViewHeightConstant = isAppearing ? 15.f : -19.f

    self.containerView.commentTextView.bottomConstraint?.constant = textViewHeightConstant
    self.containerView.commentTextView.leadingConstraint?.constant = -20
  }

  private func setContainerViewConstant(notification: Notification, isAppearing: Bool) {
    let userInfo = notification.userInfo

    if let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardSize = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardSize.height

      guard let animationDurationValue = userInfo?[
        UIResponder
          .keyboardAnimationDurationUserInfoKey
      ] as? NSNumber else { return }

      let viewHeightConstant = isAppearing ? (-keyboardHeight) : 0

      self.containerView.frame.origin.y = viewHeightConstant

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

  func fetchVisibleComments(comments: [Comment]) {
    self.visibleComments = comments
  }

  func getLike(like: [LikeInfo]) {
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
      return self.feedDetail?.data.challenges.count ?? 0

    case .like:
      return self.like.count + 1

    case .comment:
      return self.visibleComments.count
      
    default:
      return 0
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
        cell.bind(text: feedDetail.data.challenges[indexPath.item].title)
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

      cell.replyWriteButton.tag = self.visibleComments[indexPath.item].commentData.id
      cell.replyWriteButton.addTarget(
        self,
        action: #selector(self.replyWriteButtonDidTap(_:)),
        for: .touchUpInside
      )

      cell.bind(comment: self.visibleComments[indexPath.item])

      return cell

    default:
      let cell = collectionView.dequeueCell(
        withType: DefaultCollectionViewCell.self,
        for: indexPath
      )

      return cell
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
          header.bind(feedData: feedDetail.data)
        }

        return header

      case UICollectionView.elementKindSectionFooter:
        let footer = collectionView.dequeueReusableSupplementaryFooterView(
          withType: PostFooterReusableView.self,
          for: indexPath
        )

        if let feedDetail = self.feedDetail {
          footer.bind(shopAddress: feedDetail.data.feed?.storeAddress ?? "")
        }

        return footer

      default:
        return .init()
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
        return .init()
      }

    case .comment:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: ReactHeaderReusableView.self,
        for: indexPath
      )
      var count = self.allComments.count

      self.allComments.forEach {
        count += $0.commentData.replyCnt
      }

      header.bind(count: count, section: .comment)

      return header
      
    default:
      return .init()
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.section == FeedDetailSection.like.rawValue {
      if indexPath.item == self.like.count {
        self.router?.navigateToLikeDetail(source: self, like: self.like)
      }
    }
  }
}

extension FeedDetailViewController: UICollectionViewDelegateFlowLayout {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if self.containerView.postCollectionView.isDragging {
      let offset = scrollView.contentOffset.y

      if offset <= 0 {
        self.dismissKeyboard()
      }
    }
  }
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
