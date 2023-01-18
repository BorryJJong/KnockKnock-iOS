//
//  CommentViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

import Then
import KKDSKit

protocol CommentViewProtocol {
  var router: CommentRouterProtocol? { get set }
  var interactor: CommentInteractorProtocol? { get set }
  
  func fetchVisibleComments(comments: [Comment])
}

final class CommentViewController: BaseViewController<CommentView> {
  
  // MARK: - Properties
  
  var router: CommentRouterProtocol?
  var interactor: CommentInteractorProtocol?
  
  var visibleComments: [Comment] = [] {
    didSet {
      UIView.performWithoutAnimation {
        self.containerView.commentCollectionView.reloadData()
      }
    }
  }
  
  var feedId: Int = 6
  var commentId: Int?
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    LoadingIndicator.showLoading()
    self.interactor?.fetchAllComments(feedId: self.feedId)
  }
  
  // MARK: - Configure
  
  override func setupConfigure() {
    self.containerView.commentCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: PostCommentCell.self)
      $0.collectionViewLayout = self.containerView.commentCollectionViewLayout()
      $0.scrollsToTop = true
      $0.layoutIfNeeded()
    }
    
    self.containerView.exitButton.do {
      $0.addTarget(
        self,
        action: #selector(exitButtonDidTap(_:)),
        for: .touchUpInside
      )
    }
    
    self.containerView.commentTextView.do {
      $0.delegate = self
    }
    
    self.containerView.registButton.do {
      $0.addTarget(
        self,
        action: #selector(self.regitstButtonDidTap(_:)),
        for: .touchUpInside
      )
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
    self.setContainerViewConstant(notification: notification, isAppearing: true)
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    self.setContainerViewConstant(notification: notification, isAppearing: false)
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
      let textViewBottomConstant = isAppearing ? 15.f : -19.f
      
      UIView.animate(withDuration: animationDurationValue.doubleValue) {
        self.containerView.contentView.snp.updateConstraints {
          $0.bottom.equalTo(self.containerView.safeAreaLayoutGuide).offset(viewBottomConstant)
        }

        self.containerView.commentTextView.snp.updateConstraints {
          $0.bottom.equalTo(self.containerView.contentView).offset(textViewBottomConstant)
        }

        self.containerView.layoutIfNeeded()
      }
    }
  }
  
  // MARK: - Button action
  
  @objc private func exitButtonDidTap(_ sender: UIButton) {
    self.router?.dismissCommentView(view: self)
  }
  
  @objc private func replyWriteButtonDidTap(_ sender: UIButton) {
    self.commentId = sender.tag
    self.containerView.commentTextView.becomeFirstResponder()
  }
  
  @objc private func replyMoreButtonDidTap(_ sender: UIButton) {
    self.interactor?.toggleVisibleStatus(commentId: sender.tag)
  }
  
  private func commentDeleteButtonDidTap(commentId: Int) {
    self.showAlert(
      content: "댓글을 삭제하시겠습니까?",
      confirmActionCompletion: {
        self.interactor?.requestDeleteComment(commentId: commentId)
      }
    )
  }
  
  @objc private func regitstButtonDidTap(_ sender: UIButton) {
    if let content = self.containerView.commentTextView.text {
      self.interactor?.requestAddComment(
        comment: AddCommentDTO(
          postId: self.feedId,
          content: content,
          commentId: self.commentId
        )
      )
      self.containerView.commentTextView.text = ""
      self.containerView.setPlaceholder()
      self.commentId = nil
    }
  }
}

// MARK: - CommentViewProtocol

extension CommentViewController: CommentViewProtocol {
  func fetchVisibleComments(comments: [Comment]) {
    self.visibleComments = comments
  }
}

// MARK: - CollectionView Delegate, DataSource

extension CommentViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.visibleComments.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
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
  }
}

extension CommentViewController: UICollectionViewDelegateFlowLayout {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if self.containerView.commentCollectionView.isDragging {
      let offset = scrollView.contentOffset.y
      
      if offset <= 0 {
        self.dismissKeyboard()
      }
    }
  }
}

// MARK: - TextField delegate

extension CommentViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    self.containerView.setPlaceholder()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      self.containerView.setPlaceholder()
    }
  }
  
  func textViewDidChange(_ textView: UITextView) {
    let size = CGSize(width: view.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    
    textView.constraints.forEach { (constraint) in
      if estimatedSize.height <= 60 && constraint.firstAttribute == .height {
        constraint.constant = estimatedSize.height
      }
    }
  }
}
