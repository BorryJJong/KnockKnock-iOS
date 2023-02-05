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
  
  func getFeedDetail(feedDetail: FeedDetail)
  func getAllCommentsCount(allCommentsCount: Int)
  func fetchVisibleComments(visibleComments: [Comment])
  func fetchLikeList(like: [Like.Info])
  func fetchLikeStatus(isToggle: Bool)
  func deleteComment()
}

final class FeedDetailViewController: BaseViewController<FeedDetailView> {
  
  // MARK: - Properties
  
  var interactor: FeedDetailInteractorProtocol?

  var feedId: Int = 6
  var commentId: Int?
  var allCommentsCount: Int = 0

  var feedDetail: FeedDetail?
  var visibleComments: [Comment] = []

  var like: [Like.Info] = []

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
    self.interactor?.fetchLikeList(feedId: feedId)
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

    self.containerView.likeButton.do {
      $0.addTarget(self, action: #selector(self.likeButtonDidTap(_:)), for: .touchUpInside)
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
  
  // MARK: - Button Actions
  
  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func moreButtonDidTap(_ sender: UIButton) {

    guard let isMyPost = self.feedDetail?.feed?.isWriter,
          let feedId = self.feedDetail?.feed?.id else { return }

    self.interactor?.presentBottomSheetView(
      isMyPost: isMyPost,
      deleteAction: {
        self.interactor?.requestDelete(feedId: feedId)
      },
      hideAction: {
        self.interactor?.requestHide(feedId: feedId)
      },
      editAction: {
        self.interactor?.navigateToFeedEdit(feedId: feedId)
      }
    )
  }
  
  @objc private func replyMoreButtonDidTap(_ sender: UIButton) {
    self.interactor?.toggleVisibleStatus(commentId: sender.tag)
  }
  
  @objc private func registButtonDidTap(_ sender: UIButton) {
    if let content = self.containerView.commentTextView.text {
      self.interactor?.requestAddComment(
        comment: AddCommentDTO(
          postId: self.feedId,
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

  @objc func likeButtonDidTap(_ sender: UIButton) {
    self.interactor?.requestLike(feedId: self.feedId)
  }

  private func commentDeleteButtonDidTap(commentId: Int) {
    self.showAlert(
      content: "댓글을 삭제하시겠습니까?",
      confirmActionCompletion: {
        self.interactor?.requestDeleteComment(
          feedId: self.feedId,
          commentId: commentId
        )
      }
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
    self.setCommentsTextViewConstant(isAppearing: true)
    self.setContainerViewConstant(notification: notification, isAppearing: true)
    self.containerView.likeButton.isHidden = true
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    self.setCommentsTextViewConstant(isAppearing: false)
    self.setContainerViewConstant(notification: notification, isAppearing: false)

    if self.containerView.commentTextView.text.isEmpty {
      self.containerView.likeButton.isHidden = false
      
      self.containerView.commentTextView.snp.updateConstraints {
        $0.leading.equalTo(self.containerView.likeButton.snp.trailing)
      }
    }
  }
  
  private func setCommentsTextViewConstant(isAppearing: Bool) {
    let textViewHeightConstant = isAppearing ? 15.f : -19.f

    self.containerView.commentTextView.snp.updateConstraints {
      $0.bottom.equalTo(self.containerView.safeAreaLayoutGuide).offset(textViewHeightConstant)
      $0.leading.equalTo(self.containerView.likeButton.snp.trailing).offset(-20)
    }
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
      
      let viewBottomConstant = isAppearing ? (-keyboardHeight) : 0

      UIView.animate(withDuration: animationDurationValue.doubleValue) {
        self.containerView.postCollectionView.snp.updateConstraints {
          $0.bottom.equalTo(self.containerView.safeAreaLayoutGuide).offset(viewBottomConstant)
        }
        self.containerView.commentTextView.snp.updateConstraints {
          $0.bottom.equalTo(self.containerView.safeAreaLayoutGuide).offset(viewBottomConstant)
        }
        self.containerView.layoutIfNeeded()
      }
    }
  }
  
}

// MARK: - FeedDetailViewProtocol

extension FeedDetailViewController: FeedDetailViewProtocol {
  func getFeedDetail(feedDetail: FeedDetail) {
    self.feedDetail = feedDetail

    DispatchQueue.main.async {
      if let feed = self.feedDetail?.feed {
        self.containerView.navigationView.bind(feed: feed)
        self.feedId = feed.id
        self.containerView.bind(isLike: feed.isLike)
      }

      self.containerView.postCollectionView.reloadData()
      self.containerView.layoutIfNeeded()
    }
  }
  
  func getAllCommentsCount(allCommentsCount: Int) {
    self.allCommentsCount = allCommentsCount
  }
  
  func fetchVisibleComments(visibleComments: [Comment]) {
    self.visibleComments = visibleComments

    DispatchQueue.main.async {
      UIView.performWithoutAnimation {
        self.containerView.postCollectionView.reloadSections(
          IndexSet(integer: FeedDetailSection.comment.rawValue)
        )
      }
    }
  }
  
  func deleteComment() {
    self.interactor?.fetchAllComments(feedId: self.feedId)
  }
  
  func fetchLikeList(like: [Like.Info]) {
    self.like = like

    DispatchQueue.main.async {
      UIView.performWithoutAnimation {
        self.containerView.postCollectionView.reloadSections(
          IndexSet(integer: FeedDetailSection.like.rawValue)
        )
      }
    }
  }

  func fetchLikeStatus(isToggle: Bool) {
    if isToggle {
      self.containerView.likeButton.do {
        $0.isSelected.toggle()
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
    switch FeedDetailSection(rawValue: section) {
    case .content:
      return self.feedDetail?.challenges.count ?? 0
      
    case .like:
      if self.like.isEmpty {
        return self.like.count
      } else {
        return self.like.count + 1
      }
      
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
        cell.bind(text: feedDetail.challenges[indexPath.item].title)
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
        cell.setImage(imageUrl: self.like[indexPath.item].userImage)
      }

      return cell
      
    case .comment:
      let cell = collectionView.dequeueCell(
        withType: PostCommentCell.self,
        for: indexPath
      )
      let commentId = self.visibleComments[indexPath.item].data.id
      
      cell.bind(comment: self.visibleComments[indexPath.item])
      
      cell.replyMoreButton.do {
        $0.tag = commentId
        $0.addTarget(
          self,
          action: #selector(self.replyMoreButtonDidTap(_:)),
          for: .touchUpInside
        )
      }
      
      cell.commentDeleteButton.do {
        $0.tag = commentId
        $0.addAction(
          for: .touchUpInside,
          closure: { _ in
            self.commentDeleteButtonDidTap(commentId: commentId)
          }
        )
      }
      
      cell.replyWriteButton.do {
        $0.tag = commentId
        $0.addTarget(
          self,
          action: #selector(self.replyWriteButtonDidTap(_:)),
          for: .touchUpInside
        )
      }
      
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
          header.bind(feedData: feedDetail)
        }
        
        return header
        
      case UICollectionView.elementKindSectionFooter:
        let footer = collectionView.dequeueReusableSupplementaryFooterView(
          withType: PostFooterReusableView.self,
          for: indexPath
        )
        
        if let feedDetail = self.feedDetail {
          footer.bind(
            name: feedDetail.feed?.storeName,
            address: feedDetail.feed?.storeAddress
          )
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
      
      header.bind(count: self.allCommentsCount, section: .comment)
      
      return header
      
    default:
      return .init()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.section == FeedDetailSection.like.rawValue {
      if indexPath.item == self.like.count {
        self.interactor?.navigateToLikeDetail()
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
